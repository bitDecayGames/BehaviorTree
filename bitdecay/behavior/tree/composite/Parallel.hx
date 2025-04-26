package bitdecay.behavior.tree.composite;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Runs all child nodes in parallel until the provided Condition
 * is met and returns the appropriate result
**/
class Parallel extends CompositeNode {
    var condition:Condition;
    var statuses:Array<NodeStatus>;
    var previousStatuses:Array<NodeStatus>;

    public function new(condition:Condition, children:Array<Node>) {
        super(children);
        this.condition = condition;
    }

    override function init(context:BTContext) {
        super.init(context);
        statuses = [for (i in 0...children.length) {
            RUNNING;
        }];
        previousStatuses = [for (i in 0...children.length) {
            null;
        }];
    }

    override public function doProcess(delta:Float):NodeStatus {
        for (i in 0...children.length) {
            if (statuses[i] == RUNNING) {
                statuses[i] = children[i].process(delta);
            }

            #if debug
            if (previousStatuses[i] != statuses[i]) {
                previousStatuses[i] = statuses[i];
                @:privateAccess
                context.executor.dispatchChange(this, children[i], statuses[i]);
            }
            #end
        }

        var successes = 0;
        var failures = 0;
		for (s in statuses) {
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
        for (i in 0...statuses.length) {
            if (statuses[i] == RUNNING) {
                children[i].cancel();

                #if debug
                @:privateAccess
                context.executor.dispatchChange(this, children[i], FAIL);
                #end
            }
        }
    }

    override function getDetail():Array<String> {
        return ['condition: ${condition}'];
    }
}

enum Condition {
    FAIL_ON_FIRST_FAIL;
    SUCCEED_ON_FIRST_SUCCESS;
    UNTIL_N_COMPLETE(n:Int);
    UNTIL_ALL_COMPLETE;
}