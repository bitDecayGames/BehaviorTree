package bitdecay.behavior.tree.context;

/**
 * A context that holds and returns its own values, when present.
 * Returns values from the fallback context if this one cannot provide them.
**/
class FallbackContext extends BTContext {
	var fallback:BTContext = null;

	public function new() {
		super();
	}

	public function setContext(parent:BTContext) {
		fallback = parent;
		executor = fallback.executor;
	}

	override function has(key:String):Bool {
		if (super.has(key)) {
			return true;
		}

		return fallback != null && fallback.has(key);
	}

	override function get(key:String):Dynamic {
		var local = super.get(key);
		if (local != null) {
			return local;
		}

		return fallback != null ? fallback.get(key) : null;
	}

	override function getBool(key:String):Bool {
		if (super.has(key)) {
			return super.getBool(key);
		}

		return fallback != null ? fallback.getBool(key) : false;
	}

	override function dump():String {
		return [super.dump(), "---------", fallback.dump()].join("\n");
	}
}