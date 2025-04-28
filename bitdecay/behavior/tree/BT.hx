package bitdecay.behavior.tree;

import bitdecay.behavior.tree.context.BTContext;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

/**
 * Various macros/helpers. Name is short to make typing it less annoying
**/
class BT {
    /**
     * Wraps a function so that tooling can display information
     * about the function
    **/
    public static macro function wrapFn(func:Expr):Expr {
        var posExpr = macro @:pos(func.pos) null;
        var info = Context.getPosInfos(func.pos);

        var line = charPosToLine(info.file, info.min);

        var name = switch func.expr {
            case EConst(CIdent(id)): id;
            case EField(_, field): field;
            case _: "anonymous";
        }

        return macro {
            {
                name: $v{name},
                file: $v{info.file},
                line: $v{line},
                func: $func
            }
        };
    }

    public static macro function lengthsMatch(a:ExprOf<Array<Dynamic>>, b:ExprOf<Array<Dynamic>>):ExprOf<Bool> {
        switch [a.expr, b.expr] {
            case [EArrayDecl(valuesA), EArrayDecl(valuesB)]:
                // If both are array literals, check lengths
                if (valuesA.length != valuesB.length) {
                    Context.error(
                        'Array lengths do not match: ${valuesA.length} != ${valuesB.length}',
                        a.pos
                    );
                }
                // If lengths match, return `true`
                return macro true;

            default:
                // If not literals, fall back to runtime check
                return macro $a.length == $b.length;
        }
    }

    #if macro
    private static function charPosToLine(file:String, charPos:Int):Int {
        var content = sys.io.File.getContent(file);
        var line = 1;
        for (i in 0...charPos) {
            if (content.charAt(i) == "\n") line++;
        }
        return line;
    }
    #end
}

/**
 * A wrapped function so that we can display location information within tooling
**/
typedef WrappedFunc = {
    var name:String;
    var file:String;
    var line:Int;
    var func:BTContext->Void;
}

/**
 * A wrapped function returning Bool so that we can display location information within tooling
**/
typedef WrappedConditionFunc = {
    var name:String;
    var file:String;
    var line:Int;
    var func:BTContext->Bool;
}

/**
 * A wrapped time-aware, status-returning function so that we can display location information within tooling
**/
 typedef WrappedProcessFunc = {
    var name:String;
    var file:String;
    var line:Int;
    var func:(BTContext, Float)->NodeStatus;
}