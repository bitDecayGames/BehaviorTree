package bitdecay.behavior.tree;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
#end

class BTreeMacros {
    public static macro function wrapFn(func:Expr):Expr {
        var posExpr = macro @:pos(func.pos) null;
        var info = Context.getPosInfos(func.pos);

        var line = charPosToLine(info.file, info.min);

        var name = switch func.expr {
            case EConst(CIdent(id)): id;
            case EField(_, field): field;
            case _: "unknown";
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
 * A wrapped function so that we can display location information when debugging
**/
typedef BTFunc = {
    var name:String;
    var file:String;
    var line:Int;
    var func:Void->Void;
}