package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.BT;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

/**
 * Utility node that runs the provided callback and returns
 * its node status
**/
class StatusAction extends LeafNode {
    var actionName:String;
	var cb:WrappedProcessFunc;
    var onCancel:WrappedFunc;

    /**
     * @param name optional identifier for help if using anonymous functions
    **/
    public function new(name:String = "", cb:WrappedProcessFunc, ?onCancel:WrappedFunc = null) {
        this.actionName = name;
		this.cb = cb;
        this.onCancel = onCancel;
	}

    override public function process(delta:Float):NodeStatus {
		return cb.func(ctx, delta);
    }

    override function cancel() {
        super.cancel();
        if (onCancel != null) {
            onCancel.func(ctx);
        }
    }

	override public function clone():Node {
        return new StatusAction(actionName, cb, onCancel);
    }

	override function getDetail():Array<String> {
        var detailName = actionName;
        if (detailName.length == 0) {
            detailName = cb.name;
        }
        return ['name: ${detailName}', 'file: ${cb.file}:${cb.line}'];
    }
}