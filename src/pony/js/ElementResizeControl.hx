package pony.js;

import js.html.Element;
import pony.magic.HasSignal;
import pony.events.Signal2;
import pony.time.DeltaTime;

/**
 * ElementResizeControl
 * @author AxGord <axgord@gmail.com>
 */
class ElementResizeControl implements HasSignal {

	@:auto public var onResize: Signal2<Int, Int>;
	@:bindable public var element: Element;
	public var width(get, never): Int;
	public var height(get, never): Int;
	private var even: Bool;
	private var initCheckCounter: Int = 0;

	public function new(element: Element, even: Bool = true) {
		this.element = element;
		this.even = even;
		eResize.onTake << listenResize;
		eResize.onLost << unlistenResize;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_width(): Int return makeEven(element.clientWidth);

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_height(): Int return makeEven(element.clientHeight);

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function makeEven(v: Int): Int return even ? v - v % 2 : v;

	private function listenResize(): Void {
		Window.onResize << resizeHandler;
		initCheckCounter = 8;
		DeltaTime.fixedUpdate << check;
	}

	private function check(): Void {
		resizeHandler();
		if (--initCheckCounter <= 0) DeltaTime.fixedUpdate >> check;
	}

	private function unlistenResize(): Void Window.onResize >> resizeHandler;

	public function resizeHandler(): Void {
		for (i in 0...element.childElementCount)
			element.children.item(i).hidden = true;
		eResize.dispatch(width, height);
		for (i in 0...element.childElementCount)
			element.children.item(i).hidden = false;
	}

}