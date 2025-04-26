package bitdecay.behavior.tree.composite;

import TestUtils.TestNode;
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
		NodeAssert.processStatus(NodeStatus.RUNNING, node);
		cycle++;
		NodeAssert.processStatus(NodeStatus.RUNNING, node);
		cycle++;
		NodeAssert.processStatus(NodeStatus.SUCCESS, node);

	}

	@Test
	public function testInOrderFailIfNoSuccess() {
		var cycle = 0;
		var first = new TestNode(1, FAIL);
		var second = new TestNode(1, FAIL);
		var third = new TestNode(1, FAIL);
		var node = new Selector(RANDOM([.33, .33, .33]), [
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
		NodeAssert.processStatus(NodeStatus.FAIL, node);
	}
}
