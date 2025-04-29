package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.context.BTContext;

/**
 * Node intended to be extended to capture the business logic of a given application
**/
class LeafNode implements Node {
    var ctx:BTContext;

    public function init(ctx:BTContext) {
        this.ctx = ctx;
    }

    public function process(delta:Float):NodeStatus {
        throw 'process() must be implemented';
    }

    public function cancel():Void {}

    public function clone():Node {
        throw 'clone() must be implemented';
    }

    function getChildren():Array<Node> {
        return [];
    }

    function getDetail():Array<String> {
        return [];
    }
}