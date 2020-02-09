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

	public var alpha(get, set): Float;
	public var height(get, set): Float;
	public var name(get, set): String;
	// public var parent(get, set):IDisplayObjectContainer;
	public var rotation(get, set): Float; // Degrees / Rads!!!
	public var scaleX(get, set): Float;
	public var scaleY(get, set): Float;
	// public var stage(get, set):IDisplayObjectContainer;
	public var visible(get, set): Bool;
	public var width(get, set): Float;
	public var x(get, set): Float;
	public var y(get, set): Float;

	public inline function new(obj) this = obj;
	public inline function getTypedChildByName<T>(name: String, cl: Class<T>): T return untyped this.getChildByName(name);
	@:arrayAccess public inline function getChildByName(name: String): DisplayObject return getTypedChildByName(name, DisplayObject_);
	public inline function get_alpha(): Float return this.alpha;
	public inline function set_alpha(a: Float): Float return this.alpha = a;
	public inline function get_height(): Float return this.height;
	public inline function set_height(a: Float): Float return this.height = a;
	public inline function get_name(): String return this.name;
	public inline function set_name(a: String): String return this.name = a;
	public inline function get_rotation(): Float return this.rotation;
	public inline function set_rotation(a: Float): Float return this.rotation = a;
	public inline function get_scaleX(): Float return this.scaleX;
	public inline function set_scaleX(a: Float): Float return this.scaleX = a;
	public inline function get_scaleY(): Float return this.scaleY;
	public inline function set_scaleY(a: Float): Float return this.scaleY = a;
	public inline function get_visible(): Bool return this.visible;
	public inline function set_visible(a: Bool): Bool return this.visible = a;
	public inline function get_width(): Float return this.width;
	public inline function set_width(a: Float): Float return this.width = a;
	public inline function get_x(): Float return this.x;
	public inline function set_x(a: Float): Float return this.x = a;
	public inline function get_y(): Float return this.y;
	public inline function set_y(a: Float): Float return this.y = a;

}