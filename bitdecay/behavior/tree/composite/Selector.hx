package bitdecay.behavior.tree.composite;

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
    var needsInit:Bool;

    var previousChildStatus:NodeStatus;

    var order:Array<Int>;

    public function new(type:SelectorType, children:Array<Node>) {
        super(children);
        this.type = type;
        #if btree
        switch type {
            case IN_ORDER:
            case RANDOM(weights):
                if (weights.length != children.length) {
                    trace('weights (len=${weights.length}) does not match children (len=${children.length})');
                }
        }
        #end
    }

    override function init(context:BTContext) {
        super.init(context);
        index = 0;
        needsInit = true;
        previousChildStatus = UNKNOWN;
        order = [for (i in 0...children.length) i];

        switch type {
            case IN_ORDER:
                order = [for (i in 0...children.length) i];
            case RANDOM(weights):
                var indexTracker = order.copy();
                order = [];
                var weightTracker = weights.copy();
                var cumulativeWeights:Array<Float> = [];
                var sum = 0.0;
                
                for (w in weights) {
                    sum += w;
                    cumulativeWeights.push(sum);
                }

                var next = 0;
                for (i in 0...weights.length) {
					var r = Math.random() * sum;
					for (c in 0...cumulativeWeights.length) {
						if (r <= cumulativeWeights[c]) {
                            next = c;
                            break;
						}
					}
                    sum -= weightTracker[next];
					order.push(indexTracker[next]);
                    cumulativeWeights.splice(next, 1);
                    for (k in next...cumulativeWeights.length) {
                        cumulativeWeights[k] -= weightTracker[next];
                    }
                    weightTracker.splice(next, 1);
                    indexTracker.splice(next, 1);
                }
        }
    }

    override public function doProcess(delta:Float):NodeStatus {
        var result = NodeStatus.FAIL;
        while (index < children.length) {
            if (needsInit) {
                needsInit = false;
                children[order[index]].init(context);
                #if debug
                @:privateAccess
                context.owner.nodeStatusChange.dispatch(this, children[index], UNKNOWN);
                #end
            }
            result = children[order[index]].process(delta);

            #if debug
            if (previousChildStatus != result) {
                previousChildStatus = result;
    
                @:privateAccess
                context.owner.nodeStatusChange.dispatch(this, children[index], result);
            }
            #end

            if (result == RUNNING) {
                return result;
            } else if (result == SUCCESS) {
                return result;
            } else {
                needsInit = true;
                index++;
                previousChildStatus = UNKNOWN;
                return RUNNING;
            }
        }

        // We ran out of nodes to check for successes, so we have failed
        return FAIL;
    }

    override function getDetail():Array<String> {
        return ['type: ${type}', 'order: ${order}'];
    }
}

enum SelectorType {
    // Processes nodes in order
    IN_ORDER;

    // Process nodes in random order. Behavior undefined if number of weights does not match number of child nodes
    RANDOM(weights:Array<Float>);
}