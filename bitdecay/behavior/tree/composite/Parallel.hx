package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Runs all child nodes in parallel until the provided EndCondition
 * is met and returns the appropriate result
**/
class Parallel extends CompositeNode {
    var condition:EndCondition;

    public function new(condition:EndCondition, children:Array<Node>) {
        super(IN_ORDER, children);
        this.condition = condition;
    }

    override public function process(delta:Float):NodeStatus {
        var status:NodeStatus = UNKNOWN;
        for (i in 0...children.length) {
            status = children[i].process(delta);

            #if debug
            if (lastStatus[i] != status) {
                @:privateAccess
                ctx.executor.dispatchChange(this, children[i], statuses[i]);
            }
            #end

            lastStatus[i] = status;
        }

        var successes = 0;
        var failures = 0;
		for (s in lastStatus) {
            successes += s == SUCCESS ? 1 : 0;
            failures += s == FAIL ? 1 : 0;
		}

        var completes = successes + failures;
        var allComplete = children.length == completes;

        switch condition {
            case FAIL_ON_FIRST_FAIL:
                if (failures > 0) {
                    cancelIncomplete();
                    return FAIL;
                }

                if (allComplete) {
                    return SUCCESS;
                }
            case SUCCEED_ON_FIRST_SUCCESS:
                if (successes > 0) {
                    cancelIncomplete();
                    return SUCCESS;
                }

                if (allComplete) {
                    return FAIL;
                }
            case UNTIL_N_COMPLETE(n):
                if (n == completes) {
                    cancelIncomplete();
                    return SUCCESS;
                }
            case UNTIL_ALL_COMPLETE:
                if (allComplete) {
                    return SUCCESS;
                }
        }

        return RUNNING;
    }

    override public function clone():Node {
        return new Parallel(condition, [for (node in children) node.clone()]);
    }

    private function cancelIncomplete():Void {
        for (i in 0...lastStatus.length) {
            if (lastStatus[i] == RUNNING) {
                children[i].cancel();

                #if debug
                @:privateAccess
                ctx.executor.dispatchChange(this, children[i], FAIL);
                #end
            }
        }
    }

    override function getDetail():Array<String> {
        return ['condition: ${condition}'];
    }
}

enum EndCondition {
    FAIL_ON_FIRST_FAIL;
    SUCCEED_ON_FIRST_SUCCESS;
    UNTIL_N_COMPLETE(n:Int);
    UNTIL_ALL_COMPLETE;
}