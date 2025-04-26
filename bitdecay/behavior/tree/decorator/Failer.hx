package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.decorator.DecoratorNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Runs the child node, returning a FAIL status upon completion regardless of actual
 * completion status
**/
class Failer extends DecoratorNode {
    override public function doProcess(raw:NodeStatus):NodeStatus {
        if (raw == RUNNING) {
            return RUNNING;
        }
        return FAIL;
    }

    override public function clone():Node {
        return new Failer(child.clone());
    }
}