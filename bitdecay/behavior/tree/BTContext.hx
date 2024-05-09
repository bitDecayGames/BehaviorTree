package bitdecay.behavior.tree;

class BTContext {
    private var contents:Map<String, Dynamic>;

    public var dirty:Bool = false;

    public function new() {
        contents = new Map<String, Dynamic>();
    }

    public function has(key:String):Bool {
        return contents.exists(key);
    }

    public function get(key:String):Dynamic {
        return contents.get(key);
    }

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