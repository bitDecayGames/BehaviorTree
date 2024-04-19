package bitdecay.behavior.tree.leaf.util;

import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.NodeStatus;

class Succeed extends LeafNode {
    public function new() {}

    override public function doProcess(delta:Float):NodeStatus {
        return SUCCESS;
    }
}