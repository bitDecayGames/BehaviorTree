package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.context.BTContext;
import massive.munit.Assert;

class FallbackTest {
	@Test
	public function testInOrderAllFail() {
		var failOne = TestUtils.getRunningNode(1, FAIL);
		var failTwo = TestUtils.getRunningNode(1, FAIL);
		var failThree = TestUtils.getRunningNode(1, FAIL);
		var node = new Fallback(IN_ORDER, [
			failOne,
			failTwo,
			failThree,
		]);
		node.init(new BTContext());

		NodeAssert.processStatus(FAIL, node);
		NodeAssert.processCount(1, failOne);
		NodeAssert.processCount(1, failTwo);
		NodeAssert.processCount(1, failThree);
	}

	@Test
	public function testInOrderLastSucceed() {
		var failOne = TestUtils.getRunningNode(1, FAIL);
		var failTwo = TestUtils.getRunningNode(1, FAIL);
		var success = TestUtils.getRunningNode(1, SUCCESS);
		var node = new Fallback(IN_ORDER, [
			failOne,
			failTwo,
			success,
		]);
		node.init(new BTContext());

		NodeAssert.processStatus(SUCCESS, node);
		NodeAssert.processCount(1, failOne);
		NodeAssert.processCount(1, failTwo);
		NodeAssert.processCount(1, success);
	}

	@Test
	public function testInOrderFirstSucceed() {
		var failOne = TestUtils.getRunningNode(1, FAIL);
		var failTwo = TestUtils.getRunningNode(1, FAIL);
		var success = TestUtils.getRunningNode(1, SUCCESS);
		var node = new Fallback(IN_ORDER, [
			success,
			failOne,
			failTwo,
		]);
		node.init(new BTContext());

		NodeAssert.processStatus(SUCCESS, node);
		NodeAssert.processCount(1, success);
		NodeAssert.processCount(0, failOne);
		NodeAssert.processCount(0, failTwo);
	}
}
