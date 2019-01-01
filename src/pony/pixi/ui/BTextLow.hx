package pony.pixi.ui;

import pixi.extras.BitmapText;
import pony.geom.IWH;
import pony.geom.Point;
import pony.text.TextTools;

/**
 * Text
 * @author AxGord <axgord@gmail.com>
 */
class BTextLow extends BitmapText implements IWH {

	public var t(get, set):String;
	public var size(get, never):Point<Float>;
	private var ansi:String;
	public var nocache(default, null):Bool;
	
	public function new(text:String, ?style:BitmapTextStyle, ?ansi:String, nocache:Bool=false) {
		this.ansi = ansi;
		this.nocache = nocache;
		if (text == null) text = ' ';
		if (ansi != null)
			text = TextTools.convertToANSI(text, ansi);
		try {
			super(text, style);
		} catch (_:Dynamic) {
			throw 'Font error: ' + style.font;
		}
		if (!this.nocache) cacheAsBitmap = true;

	}
	
	private function get_size():Point<Float> return new Point(textWidth, textHeight);
	
	public function wait(cb:Void->Void):Void cb();
	
	@:extern inline public function get_t():String return text;
	
	public function set_t(s:String):String {
		if (!nocache) cacheAsBitmap = false;
		if (s == null) s = ' ';
		if (ansi != null)
			text = TextTools.convertToANSI(s, ansi);
		else
			text = s;
		if (!nocache) cacheAsBitmap = true;
		return s;
	}
	
	public function destroyIWH():Void destroy();
	
}