package bitdecay.behavior.tree.composite;

import TestUtils.TestNode;
import bitdecay.behavior.tree.BTreeMacros.BTProcessFunc;
import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.context.BTContext;
import massive.munit.Assert;

class ParallelTest {
	@Test
	public function testFailOnFirstFail() {
		var cycle = 0;
		var cycleTwo = new TestNode(2, FAIL);
		var runner = new TestNode(0, RUNNING);
		var node = new Parallel(SUCCEED_ON_FIRST_SUCCESS, [
			runner,
			cycleTwo
		]);
		var node = new Parallel(FAIL_ON_FIRST_FAIL, [
			cycleTwo,
			runner
		]);
		node.init(new BTContext());

		cycle++;
		NodeAssert.processStatus(NodeStatus.RUNNING, node);
		cycle++;
		NodeAssert.processStatus(NodeStatus.FAIL, node);
		Assert.isTrue(runner.cancelled, 'Unfinished runner node is cancelled');
	}

	@Test
	public function testSucceedOnFirstSucceed() {
		var cycle = 0;
		var cycleTwo = new TestNode(2, SUCCESS);
		var runner = new TestNode(0, RUNNING);
		var node = new Parallel(SUCCEED_ON_FIRST_SUCCESS, [
			runner,
			cycleTwo
		]);
		node.init(new BTContext());

		cycle++;
		NodeAssert.processStatus(NodeStatus.RUNNING, node);
		cycle++;
		NodeAssert.processStatus(NodeStatus.SUCCESS, node);
		Assert.isTrue(runner.cancelled, 'Unfinished runner node is cancelled');

	}

	@Test
	public function testUntilNComplete() {
		var cycle = 0;
		var cycleOne = new TestNode(1, SUCCESS);
		var cycleTwo = new TestNode(2, SUCCESS);
		var cycleThree = new TestNode(3, SUCCESS);
		var node = new Parallel(UNTIL_N_COMPLETE(2), [
			cycleThree,
			cycleTwo,
			cycleOne
		]);
		node.init(new BTContext());

		cycle++;
		NodeAssert.processStatus(NodeStatus.RUNNING, node);
		cycle++;
		NodeAssert.processStatus(NodeStatus.SUCCESS, node);
		Assert.isFalse(cycleOne.cancelled, 'Previously finished cycle1 node is not cancelled');
		Assert.isTrue(cycleThree.cancelled, 'Unfinished cycle3 node is cancelled');
	}

	@Test
	public function testUntilAllComplete() {
		var cycle = 0;
		var cycleOne = new TestNode(1, SUCCESS);
		var cycleTwo = new TestNode(2, SUCCESS);
		var cycleThree = new TestNode(3, SUCCESS);
		var node = new Parallel(UNTIL_ALL_COMPLETE, [
			cycleThree,
			cycleTwo,
			cycleOne
		]);
		node.init(new BTContext());

		cycle++;
		NodeAssert.processStatus(NodeStatus.RUNNING, node);
		cycle++;
		NodeAssert.processStatus(NodeStatus.RUNNING, node);
		cycle++;
		NodeAssert.processStatus(NodeStatus.SUCCESS, node);
		Assert.isFalse(cycleOne.cancelled, 'Previously finished cycle1 node is not cancelled');
		Assert.isFalse(cycleTwo.cancelled, 'Previously finished cycle2 node is not cancelled');
		Assert.isFalse(cycleThree.cancelled, 'Just-finished cycle3 node is not cancelled');
	}
}
