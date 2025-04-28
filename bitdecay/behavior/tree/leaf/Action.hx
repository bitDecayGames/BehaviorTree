package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.BT.WrappedFunc;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

/**
 * Utility node that runs the provided callback and always
 * reports SUCCESS
**/
class Action extends LeafNode {
    var name:String;
	var cb:WrappedFunc;

    public function new(name:String = "", cb:WrappedFunc) {
        this.name = name;
		this.cb = cb;
	}

    override public function doProcess(delta:Float):NodeStatus {
		cb.func(ctx);
        return SUCCESS;
    }

    override public function clone():Node {
        return new Action(name, cb);
    }

	override function getDetail():Array<String> {
        var detailName = name;
        if (detailName.length == 0) {
            detailName = cb.name;
        }
        return ['name: ${detailName}', 'file: ${cb.file}:${cb.line}'];
    }
}