package pony.ui.xml;

import h2d.filter.Filter;
import h2d.filter.DropShadow;
import h2d.filter.Group;
import h2d.filter.Outline;
import h3d.Vector;
import h2d.Font;
import h2d.Object;
import h2d.Drawable;
import h2d.Graphics;
import h2d.Text;
import h2d.TextInput;
import hxd.res.DefaultFont;
import pony.magic.HasAbstract;
import pony.geom.Point;
import pony.geom.Border;
import pony.geom.Align;
import pony.geom.Rect;
import pony.color.UColor;
import pony.heaps.HeapsApp;
import pony.heaps.HeapsAssets;
import pony.heaps.ui.gui.Node;
import pony.heaps.ui.gui.NodeBitmap;
import pony.heaps.ui.gui.NodeRepeat;
import pony.heaps.ui.gui.NodeRect;
import pony.heaps.ui.gui.Button;
import pony.heaps.ui.gui.LightButton;
import pony.heaps.ui.gui.Switch;
import pony.heaps.ui.gui.Repeat;
import pony.heaps.ui.gui.DText;
import pony.heaps.ui.gui.slices.Slice;
import pony.heaps.ui.gui.layout.IntervalLayout;
import pony.heaps.ui.gui.layout.RubberLayout;
import pony.heaps.ui.gui.layout.AlignLayout;
import pony.heaps.ui.gui.layout.BGLayout;
import pony.heaps.ui.gui.layout.BaseLayout;
import pony.ui.xml.UiTags;
import pony.ui.xml.AttrVal;
import pony.ui.gui.BaseLayoutCore;

using StringTools;
using pony.text.TextTools;

