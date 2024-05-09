package bitdecay.behavior.tree.composite;

// Runs the condition node until SUCCESS before starting the child node.
// Condition node is continuously re-run while child node operates.
// If condition node fails, FAIL is immediately returned
class Precondition extends CompositeNode {
	var running:Bool;
	var conditionStatus:NodeStatus;

	public function new(condition:Node, child:Node) {
		super([condition, child]);
	}

	override function init(context:BTContext) {
		super.init(context);
		running = false;
		conditionStatus = RUNNING;
	}

	override function doProcess(delta:Float):NodeStatus {
		if (conditionStatus == RUNNING) {
			conditionStatus = children[0].process(delta);
		}

		if (conditionStatus == FAIL) {
			children[1].exit();
			return FAIL;
		} else if (conditionStatus == SUCCESS) {
			running = true;
			children[0].init(context);
			conditionStatus = RUNNING;
		}

		if (!running) {
			return conditionStatus;
		}

		return children[1].process(delta);
	}
}