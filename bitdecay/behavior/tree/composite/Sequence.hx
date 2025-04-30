package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.composite.CompositeNode.ChildOrder;
import bitdecay.behavior.tree.context.BTContext;

/**
 * Traverses children sequentially, returning SUCCESS only if all
 * children succeed. Returns FAIL upon first child node failing
 *
 * Logically, this is similar to the AND operation
 **/
class Sequence extends CompositeNode {
    public function new(type:ChildOrder, children:Array<Node>) {
        super(type, children);
    }

    override public function process(delta:Float):NodeStatus {
        var index:Int;
        var child:Node;
        var result:NodeStatus = UNKNOWN;
        for (i in 0...children.length) {
            index = order[i];
            child = children[index];
            result = child.process(delta);

            
            #if debug
            if (lastStatus[index] != result) {
                @:privateAccess
                ctx.executor.dispatchChange(this, child, result);
            }
            #end
            lastStatus[index] = result;

            if (result == RUNNING) {
                cancelIncomplete(i);
                return result;
            } else if (result == FAIL) {
                cancelIncomplete();
                return result;
            }
        }

        // We have traversed all of our nodes with no failures, so we have succeeded
        return SUCCESS;
    }

    override public function clone():Node {
        return new Sequence(type, [for (node in children) node.clone()]);
    }
}

enum SequenceType {
    // Processes nodes in order
    IN_ORDER;

    // Process nodes in random order
    RANDOM(weights:Array<Float>);
}