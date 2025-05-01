package bitdecay.behavior.tree;

import bitdecay.behavior.tree.composite.Fallback;
import bitdecay.behavior.tree.composite.Sequence;
import bitdecay.behavior.tree.decorator.Inverter;
import bitdecay.behavior.tree.leaf.Condition;

class Shorthand {
	/**
	 * "Interrupter"
	 *
	 * An interrupter aborts the child node until 
	 * 
	 * @param condition The condition to cause the interrupt when true
	 * @param child     The node to run while interrupt
	**/
	public static function interrupter(name:String, condition:Condition, child:Node) {
		var node = new Sequence(IN_ORDER, [
			new Inverter(condition),
			child
		]);
		node.name = '${name}(interrupter)';
		return node;
	}
}