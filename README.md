# Behavior Tree

A simple behavior tree implementation. 

### **Quick Overview**

### Nodes

Behavior trees are composed of Nodes. There are 3 primary kinds of nodes:
* **Leaf Nodes**: The 'business logic'. These are the terminal nodes in the tree and directly modify game state.
* **Composite Nodes**: They contain multiple sub-nodes and have varying logic in how to decide which child node to select.
* **Decorator Nodes**: They have a single child node and either can perform logic either before or after the child node is run, and can transform the child node status.

This library includes a selection of basic nodes of each type to provide a reasonable amount of flexibility for any project. The most notable are:

* `Fallback` - Processes child nodes until one returns SUCCESS
* `Sequence` - Process child nodes until one returns FAIL
* `Inverter` - Flips the completion status of the child node
* `Repeater` - Runs a node multiple times according to the given rule
* `Wait` - Waits for a period of time before processing the child node

### Context

All nodes within a given tree share a `BTContext` that enables them to share information with each other.

* This acts as a simple key-value map that nodes can read/write to
* The context is passed to the functions of `Action` and `StatusAction` nodes so that any business logic can also access or modify the context
* Some nodes, such as the `HierarchicalContext` node, allow for more control over how nodes can interact with the context

### Special Notes

The `Action` and `StatusAction` nodes take functions take `WrappedFunc` and `WrappedProcessFunc` parameters respectively. These are special wrapped functions that contain location information to aid in debugging a tree. The `BT.wrapFn()` macro function simplifies this. See the tests for an example of how to use them.

### Debugging
The `-D btree` compilation flag can be used to enable various logging.

### Testing

Install test deps off of the github master commit
```
haxelib git munit https://github.com/massiveinteractive/MassiveUnit.git master src
haxelib git hamcrest https://github.com/mikestead/hamcrest-haxe.git master src
```

Run tests
```
haxelib run munit test -neko
```

Neko seems to be more reliable than hashlink
