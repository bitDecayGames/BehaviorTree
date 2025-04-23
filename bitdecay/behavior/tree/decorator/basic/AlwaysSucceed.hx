package bitdecay.behavior.tree.decorator.basic;

import bitdecay.behavior.tree.decorator.DecoratorNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Runs the child node, returning a SUCCESS status upon completion regardless of actual
 * completion status
**/
class AlwaysSucceed extends DecoratorNode {
    override public function doProcess(delta:Float):NodeStatus {
        if (child.process(delta) == RUNNING) {
            return RUNNING;
        }
        return SUCCESS;
    }
}