package bitdecay.behavior.tree.leaf.util;

import bitdecay.behavior.tree.BTreeMacros.BTFunc;
import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Utility node that runs the provided callback and always reports success
**/
class Action extends LeafNode {
	var cb:BTFunc;

    public function new(cb:BTFunc) {
		this.cb = cb;
	}

    override public function doProcess(delta:Float):NodeStatus {
		cb.func(context);
        return SUCCESS;
    }

	override function getDetail():Array<String> {
        return ['name: ${cb.name}', 'file: ${cb.file}:${cb.line}'];
    }
}