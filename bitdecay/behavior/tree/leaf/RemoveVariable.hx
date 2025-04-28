package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

/**
 * Removes a variable from the context. Always Succeeds
**/
class RemoveVariable extends LeafNode {
	var name:String;

    public function new(name:String) {
		this.name = name;
	}

    override public function doProcess(delta:Float):NodeStatus {
		context.remove(name);
        return SUCCESS;
    }

	override public function clone():Node {
        return new RemoveVariable(name);
    }

	override function getDetail():Array<String> {
        return ['var: ${name}'];
    }
}
