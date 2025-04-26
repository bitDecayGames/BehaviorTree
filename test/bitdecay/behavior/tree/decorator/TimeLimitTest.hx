package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.decorator.TimeLimit;
import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class TimeLimitTest {
	@Test
	public function testTimeLimitConstantTimeAborts() {
		var child = TestUtils.getRunningNode(0, RUNNING);
		var node = new TimeLimit(CONST(1.01), child);
		var ctx = new BTContext();
		node.init(ctx);

		for (i in 0...10) {
			NodeAssert.processStatus(RUNNING, node);
		}
		NodeAssert.processStatus(FAIL, node);
		Assert.isTrue(child.cancelled);
	}

	@Test
	public function testTimeLimitReturnChildStatusOnComplete() {
		var child = TestUtils.getRunningNode(11, SUCCESS);
		var node = new TimeLimit(CONST(1.5), child);
		var ctx = new BTContext();
		node.init(ctx);

		for (i in 0...10) {
			NodeAssert.processStatus(RUNNING, node);
		}
		NodeAssert.processStatus(SUCCESS, node);
	}
}