package bitdecay.behavior.tree.context;

/**
 * A context that holds and returns its own values, when present.
 * Returns values from the fallback context if this one cannot provide them.
**/
class FallbackContext extends BTContext {
	var fallback:BTContext;

	public function new(fb:BTContext) {
		super();
		fallback = fb;
	}

	override function has(key:String):Bool {
		if (super.has(key)) {
			return true;
		}

		return fallback.has(key);
	}

	override function get(key:String):Dynamic {
		var local = super.get(key);
		if (local != null) {
			return local;
		}

		return fallback.get(key);
	}

	override function getBool(key:String):Bool {
		if (super.has(key)) {
			return super.getBool(key);
		}

		return fallback.getBool(key);
	}

	override function dump():String {
		return [super.dump(), "---------", fallback.dump()].join("\n");
	}
}