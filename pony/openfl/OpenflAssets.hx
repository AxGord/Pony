package pony.openfl;

import haxe.io.Bytes;
import lime.net.URLRequest;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display.Loader;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.system.LoaderContext;
import pony.ui.AssetManager;

/**
 * 
 * @author meerfolk<meerfolk@gmail.com>
 */
class OpenflAssets {

	static var assets : Map<String, DisplayObject> = new Map<String, DisplayObject>();
	static var loader : Loader;
	
	static var loadCompleteHandler : Void -> Void;
	static var assetName : String;
	
	public static function load(asset:String, cb:Void->Void):Void {
		pony.flash.FLTools.loadBytes(AssetManager.baseUrl + asset, function (b : Bytes) {
			pony.flash.FLTools.bytesToBitmapData(b, function(bd : BitmapData){
				assets.set(asset, new Bitmap(bd));
				cb();
			});
		});
	}
	
	public static function image(asset : String) : Bitmap {
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