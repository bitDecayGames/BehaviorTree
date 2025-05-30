package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.enums.Time;
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
    var minTime:Time;
    var maxTime:Time;

    public function new(min:Time, ?max:Time) {
        minTime = min;
        maxTime = max != null ? max : min;
    }

    override public function init(ctx:BTContext) {
        super.init(ctx);
        started = false;
        var min = TimeHelper.getFloat(ctx, minTime);
        var max = TimeHelper.getFloat(ctx, maxTime);

        initial = min + Math.random() * (max - min);
        remaining = initial;
    }

    override public function process(delta:Float):NodeStatus {
        remaining -= delta;

        if (remaining <= 0) {
            remaining = 0;
            return SUCCESS;
        }

        return RUNNING;
    }

    override public function clone():Node {
        return new Wait(minTime, maxTime);
    }

    override function getDetail():Array<String> {
        return ['min: ${minTime}, max: ${maxTime}', 'initial: ${TimeHelper.roundMS(initial)}, remaining: ${TimeHelper.roundMS(remaining)}'];
    }
}
