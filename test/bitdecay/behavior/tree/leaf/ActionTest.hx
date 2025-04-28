package bitdecay.behavior.tree.leaf;

import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class ActionTest {
	@Test
	public function testActionIsExecuted() {
		var test = false;
		var node = new Action(BT.wrapFn((ctx) -> {
			test = true;
		}));
		node.init(new BTContext());

		NodeAssert.processStatus(SUCCESS, node);
		Assert.isTrue(test);
	}
}