package bitdecay.behavior.tree.composite;

/**
 * Traverses children sequentially, returning SUCCESS only if all
 * children succeed. Returns FAIL upon first child node failing
 *
 * Logically, this is similar to the AND operation
 **/
class Sequence extends CompositeNode {
    var index:Int = 0;
    var lastIndex:Int = -1;
    var previousChildStatus:NodeStatus;

    public function new(children:Array<Node>) {
        super(children);
    }

    override public function init(context:BTContext) {
        super.init(context);
        index = 0;
        lastIndex = -1;
    }

    override public function doProcess(delta:Float):NodeStatus {
        var result = NodeStatus.FAIL;
        while (index < children.length) {
            result = children[index].process(delta);

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
                previousChildStatus = UNKNOWN;
                return RUNNING;
            }
        }

        // We have traversed all of our nodes with no failures, so we have succeeded
        return SUCCESS;
    }
}