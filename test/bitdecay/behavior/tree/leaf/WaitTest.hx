package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.leaf.Wait;
import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class WaitTest {
	@Test
	public function testWaitRespectsTimeSmallSteps() {
		var node = new Wait(CONST(1.01));
		var ctx = new BTContext();
		node.init(ctx);

		for (i in 0...100) {
			NodeAssert.processStatus(RUNNING, node, .01);
		}
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testWaitRespectsTimeLargeStep() {
		var node = new Wait(CONST(1));
		var ctx = new BTContext();
		node.init(ctx);

		NodeAssert.processStatus(SUCCESS, node, 2);
	}
}