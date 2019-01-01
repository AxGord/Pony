package pony.flash;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;
import flash.Lib;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.SpreadMethod;
import flash.geom.Matrix;
import pony.flash.ui.Button;
import pony.geom.Rect;
import pony.ui.gui.ButtonCore;

typedef Sigid = {d:EventDispatcher, n:String};
 
/**
 * Flash extends
 * @author AxGord
 */
class FLExtends {
	/*
	private static var signals:Map<Sigid, Signal> = new Map<Sigid, Signal>();
	
	public static function buildSignal(d:EventDispatcher, name:String):Signal {
		var sid:Sigid = { d:d, n:name };
		var s:Signal;
		if (!signals.exists(sid)) signals.set(sid, s = new Signal());
		else s = signals.get(sid);
		d.addEventListener(name, function(event:Event) s.dispatchArgs([event]));
		return s;
	}
	*/
	public inline static function v(f:Void->Void):Dynamic return function(Void) f();
	
	public static function childrens(d:DisplayObjectContainer):Iterator<DisplayObject> {
		var it:IntIterator = 0...d.numChildren;
		return {
			hasNext: it.hasNext,
			next: function():DisplayObject return d.getChildAt(it.next())
		};
	}
	
	public static function rect(r:Rectangle):Rect<Float> return { x: r.x, y: r.y, width: r.width, height: r.height };
	
	static public function border(rect:Rectangle, x:Float, ?y:Float):Rectangle {
		var r = rect.clone();
		if (y == null) y = x;
		r.x += x;
		r.y += y;
		r.width -= x * 2;
		r.height -= y * 2;
		return r;
	}
	
	inline public static function removeAllChild(d:DisplayObjectContainer):Void while (d.numChildren > 0) d.removeChildAt(0);
	
	public static function toCenter(o:DisplayObject, width:Float, height:Float):Void {
		var b = o.getBounds(Lib.current.stage);
		o.x = width/2 - (o.width/2 - (o.x - b.x));
		o.y = height/2 - (o.height/2 - (o.y - b.y));
	}
	
	public static function toScreenCenter(o:DisplayObject):Void toCenter(o, FLTools.width, FLTools.height);
	
	inline public static function getTyped<T:DisplayObject>(o:DisplayObjectContainer, name:String, cl:Class < T >):T return cast get(o, name);
	
	inline public static function get(o:DisplayObjectContainer, name:String):DisplayObject return untyped o[name];
	
	//inline public static function button(o:DisplayObjectContainer, name:String):ButtonCore return getTyped(o, name, Button).core;
	
	public static function vlinGrad(graphics:Graphics, c1:UInt, c2:UInt, width:Float, height:Float):Void {
		var colors:Array<UInt> = [c1, c2];
		var alphas:Array<Float> = [1, 1];
		var ratios:Array<Int> = [0x00, 0xFF];
		var matr:Matrix = new Matrix();
		matr.createGradientBox(height, height, Math.PI / 2, 0, 0);
		graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);       
		graphics.drawRect(0,0,width,height);
	}
	
	public static function hlinGrad(graphics:Graphics, c1:UInt, c2:UInt, width:Float, height:Float):Void {
		var colors:Array<UInt> = [c1, c2];
		var alphas:Array<Float> = [1, 1];
		var ratios:Array<Int> = [0x00, 0xFF];
		var matr:Matrix = new Matrix();
		matr.createGradientBox(width, width, 0, 0, 0);
		graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, SpreadMethod.PAD);       
		graphics.drawRect(0,0,width,height);
	}
}