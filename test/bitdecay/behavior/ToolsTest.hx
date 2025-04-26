package bitdecay.behavior;

import massive.munit.Assert;

class ToolsTest {
	@Test
	public function testRandomOrderFromWeightsLengths() {
		var inWeights = [.5, .5];
		var outIndices = Tools.randomIndexOrderFromWeights(inWeights);
		
		Assert.areEqual(inWeights.length, outIndices.length, 'input and output should have equal length: ${inWeights.length} != ${outIndices.length}');
	}

	@Test
	public function testRandomOrderFromWeightsOrder() {
		var inWeights = [.33, .33, .33];		
		var inOrder = true;
		var index = 0;
		for (attempt in 0...10) {
			index = 0;
			var outIndices = Tools.randomIndexOrderFromWeights(inWeights);
			for (outIndex in outIndices) {
				if (outIndex != index) {
					inOrder = false;
					break;
				}
				index++;
			}

			if (!inOrder) {
				break;
			}
		}

		Assert.isFalse(inOrder, 'random should yield out-of-order indices');
	}
}