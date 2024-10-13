package pony.pixi;

import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.core.text.TextStyle;
import pixi.core.textures.Texture;
import pixi.extras.BitmapText;
import pixi.filters.blur.BlurFilter;
import pixi.filters.colormatrix.ColorMatrixFilter;

import pony.geom.Rect;

/**
 * PixijsExtends
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
class PixiExtends {

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function loaded(s: Sprite, f: Void -> Void): Void {
		PixiExtendsTexture.loaded(s.texture, f);
	}

	public static function loadedList(a: Array<Sprite>, f: Void -> Void): Void {
		var i = a.length;
		if (i == 0)
			f();
		else
			for (s in a) loaded(s, function() if (--i == 0) f());
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function darkness(c: ColorMatrixFilter, v: Float): Void {
		c.matrix = [v, 0, 0, 0, 0, 0, v, 0, 0, 0, 0, 0, v, 0, 0, 1];
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function darknessFilter(v: Float): ColorMatrixFilter {
		var c = new ColorMatrixFilter();
		darkness(c, v);
		return c;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function brightnessFilter(v: Float): ColorMatrixFilter {
		var c = new ColorMatrixFilter();
		c.brightness(v, true);
		return c;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function blurFilter(): BlurFilter {
		var b = new BlurFilter();
		b.passes = 3;
		return b;
	}

	public static function childLevel(s: Sprite, lvl: Int): Sprite {
		for (_ in 0...lvl) s = cast s.getChildAt(0);
		return s;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function flipX(o: Sprite): Void o.scale.x = -o.scale.x;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function flipY(o: Sprite): Void o.scale.y = -o.scale.y;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function flipXpos(o: Sprite): Void o.x += o.width;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function flipYpos(o: Sprite): Void o.y += o.height;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function setFilterArea(o: Sprite, size: Float): Void {
		setFilterAreaXY(o, size, size);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function setFilterAreaXY(o: Sprite, sx: Float, sy: Float): Void {
		var p = o.toGlobal(new Point());
		o.filterArea = new Rectangle(p.x - sx, p.y - sy, o.width + sx * 2, o.height + sy * 2);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function getPonyRect(o: Container): Rect<Float> {
		return { x: o.x, y: o.y, width: o.width, height: o.height };
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function pivotCenter(s: Container): Void {
		s.pivot.set(s.width / 2, s.height / 2);
	}

}

/**
 * PixijsExtendsTexture
 * @author AxGord <axgord@gmail.com>
 */
class PixiExtendsTexture {

	public static function loaded(t: Texture, f: Void -> Void): Void {
		if (t.baseTexture.hasLoaded)
			f();
		else
			t.baseTexture.once('loaded', function(_) f());
	}

}

/**
 * PixijsExtendsText
 * @author AxGord <axgord@gmail.com>
 */
class PixiExtendsText {

	public static function glow(t: Text, blur: Int = 10, ?color: Null<UInt>): Text {
		var f = new BlurFilter();
		f.blur = blur;
		var s = Reflect.copy(t.style);
		if (color != null) s.fill = color;
		var ct = new Text(t.text, s);
		ct.x = t.x;
		ct.y = t.y;
		ct.filters = [f];
		return ct;
	}

}

/**
 * PixijsExtendsBitmapText
 * @author AxGord <axgord@gmail.com>
 */
class PixiExtendsBitmapText {

	public static function glow(t: BitmapText, style: BitmapTextStyle, blur: Int = 10, ?color: Null<UInt>): BitmapText {
		var f = new BlurFilter();
		f.blur = blur;
		var s: BitmapTextStyle = Reflect.copy(style);
		if (color != null) s.tint = color;
		var ct = new BitmapText(t.text, s);
		ct.x = t.x;
		ct.y = t.y;
		ct.filters = [f];
		return ct;
	}

}