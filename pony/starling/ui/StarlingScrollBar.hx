package pony.starling.ui;

import flash.geom.Rectangle;
import pony.events.Signal;
import pony.flash.FLTools;
import pony.flash.ui.IScrollBar;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;
import pony.ui.SlideCore;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureSmoothing;



using pony.flash.FLExtends;
using pony.starling.displayFactory.DisplayListStaticExtentions;
/**
 * StarlingScrollBar
 * @author Maletin
 */
class StarlingScrollBar extends Sprite implements pony.flash.FLSt implements IScrollBar
{
	public var scroller:StarlingButton;
	public var bg:DisplayObject;
	
	private var _source:Sprite;
	
	public var size(get, set):Float;
	public var total(default, set):Float;
	public var position(get,set):Float;
	public var isVert:Bool;
	public var update:Signal;
	
	private var rect:Rectangle;
	private var mouseMove:Signal;
	private var scrollerSize(get, null):Float;
	private var scrollerPos(get, null):Float;
	
	private var slideCore:SlideCore;
	
	private var _position:Float;
	private var _scrollRect:Rectangle;

	public function new(source:Sprite) 
	{
		super();
		
		_source = source;
		
		scroller = untyped source.getChildByName("scroller");
		bg = untyped source.getChildByName("bg");
		
		scroller.smoothing = TextureSmoothing.NONE;
		if (Std.is(bg, Image)) untyped bg.smoothing = TextureSmoothing.NONE;
		
		addChild(bg);
		addChild(scroller);
		_scrollRect = scroller.getBounds(this);
		
		this.transformationMatrix = source.transformationMatrix;
		
		
		slideCore = new SlideCore(1, 20);
		slideCore.update.add(slUpdate);
		update = new Signal();
		_position = 0;
		isVert = width < height;
		
		FLTools.init < init;
	}
	
	private function init():Void {
		size = isVert ? bg.height : bg.width;
		mouseMove = buildTMSignal(TouchManager.GLOBAL, [TouchEventType.Move]);
		mouseMove.silent = true;
		mouseMove.add(scrollerMove);
		TouchManager.addListener(scroller, function(e:TouchManagerEvent):Void { startDraaag(); }, [TouchEventType.Down] );
		
	}
	
	private function buildTMSignal(displayObject:Dynamic, types:Array<TouchEventType> = null):Signal
	{
		var s:Signal;
		s = new Signal();
		TouchManager.addListener(displayObject, function(event:TouchManagerEvent) s.dispatchArgs([event]), types);
		return s;
	}
	
	private function startDraaag():Void {
		var ss:Float = size - scrollerSize;
		rect = isVert ? new Rectangle(_scrollRect.x, _scrollRect.y, 0, ss) : new Rectangle(_scrollRect.x, _scrollRect.y, ss, 0);
		scroller.startUniversalDrag(false, rect);
		mouseMove.disableSilent();
		
		TouchManager.addListener(TouchManager.GLOBAL, stopDraaag, [TouchEventType.Up]);
	}
	
	private function stopDraaag(e:Dynamic = null):Void {
		TouchManager.removeListener(TouchManager.GLOBAL, stopDraaag);
		
		scroller.stopUniversalDrag();
		mouseMove.enableSilent();
	}
	
	private function get_size():Float {
		return isVert ? bg.height : bg.width;
	}
	
	private function set_size(v:Float):Float {
		var ss:Float = size - scrollerSize;
		if (isVert) {
			bg.height = v;
			updateScroller();
			if (rect != null)
				rect.height = v - scroller.height;
			var ns:Float = size - scrollerSize;
			scroller.y *= ns / ss;
		} else {
			bg.width = v;
			updateScroller();
			if (rect != null)
				rect.width = v - scroller.width;
			var ns:Float = size - scrollerSize;
			scroller.x *= ns / ss;
		}
		scrollerMove();
		
		return v;
	}
	
	private function set_total(v:Float):Float {
		total = v;
		updateScroller();
		return v;
	}
	
	private function updateScroller():Void {
		if (isVert) {
			scroller.y = position;
			scroller.height = size * size / total;
		} else {
			scroller.x = position;
			scroller.width = size * size / total;
		}
		if (scrollerSize >= size - 10)
			slideCore.close();
		else
			slideCore.open();
	}
	
	private function scrollerMove():Void {
		_position = scrollerPos;
		dispatchUpdate();
	}
	
	inline private function dispatchUpdate():Void update.dispatch(position/size * total);
	
	private inline function get_scrollerSize():Float return isVert ? scroller.height : scroller.width;
	private inline function get_scrollerPos():Float return isVert ? scroller.y : scroller.x;
	
	private inline function get_position():Float return _position;

	private inline function set_position(p:Float):Float {
		if (p < 0 || scrollerSize >= size - 10) p = 0;
		else if (p > size - scrollerSize) p = size - scrollerSize;
		_position = p;
		updateScroller();
		dispatchUpdate();
		return position;
	}
	
	public function setPositionPercent(p:Float):Void
	{
		if (p < 0 || scrollerSize >= size - 10) p = 0;
		else if (p > 1) p = 1;
		_position = p * (size - scrollerSize);
		updateScroller();
		dispatchUpdate();
	}
	
	private function slUpdate(v:Float):Void alpha = v;
	
}