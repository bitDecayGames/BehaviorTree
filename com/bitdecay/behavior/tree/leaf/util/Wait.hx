package com.bitdecay.behavior.tree.leaf.util;

import flixel.FlxG;
import com.bitdecay.behavior.tree.BTContext;
import com.bitdecay.behavior.tree.NodeStatus;
import com.bitdecay.behavior.tree.leaf.LeafNode;

class Wait extends LeafNode {
    var started:Bool;
    var remaining:Float;

    public function new() {}

    override public function init(context:BTContext) {
        super.init(context);
        started = false;
        remaining = 0;
    }

    override public function doProcess(delta:Float):NodeStatus {
        if (remaining <= 0) {
            if (started) {
                started = false;
                return SUCCESS;
            } else {
                var min = cast(context.get("minWait"), Float);
                var max = min;
                if (context.get("maxWait") != null) {
                    max = cast(context.get("maxWait"), Float);
                }
                remaining = FlxG.random.float(min, max);
                started = true;
            }
        }

        remaining -= delta;
        return RUNNING;
    }
}