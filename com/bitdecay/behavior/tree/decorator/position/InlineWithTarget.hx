package com.bitdecay.behavior.tree.decorator.position;

import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import entities.Player;
import com.bitdecay.behavior.tree.NodeStatus;
import com.bitdecay.behavior.tree.Node;
import com.bitdecay.behavior.tree.decorator.DecoratorNode;
import com.bitdecay.behavior.tree.BTContext;

class InlineWithTarget extends DecoratorNode {

    private var triggered:Bool = false;

    public function new(child:Node) {
        super(child);
    }

    override public function doProcess(delta:Float):NodeStatus {
        if (context.get("target") == null) {
            return FAIL;
        }

        if (context.get("self") == null) {
            return FAIL;
        }

        if (triggered || cardinalAlignment(context.get("self"), context.get("target"))) {
            switch (child.process(delta)) {
                case SUCCESS:
                    triggered = false;
                    return SUCCESS;
                case FAIL:
                    triggered = false;
                    return FAIL;
                case RUNNING:
                    triggered = true;
                    return RUNNING;
            }
        } else {
            return FAIL;
        }
    }

    private function cardinalAlignment(a:FlxSprite, target:FlxPoint):Bool {
        var collisionLayer = cast(context.get("collisionLayer"), FlxTilemap);

        var tileA = collisionLayer.getTileIndexByCoords(a.getMidpoint());
        var tileB = collisionLayer.getTileIndexByCoords(target);
        var tileAPos = collisionLayer.getTileCoordsByIndex(tileA, true);
        var tileBPos = collisionLayer.getTileCoordsByIndex(tileB, true);

        if (tileAPos.x == tileBPos.x || tileAPos.y == tileBPos.y) {
            return true;
        } else {
            return false;
        }
    }
}