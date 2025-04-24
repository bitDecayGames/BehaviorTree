package bitdecay.behavior.tree.decorator;

/**
 * Runs the child node the multiple times according to the RepeatType
**/
class Repeater extends DecoratorNode {
    var type:RepeatType;
    var count:Int;
    var lastStatus:NodeStatus = null;

    public function new(type:RepeatType, child:Node) {
        super(child);
        this.type = type;
    }

    override function init(context:BTContext) {
        super.init(context);
        lastStatus = null;
        count = 0;
    }

    override public function doProcess(raw:NodeStatus):NodeStatus {
        if (lastStatus != RUNNING) {
            count++;
        }
        
        lastStatus = raw;
        if (raw != RUNNING) {
            raw = switch(type) {
                case FOREVER:
                    RUNNING;
                case COUNT(n):
                    if (n > 0 && count == n) {
                        raw;
                    } else {
                        child.init(context);
                        RUNNING;
                    }
                case UNTIL_FAIL(max):
                    if (raw == FAIL) {
                        SUCCESS;
                    } else if (count == max) {
                        FAIL;
                    } else {
                        child.init(context);
                        RUNNING;
                    }
                case UNTIL_SUCCESS(max):
                    if (raw == SUCCESS) {
                        raw;
                    } else if (count == max) {
                        FAIL;
                    } else {
                        child.init(context);
                        RUNNING;
                    }
            }
        }

        return raw;
    }

    override function getDetail():Array<String> {
        return ['type: ${type}', 'current: ${count}'];
    }
}

enum RepeatType {
    /**
     * Run n number of times, returning the final NodeStatus
    **/
    COUNT(n:Int);

    /**
     * Run until child returns FAIL status, at most `max` times. Zero implies no limit.
    **/
    UNTIL_FAIL(max:Int);

    /**
     * Run until child returns SUCCESS status, at most `max` times. Zero implies no limit.
    **/
    UNTIL_SUCCESS(max:Int);

    /**
     * Run repeatedly forever, regardless of child return status
    **/
    FOREVER;
}