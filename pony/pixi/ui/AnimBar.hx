/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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