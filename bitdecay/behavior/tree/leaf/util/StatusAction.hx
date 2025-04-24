package bitdecay.behavior.tree.leaf.util;

import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Utility node that runs the provided callback and returns the status of it
**/
class StatusAction extends LeafNode {
	var cb:(Float)->NodeStatus;

    public function new(cb:(Float)->NodeStatus) {
		this.cb = cb;
	}

    override public function doProcess(delta:Float):NodeStatus {
		return cb(delta);
    }

	override function getDetail():Array<String> {
        return [Std.string(cb)];
    }
}