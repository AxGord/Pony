package pony.pixi.ui;

import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;
import pixi.extras.BitmapText;
import pixi.filters.blur.BlurFilter;
import pony.geom.IWH;
import pony.geom.Point;
import pony.text.TextTools;
import pony.time.DeltaTime;

/**
 * Text
 * @author AxGord <axgord@gmail.com>
 */
class BText extends Sprite implements IWH {

	private static var blurFilter:BlurFilter;
	private static inline var SHADOW_OFFSET:Int = 4;
	private static inline var NORMAL_OFFSET:Int = 4;
	private static inline var WHITE:UInt = 0xFFFFFF;
	
	private static function __init__():Void {
		blurFilter = new BlurFilter();
		blurFilter.blur = 2;
		blurFilter.passes = 1;
		blurFilter.resolution = 0.5;
	}
	
	public var t(default, set):String;
	public var size(get, never):Point<Float>;
	private var _size:Point<Float>;
	private var ansi:String;
	public var style(default, null):BitmapTextStyle;
	public var color(default, set):UInt;
	private var defColor:UInt;
	private var renderTexture:RenderTexture;
	private var renderSprite:Sprite;
	private var shadow:Bool = false;
	private var app:App;
	private var lastGeneratedSize:Point<Float>;
	
	public function new(text:String, ?style:BitmapTextStyle, ?ansi:String, shadow:Bool = false, ?app:App) {
		super();
		color = style.tint;
		this.style = {font: style.font, align: style.align, tint: WHITE};
		this.ansi = ansi;
		this.app = app == null ? App.main : app;
		this.shadow = this.app.isWebGL ? shadow : false;
		defColor = color;
		t = text;
	}
	
	private function get_size():Point<Float> return _size;
	
	public function wait(cb:Void -> Void):Void cb();
	
	@:extern public inline function safeSet(s:String):Void {
		t = StringTools.replace(s, ' ', '').length == 0 ? null : s;
	}
	
	public function set_t(s:String):String {
		if (t == s) return s;
		if (s == null || s == '') {
			destroyIfExists();
			return s;
		}
		t = s;
		s = StringTools.replace(s, '\\n', '\n');
		var current:BTextLow = new BTextLow(s, style, ansi, true);
		if (current.size.x == 0 || current.size.y == 0) {
			destroyIfExists();
			current.destroy();
			current = null;
			return s;
		}
		var changeTexture:Bool = !app.isWebGL || _size == null || current.size.x > _size.x || current.size.y > _size.y;
		// !app.isWebGL force create new texture, coz prev can'n be cleaned on some devices
		var createSize:Point<Float> = null;
		if (changeTexture) {
			destroyIfExists();
			_size = createSize = current.size;
			renderTexture = createTexture(createSize);
		} else {
			removeChild(renderSprite);
			renderSprite.destroy();
			var b:Int = shadow ? SHADOW_OFFSET * 2 : NORMAL_OFFSET * 2;
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

			var shadowRenderTexture:RenderTexture = createTexture(createSize);
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

	@:extern private inline function createTexture(size:Point<Float>):RenderTexture {
		lastGeneratedSize = size;
		var b:Int = shadow ? SHADOW_OFFSET * 2 : NORMAL_OFFSET * 2;
		return RenderTexture.create(Math.ceil(size.x) + b, Math.ceil(size.y) + b);
	}
	
	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		destroyIfExists();
		ansi = null;
		style = null;
		super.destroy(options);
	}
	
	@:extern private inline function destroyIfExists():Void {
		if (renderSprite != null) {
			_size = null;
			removeChild(renderSprite);
			renderSprite.destroy(true);
			renderSprite = null;
			renderTexture.destroy(true);
			renderTexture = null;
		}
	}
	
	private function set_color(v:Null<UInt>):Null<UInt> {
		if (v == null) v = defColor;
		if (color != v) {
			color = v;
			if (renderSprite != null)
				renderSprite.tint = v;
		}
		return v;
	}
	
	public function destroyIWH():Void destroy();
	
}