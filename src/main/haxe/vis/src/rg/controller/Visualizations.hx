/**
 * ...
 * @author Franco Ponticelli
 */

package rg.controller;
import thx.error.Error;
import thx.js.Selection;
import rg.view.layout.Layout;

class Visualizations 
{
	public static var html = ["pivottable", "leaderboard"];
	public static var svg = ["linechart", "piechart", "linechart"];
	public static var visualizations = svg.concat(html);
	public static var layouts = ["simple", "simplereverse"];
	public static var layoutDefault : Hash<String>;
	public static var layoutType : Hash<Class<Dynamic>>;
	public static var layoutArgs : Hash<Array<Dynamic>>;
	
	public static function instantiateLayout(name : String, width : Int, height : Int, container : Selection) : Layout
	{
		return Type.createInstance(getType(name), getArgs(name, width, height, container));
	}
	
	static function __init__()
	{
		layoutDefault = new Hash();
		layoutType = new Hash();
		layoutArgs = new Hash();
		
		layoutDefault.set("linechart", "simple");
		layoutDefault.set("piechart", "simple");
		
		layoutType.set("simple", rg.view.layout.SimpleLayout);
		layoutArgs.set("simple", [true]);
		layoutType.set("simplereverse", rg.view.layout.SimpleLayout);
		layoutArgs.set("simplereverse", [false]);
	}
	
	static function getType(name : String) return layoutType.get(name)
	static function getArgs(name : String, width : Int, height : Int, container : Selection)
	{
		var extra = layoutArgs.get(name);
		if (null == extra)
			extra = [];
		var args : Array<Dynamic> = [];
		return args.concat([width, height, container]).concat(extra);
	}
}