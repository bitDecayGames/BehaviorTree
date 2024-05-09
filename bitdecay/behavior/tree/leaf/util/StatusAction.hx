package bitdecay.behavior.tree.leaf.util;

import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.NodeStatus;

class StatusAction extends LeafNode {
	var cb:(Float)->NodeStatus;

    public function new(cb:()->Void) {
		this.cb = cb;
	}

    override public function doProcess(delta:Float):NodeStatus {
		return cb(delta);
    }
}