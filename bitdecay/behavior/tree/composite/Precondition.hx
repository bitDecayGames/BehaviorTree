package bitdecay.behavior.tree.composite;

/**
 * Runs the condition node until SUCCESS before starting the child node.
 * Condition node is continuously re-run while child node operates.
 * If condition node fails, FAIL is immediately returned
**/
class Precondition extends CompositeNode {
	var running:Bool;
	var conditionStatus:NodeStatus;
	var previousConditionStatus:NodeStatus;

	var childStatus:NodeStatus;
	var previousChildStatus:NodeStatus;

	public function new(condition:Node, child:Node) {
		super([condition, child]);
	}

	override function init(context:BTContext) {
		super.init(context);
		running = false;
		conditionStatus = RUNNING;
		previousConditionStatus = null;

		childStatus = RUNNING;
		previousChildStatus = UNKNOWN;
	}

	override function doProcess(delta:Float):NodeStatus {
		if (conditionStatus == RUNNING) {
			conditionStatus = children[0].process(delta);
		}

        #if debug
		if (conditionStatus != previousConditionStatus) {
			previousConditionStatus = conditionStatus;
			@:privateAccess
			context.executor.dispatchChange(this, children[0], conditionStatus);
		}
		#end
		

		if (conditionStatus == FAIL) {
			children[1].cancel();
			return FAIL;
		} else if (conditionStatus == SUCCESS) {
			running = true;
			children[0].init(context);
			conditionStatus = RUNNING;
		}

		if (!running) {
			return conditionStatus;
		}

		childStatus = children[1].process(delta);

        #if debug
		if (previousChildStatus != childStatus) {
			previousChildStatus = childStatus;

			@:privateAccess
			context.executor.dispatchChange(this, children[1], childStatus);
		}
		#end

		return childStatus;
	}
}