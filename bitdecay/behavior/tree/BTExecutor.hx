package bitdecay.behavior.tree;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Controls the execution of a BTree
**/
class BTExecutor {
    private var root:Node;
    private var context:BTContext;

    var pendingAdds:Array<Node> = [];
    var pendingRemoves:Array<Node> = [];
    var persistentProcessNodes:Array<Node> = [];

    var previousChildStatus:NodeStatus = null;

    private var nodeStatusListeners:Array<(Node, Node, NodeStatus) ->Void> = [];

    public function new(root:Node) {
        if (root == null) {
			throw "Root cannot be null";
        }

        this.root = root;
    }

    public function addChangeListener(fn:(Node, Node, NodeStatus)->Void) {
        nodeStatusListeners.push(fn);
    }

    public function dispatchChange(p:Node, c:Node, status:NodeStatus) {
        for (fn in nodeStatusListeners) {
            fn(p, c, status);
        }
    }

    public function init(context:BTContext) {
        if (context == null) {
			context = new BTContext();
        }

        context.executor = this;
        this.context = context;

        previousChildStatus = null;

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

        #if debug
        if (previousChildStatus != result) {
            previousChildStatus = result;

            @:privateAccess
            context.executor.dispatchChange(null, root, result);
        }
        #end

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

    public function cancel():Void {
        root.cancel();
    }
}