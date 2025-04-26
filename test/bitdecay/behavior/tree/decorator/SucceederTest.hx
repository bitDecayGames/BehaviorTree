package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.leaf.Fail;
import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class SucceederTest {
	@Test
	public function testSucceederFails() {
		var node = new Succeeder(new Fail());
		node.init(new BTContext());

		Assert.areEqual(NodeStatus.SUCCESS, node.process(0.1));
	}
}