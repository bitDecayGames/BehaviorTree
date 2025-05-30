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
    public function new(type:ChildOrder, children:Array<Node>, ?name:String = null) {
        super(type, children, name);
    }

    override public function process(delta:Float):NodeStatus {
        var index:Int;
        var child:Node;
        var result:NodeStatus = UNKNOWN;
        for (i in 0...children.length) {
            index = order[i];
            child = children[index];

            if (lastStatus[index] == UNKNOWN) {
                child.init(ctx);
            }

            result = child.process(delta);

            
            #if (BT_DEBUG || debug)
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
        return new Sequence(type, [for (node in children) node.clone()], name);
    }
}

enum SequenceType {
    // Processes nodes in order
    IN_ORDER;

    // Process nodes in random order
    RANDOM(weights:Array<Float>);
}