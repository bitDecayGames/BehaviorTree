package bitdecay.behavior.tree.leaf;

import massive.munit.Assert;
import bitdecay.behavior.tree.leaf.SetVariable;
import bitdecay.behavior.tree.context.BTContext;

class SetVariableTest {
	@Test
	public function testConstVariableSet() {
		var node = new SetVariable("myTest", CONST("secret"));
		var ctx = new BTContext();
		node.init(ctx);
		NodeAssert.processStatus(SUCCESS, node);
		Assert.areEqual("secret", ctx.get("myTest"));
	}

	@Test
	public function testContextKeyVariableSet() {
		var node = new SetVariable("myTest", FROM_CTX("other"));
		var ctx = new BTContext();
		ctx.set("other", "secret");
		node.init(ctx);
		NodeAssert.processStatus(SUCCESS, node);
		Assert.areEqual("secret", ctx.get("myTest"));
	}
}