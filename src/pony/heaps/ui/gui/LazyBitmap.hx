package pony.heaps.ui.gui;

import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import pony.ui.AssetManager;
import pony.time.DeltaTime;
import pony.time.Tween;

/**
 * LazyBitmap
 * @author AxGord <axgord@gmail.com>
 */
class LazyBitmap extends Bitmap {
	
	private var asset: String;
	private var aname: String;
	private var anim: Tween;

	public function new(asset: String, ?name: String, ?anim: Bool, ?parent: Object) {
		super(parent);
		visible = false;
		this.asset = asset;
		this.aname = name;
		if (anim) {
			this.anim = new Tween(TweenType.Bezier, 300);
			this.anim.onProgress << animHandler;
			this.anim.onComplete << animCompleteHandler;
			alpha = 0;
		}
		AssetManager.loadComplete(AssetManager.load.bind('', asset), loadedHandler);
	}

	private function loadedHandler(): Void {
		tile = AssetManager.texture(asset, aname);
		DeltaTime.skipFrames(18, readyForShow);
	}

	private function readyForShow(): Void {
		visible = true;
		if (anim != null)
			anim.play();
	}

	private function animHandler(v: Float): Void alpha = v;

	private function animCompleteHandler(): Void {
		anim.destroy();
		anim = null;
	}

}
