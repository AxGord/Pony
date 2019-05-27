package pony.heaps;

import h2d.Bitmap;
import h2d.Tile;
import h2d.Anim;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import hxd.net.BinaryLoader;
import hxd.res.Any;
import hxd.res.Atlas;
import hxd.res.Loader;
import pony.Pair;
import pony.ui.AssetManager;
import pony.ui.gui.slices.SliceTools;

@:enum abstract Ext(String) to String {
	var ATLAS = 'atlas';
	var PNG = 'png';
	var JPG = 'jpg';
	var JPEG = 'jpeg';
}

@:enum abstract HAError(String) to String {
	var ERROR_NOT_SUPPORTED = 'Type not supported';
	var ERROR_NAME_NOT_SET = 'Name not set';
	var ERROR_NAME_SET = 'Name set';
	var ERROR_NOT_LOADED = 'Asset not loaded';
}

/**
 * HeapsAssets
 * @author AxGord <axgord@gmail.com>
 */
class HeapsAssets {

	private static var atlases:Map<String, Pair<Loader, Atlas>> = new Map();
	private static var tiles:Map<String, Tile> = new Map();

	public static function load(asset:String, cb:Int -> Int -> Void):Void {
		var realAsset:String = AssetManager.getPath(asset);
		var loader:BinaryLoader = new BinaryLoader(realAsset);
		switch ext(asset) {
			case ATLAS:
				loader.load();
				loader.onLoaded = function(textBytes:Bytes):Void {
					cb(1, 10);
					var path:String = realAsset.substr(0, realAsset.lastIndexOf('/') + 1);
					var imgFile:String = path + new BytesInput(textBytes).readLine();
					var imgLoader:BinaryLoader = new BinaryLoader(imgFile);
					imgLoader.load();
					imgLoader.onProgress = function(cur:Int, max:Int):Void if (cur != max) cb(Std.int(1 + cur / max * 9), 10);
					imgLoader.onLoaded = function(bytes:Bytes):Void {
						var img:Any = Any.fromBytes(imgFile, bytes);
						atlases[asset] = new Pair(
							@:privateAccess img.loader,
							Any.fromBytes(realAsset, textBytes).to(Atlas)
						);
						cb(10, 10);
					}
				}
			case PNG, JPG, JPEG:
				loader.load();
				loader.onProgress = function(cur:Int, max:Int):Void if (cur != max) cb(Std.int(cur / max * 10), 10);
				loader.onLoaded = function(bytes:Bytes):Void {
					tiles[asset] = Any.fromBytes(realAsset, bytes).toTile();
					cb(10, 10);
				}
			case _:
				throw ERROR_NOT_SUPPORTED;
		}
	}

	public static function ext(asset:String):String {
		return asset.substr(asset.lastIndexOf('.') + 1);
	}

	public static function reset(asset:String):Void {
		atlases.remove(asset);
	}

	public static function texture(asset:String, ?name:String):Tile {
		return switch ext(asset) {
			case ATLAS:
				if (name == null) throw ERROR_NAME_NOT_SET;
				var p:Pair<Loader, Atlas> = atlases[asset];
				if (p == null) throw ERROR_NOT_LOADED;
				Loader.currentInstance = p.a;
				p.b.get(name);
			case PNG, JPG, JPEG:
				if (name != null) throw ERROR_NAME_SET;
				if (!tiles.exists(asset)) throw ERROR_NOT_LOADED;
				tiles[asset];
			case _:
				throw ERROR_NOT_SUPPORTED;
		};
	}

	public static function image(asset:String, ?name:String):Bitmap {
		return new Bitmap(texture(asset, name));
	}

	public static function animation(asset:String, ?name:String):Array<Tile> {
		return switch ext(asset) {
			case ATLAS:
				if (name == null) throw ERROR_NAME_NOT_SET;
				var p:Pair<Loader, Atlas> = atlases[asset];
				if (p == null) throw ERROR_NOT_LOADED;
				Loader.currentInstance = p.a;
				p.b.getAnim(name);
			case PNG, JPG, JPEG:
				if (name != null) throw ERROR_NAME_SET;
				var assets:Array<String> = AssetManager.parseInterval(asset);
				if (assets.length == 1)
					assets = SliceTools.getNames(assets[0]);
				[for (e in assets) texture(e)];
			case _:
				throw ERROR_NOT_SUPPORTED;
		};
	}

	public static function clip(asset:String, ?name:String, ?speed:Float):Anim {
		return new Anim(animation(asset, name), speed);
	}

}
