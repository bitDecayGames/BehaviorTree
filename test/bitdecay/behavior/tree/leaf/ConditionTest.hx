package bitdecay.behavior.tree.leaf;

import massive.munit.Assert;
import bitdecay.behavior.tree.context.BTContext;

class ConditionTest {
	@Test
	public function testFailsOnIncompatibleTypes() {
		var node = new Condition('test', VAR_CMP('varA', LT("notANumber")));
		var ctx = new BTContext();
		ctx.set('varA', 5);
		node.init(ctx);

		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testFailsOnIncompatibleTypesReverse() {
		var node = new Condition('test', VAR_CMP('varA', LT(10)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', "NotANumber");
		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testFailsOnUnsupportedTypes() {
		var node = new Condition('test', VAR_CMP('varA', LT({isObject: true})));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 5);
		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testCrossNumberTypeCompatibility() {
		var node = new Condition('test', VAR_CMP('varA', GT(10)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 42.5);
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testCrossNumberTypeCompatibilityReverse() {
		var node = new Condition('test', VAR_CMP('varA', GT(10.5)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 42);
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testIntComparisonGT() {
		var node = new Condition('test', VAR_CMP('varA', GT(50)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 10);
		NodeAssert.processStatus(FAIL, node);

		ctx.set('varA', 100);
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testIntComparisonGTE() {
		var node = new Condition('test', VAR_CMP('varA', GTE(50)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 10);
		NodeAssert.processStatus(FAIL, node);

		ctx.set('varA', 50);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 51);
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testIntComparisonLT() {
		var node = new Condition('test', VAR_CMP('varA', LT(50)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 10);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 100);
		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testIntComparisonLTE() {
		var node = new Condition('test', VAR_CMP('varA', LTE(50)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 10);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 50);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 51);
		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testIntComparisonEQ() {
		var node = new Condition('test', VAR_CMP('varA', EQ(50)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 50);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 42);
		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testIntComparisonNEQ() {
		var node = new Condition('test', VAR_CMP('varA', NEQ(50)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 50);
		NodeAssert.processStatus(FAIL, node);

		ctx.set('varA', 42);
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testFloatComparisonGT() {
		var node = new Condition('test', VAR_CMP('varA', GT(50.5)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 10);
		NodeAssert.processStatus(FAIL, node);

		ctx.set('varA', 100);
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testFloatComparisonGTE() {
		var node = new Condition('test', VAR_CMP('varA', GTE(50.5)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 50);
		NodeAssert.processStatus(FAIL, node);

		ctx.set('varA', 50.5);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 51);
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testFloatComparisonLT() {
		var node = new Condition('test', VAR_CMP('varA', LT(50.5)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 10);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 100);
		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testFloatComparisonLTE() {
		var node = new Condition('test', VAR_CMP('varA', LTE(50.5)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 50);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 50.5);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 51);
		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testFloatComparisonEQ() {
		var node = new Condition('test', VAR_CMP('varA', EQ(50.5)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 50.5);
		NodeAssert.processStatus(SUCCESS, node);

		ctx.set('varA', 42);
		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testFloatComparisonNEQ() {
		var node = new Condition('test', VAR_CMP('varA', NEQ(50.5)));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', 50.5);
		NodeAssert.processStatus(FAIL, node);

		ctx.set('varA', 42);
		NodeAssert.processStatus(SUCCESS, node);
	}

	@Test
	public function testStringComparisonGT() {
		var node = new Condition('test', VAR_CMP('varA', GT("b")));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', "a");
		NodeAssert.processStatus(FAIL, node);
	}

	@Test
	public function testStringComparisonLT() {
		var node = new Condition('test', VAR_CMP('varA', LT("b")));
		var ctx = new BTContext();
		node.init(ctx);

		ctx.set('varA', "a");
		NodeAssert.processStatus(SUCCESS, node);
	}
}