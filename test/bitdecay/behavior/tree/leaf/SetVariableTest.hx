package bitdecay.behavior.tree.leaf;

import massive.munit.Assert;
import bitdecay.behavior.tree.leaf.SetVariable;
import bitdecay.behavior.tree.context.BTContext;

class SetVariableTest {
	@Test
	public function testVariableSet() {
		var node = new SetVariable("myTest", "secret");
		var ctx = new BTContext();
		node.init(ctx);
		NodeAssert.processStatus(SUCCESS, node);
		Assert.areEqual("secret", ctx.get("myTest"));
	}
}