package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

/**
 * Sets a variable to a given value in the context
**/
class SetVariable extends LeafNode {
	var name:String;
	var value:ValueType;

    public function new(name:String, value:ValueType) {
		this.name = name;
		this.value = value;
	}

    override public function doProcess(delta:Float):NodeStatus {
		var v = switch(value) {
			case CONST(val):
				val;
			case FROM_CTX(key):
				ctx.get(key);
		}
		ctx.set(name, v);
        return SUCCESS;
    }

	override public function clone():Node {
        return new SetVariable(name, value);
    }

	override function getDetail():Array<String> {
        return ['var: ${name}, value: ${value}'];
    }
}

enum ValueType {
	/**
	 * A constant value
	**/
	CONST(val:Dynamic);

	/**
	 * Value is pulled from another `key` in the current context
	**/
	FROM_CTX(key:String);
}