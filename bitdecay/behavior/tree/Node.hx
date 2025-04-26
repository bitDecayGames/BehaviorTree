package bitdecay.behavior.tree;

import bitdecay.behavior.tree.context.BTContext;

interface Node {
    /**
     * Called when the node is initialized. This can happen in
     * a couple scenarios, generally either:
     *   - When the behavior tree is initialized
     *   - Just before the first time the node's process is called
    **/
    public function init(context:BTContext):Void;

    /**
     * Called each time the node is updated
    **/
    public function process(delta:Float):NodeStatus;

    /**
     * Allows any cleanup logic if a node is cancelled
     * before it finishes executing
    **/
    public function cancel():Void;

    /**
     * Returns a clone of this node and all children under it
    **/
    public function clone():Node;

    /**
     * Used internally to navigate a tree for tooling purposes
    **/
    private function getChildren():Array<Node>;

    /**
     * Used internally to show debug information
    **/
    private function getDetail():Array<String>;
}