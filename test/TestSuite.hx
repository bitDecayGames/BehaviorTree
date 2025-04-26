import massive.munit.TestSuite;

import bitdecay.behavior.ToolsTest;
import bitdecay.behavior.tree.composite.ParallelTest;
import bitdecay.behavior.tree.composite.SelectorTest;
import bitdecay.behavior.tree.composite.SequenceTest;
import bitdecay.behavior.tree.decorator.FailerTest;
import bitdecay.behavior.tree.decorator.InterrupterTest;
import bitdecay.behavior.tree.decorator.SucceederTest;
import bitdecay.behavior.tree.decorator.TimeLimitTest;

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
		add(bitdecay.behavior.tree.decorator.SucceederTest);
		add(bitdecay.behavior.tree.decorator.TimeLimitTest);
	}
}
