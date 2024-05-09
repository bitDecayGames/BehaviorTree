package bitdecay.behavior.tree.composite;

// Traverses children sequentially, returning SUCCESS only if all
// children succeed. Returns FAIL upon first child node failing
class Sequence extends CompositeNode {
    var index:Int;
    var lastIndex:Int;
    var needsInit:Bool;

    public function new(children:Array<Node>) {
        super(children);
    }

    override public function init(context:BTContext) {
        this.context = context;
        index = 0;
        lastIndex = -1;
        needsInit = true;
    }

    override public function doProcess(delta:Float):NodeStatus {
        var result = NodeStatus.FAIL;
        while (index < children.length) {
            if (needsInit) {
                needsInit = false;
                children[index].init(context);
            }
            result = children[index].process(delta);

            if (result == RUNNING) {
                return result;
            } else if (result == FAIL) {
                return result;
            } else {
                index++;
                needsInit = true;
                continue;
            }
        }

        // We have traversed all of our nodes with no failures, so we have succeeded
        return SUCCESS;
    }
}