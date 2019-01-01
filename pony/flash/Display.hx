package pony.flash;

import pony.flash.starling.displayFactory.DisplayFactory;
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObject;

#if starling
typedef DisplayObject_ = starling.display.DisplayObject;
#else
typedef DisplayObject_ = flash.display.DisplayObject;
#end

/**
 * DisplayObject
 * @author AxGord <axgord@gmail.com>
 */
abstract DisplayObject(DisplayObject_) from DisplayObject_ to DisplayObject_ {
	
	public var alpha(get, set):Float;
	public var height(get, set):Float;
	public var name(get, set):String;
	//public var parent(get, set):IDisplayObjectContainer;
	public var rotation(get, set):Float;//Degrees / Rads!!!
	public var scaleX(get, set):Float;
	public var scaleY(get, set):Float;
	//public var stage(get, set):IDisplayObjectContainer;
	public var visible(get, set):Bool;
	public var width(get, set):Float;
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	inline public function new(obj) this = obj;
	
	inline public function getTypedChildByName<T>(name:String, cl:Class<T>):T {
		return untyped this.getChildByName(name);
	}
	
	@:arrayAccess inline public function getChildByName(name:String):DisplayObject {
		return getTypedChildByName(name, DisplayObject_);
	}
	
	inline public function get_alpha():Float return this.alpha;
	inline public function set_alpha(a:Float):Float return this.alpha = a;
	
	inline public function get_height():Float return this.height;
	inline public function set_height(a:Float):Float return this.height = a;
	
	inline public function get_name():String return this.name;
	inline public function set_name(a:String):String return this.name = a;
	
	inline public function get_rotation():Float return this.rotation;
	inline public function set_rotation(a:Float):Float return this.rotation = a;
	
	inline public function get_scaleX():Float return this.scaleX;
	inline public function set_scaleX(a:Float):Float return this.scaleX = a;
	
	inline public function get_scaleY():Float return this.scaleY;
	inline public function set_scaleY(a:Float):Float return this.scaleY = a;
	
	inline public function get_visible():Bool return this.visible;
	inline public function set_visible(a:Bool):Bool return this.visible = a;
	
	inline public function get_width():Float return this.width;
	inline public function set_width(a:Float):Float return this.width = a;
	
	inline public function get_x():Float return this.x;
	inline public function set_x(a:Float):Float return this.x = a;
	
	inline public function get_y():Float return this.y;
	inline public function set_y(a:Float):Float return this.y = a;
}