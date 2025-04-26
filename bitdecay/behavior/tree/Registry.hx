package bitdecay.behavior.tree;

class Registry {
	static var subtreeRegistry:Map<String, Node> = [];

	// TODO: Ideally we wouldn't store nodes to be copied and would instead
	// store a blueprint for how to create a new tree from
	public static function register(name:String, tree:Node) {
		subtreeRegistry.set(name, tree);
	}

	public static function lookup(name:String) {
		if (subtreeRegistry.exists(name)) {
			return subtreeRegistry.get(name).clone();
		}

		return null;
	}
}