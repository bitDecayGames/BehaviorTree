package bitdecay.behavior.tree.leaf.util;

import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.NodeStatus;

class Action extends LeafNode {
	var cb:()->Void;

    public function new(cb:()->Void) {
		this.cb = cb;
	}

    override public function doProcess(delta:Float):NodeStatus {
		cb();
        return SUCCESS;
    }
}