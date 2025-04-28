package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.BT;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

/**
 * Utility node that runs the provided callback and returns
 * its node status
**/
class StatusAction extends LeafNode {
    var name:String;
	var cb:WrappedProcessFunc;

    /**
     * @param name optional identifier for help if using anonymous functions
    **/
    public function new(name:String = "", cb:WrappedProcessFunc) {
        this.name = name;
		this.cb = cb;
	}

    override public function doProcess(delta:Float):NodeStatus {
		return cb.func(ctx, delta);
    }

	override public function clone():Node {
        return new StatusAction(name, cb);
    }

	override function getDetail():Array<String> {
        var detailName = name;
        if (detailName.length == 0) {
            detailName = cb.name;
        }
        return ['name: ${detailName}', 'file: ${cb.file}:${cb.line}'];
    }
}