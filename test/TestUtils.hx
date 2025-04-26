package;

import bitdecay.behavior.tree.context.BTContext;
import bitdecay.behavior.tree.Node;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

class TestNode extends LeafNode {
	public var cycle:Int;
	public var result:NodeStatus;
	public var processCount:Int = 0;
	public var cancelled = false;

    public function new(cycle:Int, result:NodeStatus) {
		this.cycle = cycle;
		this.result = result;
	}

	override function init(context:BTContext) {
		super.init(context);
		processCount = 0;
		cancelled = false;
	}

    override public function doProcess(delta:Float):NodeStatus {
		processCount++;
		if (processCount == cycle) {
			return result;
		}

		return RUNNING;
    }

	override public function clone():Node {
        return new TestNode(cycle, result);
    }

	override function cancel() {
		super.cancel();
		cancelled = true;
	}

	override function getDetail():Array<String> {
        return [];
    }
}