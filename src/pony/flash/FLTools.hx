package pony.flash;

#if !macro
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.display.LoaderInfo;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.display.DisplayObjectContainer;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.IOErrorEvent;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.geom.ColorTransform;
import flash.system.Capabilities;
import pony.events.Signal0;
import pony.time.DeltaTime;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.Timer;
#else
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
#end

using pony.Tools;

/**
 * Flash tools
 * @author AxGord
 */
class FLTools {

	#if !macro

	public static var os(get, null): String;
	public static var version(get, null): Array<Int>;
	public static var width: Float = -1;
	public static var height: Float = -1;

	public static inline function registerClassAlias<T>(cl: Class<T>): Void {
		untyped __global__['flash.net.registerClassAlias'](Type.getClassName(cl), cl);
	}

	private static inline function get_os(): String return Capabilities.version.split(' ')[0];
	private static inline function get_version(): Array<Int> return Capabilities.version.split(' ')[1].split(',').map(Std.parseInt);

	public static inline function getRect(o: DisplayObject): Rectangle return new Rectangle(o.x, o.y, o.width, o.height);

	public static inline function setRectP(o: DisplayObject, r: Rectangle): Void {
		o.x = r.x;
		o.y = r.y;
		setSize(o, r.width, r.height);
	}

	/**
	 * Вписывает объект внутрь прямоугольника, сохраняя пропорции. Размещает по центру.
	 */
	public static function setSize(o: DisplayObject, w: Float, h: Float): Void {
		var d1: Float = w / h;
		var d2: Float = o.width / o.height;
		if (d1 < d2) {
			o.width = w;
			o.scaleY = o.scaleX;
		} else if (d1 > d2) {
			o.height = h;
			o.scaleX = o.scaleY;
		} else {
			o.width = w;
			o.height = h;
		}
		o.x = (w - o.width) / 2;
		o.y = (h - o.height) / 2;
	}

	public static inline function setRect(o: DisplayObject, rect: Rectangle): Void {
		o.x = rect.x;
		o.y = rect.y;
		o.width = rect.width;
		o.height = rect.height;
	}

	public static function getStage(cb: Stage -> Void): Timer {
		if (Lib.current != null && Lib.current.stage != null) {
			cb(Lib.current.stage);
			return null;
		} else {
			var timer: Timer = new Timer(100);
			timer.run = function() {
				if (Lib.current != null && Lib.current.stage != null) {
					timer.stop();
					cb(Lib.current.stage);
				}
			}
			return timer;
		}
	}

	#if !openfl

	//SmartFit
	//private static var _rect:Rectangle;
	private static var _target: MovieClip;
	private static var _shape: Shape;
	private static var _inited: Void -> Void;

	public static function smartFit(m: MovieClip, ?inited:Void -> Void): Void {
		_target = m;
		_inited = inited;
		m.stage.scaleMode = StageScaleMode.NO_SCALE;
		m.stage.align = StageAlign.TOP_LEFT;
		//updateSize();
		//m.stage.addEventListener(Event.RESIZE, updateSize);
		m.stage.addEventListener(Event.FRAME_CONSTRUCTED, firstResize);
	}

	private static function firstResize(_): Void {
		if (_target.stage.stageWidth == 0) return;
		_target.stage.removeEventListener(Event.FRAME_CONSTRUCTED, firstResize);
		_shape = new Shape();
		if (height != -1)
			_shape.graphics.drawRect(0, 0, width, height);
		else
			_shape.graphics.drawRect(0, 0, _target.stage.stageHeight, _target.stage.stageWidth);
		//untyped _target.d.text = _target.stage.stageWidth + 'x' + _target.stage.stageHeight;
		//_rect = _target.getRect(_target.stage);
		_target.stage.addEventListener(Event.RESIZE, updateSize);
		//updateSize();
		if (_inited != null) _inited();
	}

	public static function updateSize(?_): Void {
		// var objs:List<DisplayObject> = new List<DisplayObject>();
		// for (i in 0..._target.numChildren) {
		// 	objs.push(_target.getChildAt(0));
		// 	_target.removeChildAt(0);
		// }
		var chs: Array<Rectangle> = [];
		//var zr:Rectangle = new Rectangle(1, 1);
		for (i in 0..._target.numChildren) {
			var ch: DisplayObject = _target.getChildAt(i);
			chs.push(getRect(ch));
			ch.x = ch.y = 1;
			ch.width = ch.height = 0;
			//setRect(ch, zr);
		}
		_target.addChild(_shape);
		//untyped _target.d.text = _target.stage.stageWidth + 'x' + _target.stage.stageHeight;
		setRectP(_target, new Rectangle(0, 0, _target.stage.stageWidth, _target.stage.stageHeight));
		_target.removeChild(_shape);

		for (i in 0..._target.numChildren) {
			var ch: DisplayObject = _target.getChildAt(i);
			setRect(ch, chs[i]);
		}
		//for (o in objs) _target.addChild(o);
	}

	#end

	public static function recursiveCompare(o: DisplayObjectContainer, t: Dynamic): Bool {
		if (o == t) return true;
		for (i in 0...o.numChildren)
			if (
				#if (haxe_ver >= 4.10)
				Std.isOfType(o.getChildAt(i), DisplayObjectContainer)
				#else
				Std.is(o.getChildAt(i), DisplayObjectContainer)
				#end
				&& recursiveCompare(cast(o.getChildAt(i), DisplayObjectContainer), t)
			)
				return true;
		return false;
	}

