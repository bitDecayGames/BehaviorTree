package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.composite.CompositeNode.ChildOrder;
import bitdecay.behavior.tree.context.BTContext;

/**
 * Traverses the children nodes, returning SUCCESS upon
 * first child returning SUCCESS.
 * Returns FAIL if all nodes fail
 *
 * Logically, this is similar to the OR operation
 **/
class Fallback extends CompositeNode {
    public function new(type:ChildOrder, children:Array<Node>, ?name:String = null) {
        super(type, children, name);
        switch type {
            case IN_ORDER:
            case RANDOM(weights):
                if (weights.length != children.length) {
                    #if btree
                    trace('weights (len=${weights.length}) does not match children (len=${children.length})');
                    #end

                    if (weights.length > children.length) {
                        weights.splice(children.length, children.length - weights.length);
                    } else {
                        for (i in 0...children.length - weights.length) {
                            weights.push(0);
                        }
                    }
                }
        }
    }

    override public function process(delta:Float):NodeStatus {
        var index:Int;
        var child:Node;
        var result:NodeStatus = UNKNOWN;
        for (i in 0...children.length) {
            index = order[i];
            child = children[index];
            result = child.process(delta);

            
            #if (BT_DEBUG || debug)
            if (lastStatus[index] != result) {
                @:privateAccess
                ctx.executor.dispatchChange(this, child, result);
            }
            #end

            lastStatus[index] = result;

            if (result == RUNNING) {
                return result;
            } else if (result == SUCCESS) {
                cancelIncomplete();
                return result;
            }
        }

        // We ran out of nodes to check for successes, so we have failed
        return FAIL;
    }

    override public function clone():Node {
        return new Fallback(type, [for (node in children) node.clone()], name);
    }

    override function getDetail():Array<String> {
        return ['type: ${type}', 'order: ${order}'];
    }
}