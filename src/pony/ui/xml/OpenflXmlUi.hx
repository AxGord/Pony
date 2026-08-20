package pony.ui.xml;

import flash.text.TextFieldAutoSize;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.filters.BitmapFilter;
import openfl.filters.DropShadowFilter;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFormat;
import pony.geom.Align;
import pony.geom.Border;
import pony.magic.HasAbstract;
import pony.openfl.Button;
import pony.openfl.ui.AlignLayout;
import pony.openfl.ui.BaseLayout;
import pony.openfl.ui.IntervalLayout;
import pony.openfl.ui.RubberLayout;
import pony.openfl.ui.TLayout;
import pony.ui.AssetManager;
import pony.ui.gui.BaseLayoutCore;

using Std;
using StringTools;

/**
 * OpenflXmlUi
 * @author meerfolk<meerfolk@gmail.com>
 */
#if !macro
@:autoBuild(pony.ui.xml.XmlUiBuilder.build(pony.ui.AssetManager, {
	free: openfl.display.Sprite,
	image: openfl.display.Bitmap,
	layout: pony.openfl.ui.TLayout,
	ivlayout: pony.openfl.ui.IntervalLayout,
	ihlayout: pony.openfl.ui.IntervalLayout,
	text: openfl.text.TextField
}))
#end
#if (haxe_ver >= 4.2) abstract #end
class OpenflXmlUi extends Sprite implements HasAbstract {

	private final FILTERS: Map<String, BitmapFilter> = [];
	private var SCALE: Float = 1;
	private final tweens: TweenMap<Dynamic> = [];

	public function createUIElement(name: String, attrs: Dynamic<String>, content: Array<Dynamic>, textContent: String): Dynamic {
		final obj: DisplayObject = switch name {
			case 'free':
				final s = new Sprite();
				if (attrs.w != null && attrs.h != null) {
					s.graphics.clear();
					s.graphics.beginFill(0xFF0000, 0.2);
					s.graphics.drawRect(0, 0, attrs.w.parseFloat(), attrs.h.parseFloat());
					s.graphics.endFill();
				}
				for (e in content) if (e != null) s.addChild(e);
				s;
			case 'image':
				final b = AssetManager.image(attrs.src, name);
				b;
			case 'layout':
				final align = Align.fromString(attrs.align);
				if (attrs.iv != null) {
					final l = new IntervalLayout(Std.parseInt(attrs.iv), true, cast Border.fromString(attrs.border), align);
					for (e in content) l.add(e);
					l;
				} else if (attrs.ih != null) {
					final l = new IntervalLayout(Std.parseInt(attrs.ih), false, cast Border.fromString(attrs.border), align);
					for (e in content) l.add(e);
					l;
				} else if (attrs.w != null || attrs.h != null) {
					final r = new RubberLayout(
						Std.parseFloat(attrs.w), Std.parseFloat(attrs.h), isTrue(attrs.vert), cast Border.fromString(attrs.border),
						attrs.padding == null ? true : isTrue(attrs.padding), align
					);
					for (e in content) r.add(e);
					r;
				} else {
					final s = new AlignLayout(align);
					for (e in content) s.add(e);
					s;
				}
			/*case 'lbutton':
				var b = new LabelButton(splitAttr(attrs.skin), isTrue(attrs.vert), cast Border.fromString(attrs.border), true);
				for (c in content) b.add(c);
				b; */
			case 'button':
				new Button(splitAttr(attrs.skin));
			case 'text':
				if (attrs.color != null) {
					attrs.color = attrs.color.replace('#', '0x');
				}
				final format: TextFormat = new TextFormat(attrs.font, Std.parseInt(attrs.size), Std.parseInt(attrs.color));
				final t: TextField = new TextField();
				t.autoSize = TextFieldAutoSize.LEFT;
				t.selectable = false;
				t.defaultTextFormat = format;
				t.text = putData(textContent);
				t;
			case _:
				customUIElement(name, attrs, content);
		}
		if (attrs.r != null) {
			obj.rotation = Std.parseFloat(attrs.r) * Math.PI / 180;
		}
		if (attrs.alpha != null) {
			obj.alpha = Std.parseFloat(attrs.alpha);
		}
		if (attrs.scale != null) {
			final s = Std.parseFloat(attrs.scale);
			obj.scaleX = s;
			obj.scaleY = s;
		}
		if (attrs.filters != null) {
			obj.filters = [for (f in splitAttr(attrs.filters)) FILTERS[f]];
		}
		if (attrs.x != null) obj.x = Std.parseInt(attrs.x);
		if (attrs.y != null) obj.y = Std.parseInt(attrs.y);
		return obj;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function parseAndScaleWithNull(s: String): Float {
		return Std.parseFloat(s) * SCALE;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function parseAndScale(s: String): Float {
		return s == null ? 0 : parseAndScaleWithNull(s);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function parseAndScaleInt(s: String): Int {
		return s == null ? 0 : Std.int(Std.parseInt(s) * SCALE);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function scaleBorderInt(s: String): Border<Int> return cast(Border.fromString(s) * SCALE);

	private function putData(c: String): String return c;

	private function customUIElement(name: String, attrs: Dynamic<String>, content: Array<Dynamic>): Dynamic
		throw 'Unknown component $name';

	private static function splitAttr(s: String): Array<String> {
		return s.split(',').map(StringTools.trim).map(function(v) return v == '' ? null : v);
	}

	private static inline function isTrue(s: String): Bool return s != null && s.toLowerCase() == 'true';

	@:abstract private function _createUI(): DisplayObject;

	private function createUI(): Void {
		SCALE = 1;
		addChild(_createUI());
	}

	private function createFilters(data: Dynamic<Dynamic<String>>): Void {
		for (name in Reflect.fields(data)) {
			final d = Reflect.field(data, name);
			final f: BitmapFilter = switch Reflect.field(d, 'extends') {
				case 'shadow':
					new DropShadowFilter();
				case _:
					throw 'Unknown filter';
			}
			for (n in Reflect.fields(d)) if (n != 'extends') Reflect.setProperty(f, n, Std.parseFloat(Reflect.field(d, n)));
			FILTERS[name] = f;
		}
	}

}
