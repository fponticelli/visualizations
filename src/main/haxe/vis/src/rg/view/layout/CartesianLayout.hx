/**
 * ...
 * @author Franco Ponticelli
 */

package rg.view.layout;

import rg.controller.info.InfoLayout;
import rg.view.svg.panel.Panel;
import rg.view.svg.panel.Container;
import thx.js.Selection;
import rg.view.frame.FrameLayout;
import rg.view.layout.Anchor;
import rg.view.frame.Orientation;

class CartesianLayout extends Layout
{
	var main : Panel;
	var titleUsed : Bool;
	var titleOnTop : Bool;
	
	var leftcontainer : Container;
	var rightcontainer : Container;
	var bottomcontainer : Container;
	var bottommiddlecontainer : Container;
	var maincontainer : Container;
	var middlecontainer : Container;
	
	var bottomleft : Panel;
	var bottomright : Panel;
	var xtickmarks : PanelContext;
	var title : PanelContext;
	
	var left : Bool;
	var alternating : Bool;
	var yitems : Array<{
		container : Container,
		context : PanelContext,
		title : PanelContext,
		anchor : Anchor
	}>;
	var xtitle : PanelContext;

	public function new(width : Int, height : Int, container : Selection) 
	{
		super(width, height, container);
		titleUsed = false;
		titleOnTop = true;
		left = true;
		alternating = true;
		yitems = [];
	}
	
	override public function getContext(name : String) : PanelContext
	{
		if (isY(name))
		{
			return getYContext(getYIndex(name));
		} else if (isYTitle(name)) {
			return getYTitle(getYIndex(name));
		}
		switch(name)
		{
			case "title":
				if (null == title)
					title = new PanelContext(space.createPanelAt(titleOnTop ? 0 : 1, FrameLayout.Fixed(0, 0, 0)), titleOnTop ? Bottom : Top);
				return title;
			case "x":
				return getXTickmarks();
			case "xtitle":
				return getXTitle();
			default:
				return null;
		}
	}
	
	override public function getPanel(name : String) : Panel
	{
		switch(name)
		{
			case "main":
				return getMain();
			case "xtickmarks":
				return getBottomContainer();
			case "left":
				return getLeftContainer();
			case "right":
				return getRightContainer();
			case "bottomleft":
				return bottomleft;
			case "bottomright":
				return bottomright;
			default:
				var ctx = getContext(name);
				if (null == ctx)
					return null;
				return ctx.panel;
		}
	}
	
	function getYItem(index : Int)
	{
		if (null == yitems[index])
		{
			yitems[index] = { 
				container : null,
				context : null,
				title : null,
				anchor : alternating && index % 2 == 0 ? Right : Left
			};
		}
		return yitems[index];
	}
	
	function getYContainer(index : Int)
	{
		var item = getYItem(index);
		if (null == item.container)
		{
			if (alternating && index % 2 == 0)
			{
				item.container = getLeftContainer().createContainerAt(0, FrameLayout.Fixed(0, 0, 0), Horizontal);
			} else {
				item.container = getRightContainer().createContainer(FrameLayout.Fixed(0, 0, 0), Horizontal);
			}
			item.container.g.classed().add("group-" + index);
		}
		return item.container;
	}
	
	function getYContext(index : Int)
	{
		var item = getYItem(index);
		if (null == item.context)
		{
			var panel = switch(item.anchor)
			{
				case Left:  getYContainer(index).createPanelAt(0, Fixed(0, 0, 0));
				case Right: getYContainer(index).createPanel(Fixed(0, 0, 0));
				default: null;
			}
			item.context = new PanelContext(panel, item.anchor);
		}
		return item.context;
	}
	
	function getYTitle(index : Int)
	{
		var item = getYItem(index);
		if (null == item.title)
		{
			var panel = switch(item.anchor)
			{
				case Left:  getYContainer(index).createPanel(Fixed(0, 0, 0));
				case Right: getYContainer(index).createPanelAt(0, Fixed(0, 0, 0));
				default: null;
			}
			item.title = new PanelContext(panel, item.anchor);
		}
		return item.title;
	}
/*
	function getYTitle(index : Int)
	{
		var item = getYItem(index);
		if (null == item.title)
		{
			item.title = if (alternating && index % 2 == 0)
			{
				new PanelContext(getLeftContainer().createPanelAt(0, FrameLayout.Fixed(0, 0, 0)), Right);
			} else {
				new PanelContext(getRightContainer().createPanel(FrameLayout.Fixed(0, 0, 0)), Left);
			}
			item.title.panel.g.classed().add("group-" + index);
		}
		return item.title;
	}
*/
	function getYIndex(s : String)
	{
		if (!REYINDEX.match(s))
			return -1;
		else
			return Std.parseInt(REYINDEX.matched(1));
	}
	
