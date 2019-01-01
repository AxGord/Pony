package pony.pixi.ui;

import pixi.core.display.Container;
import pixi.core.display.DisplayObject.DestroyOptions;
import pony.geom.Align;
import pony.geom.Border;
import pony.pixi.ETextStyle;
import pony.pixi.ui.BaseLayout;
import pony.pixi.UniversalText;
import pony.time.DeltaTime;
import pony.ui.gui.RubberLayoutCore;

/**
 * TextSizedBox
 * @author AxGord <axgord@gmail.com>
 */
class TextSizedBox extends BaseLayout<RubberLayoutCore<Container>> {

	public var text(get, set):String;
	public var obj(default, null):BText;
	public var noupdate:Bool = false;
	
	private var nocache:Bool;
	
	public function new(w:Float, h:Float, text:String, style:ETextStyle, ?border:Border<Int>, ?align:Align, nocache:Bool=false, shadow:Bool = false) {
		var f = align != null && align.horizontal != HAlign.Center;
		this.nocache = nocache;
		layout = new RubberLayoutCore(f, border, align);
		layout.tasks.add();
		layout.width = w;
		layout.height = h;
		super();
		switch style {
			case ETextStyle.BITMAP_TEXT_STYLE(t):
				obj = new BText(text, t, null, shadow);
				add(obj);
			case ETextStyle.TEXT_STYLE(_):
				throw 'Not supported';
				//add(obj = new UniversalText(text, style));
				//if (!nocache) obj.toContainer().cacheAsBitmap = true;
		}
		layout.tasks.end();
	}
	
	inline private function get_text():String return obj.t;
	
	private function set_text(v:String):String {
		if (obj.t != v) {
//			obj.toContainer().cacheAsBitmap = false;
//			obj.text = v;
//			if (!nocache) obj.toContainer().cacheAsBitmap = true;
			obj.t = v;
			if (!noupdate) update();
		}
		return v;
	}
	
	@:extern inline private function update():Void {
		layout.update();
		_update();
		DeltaTime.fixedUpdate < _update;
	}
	
	inline private function _update():Void {
		DeltaTime.fixedUpdate < layout.update;
	}
	
	override function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		DeltaTime.fixedUpdate >> _update;
		DeltaTime.fixedUpdate >> layout.update;
		super.destroy(options);
	}
	
}