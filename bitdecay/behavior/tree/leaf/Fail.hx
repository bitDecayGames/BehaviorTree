package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Utility node that always fails
**/
class Fail extends LeafNode {
    public function new() {}

    override public function process(delta:Float):NodeStatus {
        return FAIL;
    }

    override public function clone():Node {
        return new Fail();
    }
}