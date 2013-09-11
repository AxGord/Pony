package pony.flash.ui;
import flash.display.MovieClip;
import flash.Lib;

/**
 * Window
 * @author AxGord <axgord@gmail.com>
 */
class Window extends MovieClip {

	private var st:Windows;
	
	inline public function new() {
		super();
		visible = false;
	}
	
	inline public function initm(st:Windows):Void {
		this.st = st;
		init();
	}
	
	private function init():Void {}
	
	public function show():Void {
		st.blurOn();
		visible = true;
	}
	
	private function hide():Void {
		st.blurOff();
		visible = false;
	}
	
	
}