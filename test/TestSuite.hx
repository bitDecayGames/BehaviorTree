import massive.munit.TestSuite;

import bitdecay.behavior.tree.composite.ParallelTest;
import bitdecay.behavior.tree.composite.SelectorTest;
import bitdecay.behavior.tree.composite.SequenceTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(bitdecay.behavior.tree.composite.ParallelTest);
		add(bitdecay.behavior.tree.composite.SelectorTest);
		add(bitdecay.behavior.tree.composite.SequenceTest);
	}
}
