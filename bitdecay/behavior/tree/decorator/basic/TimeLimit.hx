package bitdecay.behavior.tree.decorator.basic;

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
	var limit:Float;
	var remaining:Float;

	public function new(limit:Float) {
        super(child);
        this.limit = limit;
    }

    override function init(context:BTContext) {
        super.init(context);
		remaining = limit;
    }

	override function process(delta:Float):NodeStatus {
		remaining = Math.max(remaining - delta, 0);
		return super.process(delta);
	}

    override public function doProcess(raw:NodeStatus):NodeStatus {
		if (remaining == 0) {
			return FAIL;
		}

		return raw;
    }
}