/**
 * ...
 * @author Franco Ponticelli
 */

package rg.info;
import rg.data.DataPoint;
import rg.axis.Stats;
import rg.svg.util.SymbolCache;
using rg.info.filter.FilterDescription;
using rg.info.Info;

@:keep class InfoScatterGraph extends InfoCartesianChart
{
	public var symbol : DataPoint -> Stats<Dynamic> -> String;
	public var symbolStyle : DataPoint -> Stats<Dynamic> -> String;
	public var segment : InfoSegment;

	public function new()
	{
		super();
		segment = new InfoSegment();
		symbol = function(dp, s) return SymbolCache.cache.get("circle", 16);
	}

	public static function filters() : Array<FilterDescription>
	{
		return [
			"symbol".toFunctionOrString(),
			"symbolstyle".toFunctionOrString(["symbolStyle"]),
			"segmenton".simplified(["segment"],
				function(value) return new InfoSegment().feed({ on : value }),
				ReturnMessageIfNot.isString
			),
			"segment".toInfo(InfoSegment)
		].concat(InfoCartesianChart.filters());
	}
/*
	public static function filters() : Array<FieldFilter>
	{
		var result : Array<FieldFilter> = [{
			field : "symbol",
			validator : function(v) return Std.is(v, String) || Reflect.isFunction(v),
			filter: function(v : Dynamic) return [ {
				field : "symbol",
				value : Std.is(v, String) ? function(_,_) return v : v
			}]
		}, {
			field : "symbolstyle",
			validator : function(v) return Reflect.isFunction(v),
			filter: function(v) return [ {
				field : "symbolStyle",
				value : v
			}]
		}, {
			field : "segmenton",
			validator : function(v) return Std.is(v, String),
			filter : function(v) return [{
				field : "segment",
				value : new InfoSegment().feed( { on : v } )
			}]
		}, {
			field : "segment",
			validator : function(v) return Types.isAnonymous(v),
			filter : function(v) return [{
				field : "segment",
				value : new InfoSegment().feed(v)
			}]
		}];
		return result.concat(InfoCartesianChart.filters());
	}
*/
}