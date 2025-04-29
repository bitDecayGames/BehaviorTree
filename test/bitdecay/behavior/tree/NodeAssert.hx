package bitdecay.behavior.tree;

import TestUtils.StatusFlipNode;
import massive.munit.Assert;

class NodeAssert {
	public static function processStatus(expected:NodeStatus, node:Node, ?errMessage:String = "", ?delta:Float = .1, ?pos:haxe.PosInfos) {
		var status = node.process(delta);
		Assert.areEqual(expected, status, '${errMessage + (errMessage.length > 0 ? "." : "")} Expected ${expected}, got: ${status} (${pos.fileName}:${pos.lineNumber})');
	}

	public static function processCount(expected:Int, node:StatusFlipNode, ?errMessage:String = "", ?pos:haxe.PosInfos) {
		Assert.areEqual(expected, node.processCount, '${errMessage + (errMessage.length > 0 ? "." : "")} Expected ${expected} process calls, got: ${node.processCount} (${pos.fileName}:${pos.lineNumber})');
	}
}