package bitdecay.behavior.tree;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Controls the execution of a BTree
**/
class BTExecutor {
    private var root:Node;
    public var ctx:BTContext;
    public var status(default, null):NodeStatus = UNKNOWN;
    
    var pendingAdds:Array<Node> = [];
    var pendingRemoves:Array<Node> = [];
    var persistentProcessNodes:Array<Node> = [];


    #if (BT_DEBUG || debug)
    private var preProcessListeners:Array<()->Void> = [];
    private var nodeStatusListeners:Array<(Node, Node, NodeStatus) ->Void> = [];
    private var postProcessListeners:Array<()->Void> = [];

    public function addChangeListener(fn:(Node, Node, NodeStatus)->Void) {
        nodeStatusListeners.push(fn);
    }

    public function addPreProcessListener(fn:()->Void) {
        preProcessListeners.push(fn);
    }

    public function addPostProcessListener(fn:()->Void) {
        postProcessListeners.push(fn);
    }

    public function dispatchChange(p:Node, c:Node, status:NodeStatus) {
        for (fn in nodeStatusListeners) {
            fn(p, c, status);
        }
    }
    #end

    public function new(root:Node) {
        if (root == null) {
			throw "Root cannot be null";
        }

        this.root = root;
    }

    public function init(ctx:BTContext) {
        if (ctx == null) {
			ctx = new BTContext();
        }

        ctx.executor = this;
        this.ctx = ctx;

        status = UNKNOWN;
        root.init(ctx);
    }

    public function process(delta:Float):NodeStatus {
        #if (BT_DEBUG || debug)
        var previousStatus = status;
        for (fn in preProcessListeners) {
            fn();
        }
        #end

        var result = root.process(delta);

        #if (BT_DEBUG || debug)
        if (previousStatus != result) {
            @:privateAccess
            ctx.executor.dispatchChange(null, root, result);
        }

        for (fn in postProcessListeners) {
            fn();
        }
        #end

        return result;
    }

    public function cancel():Void {
        root.cancel();
    }
}