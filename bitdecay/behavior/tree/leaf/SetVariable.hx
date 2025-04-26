package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Sets a variable to a given value in the context
**/
class SetVariable extends LeafNode {
	var name:String;
	var value:Dynamic;

    public function new(name:String, value:Dynamic) {
		this.name = name;
		this.value = value;
	}

    override public function doProcess(delta:Float):NodeStatus {
		context.set(name, value);
        return SUCCESS;
    }

	override public function clone():Node {
        return new SetVariable(name, value);
    }

	override function getDetail():Array<String> {
        return ['var: ${name}, value: ${value}'];
    }
}