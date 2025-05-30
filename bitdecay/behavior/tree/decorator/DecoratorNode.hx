package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Wraps a child code allowing for logic before/after the child node process is called
**/
class DecoratorNode implements Node {
    public var name:String;
    var child:Node;
    var ctx:BTContext;

    #if (BT_DEBUG || debug)
    var previousChildStatus:NodeStatus;
    #end

    public function new(child:Node, name:String) {
        this.child = child;
        this.name = name;
    }

    public function init(ctx:BTContext) {
        this.ctx = ctx;
        if (child.init != null) {
            child.init(ctx);
        }

        #if (BT_DEBUG || debug)
        previousChildStatus = UNKNOWN;

		@:privateAccess
		ctx.executor.dispatchChange(this, child, UNKNOWN);
		#end
    }

    public function process(delta:Float):NodeStatus {
        var rawStatus = child.process(delta);
        var result = doProcess(rawStatus);

        #if (BT_DEBUG || debug)
        if (previousChildStatus != rawStatus) {
            previousChildStatus = rawStatus;

            @:privateAccess
            ctx.executor.dispatchChange(this, child, rawStatus);
        }

        if (result == SUCCESS || result == FAIL) {
            // we finished, so prep ourselves for future iterations
            previousChildStatus = UNKNOWN;
        }
        #end

        return result;
    }

    public function doProcess(raw:NodeStatus):NodeStatus {
        return raw;
    }

    public function cancel():Void {
        child.cancel();
        #if (BT_DEBUG || debug)
        @:privateAccess
        ctx.executor.dispatchChange(this, child, UNKNOWN);
        #end
    }

    public function clone():Node {
        throw 'clone() must be implemented';
    }

    function getChildren():Array<Node> {
        return [child];
    }

    function getDetail():Array<String> {
        return [];
    }

    public function getName():String {
        return name;
    }
}