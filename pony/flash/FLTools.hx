/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.flash;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import flash.system.Capabilities;
import flash.display.DisplayObject;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.display.DisplayObjectContainer;
import pony.events.Signal;

/**
 * Flash tools
 * @author AxGord
 */

class FLTools 
{
	static public var os(get, null):String;
	static public var version(get, null):Array<Int>;
	
	static private function get_os():String return Capabilities.version.split(' ')[0];
	static private function get_version():Array<Int> return Capabilities.version.split(' ')[1].split(',').map(Std.parseInt);
	
	public static function getRect(o:DisplayObject):Rectangle {
		return new Rectangle(o.x, o.y, o.width, o.height);
	}
	
	public static function setRectP(o:DisplayObject, r:Rectangle):Void {
		o.x = r.x;
		o.y = r.y;
		setSize(o, r.width, r.height);
	}
	
	//Вписывает объект внутрь прямоугольника, сохраняя пропорции. Размещает по центру.
	public static function setSize(o:DisplayObject, w:Float, h:Float):Void {
		var d1:Float = w/h;
		var d2:Float = o.width/o.height;
		if (d1 < d2) {
			//height *= w/width;
			o.width = w;
			o.scaleY = o.scaleX;
			o.y += (h - o.height) / 2;
		} else if (d1 > d2) {
			//width *= h/height;
			o.height = h;
			o.scaleX = o.scaleY;
			o.x += (w - o.width) / 2; 
		} else {
			o.width = w;
			o.height = h;
		}
	}
	
	public static function setRect(o:DisplayObject, rect:Rectangle):Void {
		o.x = rect.x;
		o.y = rect.y;
		o.width = rect.width;
		o.height = rect.height;
	}
	
	//SmartFit
	//private static var _rect:Rectangle;
	private static var _target:MovieClip;
	private static var _shape:Shape;
	private static var _inited:Void->Void;
	public static var width:Float = -1;
	public static var height:Float = -1;
	
	public static function smartFit(m:MovieClip, ?inited:Void->Void):Void {
		_target = m;
		_inited = inited;
		m.stage.scaleMode = StageScaleMode.NO_SCALE;
		m.stage.align = StageAlign.TOP_LEFT;
		
		//updateSize();
		//m.stage.addEventListener(Event.RESIZE, updateSize);
		m.stage.addEventListener(Event.FRAME_CONSTRUCTED, firstResize);
	}
	
	private static function firstResize(Void):Void {
		if (_target.stage.stageWidth == 0) return;
		_target.stage.removeEventListener(Event.FRAME_CONSTRUCTED, firstResize);
		_shape = new Shape();
		if (height != -1)
			_shape.graphics.drawRect(0, 0, width, height);
		else
			_shape.graphics.drawRect(0, 0, _target.stage.stageHeight, _target.stage.stageWidth);
		//untyped _target.d.text = _target.stage.stageWidth + 'x' + _target.stage.stageHeight;
		//_rect = _target.getRect(_target.stage);
		_target.stage.addEventListener(Event.RESIZE, updateSize);
		//updateSize();
		if (_inited != null) _inited();
	}
	
	public static function updateSize(?Void):Void {
		/*
		var objs:List<DisplayObject> = new List<DisplayObject>();
		for (i in 0..._target.numChildren) {
			objs.push(_target.getChildAt(0));
			_target.removeChildAt(0);
		}*/
		
		var chs:Array<Rectangle> = [];
		//var zr:Rectangle = new Rectangle(1, 1);
		for (i in 0..._target.numChildren) {
			var ch:DisplayObject = _target.getChildAt(i);
			chs.push(getRect(ch));
			ch.x = ch.y = 1;
			ch.width = ch.height = 0;
			//setRect(ch, zr);
		}
		_target.addChild(_shape);
		//untyped _target.d.text = _target.stage.stageWidth + 'x' + _target.stage.stageHeight;
		setRectP(_target, new Rectangle(0, 0, _target.stage.stageWidth, _target.stage.stageHeight));
		_target.removeChild(_shape);
		
		for (i in 0..._target.numChildren) {
			var ch:DisplayObject = _target.getChildAt(i);
			setRect(ch, chs[i]);
		}
		
		//for (o in objs) _target.addChild(o);
	}
	
	public static function recursiveCompare(o:DisplayObjectContainer, t:Dynamic):Bool {
		if (o == t) return true;
		for (i in 0...o.numChildren)
			if (Std.is(o.getChildAt(i), DisplayObjectContainer) && recursiveCompare(cast(o.getChildAt(i), DisplayObjectContainer), t))
				return true;
		return false;
	}
	
	public static function childrens(d:DisplayObjectContainer):Iterator<DisplayObject> {
		var it:IntIterator = 0...d.numChildren;
		return {
			hasNext: it.hasNext,
			next: function():DisplayObject return d.getChildAt(it.next())
		};
	}
	
	
	public inline static function setTrace():Void haxe.Log.trace = myTrace;
	
	private static function myTrace( v : Dynamic, ?pos : haxe.PosInfos):Void {
		untyped __global__["trace"](pos.className+"#"+pos.methodName+"("+pos.lineNumber+"):",v);
	}
	
	public static function makeBigBorders(color:Int = 0x666666):Void {
		var size:Float = 100000;
		var sprite:Sprite = new Sprite();
		sprite.graphics.beginFill(color);
		sprite.graphics.drawRect( -size, -size, size*2+width, size);
		sprite.graphics.drawRect(-size, 0, size, width+size);
		sprite.graphics.drawRect(width, 0, size, width+size);
		sprite.graphics.drawRect(0, height, width, height + size);
		
		Lib.current.addChild(sprite);
	}
	/*
	public static function nextTick(o:DisplayObject):Signal {
		var s:Signal = new Signal();
		var f:Event->Void = null;
		f = function(_):Void {
			o.removeEventListener(Event.ENTER_FRAME, f);
			s.dispatch();
		}
		o.addEventListener(Event.ENTER_FRAME, 
	}
	*/
}