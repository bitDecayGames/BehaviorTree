package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.decorator.Interrupter;
import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class InterrupterTest {
	@Test
	public function testInterrupterOnKey() {
		var child = TestUtils.getRunningNode(0, RUNNING);
		var node = new Interrupter(KEY_PRESENCE('abort'), child);
		var ctx = new BTContext();
		node.init(ctx);

		for (i in 0...10) {
			NodeAssert.processStatus(RUNNING, node);
		}
		ctx.set('abort', 5);
		NodeAssert.processStatus(FAIL, node);
		Assert.isTrue(child.cancelled);
	}

	@Test
	public function testInterrupterOnCondition() {
		var count = 0;
		var abortOnEleven = (ctx:BTContext) -> {
			count++;
			return count == 11;
		};
		var child = TestUtils.getRunningNode(0, RUNNING);
		var node = new Interrupter(CONDITION(BT.wrapFn(abortOnEleven)), child);
		var ctx = new BTContext();
		node.init(ctx);

		for (i in 0...10) {
			NodeAssert.processStatus(RUNNING, node);
		}
		NodeAssert.processStatus(FAIL, node);
		Assert.isTrue(child.cancelled);
	}
}