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

		Assert.areEqual("secret", ctx.get("myTest"));
		NodeAssert.processStatus(SUCCESS, node);
		Assert.areEqual("secret", ctx.get("myTest"));
	}
}