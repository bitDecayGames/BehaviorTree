package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.leaf.Success;
import bitdecay.behavior.tree.leaf.Fail;
import TestUtils.StatusFlipNode;
import bitdecay.behavior.tree.decorator.Repeater;
import bitdecay.behavior.tree.context.BTContext;

class RepeaterTest {
	@Test
	public function testRepeaterUntilFailWaitsForFail() {
		var node = new Repeater(UNTIL_FAIL(0), new StatusFlipNode(SUCCESS, 11, FAIL, false));
		node.init(new BTContext());

		for (i in 0...10) {
			NodeAssert.processStatus(RUNNING, node);
		}

		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testRepeaterUntilFailRespectsLimit() {
		var node = new Repeater(UNTIL_FAIL(10), new Success());
		node.init(new BTContext());

		for (i in 0...9) {
			NodeAssert.processStatus(RUNNING, node);
		}

		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testRepeaterUntilSuccessWaitsForSuccess() {
		var node = new Repeater(UNTIL_SUCCESS(0), new StatusFlipNode(FAIL, 11, SUCCESS, false));
		node.init(new BTContext());

		for (i in 0...10) {
			NodeAssert.processStatus(RUNNING, node);
		}
		
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testRepeaterUntilSuccessRespectsLimit() {
		var node = new Repeater(UNTIL_SUCCESS(10), new Fail());
		node.init(new BTContext());

		for (i in 0...9) {
			NodeAssert.processStatus(RUNNING, node);
		}

		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testRepeaterCountRunsToLimit() {
		var node = new Repeater(COUNT(10), new StatusFlipNode(FAIL, 5, SUCCESS, false));
		node.init(new BTContext());

		for (i in 0...9) {
			NodeAssert.processStatus(RUNNING, node);
		}

		NodeAssert.processStatus(SUCCESS, node);
	}
}
