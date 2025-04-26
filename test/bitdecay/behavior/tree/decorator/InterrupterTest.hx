package bitdecay.behavior.tree.decorator;

import TestUtils.TestNode;
import bitdecay.behavior.tree.decorator.Interrupter;
import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class InterrupterTest {
	@Test
	public function testInterrupterOnKey() {
		var child = new TestNode(0, RUNNING);
		var node = new Interrupter(KEY_PRESENCE('abort'), child);
		var ctx = new BTContext();
		node.init(ctx);

		for (i in 0...10) {
			Assert.areEqual(NodeStatus.RUNNING, node.process(0.1));
		}
		ctx.set('abort', 5);
		Assert.areEqual(NodeStatus.FAIL, node.process(0.1));
		Assert.isTrue(child.cancelled);
	}

	@Test
	public function testInterrupterOnCondition() {
		var count = 0;
		var abortOnEleven = () -> {
			count++;
			return count == 11;
		};
		var child = new TestNode(0, RUNNING);
		var node = new Interrupter(CONDITION(abortOnEleven), child);
		var ctx = new BTContext();
		node.init(ctx);

		for (i in 0...10) {
			Assert.areEqual(NodeStatus.RUNNING, node.process(0.1));
		}
		Assert.areEqual(NodeStatus.FAIL, node.process(0.1));
		Assert.isTrue(child.cancelled);
	}
}