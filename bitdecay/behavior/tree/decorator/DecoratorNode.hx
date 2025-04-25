package bitdecay.behavior.tree.decorator;

/**
 * Wraps a child code allowing for logic before/after the child node process is called
**/
class DecoratorNode implements Node {
    var child:Node;
    var context:BTContext;
    var previousChildStatus:NodeStatus;

    public function new(child:Node) {
        this.child = child;
    }

    public function init(context:BTContext) {
        this.context = context;
        if (child.init != null) {
            child.init(context);
        }
        previousChildStatus = UNKNOWN;

        #if debug
		@:privateAccess
		context.executor.dispatchChange(this, child, UNKNOWN);
		#end
    }

    public function process(delta:Float):NodeStatus {
        #if btree
        cast(context.get("debug_path"), Array<Dynamic>).push(Type.getClassName(Type.getClass(this)));
        #end

        var rawStatus = child.process(delta);
        var result = doProcess(rawStatus);

        #if debug
        if (previousChildStatus != rawStatus) {
            previousChildStatus = rawStatus;

            @:privateAccess
            context.executor.dispatchChange(this, child, rawStatus);
        }

        if (result == SUCCESS || result == FAIL) {
            // we finished, so prep ourselves for future iterations
            previousChildStatus = UNKNOWN;
        }
        #end

        #if btree
        context.set("debug_result", result);
        #end

        return result;
    }

    public function doProcess(raw:NodeStatus):NodeStatus {
        return raw;
    }

    public function cancel():Void {}

    function getChildren():Array<Node> {
        return [child];
    }

    function getDetail():Array<String> {
        return [];
    }
}