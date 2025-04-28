import massive.munit.TestSuite;

import bitdecay.behavior.ToolsTest;
import bitdecay.behavior.tree.composite.ParallelTest;
import bitdecay.behavior.tree.composite.SelectorTest;
import bitdecay.behavior.tree.composite.SequenceTest;
import bitdecay.behavior.tree.decorator.FailerTest;
import bitdecay.behavior.tree.decorator.InterrupterTest;
import bitdecay.behavior.tree.decorator.InverterTest;
import bitdecay.behavior.tree.decorator.RepeaterTest;
import bitdecay.behavior.tree.decorator.SucceederTest;
import bitdecay.behavior.tree.decorator.TimeLimitTest;
import bitdecay.behavior.tree.leaf.ActionTest;
import bitdecay.behavior.tree.leaf.FailTest;
import bitdecay.behavior.tree.leaf.IsVarNullTest;
import bitdecay.behavior.tree.leaf.RemoveVariableTest;
import bitdecay.behavior.tree.leaf.SetVariableTest;
import bitdecay.behavior.tree.leaf.StatusActionTest;
import bitdecay.behavior.tree.leaf.SuccessTest;
import bitdecay.behavior.tree.leaf.WaitTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(bitdecay.behavior.ToolsTest);
		add(bitdecay.behavior.tree.composite.ParallelTest);
		add(bitdecay.behavior.tree.composite.SelectorTest);
		add(bitdecay.behavior.tree.composite.SequenceTest);
		add(bitdecay.behavior.tree.decorator.FailerTest);
		add(bitdecay.behavior.tree.decorator.InterrupterTest);
		add(bitdecay.behavior.tree.decorator.InverterTest);
		add(bitdecay.behavior.tree.decorator.RepeaterTest);
		add(bitdecay.behavior.tree.decorator.SucceederTest);
		add(bitdecay.behavior.tree.decorator.TimeLimitTest);
		add(bitdecay.behavior.tree.leaf.ActionTest);
		add(bitdecay.behavior.tree.leaf.FailTest);
		add(bitdecay.behavior.tree.leaf.IsVarNullTest);
		add(bitdecay.behavior.tree.leaf.RemoveVariableTest);
		add(bitdecay.behavior.tree.leaf.SetVariableTest);
		add(bitdecay.behavior.tree.leaf.StatusActionTest);
		add(bitdecay.behavior.tree.leaf.SuccessTest);
		add(bitdecay.behavior.tree.leaf.WaitTest);
	}
}
