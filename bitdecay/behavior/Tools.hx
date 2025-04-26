package bitdecay.behavior;

class Tools {
	/**
	 * A helper that given a list of weights (assumed to be in range [0.0, 1.0]), returns
	 * an array of indexes randomized according to the input weights.
	 *
	 * @param weights A list of weights
	 *
	 * @return an array of index integers with len = weights.length
	**/
	public static function randomIndexOrderFromWeights(weights:Array<Float>):Array<Int> {
		var order = [];
		var indexTracker = [for (i in 0...weights.length) i];
		var weightTracker = weights.copy();
		var cumulativeWeights:Array<Float> = [];
		var sum = 0.0;
		
		for (w in weights) {
			sum += w;
			cumulativeWeights.push(sum);
		}

		var next = 0;
		for (i in 0...weights.length) {
			var r = Math.random() * sum;
			for (c in 0...cumulativeWeights.length) {
				if (r <= cumulativeWeights[c]) {
					next = c;
					break;
				}
			}
			sum -= weightTracker[next];
			order.push(indexTracker[next]);
			cumulativeWeights.splice(next, 1);
			for (k in next...cumulativeWeights.length) {
				cumulativeWeights[k] -= weightTracker[next];
			}
			weightTracker.splice(next, 1);
			indexTracker.splice(next, 1);
		}

		return order;
	}
}