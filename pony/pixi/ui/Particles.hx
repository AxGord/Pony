/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.pixi.ui;

import cloudkid.Emitter;
import haxe.extern.EitherType;
import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pony.time.DeltaTime;
import pony.ui.AssetManager;

/**
 * Particles
 * @author AxGord <axgord@gmail.com>
 */
class Particles extends Sprite {

	private var cfgurl:String;
	private var imagesurl:Array<String>;
	private var asset:String;
	private var emitter:Emitter;
	
	public function new(cfgurl:String, imagesurl:Array<String>, ?asset:String) {
		super();
		this.cfgurl = cfgurl;
		this.imagesurl = imagesurl;
		this.asset = asset;
		if (asset == null) {
			AssetManager.load('', [cfgurl].concat(imagesurl), loadHandler);
		} else {
			AssetManager.load('', [cfgurl, asset], loadHandler);
		}
	}
	
	private function loadHandler():Void {
		if (cfgurl == null) return;
		var textures = asset == null ?
			[for (e in imagesurl) AssetManager.texture(e)] :
			[for (e in imagesurl) AssetManager.texture(asset, e)];
		emitter = new Emitter(
			this,
			textures,
			AssetManager.json(cfgurl)
		);
		play();
		cfgurl = null;
		imagesurl = null;
		asset = null;
	}
	
	public inline function play():Void DeltaTime.fixedUpdate << emitter.update;
	public inline function stop():Void DeltaTime.fixedUpdate >> emitter.update;
	
	override public function destroy(?options:EitherType<Bool, DestroyOptions>):Void {
		if (emitter != null) {
			stop();
			emitter.destroy();
			emitter = null;
		} else {
			cfgurl = null;
			imagesurl = null;
			asset = null;
		}
		super.destroy(options);
	}
	
}