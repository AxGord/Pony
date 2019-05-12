package pony.js;

import js.html.Element;
import pony.magic.HasSignal;
import pony.events.Signal2;

class ElementResizeControl implements HasSignal {

	@:auto public var onResize:Signal2<Int, Int>;
	@:bindable public var element:Element;
	public var width(get, never):Int;
	public var height(get, never):Int;

	public function new(element:Element) {
		this.element = element;
		eResize.onTake << listenResize;
		eResize.onLost << unlistenResize;
	}

	@:extern private inline function get_width():Int return element.clientWidth;
	@:extern private inline function get_height():Int return element.clientHeight;

	private function listenResize():Void {
		Window.onResize << resizeHandler;
	}

	private function unlistenResize():Void {
		Window.onResize >> resizeHandler;
	}

	public function resizeHandler():Void {
		eResize.dispatch(width, height);
	}

}