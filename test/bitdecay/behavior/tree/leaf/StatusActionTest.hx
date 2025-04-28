package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.context.BTContext;

class StatusActionTest {
	@Test
	public function testStatusActionIsExecuted() {
		var count = 3;
		var node = new StatusAction(BT.wrapFn((ctx, delta) -> {
			count--;
			if (count == 0) {
				return NodeStatus.SUCCESS;
			}

			return NodeStatus.RUNNING;
		}));
		node.init(new BTContext());

		NodeAssert.processStatus(RUNNING, node);
		NodeAssert.processStatus(RUNNING, node);
		NodeAssert.processStatus(SUCCESS, node);
	}
}