	function isY(s : String)
	{
		return REYAXIS.match(s);
	}
	
	function isYTitle(s : String)
	{
		return REYTITLE.match(s);
	}
	
	static var REYAXIS = ~/^y(\d+)$/;
	static var REYINDEX = ~/^y(\d+)/;
	static var REYTITLE = ~/^y(\d+)title$/;
	override public function suggestSize(name : String, size : Int)
	{
		if (isY(name) || isYTitle(name))
		{
			var index = getYIndex(name),
				item = getYItem(index);
			if (null == item.container)
				return;

			var ysize = 0.0;
			if (null != item.context)
			{
				if (isY(name))
					suggestPanelSize(item.context.panel, size);
				ysize += item.context.panel.frame.width;
			}
			if (null != item.title)
			{
				if (isYTitle(name))
					suggestPanelSize(item.title.panel, size);
				ysize += item.title.panel.frame.width;
			}
			suggestPanelSize(item.container, Math.round(ysize));
			suggestLateralSize(item.anchor);
			return;
		}
		super.suggestSize(name, size);
		switch(name)
		{
			case "x", "xtitle":
				var size = 0,
					c = getPanel("x");
				if (null != c)
					size += c.frame.height;
				c = getPanel("xtitle");
				if (null != c)
					size += c.frame.height;
				super.suggestSize("xtickmarks", size);
		}
	}
	
	function suggestLateralSize(anchor : Anchor)
	{
		var size = 0;
		var i = 0;
		for (item in yitems)
		{
			i++;
			if (null == item.container || !Type.enumEq(item.anchor, anchor))
				continue;
			size += item.container.frame.width;
		}
		switch(anchor)
		{
			case Right:
				suggestSize("left", size);
				suggestSize("bottomleft", size);
			case Left:
				suggestSize("right", size);
				suggestSize("bottomright", size);
			default: //
		}
	}
	
	function getXTitle()
	{
		if (null == xtitle)
			xtitle = new PanelContext(getBottomMiddleContainer().createPanel(FrameLayout.Fixed(0, 0, 0)), Top);
		return xtitle;
	}

	function getMainContainer()
	{
		if (null == maincontainer)
			maincontainer = space.createContainerAt(titleOnTop ? 1 : 0, FrameLayout.Fill(0, 0), Vertical);
		return maincontainer;
	}
	
	function getMiddleContainer()
	{
		if (null == middlecontainer)
			middlecontainer = getMainContainer().createContainerAt(0, FrameLayout.Fill(0, 0), Horizontal);
		return middlecontainer;
	}
	
	function getLeftContainer()
	{
		if (null == leftcontainer)
			leftcontainer = getMiddleContainer().createContainerAt(0, FrameLayout.Fixed(0, 0, 0), Horizontal);
		return leftcontainer;
	}
	
	function getRightContainer()
	{
		if (null == rightcontainer)
			rightcontainer = getMiddleContainer().createContainerAt(2, FrameLayout.Fixed(0, 0, 0), Horizontal);
		return rightcontainer;
	}
	
	function getBottomContainer()
	{
		if (null == bottomcontainer)
			bottomcontainer = getMainContainer().createContainerAt(1, FrameLayout.Fixed(0, 0, 0), Horizontal);
		return bottomcontainer;
	}
	
	function getBottomMiddleContainer()
	{
		if (null == bottommiddlecontainer)
		{
			var container = getBottomContainer();
			bottomleft = container.createPanel(FrameLayout.Fixed(0, 0, 0));
			bottommiddlecontainer = container.createContainer(FrameLayout.Fill(0, 0), Vertical);
			bottommiddlecontainer.g.classed().add("axis-x");
			bottomright = container.createPanel(FrameLayout.Fixed(0, 0, 0));
		}
		return bottommiddlecontainer;
	}
	
	function getXTickmarks()
	{
		if (null == xtickmarks)
		{
			var container = getBottomMiddleContainer();
			xtickmarks = new PanelContext(container.createPanelAt(0, FrameLayout.Fixed(0, 0, 0)), Top);
		}
		return xtickmarks;
	}
	
	function getMain()
	{
		if (null == main)
			main = getMiddleContainer().createPanelAt(1, FrameLayout.Fill(0, 0));
		return main;
	}
	
	override function feedOptions(info : InfoLayout)
	{
		super.feedOptions(info);
		titleOnTop = info.titleOnTop;
		
		switch(info.layoutScaleY)
		{
			case LayoutScaleY.ScalesOnLeft:
				left = true;
				alternating = false;
			case LayoutScaleY.ScalesOnRight:
				left = false;
				alternating = false;
			case LayoutScaleY.ScalesAlternating:
				left = true;
				alternating = true;
		}
	}
}