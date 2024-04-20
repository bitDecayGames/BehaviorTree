package bitdecay.behavior.tree.decorator;

// Runs the child node the specified number of times before returning the status code
// Returns FAIL upon first failure
class Repeater extends DecoratorNode {
    var type:RepeatType;
    var count:Int;
    var remaining:Int;

    public function new(type:RepeatType, child:Node) {
        super(child);
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
        var status = child.process(delta);
        if (status != RUNNING) {
            
            remaining = Std.int(Math.max(-1, remaining-1));

            switch(type) {
                case COUNT(n):
                    if (remaining == 0) {
                        // TODO: Do we return success because we ran n times? Or do we return the status of the final run?
                        return SUCCESS;
                    }
                default:
            }

            if (type == UNTIL_FAIL && status == FAIL) {
                // TODO: Do we return success because the fail happened?
                // Do we return fail because that is actually what happened?
                return status;
            }
        }

        return RUNNING;
    }
}

enum RepeatType {
    COUNT(n:Int);
    UNTIL_FAIL;
    FOREVER;
}