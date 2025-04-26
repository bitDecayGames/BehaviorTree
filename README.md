# BTree

A simple behavior tree implementation. 

### **Quick Overview**

### Nodes

Behavior trees are composed of Nodes. There are 3 primary kinds of nodes:
* **Leaf Nodes**: The 'business logic'. These are the terminal nodes in the tree and directly modify game state.
* **Composite Nodes**: They contain multiple sub-nodes and have varying logic in how to decide which child node to select.
* **Decorator Nodes**: They have a single child node and either modifies the context before calling child nodes, or modifies the result of the child node before returning.

### Debugging
The `-D btree` compilation flag can be used to enable various logging.

### Testing

Install test deps off of the github master commit
```
haxelib git munit https://github.com/massiveinteractive/MassiveUnit.git master src
haxelib git hamcrest https://github.com/mikestead/hamcrest-haxe.git master src
```
