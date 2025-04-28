package bitdecay.behavior.tree.decorator;

class Subtree extends DecoratorNode {
	var name:String;

	public function new(name:String) {
		this.name = name;
		var subtree = Registry.lookup(name);
		if (subtree == null) {
			throw 'no subtree with name "name" registered';
		}

		super(subtree);
	}

	override function getDetail():Array<String> {
		return ['name: ${name}'];
	}
}