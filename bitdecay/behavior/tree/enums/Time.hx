package bitdecay.behavior.tree.enums;

import bitdecay.behavior.tree.context.BTContext;

class TimeHelper {
	public static function getFloat(context:BTContext, wt:Time):Float {
		switch(wt) {
			case CONST(t):
				return t;
			case VAR(name, backup):
				if (context.hasTyped(name, Float) || context.hasTyped(name, Int)) {
					return context.getFloat(name);
				}
	
				return backup;
		}
	}

	/**
	 * Round a float to 3 decimal places (ms precision)
	 */
	public static function roundMS(Value:Float):Float
	{
		return Math.fround(Value * 1000) / 1000;
	}
}

enum Time {
    /**
     * A fixed time
    **/
    CONST(t:Float);

    /**
     * Pull time from a variable. Backup is used if the var
     * is missing or value is not a number
    **/
    VAR(name:String, backup:Float);
}
