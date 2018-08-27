/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package pony.pixi;

import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.loaders.Loader;
import pixi.loaders.Resource;
import pixi.plugins.spine.Spine;
import pixi.plugins.spine.core.SkeletonData;
import pony.ui.AssetManager;
import pony.JsTools;

/**
 * PixiAssets
 * @author AxGord <axgord@gmail.com>
 */
class PixiAssets {
	
	private static var sounds:Map<String, PixiSound> = new Map();
	private static var spines:Map<String, SkeletonData> = new Map();
	private static var texts:Map<String, String> = new Map();
	private static var jsons:Map<String, Dynamic> = new Map();
	
	public static function load(asset:String, cb:Void->Void):Void {
		var loader = new Loader();
		
		var sp = asset.split('(spine)');
		if (sp.length > 1) {
			loadSpine(sp.join(''), function(d:SkeletonData) {
				spines[asset] = d;
				cb();
			});
			
			return;
		}
		
		if (['.mp3', '.wav', '.ogg'].indexOf(asset.substr( -4)) != -1) {
			if (!sounds.exists(asset)) {
				var s = new PixiSound();
				sounds[asset] = s;
				loader.add(asset, AssetManager.getPath(asset), { loadType: 2 }, s.loadHandler);
			}
		} else if (['frag', '.txt'].indexOf(asset.substr( -4)) != -1) {
			asset = linuxReplace(asset);
			if (!texts.exists(asset)) {
				loader.add(asset, AssetManager.getPath(asset), { loadType: 0 }, function(r:Resource):Void {
					texts[asset] = r.data;
				});
			}
		} else if (['json'].indexOf(asset.substr( -4)) != -1) {
			asset = webpReplace(asset);
			if (!jsons.exists(asset)) {
				loader.add(asset, AssetManager.getPath(asset), { loadType: 0 }, function(r:Resource):Void {
					jsons[asset] = r.data;
				});
			}
		} else {
			asset = webpReplace(asset);
			loader.add(asset, AssetManager.getPath(asset));
		}
		loader.load(cb);
	}

	public static function linuxReplace(asset:String):String {
		if (JsTools.os.equals(OS.Linux(Ubuntu)) || JsTools.os.equals(OS.Linux(Other)))
			return StringTools.replace(asset, '{linux}', '_linux');
		else
			return StringTools.replace(asset, '{linux}', '');
	}

	public static function webpReplace(asset:String):String {
		asset = StringTools.replace(asset, '{webp}', JsTools.webp ? '_webp' : '');
		asset = StringTools.replace(asset, '{webp|png}', JsTools.webp ? 'webp' : 'png');
		asset = StringTools.replace(asset, '{png|webp}', JsTools.webp ? 'webp' : 'png');
		asset = StringTools.replace(asset, '{webp|jpg}', JsTools.webp ? 'webp' : 'jpg');
		asset = StringTools.replace(asset, '{jpg|webp}', JsTools.webp ? 'webp' : 'jpg');
		return asset;
	}
	
	public static function loadSpine(asset:String, cb:SkeletonData->Void):Void {
		var loader = new Loader();
		loader.add(asset, AssetManager.getPath(asset));
		loader.load(function(_, resources) {
			cb(Reflect.field(resources, asset).spineData);
		});
	}
	
	public static function image(asset:String, ?name:String):Sprite {
		return name == null ? Sprite.fromImage(AssetManager.getPath(webpReplace(asset))) : Sprite.fromFrame(name);
	}
	
	public static function texture(asset:String, ?name:String):Texture {
		return name == null ? Texture.fromImage(AssetManager.getPath(webpReplace(asset))) : Texture.fromFrame(name);
	}
	
	public static function cImage(asset:String, useSpriteSheet:Bool):Sprite {
		return useSpriteSheet ? Sprite.fromFrame(asset) : Sprite.fromImage(AssetManager.getPath(webpReplace(asset)));
	}
	
	public static function cTexture(asset:String, useSpriteSheet:Bool):Texture {
		return useSpriteSheet ? Texture.fromFrame(asset) : Texture.fromImage(AssetManager.getPath(webpReplace(asset)));
	}
	
	public static function sound(asset:String):PixiSound return sounds[asset];
	public static function spine(asset:String):SkeletonData return spines[asset];
	public static function text(asset:String):String return texts[asset];
	public static function json(asset:String):String return jsons[asset];
	
}