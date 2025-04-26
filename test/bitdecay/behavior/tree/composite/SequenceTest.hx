package bitdecay.behavior.tree.composite;

import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;
import TestUtils.TestNode;

class SequenceTest {
	@Test
	public function testInOrderFailOnFail() {
		var cycle = 0;
		var first = new TestNode(1, SUCCESS);
		var second = new TestNode(1, SUCCESS);
		var third = new TestNode(1, FAIL);
		var node = new Sequence(IN_ORDER, [
			first,
			second,
			third,
		]);
		node.init(new BTContext());

		cycle++;
		Assert.areEqual(NodeStatus.RUNNING, node.process(0.1), "First cycle returns RUNNING");
		cycle++;
		Assert.areEqual(NodeStatus.RUNNING, node.process(0.1), "Second cycle returns RUNNING");
		cycle++;
		Assert.areEqual(NodeStatus.FAIL, node.process(0.1), "Third cycle returns FAIL");
	}

	@Test
	public function testInOrderAllSucceed() {
		var cycle = 0;
		var first = new TestNode(1, SUCCESS);
		var second = new TestNode(1, SUCCESS);
		var third = new TestNode(1, SUCCESS);
		var node = new Sequence(IN_ORDER, [
			first,
			second,
			third,
		]);
		node.init(new BTContext());

		cycle++;
		NodeAssert.processStatus(NodeStatus.RUNNING, node);
		cycle++;
		NodeAssert.processStatus(NodeStatus.RUNNING, node);
		cycle++;
		NodeAssert.processStatus(NodeStatus.SUCCESS, node);
	}
}