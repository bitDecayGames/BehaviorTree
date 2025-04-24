package bitdecay.behavior.tree;

import flixel.util.FlxSignal.FlxTypedSignal;


/**
 * Top node of a Behavior Tree that owns the tree and its context
**/
class BTree implements Node {
    private var root:Node;
    private var context:BTContext;
    public var nodeStatusChange = new FlxTypedSignal<(Node, Node, NodeStatus) ->Void>();

    public function new(root:Node) {
        if (root == null) {
			throw "Root cannot be null";
        }

        this.root = root;
    }

    public function init(context:BTContext) {
        if (context == null) {
			context = new BTContext();
        }

        context.owner = this;

        this.context = context;
        root.init(context);
    }

    #if btree
    var current:String = "";
    var last:String = "";
    #end

    public function process(delta:Float):NodeStatus {
        #if btree
        context.set("debug_path", new Array<String>());
        #end

        var result = root.process(delta);

        #if btree
        var path:Array<String> = context.get("debug_path");
        for (i in 0...path.length) {
            path[i] = path[i].split(".").pop();
        }
        path.push(context.get("debug_result"));
        current = path.join(" -> ");

        if (current != last) {
            trace(current);
            last = current;
        }

        if (context.dirty) {
            context.dirty = false;
            trace(context.dump());
        }
        #end

        return result;
    }

    public function exit():Void {}

    function getChildren():Array<Node> {
        return [root];
    }
}