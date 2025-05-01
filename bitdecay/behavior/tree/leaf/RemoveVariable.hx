package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

/**
 * Removes a variable from the context. Always Succeeds
**/
class RemoveVariable extends LeafNode {
	var varName:String;

    public function new(name:String) {
		this.varName = name;
	}

    override public function process(delta:Float):NodeStatus {
		ctx.remove(varName);
        return SUCCESS;
    }

	override public function clone():Node {
        return new RemoveVariable(varName);
    }

	override function getDetail():Array<String> {
        return ['var: ${varName}'];
    }
}
