package bitdecay.behavior.tree.decorator;

// Runs the child node the specified number of times before returning the status code
// Returns FAIL upon first failure
class Repeater extends DecoratorNode {
    var type:RepeatType;
    var count:Int;
    var remaining:Int;

    var newLoopNeeded = false;

    public function new(type:RepeatType, child:Node) {
        super(child);
        this.type = type;
    }

    override function init(context:BTContext) {
        super.init(context);

        switch(type) {
            case COUNT(n):
                count = n;
            default:
                count == -1;
        }
    }

    override public function doProcess(delta:Float):NodeStatus {
        if (newLoopNeeded) {
            newLoopNeeded = false;
			// TODO: Do we need/want to init the child every loop?
            trace('reapeater init children');
			child.init(context);
        }
        
        var status = child.process(delta);
        if (status != RUNNING) {
            newLoopNeeded = true;
            
            remaining = Std.int(Math.max(-1, remaining-1));

            switch(type) {
                case FOREVER:
                    return RUNNING;
                case COUNT(n):
                    if (remaining == 0) {
                        // TODO: Do we return success because we ran n times? Or do we return the status of the final run?
                        return status;
                    } else {
                        // More iterations to do
                        return RUNNING;
                    }
                default:
            }

            if ((type == UNTIL_FAIL && status == FAIL) || type == UNTIL_SUCCESS && status == SUCCESS) {
                return status;
            }
        }

        return RUNNING;
    }
}

enum RepeatType {
    COUNT(n:Int);
    UNTIL_FAIL;
    UNTIL_SUCCESS;
    FOREVER;
}