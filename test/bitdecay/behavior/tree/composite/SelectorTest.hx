package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.context.BTContext;
import massive.munit.Assert;

class SelectorTest {
	@Test
	public function testInOrder() {
		var cycle = 0;
		var first = TestUtils.getRunningNode(1, FAIL);
		var second = TestUtils.getRunningNode(1, FAIL);
		var third = TestUtils.getRunningNode(1, SUCCESS);
		var node = new Selector(IN_ORDER, [
			first,
			second,
			third,
		]);
		node.init(new BTContext());

		cycle++;
		NodeAssert.processStatus(RUNNING, node);
		cycle++;
		NodeAssert.processStatus(RUNNING, node);
		cycle++;
		NodeAssert.processStatus(SUCCESS, node);

	}

	@Test
	public function testInOrderFailIfNoSuccess() {
		var cycle = 0;
		var first = TestUtils.getRunningNode(1, FAIL);
		var second = TestUtils.getRunningNode(1, FAIL);
		var third = TestUtils.getRunningNode(1, FAIL);
		var node = new Selector(RANDOM([.33, .33, .33]), [
			first,
			second,
			third,
		]);
		node.init(new BTContext());

		cycle++;
		NodeAssert.processStatus(RUNNING, node);
		cycle++;
		NodeAssert.processStatus(RUNNING, node);
		cycle++;
		NodeAssert.processStatus(FAIL, node);
	}
}
