package pony.flash.ui;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.Lib;
#if starling
import pony.flash.starling.ui.StarlingWindow;
import pony.flash.starling.converter.StarlingConverter;
import pony.flash.starling.converter.IStarlingConvertible;
import starling.display.Sprite;
#end

/**
 * Window
 * @author AxGord <axgord@gmail.com>
 */
#if !starling
class Window extends MovieClip implements IWindow {
#else
class Window extends MovieClip implements IWindow implements IStarlingConvertible {
#end

	private var st: Windows;

	public inline function new() {
		super();
		visible = false;
	}

	public inline function initm(st: Windows): Void {
		this.st = st;
		init();
	}

	private function init(): Void {}

	public function show(): Void {
		st.blurOn();
		visible = true;
	}

	private function hide(): Void {
		st.blurOff();
		visible = false;
	}

	#if starling
	public function convert(coordinateSpace: DisplayObject): starling.display.DisplayObject
		return new StarlingWindow(untyped StarlingConverter.getSprite(cast this, coordinateSpace, false));
	#end

}