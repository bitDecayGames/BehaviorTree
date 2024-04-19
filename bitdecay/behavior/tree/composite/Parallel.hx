package bitdecay.behavior.tree.composite;

// Runs all child nodes in parallel.
// Returns RUNNING while any nodes still return RUNNING status, otherwise:
//     Returns SUCCESS if all nodes return success
//     Returns FAIL if any node returns FAIL
class Parallel extends CompositeNode {
    var condition:Condition;
    var statuses:Array<NodeStatus>;

    public function new(condition:Condition, children:Array<Node>) {
        super(children);
        this.condition = condition;
    }

    override function init(context:BTContext) {
        super.init(context);
        statuses = [for (i in 0...children.length) {
            RUNNING;
        }];
    }

    override public function doProcess(delta:Float):NodeStatus {
        for (i in 0...children.length) {
            if (statuses[i] == RUNNING) {
                statuses[i] = children[i].process(delta);
            }
        }

        switch condition {
            case ON_FIRST_FAIL:
                if (statuses.contains(FAIL)) {
                    exitIncomplete();
                    return FAIL;
                }
            case ON_FIRST_SUCCESS:
                if (statuses.contains(SUCCESS)) {
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
            case ON_ALL_COMPLETE:
                return SUCCESS;
            default:
                // other conditions were checked earlier
        }

        return FAIL;
    }

    private function exitIncomplete():Void {
    for (i in 0...statuses.length) {
        if (statuses[i] != RUNNING) {
            children[i].exit();
        }
    }
    }
}

enum Condition {
    ON_FIRST_FAIL;
    ON_FIRST_SUCCESS;
    ON_ALL_COMPLETE;
    // Room here for more options, such as `ON_N_SUCCESS(n:Int)`, etc
}