package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Runs the child node the multiple times according to the RepeatType
**/
class Repeater extends DecoratorNode {
    var type:RepeatType;
    var count:Int;
    var lastStatus:NodeStatus = UNKNOWN;

    public function new(type:RepeatType, child:Node, name:String = null) {
        super(child, name);
        this.type = type;
    }

    override function init(ctx:BTContext) {
        super.init(ctx);
        lastStatus = UNKNOWN;
        count = 0;
    }

    override function process(delta:Float):NodeStatus {
        if (lastStatus != RUNNING) {
            if (lastStatus != UNKNOWN) {
                // prevent double-init'ing our first time through
                child.init(ctx);
            }
            
            count++;
        }
        return super.process(delta);
    }

    override public function doProcess(raw:NodeStatus):NodeStatus {
        lastStatus = raw;
        if (raw != RUNNING) {
            raw = switch(type) {
                case FOREVER:
                    RUNNING;
                case COUNT(n):
                    if (n > 0 && count == n) {
                        SUCCESS;
                    } else {
                        RUNNING;
                    }
                case UNTIL_FAIL(max):
                    if (raw == FAIL) {
                        SUCCESS;
                    } else if (max > 0 && count == max) {
                        FAIL;
                    } else {
                        RUNNING;
                    }
                case UNTIL_SUCCESS(max):
                    if (raw == SUCCESS) {
                        raw;
                    } else if (max > 0 && count == max) {
                        FAIL;
                    } else {
                        RUNNING;
                    }
            }
        }

        return raw;
    }

    override public function clone():Node {
        return new Repeater(type, child.clone(), name);
    }

    override function getDetail():Array<String> {
        return ['type: ${type}', 'current: ${count}'];
    }
}

enum RepeatType {
    /**
     * Run n number of times, returning SUCCESS after n completions
    **/
    COUNT(n:Int);

    /**
     * Run until child returns FAIL status, at most `max` times. Zero implies no limit.
     * Returns SUCCESS once child fails. Returns FAIL if `max` cycles complete without
     * a FAIL occurring.
    **/
    UNTIL_FAIL(max:Int);

    /**
     * Run until child returns SUCCESS status, at most `max` times. Zero implies no limit.
     * Returns SUCCESS once child succeeds. Returns FAIL if `max` cycles complete without
     * a SUCCESS occurring.
    **/
    UNTIL_SUCCESS(max:Int);

    /**
     * Run repeatedly forever, regardless of child return status
    **/
    FOREVER;
}