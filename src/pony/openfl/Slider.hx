package pony.openfl;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import pony.openfl.Button;
import pony.ui.gui.SliderCore;
import pony.ui.gui.ButtonCore;

private typedef SliderType = {
	public function new(?button:ButtonCore, size:Float, ?isVertical:Bool, ?invert:Bool, ?draggable:Bool):Void;
	dynamic public function changeX(v:Float):Void;
	dynamic public function changeY(v:Float):Void;
	public function endInit():Void;
}

/**
 * Slider
 * @author AxGord <axgord@gmail.com>
 */
@:generic
class Slider<T:SliderType> extends Sprite {

	public var core(default, null):T;
	
	public function new(b:Button, bg:Bitmap, invert:Bool=false, sizeFix:Float=0, bFix:Float=0, draggable:Bool=true) {
		super();
		addChild(bg);
		addChild(b);
		var isVert = bg.height > bg.width;
		core = new T(b.core, (isVert ? bg.height : bg.width) + sizeFix, isVert, invert, draggable);
		core.changeX = function(v:Float) b.x = Std.int(v + bFix); 
		core.changeY = function(v:Float) b.y = Std.int(v + bFix); 
		core.endInit();
	}
	
}