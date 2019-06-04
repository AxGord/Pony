package pony.ui.xml;

import h2d.Scene;
import h2d.Object;
import h2d.Drawable;
import h2d.Graphics;
import h2d.Text;
import pony.magic.HasAbstract;
import pony.geom.Point;
import pony.geom.Border;
import pony.geom.Align;
import pony.color.UColor;
import pony.heaps.HeapsApp;
import pony.heaps.HeapsAssets;
import pony.heaps.ui.gui.Node;
import pony.heaps.ui.gui.NodeBitmap;
import pony.heaps.ui.gui.NodeRepeat;
import pony.heaps.ui.gui.slices.Slice;
import pony.heaps.ui.gui.layout.IntervalLayout;
import pony.heaps.ui.gui.layout.RubberLayout;
import pony.heaps.ui.gui.layout.AlignLayout;
import pony.heaps.ui.gui.layout.BGLayout;
import pony.ui.xml.UiTags;

using pony.text.TextTools;

/**
 * HeapsXmlUi
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.ui.xml.XmlUiBuilder.build({
	node: h2d.Drawable,
	rect: h2d.Graphics,
	line: h2d.Graphics,
	circle: h2d.Graphics,
	text: h2d.Text,
	image: pony.heaps.ui.gui.NodeBitmap,
	tile: pony.heaps.ui.gui.NodeRepeat,
	slice: pony.heaps.ui.gui.Node,
	layout: pony.heaps.ui.gui.layout.TLayout
}))
#end
class HeapsXmlUi extends Scene implements HasAbstract {
	
	private var SCALE:Float = 1;
	public var app(default, null):HeapsApp;
	
	private function createUIElement(name:String, attrs:Dynamic<String>, content:Array<Dynamic>):Dynamic {
		if (attrs.reverse.isTrue()) content.reverse();
		var obj:Object = switch name {
			case UiTags.node:
				var s:Object = new Object();
				for (e in content) s.addChild(e);
				s;
			case UiTags.rect:
				var color:UColor = UColor.fromString(attrs.color);
				var g:Graphics = new Graphics();
				g.beginFill(color.rgb, color.invertAlpha.af);
				if (attrs.round == null)
					g.drawRect(0, 0, parseAndScale(attrs.w), parseAndScale(attrs.h));
				else
					g.drawRoundedRect(0, 0, parseAndScale(attrs.w), parseAndScale(attrs.h), parseAndScaleInt(attrs.round));
				g.endFill();
				g;
			case UiTags.line:
				var color:UColor = UColor.fromString(attrs.color);
				var g:Graphics = new Graphics();
				g.lineStyle(parseAndScale(attrs.size), color.rgb, color.invertAlpha.af);
				g.moveTo(0, 0);
				g.lineTo(parseAndScale(attrs.w), parseAndScale(attrs.h));
				g;
			case UiTags.circle:
				var g = new Graphics();
				if (attrs.line != null) {
					var a = attrs.line.split(' ');
					if (a[0].charAt(0) == '#') a.unshift(a.pop());
					var lsize:Float = parseAndScale(a[0]);
					var lcolor = UColor.fromString(a[1]);
					g.lineStyle(lsize, lcolor.rgb, lcolor.invertAlpha.af);
				} else {
					g.lineStyle();
				}
				if (attrs.color != null) {
					var color = UColor.fromString(attrs.color);
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
				// new Text(HeapsAssets.font(attrs.src));
				throw 'todo';
			case _:
				customUIElement(name, attrs, content);
		}
		if (Std.is(obj, Node)) {
			var node:Node = cast obj;
			var w:Float = null;
			var h:Float = null;
			if (attrs.wh != null) {
				var a:Array<Float> = StringTools.trim(attrs.wh).split(' ').map(parseAndScaleWithoutNull);
				w = a[0];
				h = a.length == 1 ? a[0] : a[1];
			}
			if (attrs.w != null)
				w = parseAndScaleWithoutNull(attrs.w);
			if (attrs.h != null)
				h = parseAndScaleWithoutNull(attrs.h);
			if (w != null && h != null)
				node.wh = new Point(w, h);
			else if (w != null)
				node.w = w;
			else if (h != null)
				node.h = h;
			
			if (attrs.flipx.isTrue()) node.flipx = true;
			if (attrs.flipy.isTrue()) node.flipy = true;
		
		}
		if (attrs.x != null) obj.x = parseAndScale(attrs.x);
		if (attrs.y != null) obj.y = parseAndScale(attrs.y);
		if (attrs.visible.isFalse()) obj.visible = false;
		return obj;
	}

	@:extern private inline function createLayout(attrs:Dynamic<String>, content:Array<Dynamic>):Object {
		var align = Align.fromString(attrs.align);
		return if (attrs.src != null) {
			var l = new BGLayout(HeapsAssets.image(attrs.src, attrs.name), attrs.vert.isTrue(), scaleBorderInt(attrs.border));
			for (e in content) l.add(e);
			l;
		} else if (attrs.iv != null) {
			var l = new IntervalLayout(parseAndScaleInt(attrs.iv), true, scaleBorderInt(attrs.border), align);
			for (e in content) l.add(e);
			l;
		} else if (attrs.ih != null) {
			var l = new IntervalLayout(parseAndScaleInt(attrs.iv), false, scaleBorderInt(attrs.border), align);
			for (e in content) l.add(e);
			l;
		} else if (attrs.w != null || attrs.h != null) {
			var r = new RubberLayout(
				parseAndScale(attrs.w),
				parseAndScale(attrs.h),
				attrs.vert.isTrue(),
				scaleBorderInt(attrs.border),
				attrs.padding == null ? true : attrs.padding.isTrue(),
				align
			);
			for (e in content) r.add(e);
			r;
		} else {
			var s = new AlignLayout(align, scaleBorderInt(attrs.border));
			for (e in content) s.add(e);
			s;
		}
	}

	@:extern private inline function parseSizePointFloat(a:Dynamic<String>):Point<Float> {
		return new Point<Float>(parseAndScale(a.w), parseAndScale(a.h));
	}
	
	private inline function parseFloat(s:String):Float {
		return s == null ? 0 : Std.parseFloat(s);
	}

	private inline function parseAndScaleWithoutNull(s:String):Float {
		return Std.parseFloat(s) * SCALE;
	}
	
	private inline function parseAndScale(s:String):Float {
		return s == null ? 0 : parseAndScaleWithoutNull(s);
	}
	
	inline function parseAndScaleInt(s:String):Int {
		return s == null ? 0 : Std.int(Std.parseInt(s) * SCALE);
	}
	
	@:extern private inline function scaleBorderInt(s:String):Border<Int> return cast (Border.fromString(s) * SCALE);

	private function _putData(content:Array<Dynamic>):String return putData(content.length > 0 ? content[0] : '');
	private function putData(c:String):String return c;
	private function customUIElement(name:String, attrs:Dynamic<String>, content:Array<Dynamic>):Dynamic throw 'Unknown component $name';
	
	private static function splitAttr(s:String):Array<String> {
		return s.split(',').map(StringTools.trim).map(function(v):String return v == '' ? null : v);
	}
	
	/* @:abstract  */private function _createUI():Object return null;
	
	private function createUI(?app:HeapsApp, scale:Float = 1):Void {
		if (this.app == null)
			this.app = app == null ? HeapsApp.instance : app;
		SCALE = scale;
		addChild(_createUI());
	}

	private function createFilters(data:Dynamic<Dynamic<String>>):Void {}

}
