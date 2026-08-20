package pony.pixi;

import haxe.Json;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.loaders.Loader;
import pixi.loaders.Resource;
import pixi.plugins.spine.Spine;
import pixi.plugins.spine.core.SkeletonData;
import pony.JsTools;
import pony.ui.AssetManager;

/**
 * PixiAssets
 * @author AxGord <axgord@gmail.com>
 */
class PixiAssets {

	private static final sounds: Map<String, PixiSound> = [];
	private static final spines: Map<String, SkeletonData> = [];
	private static final texts: Map<String, String> = [];
	private static final jsons: Map<String, Dynamic> = [];

	public static function reset(asset: String): Void {
		sounds.remove(asset);
		spines.remove(asset);
		texts.remove(asset);
		jsons.remove(asset);
	}

	public static function load(asset: String, cb: Void -> Void): Void {
		final loader = new Loader();

		final sp = asset.split('(spine)');
		if (sp.length > 1) {
			loadSpine(sp.join(''), function(d: SkeletonData) {
				spines[asset] = d;
				cb();
			});
			return;
		}

		if (['.mp3', '.wav', '.ogg'].indexOf(asset.substr(-4)) != -1) {
			if (!sounds.exists(asset)) {
				final s = new PixiSound();
				sounds[asset] = s;
				loader.add(asset, AssetManager.getPath(asset), { loadType: 2 }, s.loadHandler);
			}
		} else if (['frag', '.txt', '.cdb'].indexOf(asset.substr(-4)) != -1) {
			asset = linuxReplace(asset);
			if (!texts.exists(asset)) {
				loader.add(asset, AssetManager.getPath(asset), { loadType: 0 }, function(r: Resource): Void {
					texts[asset] = r.data;
				});
			}
		} else if (['json', '.img'].indexOf(asset.substr(-4)) != -1) {
			asset = webpReplace(asset);
			if (!jsons.exists(asset)) {
				loader.add(asset, AssetManager.getPath(asset), { loadType: 0 }, function(r: Resource): Void {
					if (asset.substr(-4) == 'json')
						jsons[asset] = r.data;
					else
						jsons[asset] = Json.parse(r.data);
				});
			}
		} else {
			asset = webpReplace(asset);
			loader.add(asset, AssetManager.getPath(asset));
		}
		loader.load(cb);
	}

	public static function linuxReplace(asset: String): String {
		if (JsTools.os.equals(OS.Linux(Ubuntu)) || JsTools.os.equals(OS.Linux(Other)))
			return StringTools.replace(asset, '{linux}', '_linux');
		else
			return StringTools.replace(asset, '{linux}', '');
	}

	public static function webpReplace(asset: String): String {
		asset = StringTools.replace(asset, '{webp}', JsTools.webp ? '_webp' : '');
		asset = StringTools.replace(asset, '{webp|png}', JsTools.webp ? 'webp' : 'png');
		asset = StringTools.replace(asset, '{png|webp}', JsTools.webp ? 'webp' : 'png');
		asset = StringTools.replace(asset, '{webp|jpg}', JsTools.webp ? 'webp' : 'jpg');
		asset = StringTools.replace(asset, '{jpg|webp}', JsTools.webp ? 'webp' : 'jpg');
		return asset;
	}

	public static function loadSpine(asset: String, cb: SkeletonData -> Void): Void {
		final loader = new Loader();
		loader.add(asset, AssetManager.getPath(asset));
		loader.load(function(_, resources) {
			cb(Reflect.field(resources, asset).spineData);
		});
	}

	public static function image(asset: String, ?name: String): Sprite {
		return name == null ? Sprite.fromImage(AssetManager.getPath(webpReplace(asset))) : Sprite.fromFrame(name);
	}

	public static function texture(asset: String, ?name: String): Texture {
		return name == null ? Texture.fromImage(AssetManager.getPath(webpReplace(asset))) : Texture.fromFrame(name);
	}

	public static function cImage(asset: String, useSpriteSheet: Bool): Sprite {
		return useSpriteSheet ? Sprite.fromFrame(asset) : Sprite.fromImage(AssetManager.getPath(webpReplace(asset)));
	}

	public static function cTexture(asset: String, useSpriteSheet: Bool): Texture {
		return useSpriteSheet ? Texture.fromFrame(asset) : Texture.fromImage(AssetManager.getPath(webpReplace(asset)));
	}

	public static function sound(asset: String): PixiSound return sounds[asset];

	public static function spine(asset: String): SkeletonData return spines[asset];

	public static function text(asset: String): String return texts[asset];

	public static function json(asset: String): Dynamic return jsons[asset];

}
