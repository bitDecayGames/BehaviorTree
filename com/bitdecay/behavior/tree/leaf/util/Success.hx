package com.bitdecay.behavior.tree.leaf.util;

import com.bitdecay.behavior.tree.leaf.LeafNode;
import com.bitdecay.behavior.tree.NodeStatus;

class Succeed extends LeafNode {
    public function new() {}

    override public function doProcess(delta:Float):NodeStatus {
        return SUCCESS;
    }
}