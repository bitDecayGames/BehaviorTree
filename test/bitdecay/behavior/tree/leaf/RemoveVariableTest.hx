package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.context.BTContext;
import bitdecay.behavior.tree.leaf.RemoveVariable;
import bitdecay.behavior.tree.leaf.SetVariable;
import massive.munit.Assert;

class RemoveVariableTest {
	@Test
	public function testVariableRemoved() {
		var ctx = new BTContext();
		ctx.set("myTest", "secret");

		var node = new RemoveVariable("myTest");
		node.init(ctx);

		Assert.isTrue(ctx.has("myTest"), "context should have key");
		NodeAssert.processStatus(SUCCESS, node);
		Assert.isFalse(ctx.has("secret"), "context key should be removed");
	}
}