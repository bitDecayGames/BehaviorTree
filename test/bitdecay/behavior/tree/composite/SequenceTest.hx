package bitdecay.behavior.tree.composite;

import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class SequenceTest {
	@Test
	public function testInOrderFailOnFirstFail() {
		var successOne = TestUtils.getRunningNode(1, SUCCESS);
		var successTwo = TestUtils.getRunningNode(1, SUCCESS);
		var fail = TestUtils.getRunningNode(1, FAIL);
		var node = new Sequence(IN_ORDER, [
			fail,
			successOne,
			successTwo,
		]);
		node.init(new BTContext());

		NodeAssert.processStatus(FAIL, node);
		NodeAssert.processCount(1, fail);
		NodeAssert.processCount(0, successOne);
		NodeAssert.processCount(0, successTwo);
	}

	@Test
	public function testInOrderAllSucceed() {
		var first = TestUtils.getRunningNode(1, SUCCESS);
		var second = TestUtils.getRunningNode(1, SUCCESS);
		var third = TestUtils.getRunningNode(1, SUCCESS);
		var node = new Sequence(IN_ORDER, [
			first,
			second,
			third,
		]);
		node.init(new BTContext());

		NodeAssert.processStatus(SUCCESS, node);
		NodeAssert.processCount(1, first);
		NodeAssert.processCount(1, second);
		NodeAssert.processCount(1, third);
	}
}