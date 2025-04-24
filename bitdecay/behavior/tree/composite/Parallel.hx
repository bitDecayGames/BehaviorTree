package bitdecay.behavior.tree.composite;

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
                context.owner.nodeStatusChange.dispatch(this, children[i], statuses[i]);
            }
            #end
        }

        switch condition {
            case UNTIL_FIRST_FAIL:
                if (statuses.contains(FAIL)) {
                    // trace('ON_FIRST_FAIL triggered');
                    exitIncomplete();
                    return FAIL;
                }
            case UNTIL_FIRST_SUCCESS:
                if (statuses.contains(SUCCESS)) {
                    // trace('ON_FIRST_SUCCESS triggered');
                    exitIncomplete();
                    return SUCCESS;
                }
            default:
                // only need to check these up front
        }

		var allSuccess = true;
		for (s in statuses) {
			allSuccess = allSuccess && s == SUCCESS;

			if (s == RUNNING) {
				return RUNNING;
			}
		}

        switch condition {
            case UNTIL_ALL_COMPLETE, UNTIL_FIRST_FAIL:
                //trace('all tasks finished');
                return SUCCESS;
            default:
                // other conditions were checked earlier
        }

        trace("something went wrong, fail");
        return FAIL;
    }

    private function exitIncomplete():Void {
        for (i in 0...statuses.length) {
            if (statuses[i] == RUNNING) {
                children[i].exit();

                #if debug
                @:privateAccess
                context.owner.nodeStatusChange.dispatch(this, children[i], FAIL);
                #end
            }
        }
    }

    override function getDetail():Array<String> {
        return ['condition: ${condition}'];
    }
}

enum Condition {
    UNTIL_FIRST_FAIL;
    UNTIL_FIRST_SUCCESS;
    UNTIL_ALL_COMPLETE;
    // Room here for more options, such as `ON_N_SUCCESS(n:Int)`, etc
}