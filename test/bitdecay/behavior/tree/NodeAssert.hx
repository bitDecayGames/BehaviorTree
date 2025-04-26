package bitdecay.behavior.tree;

import massive.munit.Assert;

class NodeAssert {
	public static function processStatus(expected:NodeStatus, node:Node, ?errMessage:String = "", ?delta:Float = .1, ?pos:haxe.PosInfos) {
		var status = node.process(delta);
		Assert.areEqual(expected, status, '${errMessage + (errMessage.length > 0 ? "." : "")} Expected ${expected}, got: ${status} (${pos.fileName}:${pos.lineNumber})');
	}
}