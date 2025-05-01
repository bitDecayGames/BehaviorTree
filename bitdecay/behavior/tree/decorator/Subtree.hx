package bitdecay.behavior.tree.decorator;

class Subtree extends DecoratorNode {
	public function new(name:String) {
		var subtree = Registry.lookup(name);
		if (subtree == null) {
			throw 'no subtree with name ${name} registered';
		}
		super(subtree, name);
	}

	override function process(delta:Float):NodeStatus {
		return super.process(delta);
	}

	override function clone():Node {
		return new Subtree(name);
	}

	override function getDetail():Array<String> {
		return ['name: ${name}'];
	}
}