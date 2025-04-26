package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.decorator.TimeLimit;
import TestUtils.TestNode;
import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class TimeLimitTest {
	@Test
	public function testTimeLimitConstantTimeAborts() {
		var child = new TestNode(0, RUNNING);
		var node = new TimeLimit(CONST(1.01), child);
		var ctx = new BTContext();
		node.init(ctx);

		for (i in 0...10) {
			Assert.areEqual(NodeStatus.RUNNING, node.process(0.1));
		}
		Assert.areEqual(NodeStatus.FAIL, node.process(0.1));
		Assert.isTrue(child.cancelled);
	}

	@Test
	public function testTimeLimitReturnChildStatusOnComplete() {
		var child = new TestNode(11, SUCCESS);
		var node = new TimeLimit(CONST(1.5), child);
		var ctx = new BTContext();
		node.init(ctx);

		for (i in 0...10) {
			Assert.areEqual(NodeStatus.RUNNING, node.process(0.1));
		}
		Assert.areEqual(NodeStatus.SUCCESS, node.process(0.1));
	}
}