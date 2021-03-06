/**
 * ...
 * @author Franco Ponticelli
 */

package rg.svg.chart;
import rg.svg.panel.Panel;
import rg.svg.panel.Layer;
import rg.axis.Stats;
import rg.html.widget.Tooltip;
import thx.math.Equations;
import rg.svg.panel.Panels;
import hxevents.Notifier;

class Chart extends Layer
{
	public var animated : Bool;
	public var animationDuration : Int;
	public var animationEase : Float -> Float;
	public var click : Dynamic -> Stats<Dynamic> -> Void;
	public var labelDataPoint : Dynamic -> Stats<Dynamic> -> String;
	public var labelDataPointOver : Dynamic -> Stats<Dynamic> -> String;
	public var ready(default, null) : Notifier;

	var panelx : Float;
	var panely : Float;
	var tooltip : Tooltip;

	public function new(panel : Panel)
	{
		super(panel);
		animated = true;
		animationDuration = 1500;
		animationEase = Equations.linear;
		ready = new Notifier();
	}

	override function resize()
	{
		var coords = Panels.absolutePos(panel);
		panelx = coords.x;
		panely = coords.y;
	}

	public function init()
	{
		if (null != labelDataPointOver)
		{
			tooltip = Tooltip.instance;
		}
		resize();
	}

	function moveTooltip(x : Float, y : Float, color : Null<String>)
	{
		var coords = Panels.absolutePos(panel);
		panelx = coords.x;
		panely = coords.y;
		tooltip.setAnchorColor(color);
		tooltip.showAt(Std.int(panelx + x), Std.int(panely + y));
	}
}