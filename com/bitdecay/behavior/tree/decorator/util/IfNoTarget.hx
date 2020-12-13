package com.bitdecay.behavior.tree.decorator.util;

import com.bitdecay.behavior.tree.NodeStatus;

class IfNoTarget extends DecoratorNode {

    override public function doProcess(delta:Float):NodeStatus {
        if (context.get("target") == null) {
            return child.process(delta);
        } else {
            return SUCCESS;
        }
    }
}