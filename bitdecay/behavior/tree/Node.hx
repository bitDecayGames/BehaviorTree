package bitdecay.behavior.tree;

interface Node {
    public function init(context:BTContext):Void;
    public function process(delta:Float):NodeStatus;
    // Allows any cleanup logic in case a node needs
    // to be cancelled in certain situations
    public function exit():Void;
}