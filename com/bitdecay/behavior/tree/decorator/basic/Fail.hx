package com.bitdecay.behavior.tree.decorator.basic;

import com.bitdecay.behavior.tree.decorator.DecoratorNode;
import com.bitdecay.behavior.tree.NodeStatus;

class Fail extends DecoratorNode {
    override public function doProcess(delta:Float):NodeStatus {
        child.process(delta);
        return FAIL;
    }
}