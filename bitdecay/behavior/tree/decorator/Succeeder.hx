package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.decorator.DecoratorNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Runs the child node, returning a SUCCESS status upon completion regardless of actual
 * completion status
**/
class Succeeder extends DecoratorNode {
    public function new(child:Node, ?name:String = null) {
		super (child, name);
	}
    
    override public function doProcess(raw:NodeStatus):NodeStatus {
        if (raw == RUNNING) {
            return RUNNING;
        }
        return SUCCESS;
    }

    override public function clone():Node {
        return new Succeeder(child.clone(), name);
    }
}