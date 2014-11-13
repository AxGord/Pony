package pony.starling.utils;
import com.greensock.TweenMax;
import flash.geom.Rectangle;
import pony.flash.ui.IScrollBar;
import pony.starling.displayFactory.DisplayFactory.IDisplayObject;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;

/**
 * PageScroller
 * @author Maletin
 */
using pony.starling.displayFactory.DisplayListStaticExtentions;
 
class PageScroller 
{
	private var _pageAreaHeight:Int;
	private var pageHeight:Int;
	private var kineticDragged:Bool = false;
	private var activelyDragged:Bool = false;
	private var dragged(get, null):Bool;
	private var _scrollBar:IScrollBar;
	private var _page:IDisplayObject;

	public function new(pageAreaHeight:Int, scrollBar:IScrollBar, page:IDisplayObject) 
	{
		_scrollBar = scrollBar;
		_page = page;
		_pageAreaHeight = pageAreaHeight;
		_scrollBar.update.add(function(p:Float):Void { if (!dragged) page.y = -p; });
		TouchManager.addListener(page, scrollListener, [TouchEventType.MouseWheel]);
		
		TouchManager.addListener(page, onAreaDrag, [TouchEventType.Down]);
		TouchManager.addListener(page, dragScrollUpdate, [TouchEventType.Move]);
		TouchManager.addListener(page, onAreaStopDrag, [TouchEventType.Up]);
	}
	
	private function onAreaDrag(e:TouchManagerEvent):Void
	{
		activelyDragged = true;
		var dHeight:Int = dSize();
		_page.startUniversalDrag(false, new Rectangle(_page.x, -dHeight, 0, dHeight));
	}
	
	private function onAreaStopDrag(e:TouchManagerEvent):Void
	{
		_page.stopUniversalDragKinetic();
		TweenMax.killTweensOf(this);
		kineticDragged = true;
		TweenMax.to(this, UniversalDrag.KINETIC_DRAG_DURATION, { onUpdate:function():Void { kineticDragged = true; dragScrollUpdate(null); }, onComplete:function ():Void { kineticDragged = false; } } );
		activelyDragged = false;
	}
	
	private function dragScrollUpdate(e:TouchManagerEvent):Void
	{
		if (dragged)
		{
			var dHeight:Int = dSize();
			if (dHeight == 0)
			{
				_scrollBar.setPositionPercent(0);
			}
			else
			{
				_scrollBar.setPositionPercent(-_page.y / dHeight);
			}
		}
	}
	
	private function scrollListener(e:TouchManagerEvent):Void { if (!dragged) _scrollBar.position -= e.value * 15; }
	
	private function dSize():Int
	{
		return Std.int(pageHeight - _pageAreaHeight < 0 ? 0 : pageHeight - _pageAreaHeight);
	}
	
	public function setPageSize(size:Float):Void
	{
		pageHeight = Std.int(size);
		_scrollBar.total = size;
		_scrollBar.position = 0;
	}
	
	private function get_dragged():Bool
	{
		return kineticDragged || activelyDragged;
	}
	
}