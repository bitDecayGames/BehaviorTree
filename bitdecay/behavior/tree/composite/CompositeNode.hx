package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.context.BTContext;

/**
 * A node that has children nodes
**/
class CompositeNode implements Node {
    var children:Array<Node>;
    var context:BTContext;

    public function new(children:Array<Node>) {
        this.children = children;
    }

    public function init(context:BTContext):Void {
        this.context = context;
        for (c in children) {
            c.init(context);
            #if debug
            @:privateAccess
            context.executor.dispatchChange(this, c, UNKNOWN);
            #end
        }
    }

    public function process(delta:Float):NodeStatus {
        #if btree
        cast(context.get("debug_path"), Array<Dynamic>).push(Type.getClassName(Type.getClass(this)));
        #end

        var result = doProcess(delta);

        #if btree
        context.set("debug_result", result);
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