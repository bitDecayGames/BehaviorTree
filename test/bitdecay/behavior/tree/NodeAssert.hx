package bitdecay.behavior.tree;

import massive.munit.Assert;

class NodeAssert {
	public static function processStatus(expected:NodeStatus, node:Node, ?errMessage:String = "") {
		var status = node.process(0.1);
		Assert.areEqual(expected, status, '${errMessage + (errMessage.length > 0 ? "." : "")} Expected ${expected}, got: ${status}');
	}
}