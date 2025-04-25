package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Runs the child node until it completes or the interrupt signal is caught,
 * whichever happens first.
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

    override function process(delta:Float):NodeStatus {
        // check this up-front so we don't bother even trying to run children if
        // our signal already triggered
        switch(type) {
            case KEY_PRESENCE(k):
                if (context.has(k)) {
                    child.cancel();
                    return FAIL;
                }
            case CONDITION(fn):
                if (fn()) {
                    child.cancel();
                    return FAIL;
                }
        }

        return super.process(delta);
    }

    override function getDetail():Array<String> {
        return ['type: ${type}'];
    }
}

enum InterruptType {
    /**
     * Interrupts upon key presence
    **/
    KEY_PRESENCE(k:String);

    /**
     * Interrupts upon function returning true
    **/
    CONDITION(fn:()->Bool);
}
