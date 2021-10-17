package pony.heaps;

import h2d.Anim;
import h2d.Bitmap;
import h2d.Font;
import h2d.Tile;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Timer;

import hxd.fmt.bfnt.FontParser;
import hxd.res.Any;
import hxd.res.Atlas;
import hxd.res.Loader;
import hxd.res.Sound;

import pony.Fast;
import pony.Pair;
import pony.Queue.Queue1;
import pony.time.DeltaTime;
import pony.ui.AssetManager;
import pony.ui.gui.slices.SliceTools;

@:enum abstract Ext(String) to String {
	var ATLAS = 'atlas';
	var PNG = 'png';
	var JPG = 'jpg';
	var JPEG = 'jpeg';
	var FNT = 'fnt';
	var TXT = 'txt';
	var CSS = 'css';
	var JSON = 'json';
	var CDB = 'cdb';
	var IMG = 'img';
	var BIN = 'bin';
	var LDTK = 'ldtk';
	var WAV = 'wav';
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
@:nullSafety(Strict) @:final class HeapsAssets {

	private static inline var SDF_ALPHA: Float = 0.5;
	private static inline var SDF_SMOOTHING: Float = 0.5;

	private static var atlases: Map<String, Pair<Loader, Atlas>> = new Map();
	private static var tiles: Map<String, Tile> = new Map();
	private static var fonts: Map<String, Font> = new Map();
	private static var texts: Map<String, String> = new Map();
	private static var bins: Map<String, Bytes> = new Map();
	private static var sounds: Map<String, Sound> = new Map();

	#if sys
	private static var queue: Queue1<BinaryLoader> = new Queue1(getAsset);
	private static var lastAssetTime: Float = 0;
	private static var assetLoader: Null<BinaryLoader>;
	#end

	#if mobile
	private static var assetBytesOutput: Null<BytesOutput>;
	private static var assetTotalSize: UInt = 0;
	#end

	public static function load(asset: String, cb: Int -> Int -> Void): Void {
		var realAsset: String = AssetManager.getPath(asset);
		var loader: BinaryLoader = new BinaryLoader(realAsset);
		inline function finish(): Void cb(AssetManager.MAX_ASSET_PROGRESS, AssetManager.MAX_ASSET_PROGRESS);
		function progressHandler(cur: Int, max: Int): Void
			if (cur != max) cb(Std.int(1 + cur / max * (AssetManager.MAX_ASSET_PROGRESS - 1)), AssetManager.MAX_ASSET_PROGRESS);
		switch ext(asset) {
			case ATLAS:
				loader.onLoaded = function(textBytes: Bytes): Void {
					cb(1, AssetManager.MAX_ASSET_PROGRESS);
					var path: String = realAsset.substr(0, realAsset.lastIndexOf('/') + 1);
					var imgFile: String = path + new BytesInput(textBytes).readLine();
					var imgLoader: BinaryLoader = new BinaryLoader(imgFile);
					imgLoader.onProgress = progressHandler;
					imgLoader.onLoaded = function(bytes: Bytes): Void {
						var img: Any = Any.fromBytes(imgFile, bytes);
						atlases[asset] = new Pair(
							@:privateAccess img.loader,
							Any.fromBytes(realAsset, textBytes).to(Atlas)
						);
						finish();
					}
					loadAsset(imgLoader);
				}
			case FNT:
				loader.onLoaded = function(fntbytes: Bytes): Void {
					cb(1, AssetManager.MAX_ASSET_PROGRESS);
					var data: String = fntbytes.toString();
					var image: Null<String> = null;
					var type: Null<String> = null;
					try {
						var xml: Fast = new Fast(Xml.parse(data)).node.font;
						image = xml.node.pages.node.page.att.file;
						try {
							type = xml.node.distanceField.att.fieldType;
						} catch (_: String) {}
					} catch (_: String) {
						var filePattern: String = '\npage id=0 file=';
						var fileIndex: Int = data.indexOf(filePattern);
						if (fileIndex != -1) {
							fileIndex += filePattern.length;
							image = data.substr(fileIndex);
							image = image.substr(0, image.indexOf('\n'));
						}
						var typePattern: String = '\ndistanceField fieldType=';
						var typeIndex: Int = data.indexOf(typePattern);
						if (typeIndex != -1) {
							typeIndex += typePattern.length;
							type = data.substr(typeIndex);
							type = type.substr(0, type.indexOf(' '));
						}
					}
					if (image == null) throw "Can't get image url";
					image = StringTools.replace(image, '"', '');
					var path: String = realAsset.substr(0, realAsset.lastIndexOf('/') + 1);
					var imgLoader: BinaryLoader = new BinaryLoader(path + image);
					imgLoader.onProgress = progressHandler;
					imgLoader.onLoaded = function(imgbytes: Bytes): Void {
						var font:Font = FontParser.parse(fntbytes, realAsset, function(path: String): Tile {
							return Any.fromBytes(path, imgbytes).toTile();
						});
						setFontType(font, type);
						fonts[asset] = font;
						finish();
					}
					loadAsset(imgLoader);
				}
			case PNG, JPG, JPEG:
				loader.onProgress = progressHandler;
				loader.onLoaded = function(bytes: Bytes): Void {
					tiles[asset] = Any.fromBytes(realAsset, bytes).toTile();
					finish();
				}
			case TXT, CSS, JSON, CDB, IMG, LDTK:
				loader.onProgress = progressHandler;
				loader.onLoaded = function(bytes: Bytes): Void {
					texts[asset] = Any.fromBytes(realAsset, bytes).toText();
					finish();
				}
			case BIN:
				loader.onProgress = progressHandler;
				loader.onLoaded = function(bytes: Bytes): Void {
					asset = StringTools.replace(asset, '@', '');
					bins[asset] = bytes;
					finish();
				}
			case WAV:
				loader.onProgress = progressHandler;
				loader.onLoaded = function(bytes: Bytes): Void {
					sounds[asset] = Any.fromBytes(realAsset, bytes).toSound();
					finish();
				}
			case v:
				throw ERROR_NOT_SUPPORTED;
		}
		loadAsset(loader);
	}

	private static inline function loadAsset(loader: BinaryLoader): Void {
		#if sys
		queue.call(loader);
		#else
		loader.load();
		#end
	}

	private static function getAsset(loader: BinaryLoader): Void {
		lastAssetTime = Timer.stamp();
		assetLoader = loader;
		#if mobile
		assetBytesOutput = new BytesOutput();
		Native.getAsset(loader.url);
		assetTotalSize = Native.assetBytesAvailable;
		if (assetTotalSize > Native.BUFFER_SIZE)
			DeltaTime.fixedUpdate < loadAssetStep; // Prepare before large asset
		else #end
			loadAssetStep();
	}

	private static function loadAssetStep(): Void {
		#if mobile
		if (Native.assetBytesAvailable > 0) {
			@:nullSafety(Off) assetBytesOutput.write(Native.getAssetBytes());
			@:nullSafety(Off) assetLoader.onProgress(assetTotalSize - Native.assetBytesAvailable, assetTotalSize);
			runNext(loadAssetStep);
		} else {
			@:nullSafety(Off) assetLoader.onLoaded(assetBytesOutput.getBytes());
			assetBytesOutput = null;
			assetLoader = null;
			Native.finishGetAsset();
			runNext(queue.next);
		}
		#else
		var onLoaded = @:nullSafety(Off) assetLoader.onLoaded;
		@:nullSafety(Off) assetLoader.onLoaded = function(bytes: Bytes): Void {
			onLoaded(bytes);
			assetLoader = null;
			runNext(queue.next);
		}
		assetLoader.load();
		#end
	}

	private static function runNext(cb: Void -> Void): Void {
		var t: Float = Timer.stamp();
		var nextFrame: Bool = t - lastAssetTime > 1 / 120;
		if (nextFrame) {
			lastAssetTime = t;
			DeltaTime.skipUpdate(cb);
		} else {
			cb();
		}
	}

	public static inline function ext(asset: String): String {
		return asset.indexOf('@') != -1 ? BIN : asset.substr(asset.lastIndexOf('.') + 1);
	}

	public static inline function reset(asset: String): Void {
		atlases.remove(asset);
	}

	public static function texture(asset: String, ?name: String): Tile {
		return switch ext(asset) {
			case ATLAS:
				if (name == null) throw ERROR_NAME_NOT_SET;
				var p: Null<Pair<Loader, Atlas>> = atlases[asset];
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

	public static inline function image(asset: String, ?name: String): Bitmap {
		return new Bitmap(texture(asset, name));
	}

	public static function animation(asset: String, ?name: String): Array<Tile> {
		return switch ext(asset) {
			case ATLAS:
				if (name != null) {
					name = SliceTools.clean(name);
				} else {
					var classet: String = SliceTools.clean(asset);
					if (classet == asset) return [texture(classet)];
				}
				if (name == null) throw ERROR_NAME_NOT_SET;
				var p: Null<Pair<Loader, Atlas>> = atlases[asset];
				if (p == null) throw ERROR_NOT_LOADED;
				Loader.currentInstance = p.a;
				p.b.getAnim(name);
			case PNG, JPG, JPEG:
				if (name != null) throw ERROR_NAME_SET;
				var assets: Array<String> = AssetManager.parseInterval(asset);
				if (assets.length == 1)
					assets = SliceTools.getNames(assets[0]);
				[for (e in assets) texture(e)];
			case _:
				throw ERROR_NOT_SUPPORTED;
		};
	}

	public static inline function clip(asset: String, ?name: String, ?speed: Float): Anim {
		return new Anim(animation(asset, name), speed);
	}

	public static inline function font(asset: String): Font {
		return cast fonts[asset];
	}

	public static inline function text(asset: String): String {
		return cast texts[asset];
	}

	public static inline function sound(asset: String): Sound {
		return cast sounds[asset];
	}

	public static inline function bin(asset: String): Bytes {
		asset = StringTools.replace(asset, '@', '');
		return cast bins[asset];
	}

	public static function setFontType(font: Font, type: Null<String>): Void {
		switch type {
			case null:
			case 'msdf':
				font.type = SignedDistanceField(SDFChannel.MultiChannel, SDF_ALPHA, SDF_SMOOTHING);
			case 'sdf':
				font.type = SignedDistanceField(SDFChannel.Alpha, SDF_ALPHA, SDF_SMOOTHING);
			case _:
				throw 'Unsupported font type';
		}
	}

}