package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.leaf.Success;
import bitdecay.behavior.tree.decorator.Inverter;
import bitdecay.behavior.tree.leaf.Fail;
import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class InverterTest {
	@Test
	public function testInverterCausesSuccess() {
		var node = new Inverter(new Fail());
		node.init(new BTContext());

		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testInverterCausesFail() {
		var node = new Inverter(new Success());
		node.init(new BTContext());

		NodeAssert.processStatus(FAIL, node);
	}
}