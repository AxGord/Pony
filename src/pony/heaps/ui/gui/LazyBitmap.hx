package pony.heaps.ui.gui;

import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import pony.geom.Point;
import pony.ui.AssetManager;
import pony.time.DeltaTime;
import pony.time.Tween;

/**
 * LazyBitmap
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety class LazyBitmap extends Bitmap {

	private var asset: String;
	private var aname: Null<String>;
	private var needAnim: Bool;
	private var anim: Null<Tween>;
	public var finalAlpha(default, set): Float = 1;
	public var finalVisible(default, set): Bool = false;
	public var offset(default, set): Point<Float> = 0;
	public var posWithOffset(get, set): Point<Float>;
	public var posWitoutOffset(default, null): Point<Float> = 0;
	private var inited: Bool = false;

	public function new(asset: String, ?name: String, anim: Bool = false, hidden: Bool = false, ?parent: Object) {
		super(parent);
		this.asset = asset;
		this.aname = name;
		this.needAnim = anim;
		finalVisible = !hidden;
		if (!hidden) init();
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_posWithOffset(): Point<Float> return this;

	public inline function set_posWithOffset(p: Point<Float>): Point<Float> {
		posWitoutOffset = p;
		(p - offset).setPosition(this);
		return p;
	}

	public inline function set_offset(p: Point<Float>): Point<Float> {
		offset = p;
		posWithOffset = posWitoutOffset;
		return p;
	}

	private function init(): Void {
		inited = true;
		if (!AssetManager.isLoaded(asset)) {
			if (needAnim) {
				anim = new Tween(TweenType.Bezier, 300);
				anim.onProgress << animHandler;
				anim.onComplete << animCompleteHandler;
				setAlpha(0);
			}
			AssetManager.loadComplete(AssetManager.load.bind('', asset), loadedHandler);
		} else {
			setTile();
		}
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function setTile(): Void {
		tile = AssetManager.texture(asset, aname);
	}

	private function loadedHandler(): Void {
		setTile();
		DeltaTime.skipFrames(18, readyForShow);
	}

	private function readyForShow(): Void {
		visible = true;
		if (anim != null)
			anim.play();
	}

	private function animHandler(v: Float): Void setAlpha(v * finalAlpha);

	private function animCompleteHandler(): Void {
		if (anim != null) {
			anim.destroy();
			anim = null;
		}
	}

	private inline function set_finalAlpha(v: Float): Float {
		finalAlpha = v;
		if (anim == null) setAlpha(v);
		return v;
	}

	public inline function setAlpha(v: Float): Void {
		visible = finalVisible && v != 0;
		alpha = v;
	}

	private inline function set_finalVisible(v: Bool): Bool {
		visible = v && alpha != 0;
		finalVisible = v;
		if (v && !inited) init();
		return v;
	}

}
