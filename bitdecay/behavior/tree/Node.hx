package bitdecay.behavior.tree;

interface Node {
    /**
     * Called when the node is initialized. This can happen in
     * a couple scenarios, generally either:
     *   - When the behavior tree is initialized
     *   - Just before the first time the node's process is called
    **/
    public function init(context:BTContext):Void;

    /**
     * Called each time this node is updated
    **/
    public function process(delta:Float):NodeStatus;

    /**
     * Allows any cleanup logic in case a node needs
     * to be cancelled in certain situations
    **/
    public function exit():Void;

    /**
     * Used internally to navigate a tree for tooling purposes
    **/
    private function getChildren():Array<Node>;

    /**
     * Used internally to show debug information
    **/
    private function getDetail():Array<String>;
}