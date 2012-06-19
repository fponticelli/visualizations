/**
 * ...
 * @author Franco Ponticelli
 */

package rg.info;
import rg.data.Variable;
import rg.data.DataPoint;
import rg.axis.Stats;
using rg.info.filter.FilterDescription;

@:keep class InfoLabelSankey extends InfoLabel
{
	public var edge : { head : DataPoint, tail : DataPoint, edgeweight : Float, nodeweight : Float } -> Stats<Dynamic> -> String;
	public var edgeover : { head : DataPoint, tail : DataPoint, edgeweight : Float, nodeweight : Float } -> Stats<Dynamic> -> String;
	public var node : DataPoint -> Stats<Dynamic> -> String;

	public static function filters() : Array<FilterDescription>
	{
		return [
			"edge".toFunction(),
			"edgeover".toFunction(),
			"node".toFunction()
		].concat(InfoLabel.filters());
	}
/*
	public static function filters() : Array<FieldFilter>
	{
		return [{
			field : "edge",
			validator : function(v) return Reflect.isFunction(v),
			filter : null
		}, {
			field : "edgeover",
			validator : function(v) return Reflect.isFunction(v),
			filter : null
		}, {
			field : "node",
			validator : function(v) return Reflect.isFunction(v),
			filter : null
		}].concat(InfoLabel.filters());
	}
*/
}