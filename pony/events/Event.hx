package pony.events;

import pony.events.Listener;
/**
 * ...
 * @author AxGord
 */
class Event {
	
	public var parent(default,null):Event;
	public var args(default, null):Array<Dynamic>;
	public var count(get, set):Int;
	public var prev(get, null):Event;
	public var _stopPropagation:Bool;
	public var signal:Signal;
	
	private var currentListener:Listener_;
	
	public function new(?args:Array<Dynamic>, ?parent:Event) {
		this.args = args == null ? [] : args;
		this.parent = parent;
		_stopPropagation = false;
	}
	
	public inline function _setListener(l:Listener_):Void currentListener = l;
	
	public inline function stopPropagation():Void _stopPropagation = true;
	
	private inline function get_count():Int return currentListener.count;
	
	private inline function set_count(v:Int):Int return currentListener.count = v;
	
	private inline function get_prev():Event return currentListener.prev;
	
}
