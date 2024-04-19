package bitdecay.behavior.tree.decorator;

// Runs the child node the specified number of times before returning the status code
// Returns FAIL upon first failure
class Repeater extends DecoratorNode {
    var count:Int;
    var remaining:Int;

    public function new(child:Node, count:Int = 0) {
        super(child);
        this.count = count;
    }

    override function init(context:BTContext) {
        super.init(context);
        remaining = count;
    }

    override public function doProcess(delta:Float):NodeStatus {
        var status = child.process(delta);
        if (status != RUNNING) {
            remaining--;

            if (status == FAIL || remaining == 0) {
                return status;
            }
        }

        return RUNNING;
    }
}