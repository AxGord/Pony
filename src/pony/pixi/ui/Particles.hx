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
	public var emitter:Emitter;
	
	public function new(cfgurl:String, imagesurl:Array<String>, ?asset:String) {
		super();
		this.cfgurl = cfgurl;
		this.imagesurl = imagesurl;
		this.asset = asset;
		if (asset == null) {
			AssetManager.loadComplete(AssetManager.load.bind('', [cfgurl].concat(imagesurl)), loadHandler);
		} else {
			AssetManager.loadComplete(AssetManager.load.bind('', [cfgurl, asset]), loadHandler);
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