package;

import bitdecay.behavior.tree.context.BTContext;
import bitdecay.behavior.tree.Node;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

class TestUtils {
	public static function getRunningNode(cycle:Int, then:NodeStatus) {
		return new StatusFlipNode(RUNNING, cycle, then);
	}
}

class StatusFlipNode extends LeafNode {
	public var cycle:Int;
	public var start:NodeStatus;
	public var end:NodeStatus;
	public var processCount:Int = 0;
	public var resetOnInit = true;
	public var cancelled = false;

    public function new(startStatus:NodeStatus, cycle:Int, flipStatus:NodeStatus, ?resetOnInit:Bool = true) {
		this.cycle = cycle;
		this.start = startStatus;
		this.end = flipStatus;
		this.resetOnInit = resetOnInit;
	}

	override function init(ctx:BTContext) {
		super.init(ctx);
		if (resetOnInit) {
			processCount = 0;
			cancelled = false;
		}
	}

	override function process(delta:Float):NodeStatus {
		processCount++;

		if (processCount < cycle) {
			return start;
		}

		return end;
	}

	override public function clone():Node {
        return new StatusFlipNode(start, cycle, end);
    }

	override function cancel() {
		super.cancel();
		cancelled = true;
	}

	override function getDetail():Array<String> {
        return [];
    }
}