package bitdecay.behavior.tree.leaf.util;

import bitdecay.behavior.tree.context.BTContext;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

/**
 * Waits before returning a SUCCESS status
 **/ 
class Wait extends LeafNode {
    
    var started:Bool;
    var initial:Float;
    var remaining:Float;
    var minTime:WaitTime;
    var maxTime:WaitTime;

    public function new(min:WaitTime, ?max:WaitTime) {
        minTime = min;
        maxTime = max != null ? max : min;
    }

    override public function init(context:BTContext) {
        super.init(context);
        started = false;
        var min = getFloat(minTime);
        var max = getFloat(maxTime);

        initial = min + Math.random() * (max - min);
        remaining = initial;
    }

    private function getFloat(wt:WaitTime):Float {
        switch(wt) {
            case CONST(t):
                return t;
            case VAR(name, backup):
                if (context.hasTyped(name, Float) || context.hasTyped(name, Int)) {
                    return context.getFloat(name);
                }

                return backup;
        }
    }

    override public function doProcess(delta:Float):NodeStatus {
        remaining -= delta;

        if (remaining <= 0) {
            remaining = 0;
            return SUCCESS;
        }

        return RUNNING;
    }

    override function getDetail():Array<String> {
        return ['min: ${minTime}, max: ${maxTime}', 'initial: ${FlxMath.roundDecimal(initial, 3)}, remaining: ${FlxMath.roundDecimal(remaining, 3)}'];
    }
}

enum WaitTime {
    /**
     * A fixed time
    **/
    CONST(t:Float);

    /**
     * Pull time from a variable. Backup is used if the var
     * is missing or value is not a number
    **/
    VAR(name:String, backup:Float);
}