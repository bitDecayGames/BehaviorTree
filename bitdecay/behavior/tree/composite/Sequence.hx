package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Traverses children sequentially, returning SUCCESS only if all
 * children succeed. Returns FAIL upon first child node failing
 *
 * Logically, this is similar to the AND operation
 **/
class Sequence extends CompositeNode {
    var type:SequenceType;
    var index:Int = 0;
    var order:Array<Int>;

    var previousChildStatus:NodeStatus;

    public function new(type:SequenceType, children:Array<Node>) {
        super(children);
        this.type = type;
    }

    override public function init(context:BTContext) {
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
        while (index < children.length) {
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
            } else if (result == FAIL) {
                return result;
            } else {
                index++;
                if (index < children.length) {
                    previousChildStatus = UNKNOWN;
                    return RUNNING;
                }
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