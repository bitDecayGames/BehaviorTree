package bitdecay.behavior.tree;

class BTContext {
    public var owner:BTree;
    private var contents:Map<String, Dynamic>;

    public var dirty:Bool = false;

    public function new() {
        contents = new Map<String, Dynamic>();
    }

    /**
     * Returns true if a value is set for the given key, false otherwise
    **/
    public function has(key:String):Bool {
        return contents.exists(key);
    }

    /**
     * Returns the value of the requested key, null if key not set.
    **/
    public function get(key:String):Dynamic {
        return contents.get(key);
    }

    /**
     * Gets the requested key from the context as a boolean. Returns false
     * if the value is not present, or value is not of type Bool
    **/
    public function getBool(key:String):Bool {
        var val = contents.get(key);

        if (val != null && val is Bool) {
            return cast val;
        }

        return false;
    }

    /**
     * Sets a key/value pair into the context
    **/
    public function set(key:String, value:Dynamic) {
        #if btree
        if (!StringTools.startsWith(key, "debug") && (!contents.exists(key) || contents.get(key) != value)) {
            dirty = true;
            trace('key ${key}: ${contents.get(key)} -> ${value}');
        }
        #end

        contents.set(key, value);
    }

    public function dump():String {
        var entries = new Array<String>();
        for (key => value in contents) {
            entries.push([key, value].join(":"));
        }

        return entries.join("\n");
    }
}