package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Traverses the children nodes, returning SUCCESS upon
 * first child returning SUCCESS.
 * Returns FAIL if all nodes fail
 *
 * Logically, this is similar to the OR operation
 **/
class Selector extends CompositeNode {
    var index:Int = 0;
    var type:SelectorType;
    var order:Array<Int>;

    var previousChildStatus:NodeStatus;

    public function new(type:SelectorType, children:Array<Node>) {
        super(children);
        this.type = type;
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

    override function init(context:BTContext) {
        super.init(context);
        index = 0;
        previousChildStatus = UNKNOWN;

        switch type {
            case IN_ORDER:
                order = [for (i in 0...children.length) i];
            case RANDOM(weights):
                order = Tools.randomIndexOrderFromWeights(weights);
        }
    }

    override public function doProcess(delta:Float):NodeStatus {
        var result = NodeStatus.FAIL;
        if (index < children.length) {
            result = children[order[index]].process(delta);

            #if debug
            if (previousChildStatus != result) {
                previousChildStatus = result;
    
                @:privateAccess
                context.executor.dispatchChange(this, children[index], result);
            }
            #end

            if (result == RUNNING) {
                return result;
            } else if (result == SUCCESS) {
                return result;
            }

            index++;
            if (index < children.length) {
                previousChildStatus = UNKNOWN;
                return RUNNING;
            }
        }

        // We ran out of nodes to check for successes, so we have failed
        return FAIL;
    }

    override public function clone():Node {
        return new Selector(type, [for (node in children) node.clone()]);
    }

    override function getDetail():Array<String> {
        return ['type: ${type}', 'order: ${order}'];
    }
}

enum SelectorType {
    // Processes nodes in order
    IN_ORDER;

    // Process nodes in random order
    RANDOM(weights:Array<Float>);
}