	public static function childrens(d: DisplayObjectContainer): Iterator<DisplayObject> {
		var it: IntIterator = 0...d.numChildren;
		return {
			hasNext: it.hasNext,
			next: function(): DisplayObject return d.getChildAt(it.next())
		};
	}

	public static function brightness(v: Int): ColorTransform {
		var t = new ColorTransform();
		t.with (greenOffset = v, redOffset = v, blueOffset = v);
		return t;
	}

	public static inline function setTrace(): Void haxe.Log.trace = myTrace;

	private static function myTrace( v : Dynamic, ?pos : haxe.PosInfos): Void {
		untyped __global__['trace'](pos.className + '#' + pos.methodName + '(' + pos.lineNumber + '):', v);
	}

	public static function makeBigBorders(color: Int = 0x666666): Void {
		var size: Float = 100000;
		var sprite: Sprite = new Sprite();
		sprite.graphics.beginFill(color);
		sprite.graphics.drawRect(-size, -size, size * 2 + width, size);
		sprite.graphics.drawRect(-size, 0, size, width + size);
		sprite.graphics.drawRect(width, 0, size, width + size);
		sprite.graphics.drawRect(0, height, width, height + size);
		sprite.graphics.endFill();
		Lib.current.stage.addChild(sprite);
	}

	public static function reverseChildren(container: DisplayObjectContainer): Void {
		var children: Array<DisplayObject> = [for (i in 0...container.numChildren) container.getChildAt(i)];
		container.removeChildren();
		for (i in 0...children.length)
			container.addChild(children[children.length - i - 1]);
	}
	#end

	macro public static function includeAS(dir: String): Expr {
		var from = Tools.currentDir();
		asCopy('HaxeInit', from, dir);
		asCopy('ExtendedMovieClip', from, dir);
		return macro null;
	}

	#if macro

	private static function asCopy(file: String, from: String, to: String): Void {
		file = '/' + file + '.as';
		if (!FileSystem.exists(to + file))
			File.copy(from + file, to + file);
	}

	#else

	public static function base64ToBitmapDataAsync(base64: String, ok: BitmapData -> Void, ?error: Dynamic -> Void): Void {
		if (error == null) error = Tools.errorFunction;
		base64 = {
			var s = base64.split(',');
			s.length == 1 ? s[0] : s[1];
		}; //Remove header
		try {
			bytesToBitmapData(Base64.decode(base64), ok, error);
		} catch (e: Dynamic) error(e);
	}

	public static function bytesToBitmapData(bytes: Bytes, ok: BitmapData -> Void, ?error: Dynamic -> Void): Void {
		if (error == null) error = Tools.errorFunction;
		try {
			var loader = new Loader();
			var removeEvents: Void -> Void = null;
			function errorHandler(e: IOErrorEvent): Void {
				removeEvents();
				error(e.text);
			}
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			function handler(e: Event): Void {
				try {
					removeEvents();
					var src: BitmapData = new BitmapData(Std.int(loader.content.width), Std.int(loader.content.height));
					src.draw(loader.content);
					ok(src);
				} catch (e: Dynamic) error(e);
			}
			removeEvents = function() {
				loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
			};
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler);
			loader.loadBytes(bytes.getData());
		} catch (e: Dynamic) error(e);
	}

	public static inline function bytesDataToBase64(data: BytesData): String return Base64.encode(Bytes.ofData(data));
	public static inline function bitmapDataToBase64(data: BitmapData): String return bytesDataToBase64(data.getPixels(data.rect));

	public static function loadText(url: String, ok: String -> Void, ?error: Dynamic -> Void): Void {
		if (error == null) error = Tools.errorFunction;
		try {
			var loader = new URLLoader(new URLRequest(url));
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			var removeEvents: Void -> Void = null;
			function errorHandler(e: IOErrorEvent): Void {
				removeEvents();
				error(e.text);
			}
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			function handler(e: Event): Void {
				try {
					removeEvents();
					ok(loader.data);
				} catch (e: Dynamic) error(e);
			}
			removeEvents = function() {
				loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.removeEventListener(Event.COMPLETE, handler);
			};

			loader.addEventListener(Event.COMPLETE, handler);
		} catch (e: Dynamic) error(e);
	}

	public static function loadBytes(url: String, ok: Bytes -> Void, ?error: Dynamic -> Void): Void {
		if (error == null) error = Tools.errorFunction;
		try {
			var loader = new URLLoader(new URLRequest(url));
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			var removeEvents: Void -> Void = null;
			function errorHandler(e: IOErrorEvent): Void {
				removeEvents();
				error(e.text);
			}
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			function handler(e: Event): Void {
				//try {
					removeEvents();
					ok(Bytes.ofData(loader.data));
				//} catch (e:Dynamic) error(e);
			}
			removeEvents = function() {
				loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.removeEventListener(Event.COMPLETE, handler);
			};
			loader.addEventListener(Event.COMPLETE, handler);
		} catch (e: Dynamic) error(e);
	}

	#end

}