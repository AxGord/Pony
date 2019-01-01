package pony.pixi.ui;

import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pixi.extras.BitmapText.BitmapTextStyle;
import pony.geom.Border;
import pony.pixi.ETextStyle;
import pony.pixi.UniversalText;
import pony.time.DeltaTime;
import pony.ui.gui.RubberLayoutCore;

using pony.pixi.PixiExtends;

/**
 * TextBox
 * @author AxGord <axgord@gmail.com>
 */
class TextBox extends BaseLayout<RubberLayoutCore<Container>> {

	public var text(get, set):String;
	public var obj(default, null):BText;
	
	private var nocache:Bool;
	
	public function new(
		image:Sprite,
		text:String,
		style:ETextStyle,
		?ansi:String,
		?border:Border<Int>,
		nocache:Bool = false,
		shadow:Bool = false,
		?app:App
	) {
		this.nocache = nocache;
		layout = new RubberLayoutCore(border);
		layout.tasks.add();
		super();
		addChild(image);
		image.loaded(function(){
			layout.width = image.width;
			layout.height = image.height;
			layout.tasks.end();
		});
		switch style {
			case ETextStyle.BITMAP_TEXT_STYLE(s):
				add(obj = new BText(text, s, ansi, shadow, app));
			case _:
				throw 'Not supported';
		}
	}
	
	inline private function get_text():String return obj.t;
	
	private function set_text(v:String):String {
		if (v != obj.t) {
			obj.t = v;
			layout.update();
		}
		return v;
	}
	
}