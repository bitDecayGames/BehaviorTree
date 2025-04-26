package bitdecay.behavior.tree.composite;

import TestUtils.TestNode;
import bitdecay.behavior.tree.BTreeMacros.BTProcessFunc;
import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.context.BTContext;
import massive.munit.Assert;

class SelectorTest {
	@Test
	public function testInOrder() {
		var cycle = 0;
		var first = new TestNode(1, FAIL);
		var second = new TestNode(1, FAIL);
		var third = new TestNode(1, SUCCESS);
		var node = new Selector(IN_ORDER, [
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
		Assert.areEqual(NodeStatus.SUCCESS, node.process(0.1), "Third cycle returns SUCCESS");
	}

	@Test
	public function testInOrderFailIfNoSuccess() {
		var cycle = 0;
		var first = new TestNode(1, FAIL);
		var second = new TestNode(1, FAIL);
		var third = new TestNode(1, FAIL);
		var node = new Selector(IN_ORDER, [
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
}
