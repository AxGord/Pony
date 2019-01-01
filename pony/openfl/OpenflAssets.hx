package pony.openfl;

import haxe.io.Bytes;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display.Loader;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.utils.ByteArray;
import pony.ui.AssetManager;
import openfl.net.URLLoaderDataFormat;

/**
 * OpenflAssets
 * @author meerfolk<meerfolk@gmail.com>
 */
class OpenflAssets {

	static var assets : Map<String, DisplayObject> = new Map<String, DisplayObject>();
	static var loader : Loader;
	
	static var loadCompleteHandler : Void -> Void;
	static var assetName : String;
	
	public static function load(asset:String, cb:Void->Void):Void {
		if (Assets.exists(asset)) {
			cb();
			return;
		}
		asset = AssetManager.baseUrl + asset;
		loadBytes(asset,function (b : ByteArray) {
			bytesToBitmapData(b, function(bd : BitmapData){
				assets.set(asset, new Bitmap(bd));
				cb();
			});
		});
	}
	
	public static function loadBytes(url:String, ok:ByteArray->Void, ?error:Dynamic->Void):Void {
		if (error == null) error = Tools.errorFunction;
		try {
			var loader = new URLLoader(new URLRequest(url));
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			var removeEvents:Void->Void = null;
			function errorHandler(e:IOErrorEvent):Void {
				removeEvents();
				error(e.text);
			}
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			function handler(e:Event):Void {
				//try {
					removeEvents();
					ok(loader.data);
				//} catch (e:Dynamic) error(e);
			}
			removeEvents = function() {
				loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.removeEventListener(Event.COMPLETE, handler);
			};
			
			loader.addEventListener(Event.COMPLETE, handler);
		} catch (e:Dynamic) error(e);
	}
	
	public static function bytesToBitmapData(bytes:ByteArray, ok:BitmapData->Void, ?error:Dynamic->Void):Void {
		if (error == null) error = Tools.errorFunction;
		try {
			var loader = new Loader();
			var removeEvents:Void->Void = null;
			function errorHandler(e:IOErrorEvent):Void {
				removeEvents();
				error(e.text);
			}
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			function handler(e:Event):Void {
				try {
					removeEvents();
					var src:BitmapData = new BitmapData(e.target.content.width, e.target.content.height);
					src.draw(e.target.content);
					ok(src);
				} catch (e:Dynamic) error(e);
			}
			removeEvents = function() {
				loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
			};
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler);
			loader.loadBytes(bytes);
		} catch (e:Dynamic) error(e);
	}
	
	public static function image(asset : String) : Bitmap {
		if (Assets.exists(asset)) {
			try {
				return cast (new Bitmap(Assets.getBitmapData(asset)), Bitmap);
			} catch (e : Error) {
				return null;
			}
		}
		asset = AssetManager.baseUrl + asset;
		if (assets.exists(asset)) {
			try {
				return cast (assets.get(asset), Bitmap);
			} catch (e : Error) {
				return null;
			}
		} else {
			return null;
		}
	}
	
	/*public static function image(asset:String, ?name:String):Sprite {
		return name == null ? Sprite.fromImage(AssetManager.baseUrl+asset) : Sprite.fromFrame(name);
	}
	
	public static function texture(asset:String, ?name:String):Texture {
		return name == null ? Texture.fromImage(AssetManager.baseUrl+asset) : Texture.fromFrame(name);
	}
	
	public static function cImage(asset:String, useSpriteSheet:Bool):Sprite {
		return useSpriteSheet ? Sprite.fromFrame(asset) : Sprite.fromImage(AssetManager.baseUrl + asset);
	}
	
	public static function cTexture(asset:String, useSpriteSheet:Bool):Texture {
		return useSpriteSheet ? Texture.fromFrame(asset) : Texture.fromImage(AssetManager.baseUrl + asset);
	}*/
	
}