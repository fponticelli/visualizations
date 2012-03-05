/**
 * ...
 * @author Franco Ponticelli
 */

package rg.info;

import thx.math.Equations;

@:keep class InfoAnimation
{
	public var animated : Bool;
	public var duration : Int;
	public var ease : Float -> Float;
	public var delay : Int;

	public function new()
	{
		animated = false;
		duration = 1500;
		delay = 150;
		ease = Equations.elasticf();
	}

	public static function filters()
	{
		return [{
			field : "animated",
			validator : function(v) return Std.is(v, Bool),
			filter : null
		}, {
			field : "duration",
			validator : function(v) return Std.is(v, Int),
			filter : null
		}, {
			field : "delay",
			validator : function(v) return Std.is(v, Int),
			filter : null
		}, {
			field : "ease",
			validator : function(v) return Reflect.isFunction(v),
			filter : null
		}];
	}
}