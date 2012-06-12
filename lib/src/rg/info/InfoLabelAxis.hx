/**
 * ...
 * @author Franco Ponticelli
 */

package rg.info;
import rg.data.Variable;
import rg.data.DataPoint;
import rg.axis.Stats;

@:keep class InfoLabelAxis extends InfoLabel
{
	public var axis : String -> String;
//	public var axisvalue : Dynamic -> String -> String;
	public var tickmark : Dynamic -> String -> String;

	public static function filters() : Array<FieldFilter>
	{
		return [{
			field : "axis",
			validator : function(v) return Reflect.isFunction(v),
			filter : null
		}, {
			field : "tickmark",
			validator : function(v) return Reflect.isFunction(v),
			filter : null
		}].concat(InfoLabel.filters());
	}
}