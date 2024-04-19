package bitdecay.behavior.tree.leaf.util;

import bitdecay.behavior.tree.BTContext;
import bitdecay.behavior.tree.NodeStatus;
import bitdecay.behavior.tree.leaf.LeafNode;

// Waits a random amount of time between min/max. If no times provided to constructor, the context is
// used to determine wait times
class Wait extends LeafNode {
    public static inline var MIN_TIME = "waitMin";
    public static inline var MAX_TIME = "waitMax";
    
    var started:Bool;
    var remaining:Float;
    var minTime:Float;
    var maxTime:Float;

    public function new(min:Float = -1.0, max:Float = -1.0) {
        minTime = min;
        maxTime = Math.max(min, max);
    }

    override public function init(context:BTContext) {
        super.init(context);
        started = false;
        var min = minTime;
        if (min < 0 && context.has(MIN_TIME)) {
            min = cast(context.get(MIN_TIME), Float);
        }
        var max = maxTime;
        if (max < 0 && context.has(MAX_TIME)) {
            max = cast(context.get(MAX_TIME), Float);
        }
        remaining = min + Math.random() * (max - min);
    }

    override public function doProcess(delta:Float):NodeStatus {
        remaining -= delta;

        if (remaining <= 0) {
            return SUCCESS;
        }

        return RUNNING;
    }
}