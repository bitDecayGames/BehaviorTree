package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.context.BTContext;

/**
 * A node that has children nodes
**/
class CompositeNode implements Node {
    public var name:String;
    var children:Array<Node>;
    var type:ChildOrder;
    var order:Array<Int>;
    var lastStatus:Array<NodeStatus>;
    var ctx:BTContext;

    public function new(order:ChildOrder, children:Array<Node>, name:String) {
        type = order;
        this.children = children;
        this.name = name;
    }

    public function init(ctx:BTContext):Void {
        this.ctx = ctx;
        lastStatus = [];
        for (c in children) {
            c.init(ctx);
            lastStatus.push(UNKNOWN);
            #if (BT_DEBUG || debug)
            @:privateAccess
            ctx.executor.dispatchChange(this, c, UNKNOWN);
            #end
        }
        
        switch type {
            case IN_ORDER:
                order = [for (i in 0...children.length) i];
            case RANDOM(weights):
                order = Tools.randomIndexOrderFromWeights(weights);
        }
    }

    public function process(delta:Float):NodeStatus {
        throw 'process() must be implemented';
    }

    public function cancel():Void {
        cancelIncomplete();
    }

    private function cancelIncomplete(after:Int = -1):Void {
        var start = after != -1 ? after + 1 : 0;
        for (i in start...lastStatus.length) {
            if (lastStatus[i] == RUNNING) {
                children[i].cancel();
                lastStatus[i] = UNKNOWN;

                #if (BT_DEBUG || debug)
                @:privateAccess
                ctx.executor.dispatchChange(this, children[i], FAIL);
                #end
            }
        }
    }

    public function clone():Node {
        throw 'clone() must be implemented';
    }

    function getChildren():Array<Node> {
        return children;
    }

    function getDetail():Array<String> {
        return [];
    }

    public function getName():String {
        return name;
    }
}

enum ChildOrder {
    // Processes nodes in order
    IN_ORDER;

    // Process nodes in random order
    RANDOM(weights:Array<Float>);
}