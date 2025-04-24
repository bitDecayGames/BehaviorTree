package bitdecay.behavior.tree.decorator.basic;

import bitdecay.behavior.tree.decorator.DecoratorNode;
import bitdecay.behavior.tree.NodeStatus;

/**
 * Runs the child node, returning the opposite result upon completion
 * Concretely: Returns FAIL of the child node returns SUCCESS
 *             Returns SUCCESS if the child node returns FAIL
**/
class Invert extends DecoratorNode {
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
}