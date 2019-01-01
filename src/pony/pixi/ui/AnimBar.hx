package pony.pixi.ui;

import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pony.geom.Point;
import pony.time.Tween;

/**
 * AnimBar
 * @author AxGord <axgord@gmail.com>
 */
class AnimBar extends Bar {

	private var animation:Sprite;
	private var tween:Tween;
	
	public function new(
		bg:String,
		fillBegin:String,
		fill:String,
		?animation:String,
		animationSpeed:Int = 2000,
		?offset:Point<Int>,
		invert:Bool = false,
		useSpriteSheet:Bool=false,
		creep:Float = 0,
		smooth:Bool = false
	) {
		super(bg, fillBegin, fill, offset, invert, useSpriteSheet, creep, smooth);
		tween = new Tween(animationSpeed, true, true, true, true);
		if (animation != null) {
			this.animation = PixiAssets.cImage(animation, useSpriteSheet);
			this.animation.visible = false;
			if (offset != null) {
				this.animation.x = offset.x;
				this.animation.y = offset.y;
			}
			tween.onUpdate << animUpdate;
			onReady < animInit;
		} else {
			tween.onUpdate << animUpdate2;
		}
	}
	
	private function animInit():Void addChildAt(animation, children.length);
	
	private function animUpdate(alp:Float):Void animation.alpha = alp;
	private function animUpdate2(alp:Float):Void begin.alpha = fill.alpha = end.alpha = alp;
	
	public function startAnimation():Void {
		if (animation != null) animation.visible = true;
		tween.play();
	}
	
	public function stopAnimation():Void {
		if (animation != null) animation.visible = false;
		else begin.alpha = fill.alpha = end.alpha = 1;
		tween.stopOnEnd();
	}
	
	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		if (tween == null) return;
		tween.destroy();
		tween = null;
		if (animation != null) {
			removeChild(animation);
			animation.destroy();
			animation = null;
		}
		super.destroy(options);
	}
	
}