package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.context.BTContext;
import bitdecay.behavior.tree.context.FallbackContext;
import bitdecay.behavior.tree.decorator.DecoratorNode;

/**
 * Creates a new context for the child to use. All children
 * under this node are unable to change the input context,
 * but are able to retrieve values from it. Any values set
 * in children nodes are only visible to children under this
 * node.
**/
class HierarchicalContext extends DecoratorNode {
	var subContext:BTContext;

	override function init(context:BTContext) {
		 this.context = context;
		 subContext = new FallbackContext(context);
		 subContext.executor = context.executor;
        if (child.init != null) {
            child.init(subContext);
        }
        previousChildStatus = null;
	}

	override public function clone():Node {
        return new HierarchicalContext(child.clone());
    }
}