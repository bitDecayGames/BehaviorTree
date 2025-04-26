package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.context.BTContext;

class FailTest {
	@Test
	public function testFailFails() {
		var node = new Fail();
		node.init(new BTContext());

		NodeAssert.processStatus(FAIL, node);
	}
}