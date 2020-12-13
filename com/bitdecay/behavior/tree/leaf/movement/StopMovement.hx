package com.bitdecay.behavior.tree.leaf.movement;

import flixel.FlxSprite;
import com.bitdecay.behavior.tree.NodeStatus;
import com.bitdecay.behavior.tree.leaf.LeafNode;

class StopMovement extends LeafNode {
	public function new() {}

	override public function doProcess(delta:Float):NodeStatus {
		var self = cast(context.get("self"), FlxSprite);
		self.velocity.set();
		return SUCCESS;
	}
}