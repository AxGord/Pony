/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package pony.flash.starling.utils;
import flash.geom.Rectangle;
import pony.flash.starling.displayFactory.DisplayFactory;
import pony.flash.ui.IScrollBar;
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObject;
import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;
#if tweenmax
import com.greensock.TweenMax;
#end

/**
 * PageScroller
 * @author Maletin
 */
using pony.flash.starling.displayFactory.DisplayListStaticExtentions;
 
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
		//TouchManager.addListener(_scrollBar, scrollListener, [TouchEventType.MouseWheel]);
		//TouchManager.addListener(_scrollBar, function(e:TouchManagerEvent):Void { trace("ScrollBar mousewheel"); } , [TouchEventType.MouseWheel]);
		
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
		#if tweenmax
		TweenMax.killTweensOf(this);
		kineticDragged = true;
		TweenMax.to(this, UniversalDrag.KINETIC_DRAG_DURATION, { onUpdate:function():Void { kineticDragged = true; dragScrollUpdate(null); }, onComplete:function ():Void { kineticDragged = false; } } );
		#end
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