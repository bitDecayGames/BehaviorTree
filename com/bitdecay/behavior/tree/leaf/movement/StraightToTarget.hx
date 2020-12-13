package com.bitdecay.behavior.tree.leaf.movement;

import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import com.bitdecay.behavior.tree.NodeStatus;
import com.bitdecay.behavior.tree.leaf.LeafNode;
import com.bitdecay.behavior.tree.BTContext;
import entities.Enemy;
import flixel.tile.FlxBaseTilemap.FlxTilemapDiagonalPolicy;
import flixel.math.FlxPoint;

class StraightToTarget extends LeafNode {

	var started:Bool = false;

	public function new() {}

	public function generatePath(spr:FlxSprite, dest:FlxPoint, collisionLayer:FlxTilemap):Array<FlxPoint> {
		var destinationTile = collisionLayer.getTileIndexByCoords(dest);
        var destinationTileCoords = collisionLayer.getTileCoordsByIndex(destinationTile, true);
        var points = collisionLayer.findPath(spr.getMidpoint(), destinationTileCoords, FlxTilemapDiagonalPolicy.NORMAL);
        return points;
	}

	override public function init(context:BTContext) {
		super.init(context);
		started = false;
	}

	override public function doProcess(delta:Float):NodeStatus {
		var self = cast(context.get("self"), FlxSprite);
		var speed = cast(context.get("speed"), Float);

		if (!started) {
			started = true;
			if (context.get("target") == null) {
				return FAIL;
			}

			var points = generatePath(self, context.get("target"), context.get("collisionLayer"));
			if (points == null || points.length == 0) {
				return FAIL;
			}

			self.path.start(points, speed);
		} else {
			if (self.path.finished || self.path.nodes.length == 0) {
				context.set("target", null);
				started = false;
				return SUCCESS;
			}
		}

		return RUNNING;
	}
}