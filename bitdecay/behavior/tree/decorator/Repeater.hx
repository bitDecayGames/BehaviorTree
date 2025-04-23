package bitdecay.behavior.tree.decorator;

/**
 * Runs the child node the multiple times according to the RepeatType
**/
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
            trace('repeater init children');
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
                        return status;
                    } else {
                        // More iterations to do
                        return RUNNING;
                    }
                case UNTIL_FAIL:
                    if (status == FAIL) {
                        return status;
                    }
                case UNTIL_SUCCESS:
                    if (status == SUCCESS) {
                        return status;
                    }
                default:
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