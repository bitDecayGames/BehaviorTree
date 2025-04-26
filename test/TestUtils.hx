package;

import bitdecay.behavior.tree.Node;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

class TestNode extends LeafNode {
	public var cycle:Int;
	var remaining:Int;
	public var result:NodeStatus;
	public var cancelled = false;

    public function new(cycle:Int, result:NodeStatus) {
		this.cycle = cycle;
		remaining = cycle;
		this.result = result;
	}

    override public function doProcess(delta:Float):NodeStatus {
		remaining--;
		if (remaining == 0) {
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