package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.context.BTContext;
import bitdecay.behavior.tree.leaf.Success;

class SuccessTest {
	@Test
	public function testSuccessSucceeds() {
		var node = new Success();
		node.init(new BTContext());

		NodeAssert.processStatus(SUCCESS, node);
	}
}