package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.leaf.IsVarNull;
import bitdecay.behavior.tree.context.BTContext;

class IsVarNullTest {
	@Test
	public function testNullVarSucceedsOnNull() {
		var node = new IsVarNull("myTest");
		var ctx = new BTContext();
		node.init(ctx);
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testNullVarFailsOnVarSet() {
		var node = new IsVarNull("myTest");
		var ctx = new BTContext();
		node.init(ctx);
		ctx.set("myTest", "something");
		NodeAssert.processStatus(FAIL, node);
	}
}