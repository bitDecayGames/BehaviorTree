package bitdecay.behavior.tree.context;

class BTContext {
    public var executor:BTExecutor;
    private var contents:Map<String, Dynamic>;

    #if debug
    public var dirty:Bool = false;
    #end

    public function new() {
        contents = new Map<String, Dynamic>();
    }

    /**
     * Returns true if a value is set for `key`, false otherwise
    **/
    public function has(key:String):Bool {
        return contents.exists(key);
    }

    /**
     * Returns true if a value is set for `key` and is of type `t`, false otherwise
    **/
    public function hasTyped(key:String, t:Dynamic):Bool {
        return contents.exists(key) && Std.isOfType(contents.get(key), t);
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
     * Gets the requested key from the context as a float. Returns
     * Negative infinity if value not present, or value not is not a number
    **/
    public function getFloat(key:String):Float {
        var val = contents.get(key);

        if (val != null && (val is Float || val is Int)) {
            return cast val;
        }

        return Math.NEGATIVE_INFINITY;
    }

    /**
     * Sets a key/value pair into the context
    **/
    public function set(key:String, value:Dynamic) {

        #if btree
        if (!StringTools.startsWith(key, "debug") && (!contents.exists(key) || contents.get(key) != value)) {
            trace('key ${key}: ${contents.get(key)} -> ${value}');
        }
        #end

        #if debug
        dirty = true;
        #end

        contents.set(key, value);
    }

     /**
     * Attempts to remove `key` from the context and returns true if `key` was removed, false otherwise
    **/
    public function remove(key:String):Bool {
        #if debug
        dirty = true;
        #end
        
        return contents.remove(key);
    }

    public function dump():String {
        var entries = new Array<String>();
        for (key => value in contents) {
            entries.push([key, value].join(":"));
        }

        return entries.join("\n");
    }
}