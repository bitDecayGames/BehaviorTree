package bitdecay.behavior.tree.composite;

import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class SequenceTest {
	@Test
	public function testInOrderFailOnFail() {
		var cycle = 0;
		var first = TestUtils.getRunningNode(1, SUCCESS);
		var second = TestUtils.getRunningNode(1, SUCCESS);
		var third = TestUtils.getRunningNode(1, FAIL);
		var node = new Sequence(IN_ORDER, [
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

	@Test
	public function testInOrderAllSucceed() {
		var cycle = 0;
		var first = TestUtils.getRunningNode(1, SUCCESS);
		var second = TestUtils.getRunningNode(1, SUCCESS);
		var third = TestUtils.getRunningNode(1, SUCCESS);
		var node = new Sequence(IN_ORDER, [
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
}