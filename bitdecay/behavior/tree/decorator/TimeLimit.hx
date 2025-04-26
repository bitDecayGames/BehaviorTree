package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.enums.Time;
import bitdecay.behavior.tree.context.BTContext;
import bitdecay.behavior.tree.decorator.DecoratorNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Runs the child node until the time limit is reached,
 * at which point it returns FAIL.
 *
 * If child node finishes before time limit is reached,
 * returns child node status.
**/
class TimeLimit extends DecoratorNode {
	var limit:Time;
	var initial:Float;
	var remaining:Float;

	public function new(limit:Time, child:Node) {
        super(child);
        this.limit = limit;
    }

    override function init(context:BTContext) {
        super.init(context);
		initial = TimeHelper.getFloat(context, limit);
		remaining = initial;
    }

	override function process(delta:Float):NodeStatus {
		remaining = Math.max(remaining - delta, 0);
		if (remaining == 0) {
			child.cancel();
			return FAIL;
		}

		return super.process(delta);
	}

	override public function clone():Node {
        return new TimeLimit(limit, child.clone());
    }

	override function getDetail():Array<String> {
        return ['limit: ${limit}, initial: ${TimeHelper.roundMS(initial)}, remaining: ${TimeHelper.roundMS(remaining)}'];
    }
}