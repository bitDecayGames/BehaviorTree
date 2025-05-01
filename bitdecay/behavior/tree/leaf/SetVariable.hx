package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;
import haxe.Timer;

/**
 * Sets a variable to a given value in the context
**/
class SetVariable extends LeafNode {
	var varName:String;
	var value:ValueType;

    public function new(name:String, value:ValueType) {
		this.varName = name;
		this.value = value;
	}

    override public function process(delta:Float):NodeStatus {
		var v:Dynamic = switch(value) {
			case CONST(val):
				val;
			case FROM_CTX(key):
				ctx.get(key);
			case TIMESTAMP(mod):
				Timer.stamp() + mod;
		}
		ctx.set(varName, v);
        return SUCCESS;
    }

	override public function clone():Node {
        return new SetVariable(varName, value);
    }

	override function getDetail():Array<String> {
        return ['var: ${varName}, value: ${value}'];
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

	/**
	 * Value is set to the current system time + `mod` in seconds. Useful for setting timers,
	 * delays, or other temporal event triggers
	**/
	TIMESTAMP(mod:Float);
}