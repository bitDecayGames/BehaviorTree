package bitdecay.behavior.tree.leaf;

import bitdecay.behavior.tree.BT.WrappedConditionFunc;

/**
 * A simple node that can only return either SUCCESS or FAIL
**/
class Condition extends LeafNode {
	var name:String;
	var type:ConditionType;

	public function new(name:String, type:ConditionType) {
		this.name = name;
		this.type = type;	
	}

	override function process(delta:Float):NodeStatus {
		switch type {
			case VAR_SET(v):
				if (ctx.get(v) != null) {
					return SUCCESS;
				}
			case VAR_CMP(vName, cmp):
				var outcome = doComparison(ctx.get(vName), cmp);
				if (outcome) {
					return SUCCESS;
				}
			case FUNC(fn):
				if (fn.func(ctx)) {
					return SUCCESS;
				}
		}
		

		return FAIL;
	}

	function doComparison(a:Dynamic, cmp:ComparisonType):Bool {
		var p = cmp.getParameters()[0];
		if (!(
			Std.isOfType(p, Int) ||
			Std.isOfType(p, Float) ||
			Std.isOfType(p, String)
		)) {
			trace('can only compare Int, Float, or String currently');
			return false;
		}

		if (Std.isOfType(p, Int)) {
			var b:Int = cast p;
			switch cmp {
				case LT(_): {
					return a < b;
				}
				case LTE(_): {
					return a <= b;
				}
				case GT(_): {
					return a > b;
				}
				case GTE(_): {
					return a >= b;
				}
				case NEQ(_): {
					return a != b;
				}
				case EQ(_): {
					return a == b;
				}
				default:
					return false;
			}
		} else if (Std.isOfType(p, Float)) {
			var b:Float = cast p;
			switch cmp {
				case LT(_): {
					return a < b;
				}
				case LTE(_): {
					return a <= b;
				}
				case GT(_): {
					return a > b;
				}
				case GTE(_): {
					return a >= b;
				}
				case NEQ(_): {
					return a != b;
				}
				case EQ(_): {
					return a == b;
				}
				default:
					return false;
			}
		} else if (Std.isOfType(p, String)) {
			var b:String = cast p;
			switch cmp {
				case LT(_): {
					return a < b;
				}
				case LTE(_): {
					return a <= b;
				}
				case GT(_): {
					return a > b;
				}
				case GTE(_): {
					return a >= b;
				}
				case NEQ(_): {
					return a != b;
				}
				case EQ(_): {
					return a == b;
				}
				default:
					return false;
			}
		}
		return false;
	}

	override public function clone():Node {
        return new Condition(name, type);
    }

	override function getDetail():Array<String> {
		switch type {
			case FUNC(fn):
				var detailName = name;
				if (detailName.length == 0) {
					detailName = fn.name;
				}
				return ['name: ${detailName}', 'file: ${fn.file}:${fn.line}'];
			default:
				return ['name: ${name}', 'type: ${type}'];
		}
	}
}

enum ConditionType {
	VAR_SET(v:String);
	VAR_CMP(v:String, t:ComparisonType);
	FUNC(fn:WrappedConditionFunc);
}

enum ComparisonType {
	LT(v:Dynamic);
	LTE(v:Dynamic);
	GT(v:Dynamic);
	GTE(v:Dynamic);
	EQ(v:Dynamic);
	NEQ(v:Dynamic);
}
