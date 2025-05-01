package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.decorator.DecoratorNode;

/**
 * Runs the child node, returning the opposite result upon completion
 * Concretely: Returns FAIL of the child node returns SUCCESS
 *             Returns SUCCESS if the child node returns FAIL
**/
class Inverter extends DecoratorNode {
	public function new(child:Node, ?name:String = null) {
		super (child, name);
	}
	
    override public function doProcess(raw:NodeStatus):NodeStatus {
		switch (raw) {
			case RUNNING, UNKNOWN:
				return raw;
			case FAIL:
				return SUCCESS;
			case SUCCESS:
				return FAIL;
        }
    }

	override public function clone():Node {
        return new Inverter(child.clone(), name);
    }
}