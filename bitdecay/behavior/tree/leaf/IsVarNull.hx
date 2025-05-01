package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

/**
 * Succeeds if the given var either not set, or value is null.
 * Fails if the var is set to a non-null value
**/
class IsVarNull extends LeafNode {
    public function new(name:String) {
		this.name = name;
	}

    override public function process(delta:Float):NodeStatus {
		if (!ctx.has(name) || ctx.get(name) == null) {
			return SUCCESS;
		}

        return FAIL;
    }

	override public function clone():Node {
        return new IsVarNull(name);
    }

	override function getDetail():Array<String> {
        return ['var: ${name}'];
    }
}