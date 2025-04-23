package bitdecay.behavior.tree.decorator.basic;

import bitdecay.behavior.tree.decorator.DecoratorNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Runs the child node, returning a FAIL status upon completion regardless of actual
 * completion status
**/
class AlwaysFail extends DecoratorNode {
    override public function doProcess(delta:Float):NodeStatus {
        if (child.process(delta) == RUNNING) {
            return RUNNING;
        }
        return FAIL;
    }
}