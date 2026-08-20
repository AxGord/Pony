package pony.pixi.ui;

import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;
import pixi.extras.BitmapText;
import pixi.filters.blur.BlurFilter;
import pony.geom.IWH;
import pony.geom.Point;

using StringTools;

/**
 * Text
 * @author AxGord <axgord@gmail.com>
 */
class BText extends Sprite implements IWH {

	private static inline final SHADOW_OFFSET: Int = 4;
	private static inline final NORMAL_OFFSET: Int = 4;
	private static inline final WHITE: UInt = 0xFFFFFF;

	private static var blurFilter: BlurFilter;

	public var t(default, set): String;
	public var style(default, null): BitmapTextStyle;
	public var color(default, set): UInt;

	public var size(get, never): Point<Float>;

	private final defColor: UInt;
	private final app: App;

	private var shadow: Bool = false;
	private var _size: Point<Float>;
	private var ansi: String;
	private var renderTexture: RenderTexture;
	private var renderSprite: Sprite;
	private var lastGeneratedSize: Point<Float>;

	public function new(text: String, ?style: BitmapTextStyle, ?ansi: String, shadow: Bool = false, ?app: App) {
		super();
		color = style.tint;
		this.style = { font: style.font, align: style.align, tint: WHITE };
		this.ansi = ansi;
		this.app = app == null ? App.main : app;
		this.shadow = this.app.isWebGL ? shadow : false;
		defColor = color;
		t = text;
	}

	private function get_size(): Point<Float> return _size;

	public function set_t(s: String): String {
		if (t == s) return s;
		if (s == null || s == '') {
			destroyIfExists();
			t = '';
			return s;
		}
		t = s;
		s = s.replace('\\n', '\n');
		var current: BTextLow = new BTextLow(s, style, ansi, true);
		if (current.size.x == 0 || current.size.y == 0) {
			destroyIfExists();
			current.destroy();
			current = null;
			return s;
		}
		final changeTexture: Bool = !app.isWebGL || _size == null || current.size.x > _size.x || current.size.y > _size.y;
		// !app.isWebGL force create new texture, coz prev can'n be cleaned on some devices
		var createSize: Point<Float> = null;
		if (changeTexture) {
			destroyIfExists();
			_size = createSize = current.size;
			renderTexture = createTexture(createSize);
		} else {
			removeChild(renderSprite);
			renderSprite.destroy();
			createSize = lastGeneratedSize;
			_size = current.size;
		}
		if (shadow) {
			current.x += SHADOW_OFFSET;
			current.y += SHADOW_OFFSET;
		} else {
			current.x += NORMAL_OFFSET;
			current.y += NORMAL_OFFSET;
		}
		app.app.renderer.render(current, renderTexture, !changeTexture);
		current.destroy();
		current = null;
		renderSprite = new Sprite(renderTexture);
		if (shadow) {
			renderSprite.tint = 0;
			renderSprite.filters = [blurFilter];

			final shadowRenderTexture: RenderTexture = createTexture(createSize);
			app.app.renderer.render(renderSprite, shadowRenderTexture, false);
			app.app.renderer.render(renderSprite, shadowRenderTexture, false);
			app.app.renderer.render(renderSprite, shadowRenderTexture, false);

			renderSprite.tint = WHITE;
			renderSprite.filters = null;

			app.app.renderer.render(renderSprite, shadowRenderTexture, false);

			renderSprite.destroy(true);
			renderTexture.destroy(true);

			renderTexture = shadowRenderTexture;
			renderSprite = new Sprite(renderTexture);
			renderSprite.x -= SHADOW_OFFSET;
			renderSprite.y -= SHADOW_OFFSET;
		} else {
			renderSprite.x -= NORMAL_OFFSET;
			renderSprite.y -= NORMAL_OFFSET;
		}
		renderSprite.tint = color;
		addChild(renderSprite);
		return s;
	}

	private function set_color(v: Null<UInt>): Null<UInt> {
		if (v == null) v = defColor;
		if (color != v) {
			color = v;
			if (renderSprite != null) renderSprite.tint = v;
		}
		return v;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function safeSet(s: String): Void {
		t = s.replace(' ', '').length == 0 ? null : s;
	}

	public function wait(cb: Void -> Void): Void cb();

	override public function destroy(?options: haxe.extern.EitherType<Bool, DestroyOptions>): Void {
		destroyIfExists();
		ansi = null;
		style = null;
		super.destroy(options);
	}

	public function destroyIWH(): Void destroy();

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function createTexture(size: Point<Float>): RenderTexture {
		lastGeneratedSize = size;
		final b: Int = shadow ? SHADOW_OFFSET * 2 : NORMAL_OFFSET * 2;
		return RenderTexture.create(Math.ceil(size.x) + b, Math.ceil(size.y) + b);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function destroyIfExists(): Void {
		if (renderSprite == null) return;
		_size = null;
		removeChild(renderSprite);
		renderSprite.destroy(true);
		renderSprite = null;
		renderTexture.destroy(true);
		renderTexture = null;
	}

	private static function __init__(): Void {
		blurFilter = new BlurFilter();
		blurFilter.blur = 2;
		blurFilter.passes = 1;
		blurFilter.resolution = 0.5;
	}

}
