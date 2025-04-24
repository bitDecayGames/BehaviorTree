package bitdecay.behavior.tree.decorator;

/**
 * Runs the child node until it completes or the interrupt signal is caught,
 * whichever happens first.
 *
 * If the interrupt signal is received on the same process cycle that the
 * child node completes and the status is returned.
**/
class Interrupter extends DecoratorNode {
    var type:InterruptType;

    public function new(type:InterruptType, child:Node) {
        super(child);
        this.type = type;
    }

    override function init(context:BTContext) {
        super.init(context);
    }

    override public function doProcess(raw:NodeStatus):NodeStatus {
        if (raw != RUNNING) {
            return raw;
        }

        switch(type) {
            case KEY_PRESENCE(k):
                if (context.has(k)) {
                    child.exit();
                    return FAIL;
                }
            case CONDITION(fn):
                if (fn()) {
                    child.exit();
                    return FAIL;
                }
        }

        return RUNNING;
    }
}

enum InterruptType {
    KEY_PRESENCE(k:String);
    CONDITION(fn:()->Bool);
}
