package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.BTreeMacros.BTProcessFunc;
import bitdecay.behavior.tree.leaf.LeafNode;
import bitdecay.behavior.tree.context.BTContext;
import massive.munit.Assert;

class ParallelTest {
	@Test
	public function testFailOnFirstFail() {
		var cycle = 0;
		var cycleTwo = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			if (cycle == 2) {
				return FAIL;
			}

			return RUNNING;
		}));
		var runner = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			return RUNNING;
		}));
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
		Assert.areEqual(NodeStatus.RUNNING, node.process(0.1), "First cycle returns RUNNING");
		cycle++;
		Assert.areEqual(NodeStatus.FAIL, node.process(0.1), "Second cycle returns FAIL");
		Assert.isTrue(runner.cancelled, 'Unfinished runner node is cancelled');
	}

	@Test
	public function testSucceedOnFirstSucceed() {
		var cycle = 0;
		var cycleTwo = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			if (cycle == 2) {
				return SUCCESS;
			}

			return RUNNING;
		}));
		var runner = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			return RUNNING;
		}));
		var node = new Parallel(SUCCEED_ON_FIRST_SUCCESS, [
			runner,
			cycleTwo
		]);
		node.init(new BTContext());

		cycle++;
		Assert.areEqual(NodeStatus.RUNNING, node.process(0.1), "First cycle returns RUNNING");
		cycle++;
		Assert.areEqual(NodeStatus.SUCCESS, node.process(0.1), "Second cycle returns SUCCESS");
		Assert.isTrue(runner.cancelled, 'Unfinished runner node is cancelled');

	}

	@Test
	public function testUntilNComplete() {
		var cycle = 0;
		var cycleOne = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			if (cycle == 1) {
				return SUCCESS;
			}

			return RUNNING;
		}));
		var cycleTwo = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			if (cycle == 2) {
				return SUCCESS;
			}

			return RUNNING;
		}));
		var cycleThree = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			if (cycle == 3) {
				return SUCCESS;
			}
			return RUNNING;
		}));
		var node = new Parallel(UNTIL_N_COMPLETE(2), [
			cycleThree,
			cycleTwo,
			cycleOne
		]);
		node.init(new BTContext());

		cycle++;
		Assert.areEqual(NodeStatus.RUNNING, node.process(0.1), "First cycle returns RUNNING");
		cycle++;
		Assert.areEqual(NodeStatus.SUCCESS, node.process(0.1), "Second cycle returns SUCCESS");
		Assert.isFalse(cycleOne.cancelled, 'Previously finished cycle1 node is not cancelled');
		Assert.isTrue(cycleThree.cancelled, 'Unfinished cycle3 node is cancelled');
	}

	@Test
	public function testUntilAllComplete() {
		var cycle = 0;
		var cycleOne = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			if (cycle == 1) {
				return SUCCESS;
			}

			return RUNNING;
		}));
		var cycleTwo = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			if (cycle == 2) {
				return SUCCESS;
			}

			return RUNNING;
		}));
		var cycleThree = new ParallelTestNode(BTreeMacros.wrapFn((ctx:BTContext, delta:Float) -> {
			if (cycle == 3) {
				return SUCCESS;
			}
			return RUNNING;
		}));
		var node = new Parallel(UNTIL_ALL_COMPLETE, [
			cycleThree,
			cycleTwo,
			cycleOne
		]);
		node.init(new BTContext());

		cycle++;
		Assert.areEqual(NodeStatus.RUNNING, node.process(0.1), "First cycle returns RUNNING");
		cycle++;
		Assert.areEqual(NodeStatus.RUNNING, node.process(0.1), "Second cycle returns RUNNING");
		cycle++;
		Assert.areEqual(NodeStatus.SUCCESS, node.process(0.1), "Third cycle returns SUCCESS");
		Assert.isFalse(cycleOne.cancelled, 'Previously finished cycle1 node is not cancelled');
		Assert.isFalse(cycleTwo.cancelled, 'Previously finished cycle2 node is not cancelled');
		Assert.isFalse(cycleThree.cancelled, 'Just-finished cycle3 node is not cancelled');
	}
}

class ParallelTestNode extends LeafNode {
	var cb:BTProcessFunc;
	public var cancelled = false;

    public function new(cb:BTProcessFunc) {
		this.cb = cb;
	}

    override public function doProcess(delta:Float):NodeStatus {
		return cb.func(context, delta);
    }

	override public function clone():Node {
        return new ParallelTestNode(cb);
    }

	override function cancel() {
		super.cancel();
		cancelled = true;
	}

	override function getDetail():Array<String> {
        return [Std.string(cb)];
    }
}