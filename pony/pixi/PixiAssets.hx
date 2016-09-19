/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.pixi;

import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.loaders.Loader;
import pixi.loaders.Resource;
import pony.ui.AssetManager;

/**
 * PixiAssets
 * @author AxGord <axgord@gmail.com>
 */
class PixiAssets {
	
	private static var sounds:Map<String, PixiSound> = new Map();
	
	public static function load(asset:String, cb:Void->Void):Void {
		var loader = new Loader();
		if (['.mp3', '.wav', '.ogg'].indexOf(asset.substr( -4)) != -1) {
			if (!sounds.exists(asset)) {
				var s = new PixiSound();
				sounds[asset] = s;
				loader.add(asset, AssetManager.getPath(asset), { loadType: 3 }, s.loadHandler);
			}
		} else {
			loader.add(asset, AssetManager.getPath(asset));
		}
		loader.load(cb);
	}
	
	public static function image(asset:String, ?name:String):Sprite {
		return name == null ? Sprite.fromImage(AssetManager.getPath(asset)) : Sprite.fromFrame(name);
	}
	
	public static function texture(asset:String, ?name:String):Texture {
		return name == null ? Texture.fromImage(AssetManager.getPath(asset)) : Texture.fromFrame(name);
	}
	
	public static function cImage(asset:String, useSpriteSheet:Bool):Sprite {
		return useSpriteSheet ? Sprite.fromFrame(asset) : Sprite.fromImage(AssetManager.getPath(asset));
	}
	
	public static function cTexture(asset:String, useSpriteSheet:Bool):Texture {
		return useSpriteSheet ? Texture.fromFrame(asset) : Texture.fromImage(AssetManager.getPath(asset));
	}
	
	public static function sound(asset:String):PixiSound return sounds[asset]; 
	
}