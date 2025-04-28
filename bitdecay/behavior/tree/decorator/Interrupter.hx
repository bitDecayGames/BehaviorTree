package bitdecay.behavior.tree.decorator;

import bitdecay.behavior.tree.BT.WrappedConditionFunc;
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

    override function init(ctx:BTContext) {
        super.init(ctx);
    }

    override function process(delta:Float):NodeStatus {
        // check this up-front so we don't bother even trying to run children if
        // our signal already triggered
        switch(type) {
            case KEY_PRESENCE(k):
                if (ctx.has(k)) {
                    child.cancel();
                    return FAIL;
                }
            case CONDITION(cb):
                if (cb.func(ctx)) {
                    child.cancel();
                    return FAIL;
                }
        }

        return super.process(delta);
    }

    override public function clone():Node {
        return new Interrupter(type, child.clone());
    }

    override function getDetail():Array<String> {
        switch type {
            case KEY_PRESENCE(k):
                return ['type: ${type}'];
            case CONDITION(cb):
                return ['type: CONDITION(${cb.name})', 'file: ${cb.file}:${cb.line}'];
        }
    }
}

enum InterruptType {
    /**
     * Interrupts upon key presence
    **/
    KEY_PRESENCE(k:String);

    /**
     * Interrupts upon callback returning true
    **/
    CONDITION(cb:WrappedConditionFunc);
}
