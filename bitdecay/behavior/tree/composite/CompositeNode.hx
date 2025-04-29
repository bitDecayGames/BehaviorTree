package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.context.BTContext;

/**
 * A node that has children nodes
**/
class CompositeNode implements Node {
    var children:Array<Node>;
    var type:ChildOrder;
    var order:Array<Int>;
    var lastStatus:Array<NodeStatus>;
    var ctx:BTContext;

    public function new(order:ChildOrder, children:Array<Node>) {
        this.children = children;
    }

    public function init(ctx:BTContext):Void {
        this.ctx = ctx;
        lastStatus = [];
        for (c in children) {
            c.init(ctx);
            lastStatus.push(UNKNOWN);
            #if debug
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
        #if btree
        cast(ctx.get("debug_path"), Array<Dynamic>).push(Type.getClassName(Type.getClass(this)));
        #end

        var result = doProcess(delta);

        #if btree
        ctx.set("debug_result", result);
        #end

        return result;
    }

    public function doProcess(delta:Float):NodeStatus {
        return FAIL;
    }

    public function cancel():Void {}

    public function clone():Node {
        throw 'clone() must be implemented';
    }

    function getChildren():Array<Node> {
        return children;
    }

    function getDetail():Array<String> {
        return [];
    }
}

enum ChildOrder {
    // Processes nodes in order
    IN_ORDER;

    // Process nodes in random order
    RANDOM(weights:Array<Float>);
}