package pony.ui.xml;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import pony.magic.HasAbstract;
import pony.openfl.ui.IntervalLayout;
import pony.ui.AssetManager;

using StringTools;

/**
 * ...
 * @author meerfolk<meerfolk@gmail.com>
 */

#if !macro
@:autoBuild(pony.ui.xml.XmlUiBuilder.build({
	free: openfl.display.Sprite,
	image: openfl.display.Bitmap,
	ivlayout : pony.openfl.ui.IntervalLayout,
	ihlayout : pony.openfl.ui.IntervalLayout,
	text: openfl.text.TextField
}))
#end
 

class OpenflXmlUi extends Sprite implements HasAbstract {
	
	public function createUIElement (name:String, attrs:Dynamic<String>, content:Array<Dynamic>):Dynamic {
		var obj : DisplayObject = 
		switch name {
			case 'free' :
				var s = new Sprite();
				if (attrs.x != null) s.x = Std.parseInt(attrs.x);
				if (attrs.y != null) s.y = Std.parseInt(attrs.y);
				for (e in content) s.addChild(e);
				s;
			case 'image' : 
				var b = AssetManager.image(attrs.src, name);
				b;
			case 'ivlayout' :
				var l = new IntervalLayout(Std.parseInt(attrs.i), true);
				for (e in content) {
					l.add(e);
				}
				l;
			case 'ihlayout' :
				var l = new IntervalLayout(Std.parseInt(attrs.i), false);
				for (e in content) {
					l.add(e);
				}
				l;
			case 'text':
				if (attrs.color != null) {
					attrs.color = attrs.color.replace('#', '0x');
				}
				var format : TextFormat = new TextFormat(attrs.font, Std.parseInt(attrs.size),Std.parseInt(attrs.color));
				var text = content.length > 0 ? content[0] : '';
				var t : TextField = new TextField();
				t.defaultTextFormat = format;
				t.text = text;
				t;
			case _:
				throw 'Unknown component $name';
		}
		if (attrs.x != null) obj.x = Std.parseInt(attrs.x);
		if (attrs.y != null) obj.y = Std.parseInt(attrs.y);
		return obj;	}

	
	@:abstract private function _createUI():DisplayObject;
	
	private function createUI():Void addChild(_createUI());
	
	private function createFilters(data:Dynamic<Dynamic<String>>):Void {}
}