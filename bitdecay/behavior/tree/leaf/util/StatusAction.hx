package bitdecay.behavior.tree.leaf.util;

import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.BTreeMacros;

/**
 * Utility node that runs the provided callback and returns the status of it
**/
class StatusAction extends LeafNode {
	var cb:BTProcessFunc;

    public function new(cb:BTProcessFunc) {
		this.cb = cb;
	}

    override public function doProcess(delta:Float):NodeStatus {
		return cb.func(context, delta);
    }

	override public function clone():Node {
        return new StatusAction(cb);
    }

	override function getDetail():Array<String> {
        return [Std.string(cb)];
    }
}