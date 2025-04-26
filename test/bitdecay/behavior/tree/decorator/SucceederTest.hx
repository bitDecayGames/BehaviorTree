package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.leaf.Fail;
import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class SucceederTest {
	@Test
	public function testSucceederFails() {
		var node = new Succeeder(new Fail());
		node.init(new BTContext());

		NodeAssert.processStatus(SUCCESS, node);
	}
}