/**
 * HeapsXmlUi
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.ui.xml.XmlUiBuilder.build(pony.ui.AssetManager, {
	node: h2d.Drawable,
	rect: pony.heaps.ui.gui.NodeRect,
	sw: pony.heaps.ui.gui.Switch,
	line: h2d.Graphics,
	circle: h2d.Graphics,
	text: pony.heaps.ui.gui.DText,
	input: h2d.TextInput,
	repeat: pony.heaps.ui.gui.Repeat,
	image: pony.heaps.ui.gui.NodeBitmap,
	layout: pony.heaps.ui.gui.layout.TLayout,
	button: pony.heaps.ui.gui.Button,
	lightButton: pony.heaps.ui.gui.LightButton
}))
#end
@:nullSafety(Strict) class HeapsXmlUi extends Object implements HasAbstract {

	private static inline var HALF: Float = 0.5;
	private static var fonts: Map<String, Font> = new Map();
	private static var DYNS: Array<AttrVal> = [dynX, dynY, dynWidth, dynHeight, dyn];

	private var _scale: Float = 1;
	@:nullSafety(Off) public var app(default, null): HeapsApp;
	private var watchList: Array<Pair<Object, Dynamic<String>>> = [];

	private function createUIElement(name: String, attrs: Dynamic<String>, content: Array<Dynamic>): Dynamic {
		if (attrs.reverse.isTrue()) content.reverse();
		var obj: Object = switch (name: UiTags) {
			case UiTags.repeat:
				new Repeat(this, content[0], attrs.count != null ? Std.parseInt(attrs.count) : 0);
			case UiTags.node:
				var s: Object = new Object();
				for (e in content) s.addChild(e);
				s;
			case UiTags.rect:
				var rect: NodeRect = new NodeRect(
					new Point<Float>(parseAndScale(attrs.w), parseAndScale(attrs.h)),
					parseLineStyle(attrs.line),
					attrs.color == null ? null : attrs.color,
					parseAndScale(attrs.round)
				);
				for (e in content) rect.addChild(e);
				rect;
			case UiTags.sw:
				return new Switch(cast content, attrs.def == null ? -1 : Std.parseInt(attrs.def));
			case UiTags.line:
				var color: UColor = attrs.color;
				var g: Graphics = new Graphics();
				g.lineStyle(parseAndScale(attrs.size), color.rgb, color.invertAlpha.af);
				g.moveTo(0, 0);
				g.lineTo(parseAndScale(attrs.w), parseAndScale(attrs.h));
				g;
			case UiTags.circle:
				var g: Graphics = new Graphics();
				if (attrs.line != null) {
					var a: Array<String> = attrs.line.split(' ');
					if (a[0].charAt(0) == '#') a.unshift(cast a.pop());
					var lsize: Float = parseAndScale(a[0]);
					var lcolor: UColor = a[1];
					g.lineStyle(lsize, lcolor.rgb, lcolor.invertAlpha.af);
				} else {
					g.lineStyle();
				}
				if (attrs.color != null) {
					var color: UColor = attrs.color;
					g.beginFill(color.rgb, color.invertAlpha.af);
				}
				g.drawCircle(0, 0, parseAndScale(attrs.r));
				g.endFill();
				g;
			case UiTags.image:
				Slice.create(
					HeapsAssets.animation(attrs.src, attrs.name),
					attrs.name == null ? attrs.src : attrs.name,
					attrs.repeat.isTrue()
				);
			case UiTags.layout:
				createLayout(attrs, content);
			case UiTags.text:
				createDText(attrs, content);
			case UiTags.simpleText:
				createText(attrs, content);
			case UiTags.input:
				createTextInput(attrs, content);
			case UiTags.button:
				var b: Button = new Button(cast content);
				if (attrs.disabled.isTrue()) b.core.disable();
				b;
			case UiTags.lightButton:
				var b: LightButton = new LightButton(getSizeFromAttrs(attrs), attrs.color);
				if (attrs.disabled.isTrue()) b.core.disable();
				b;
			case _:
				customUIElement(name, attrs, content);
		}
		if (Std.is(obj, Node)) setNodeAttrs(cast obj, attrs);
		if (attrs.x != null) obj.x = parseAndScale(attrs.x);
		if (attrs.y != null) obj.y = parseAndScale(attrs.y);
		if (attrs.visible.isFalse()) obj.visible = false;
		if (attrs.alpha != null) obj.alpha = Std.parseFloat(attrs.alpha);
		if (attrs.scale != null) {
			var a: Array<String> = attrs.scale.split(' ');
			if (a.length == 1) {
				obj.scale(Std.parseFloat(a[0]));
			} else {
				obj.scaleX = Std.parseFloat(a[0]);
				obj.scaleY = Std.parseFloat(a[1]);
			}
		}
		if (attrs.tint != null) {
			var c: UColor = attrs.tint;
			cast(obj, Drawable).color = Vector.fromColor(c.rgb);
		}
		addFilters(cast obj, attrs);
		setWatchers(obj, attrs);
		return obj;
	}

	private function parseLineStyle(attr: Null<String>): Null<Pair<UColor, Float>> {
		if (attr == null) return null;
		var a: Array<String> = StringTools.trim(attr).split(' ');
		var color: UColor = 0;
		var line: Float = 1;
		if (a[0].charAt(0) == '#') {
			color = a[0];
			if (a.length > 1) line = parseAndScaleWithoutNull(a[1]);
		} else {
			line = parseAndScaleWithoutNull(a[0]);
			if (a.length > 1) color = a[1];
		}
		return new Pair(color, line);
	}

	private function getWhPoint(v: String): Point<Float> {
		v = StringTools.trim(v);
		return switch v {
			case AttrVal.stage:
				app.canvas.stageInitSize;
			case AttrVal.dyn:
				new Point(app.canvas.dynStage.width, app.canvas.dynStage.height);
			case _:
				var a: Array<Float> = v.split(' ').map(parseAndScaleWithoutNull);
				new Point(a[0], a.length == 1 ? a[0] : a[1]);
		}
	}

	private function getSizeFromAttrs(attrs: Dynamic<String>): Point<Float> {
		var p: Null<Point<Float>> = attrs.wh != null ? getWhPoint(attrs.wh) : 0;
		if (attrs.w != null)
			p.x = parseAndScaleWithoutNull(attrs.w);
		if (attrs.h != null)
			p.y = parseAndScaleWithoutNull(attrs.h);
		return p;
	}

	@:extern private inline function setNodeAttrs(node: Node, attrs: Dynamic<String>): Void {
		var w: Null<Float> = null;
		var h: Null<Float> = null;
		if (attrs.wh != null) {
			var p: Point<Float> = getWhPoint(attrs.wh);
			w = p.x;
			h = p.y;
		}
		if (attrs.w != null)
			w = parseAndScaleWithoutNull(attrs.w);
		if (attrs.h != null)
			h = parseAndScaleWithoutNull(attrs.h);
		if (w != null && h != null)
			node.wh = cast new Point(w, h);
		else if (w != null)
			node.w = w;
		else if (h != null)
			node.h = h;

		if (attrs.flipx.isTrue()) node.flipx = true;
		if (attrs.flipy.isTrue()) node.flipy = true;
	}

	@:extern private inline function createText(attrs: Dynamic<String>, content: Array<Dynamic>): Object {
		return createTextBase(new Text(getFont(attrs)), attrs, content);
	}

	@:extern private inline function createDText(attrs: Dynamic<String>, content: Array<Dynamic>): Object {
		var c: Null<String> = attrs.color;
		if (c != null) c = attrs.color.trim().allAfter(' ');
		var color: Null<UColor> = c == null ? null : UColor.fromString(c);
		return createTextBase(new DText(getFont(attrs), color, attrs.disabled.isTrue()), attrs, content);
	}

	@:extern private inline function createTextInput(attrs: Dynamic<String>, content: Array<Dynamic>): Object {
		return createTextBase(new TextInput(getFont(attrs)), attrs, content);
	}

	private function createTextBase(t: Text, attrs: Dynamic<String>, content: Array<Dynamic>): Object {
		t.maxWidth = parseAndScaleWithNull(attrs.maxWidth);
		t.lineSpacing = cast parseAndScaleWithNull(attrs.lineSpacing);
		t.letterSpacing = cast parseAndScaleWithNull(attrs.letterSpacing);
		if (attrs.color != null)
			t.textColor = UColor.fromString(attrs.color.allBefore(' ')).argb;
		if (attrs.align != null)
			t.textAlign = Align.createByName(TextTools.bigFirst(attrs.align));
		if (attrs.smooth.isTrue())
			t.smooth = true;
		else if (attrs.smooth.isFalse())
			t.smooth = false;
		t.text = textTransform(_putData(content), attrs.transform);
		return t;
	}

	@:extern private inline function addFilters(obj: Drawable, attrs: Dynamic<String>): Void {
		var filters: Array<Filter> = [];
		if (attrs.outline != null) {
			var out: String = StringTools.trim(attrs.outline);
			if (out.length > 0) {
				var a: Array<String> = out.split(' ');
				var color: UColor = 0;
				if (a[0].charAt(0) == '#')
					color = cast a.shift();
				else if (a[a.length - 1].charAt(0) == '#')
					color = cast a.pop();
				var d: Null<Int> = a.length > 0 ? Std.parseInt(cast a.pop()) : 4;
				filters.push(new Outline(d, color.rgb, 0.3));
			}
		}
		if (attrs.shadow != null) {
			var sh: String = StringTools.trim(attrs.shadow);
			if (sh.length > 0) {
				var a: Array<String> = sh.split(' ');
				var smooth: Bool = false;
				if (a.indexOf('smooth') != -1) {
					smooth = true;
					a.remove('smooth');
				}
				var color: UColor = 0;
				if (a[0].charAt(0) == '#')
					color = cast a.shift();
				else if (a[a.length - 1].charAt(0) == '#')
					color = cast a.pop();
				var d: Null<Int> = null;
				var angle: Float = 0;
				if (a.length > 0)
					d = Std.parseInt(cast a.pop());
				if (a.length > 0) {
					@:nullSafety(Off) angle = Std.parseInt(a.pop()) / 180 * Math.PI;
				} else {
					if (d == null) d = 4;
					angle = 0.785;
				}
				filters.push(new DropShadow(d, angle, color.rgb, color.invertAlpha.af, 1, color.invertAlpha.af, 0.1, smooth));
			}
		}
		if (filters.length > 0)
			obj.filter = filters.length > 1 ? new Group(filters) : filters[0];
	}

	@:extern private inline function createLayout(attrs: Dynamic<String>, content: Array<Dynamic>): Object {
		return if (attrs.src != null) {
			var l = new BGLayout(HeapsAssets.image(attrs.src, attrs.name), attrs.vert.isTrue(), scaleBorderInt(attrs.border));
			for (e in content) l.add(e);
			l;
		} else if (attrs.iv != null) {
			var l = new IntervalLayout(parseAndScaleInt(attrs.iv), true, scaleBorderInt(attrs.border), attrs.align);
			for (e in content) l.add(e);
			l;
		} else if (attrs.ih != null) {
			var l = new IntervalLayout(parseAndScaleInt(attrs.ih), false, scaleBorderInt(attrs.border), attrs.align);
			for (e in content) l.add(e);
			l;
		} else if (attrs.w != null || attrs.h != null) {
			var r = new RubberLayout(
				parseAndScale(attrs.w),
				parseAndScale(attrs.h),
				attrs.vert.isTrue(),
				scaleBorderInt(attrs.border),
				attrs.padding == null ? true : attrs.padding.isTrue(),
				attrs.align
			);
			for (e in content) r.add(e);
			r;
		} else if (attrs.wh != null) {
			var p: Point<Float> = getWhPoint(attrs.wh);
			var r: RubberLayout = new RubberLayout(
				p.x,
				p.y,
				attrs.vert.isTrue(),
				scaleBorderInt(attrs.border),
				attrs.padding == null ? true : attrs.padding.isTrue(),
				attrs.align
			);
			for (e in content) r.add(e);
			r;
		} else {
			var s: AlignLayout = new AlignLayout(attrs.align, scaleBorderInt(attrs.border));
			for (e in content) s.add(e);
			s;
		}
	}

	private static function textTransform(text: String, transform: String): String {
		return switch transform {
			case 'uppercase': text.toUpperCase();
			case 'lowercase': text.toLowerCase();
			case _: text;
		}
	}

	@:extern private inline function parseSizePointFloat(a: Dynamic<String>): Point<Float> {
		return new Point<Float>(parseAndScale(a.w), parseAndScale(a.h));
	}

	private inline function parseFloat(s: String): Float {
		return s == null ? 0 : Std.parseFloat(s);
	}

	private function parseAndScaleWithoutNull(s: String): Float {
		return switch s {
			case AttrVal.stageWidth:
				app.canvas.stageInitSize.x;
			case AttrVal.stageHeight:
				app.canvas.stageInitSize.y;
			case AttrVal.dynWidth:
				app.canvas.dynStage.width;
			case AttrVal.dynHeight:
				app.canvas.dynStage.height;
			case AttrVal.dynX:
				app.canvas.dynStage.x;
			case AttrVal.dynY:
				app.canvas.dynStage.y;
			case _:
				Std.parseFloat(s) * _scale;
		}
	}

	private inline function parseAndScale(s: String): Float {
		return s == null ? 0 : parseAndScaleWithoutNull(s);
	}

	private inline function parseAndScaleWithNull(s: String): Null<Float> {
		return s == null ? null : parseAndScaleWithoutNull(s);
	}

	private inline function parseAndScaleInt(s: String): Int {
		if (s == null) {
			return 0;
		} else {
			var v: Null<Int> = Std.parseInt(s);
			return v == null ? 0 : Std.int(v * _scale);
		}
	}

	@:extern private inline function scaleBorderInt(s: String): Border<Int> return cast (Border.fromString(s) * _scale);

	private function getFont(attrs: Dynamic<String>): Font {
		var name: String = attrs.src;
		var size: Int = parseAndScaleInt(attrs.size);
		var font: Null<Font> = null;
		if (name == null) {
			font = DefaultFont.get();
			if (size != 0) font = font.clone();
		} else {
			var cacheName: String = name;
			if (size != 0) cacheName += size;
			font = fonts[cacheName];
			if (font != null) return font;
			font = HeapsAssets.font(attrs.src);
			if (size != 0) font = font.clone();
			HeapsAssets.setFontType(font, attrs.type);
			fonts[cacheName] = font;
		}
		if (size != 0) font.resizeTo(size);
		return font;
	}

	private function _putData(content: Array<Dynamic>): String return putData(content.length > 0 ? content[0] : '');
	private function putData(c: String): String return c;
	private function customUIElement(name: String, attrs: Dynamic<String>, content: Array<Dynamic>): Dynamic throw 'Unknown component $name';

	private static function splitAttr(s: String): Array<Null<String>> {
		return s.split(',').map(splitAttrMapFn);
	}

	private static function splitAttrMapFn(s: String): Null<String> {
		s = StringTools.trim(s);
		return s == '' ? null : s;
	}

	@:abstract private function _createUI(): Object return null;

	public function createUI(?app: HeapsApp, scale: Float = 1): Void {
		if (this.app == null)
			this.app = app == null ? cast HeapsApp.instance : app;
		_scale = scale;
		addChild(_createUI());
		this.app.canvas.onDynStageResize << dynStageHandler;
	}

	private function createFilters(data: Dynamic<Dynamic<String>>): Void {}

	private function setWatchers(obj: Object, attrs: Dynamic<String>): Void {
		var na: Dynamic<String> = {};
		var founded: Bool = false;
		for (f in Reflect.fields(attrs)) {
			var a = StringTools.trim(Reflect.field(attrs, f));
			if (checkInDyns(a)) {
				Reflect.setField(na, f, a);
				founded = true;
			}
		}
		if (founded) {
			watchList.push(new Pair(obj, na));
		}
	}

	private static inline function checkInDyns(v: String): Bool return DYNS.indexOf(v) != -1;

	private function dynStageHandler(r: Rect<Float>): Void {
		watchList = watchList.filter(watchFilter);
		for (e in watchList) {
			for (f in Reflect.fields(e.b)) {
				var a = Reflect.field(e.b, f);
				switch a {
					case dyn:
						var p: Point<Float> = new Point(r.width, r.height);
						if (Std.is(e.a, BaseLayout)) {
							var o: BaseLayout<Dynamic> = cast e.a;
							o.wh = p;
						} else if (Std.is(e.a, Node)) {
							var o:Node = cast e.a;
							o.wh = p;
						} else {
							Reflect.setProperty(e.a, f, p);
						}
					case dynWidth:
						if (Std.is(e.a, BaseLayout)) {
							var o: BaseLayout<Dynamic> = cast e.a;
							o.w = r.width;
						} else {
							Reflect.setProperty(e.a, f, r.width);
						}
					case dynHeight:
						if (Std.is(e.a, BaseLayout)) {
							var o: BaseLayout<Dynamic> = cast e.a;
							o.h = r.height;
						} else {
							Reflect.setProperty(e.a, f, r.height);
						}
					case dynX:
						Reflect.setProperty(e.a, f, r.x);
					case dynY:
						Reflect.setProperty(e.a, f, r.y);
					case _:
				}

			}
		}
	}

	private function watchFilter(p: Pair<Object, Dynamic<String>>): Bool {
		return p.a.parent != null;
	}

}
