package bitdecay.behavior.tree.leaf;

/**
 * Node intended to be extended to capture the business logic of a given application
**/
class LeafNode implements Node {
    var context:BTContext;

    public function init(context:BTContext) {
        this.context = context;
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

    public function exit():Void {}

    function getChildren():Array<Node> {
        return [];
    }
}