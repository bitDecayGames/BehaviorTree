package bitdecay.behavior.tree.composite;

// Traverses children nodes sequentially, returning SUCCESS upon
// first child returning SUCCESS.
// Returns FAIL if all nodes fail
class Selector extends CompositeNode {
    var active:Int = 0;

    public function new(children:Array<Node>) {
        super(children);
    }

    override public function doProcess(delta:Float):NodeStatus {
        var result = NodeStatus.FAIL;
        while (active < children.length) {
            result = children[active].process(delta);

            if (result == RUNNING) {
                return result;
            } else if (result == SUCCESS) {
                return result;
            } else {
                active++;
                continue;
            }
        }

        // We ran out of nodes to check for successes, so we have failed
        return FAIL
    }
}