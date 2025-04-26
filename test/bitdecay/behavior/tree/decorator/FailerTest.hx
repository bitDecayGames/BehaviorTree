package bitdecay.behavior.tree.decorator;

import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;
import bitdecay.behavior.tree.leaf.Success;

class FailerTest {
	@Test
	public function testFailerFails() {
		var node = new Failer(new Success());
		node.init(new BTContext());

		NodeAssert.processStatus(FAIL, node);
	}
}