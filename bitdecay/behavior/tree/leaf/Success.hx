package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Utility node that always succeeds
**/
class Success extends LeafNode {
    public function new() {}

    override public function doProcess(delta:Float):NodeStatus {
        return SUCCESS;
    }

    override public function clone():Node {
        return new Success();
    }
}