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
package pony.pixi.nape;

import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;
import pixi.core.display.DisplayObject;
import haxe.extern.EitherType;
import pony.geom.Point;
import pony.events.Signal1;
import pony.physics.nape.BodyBase;
import pony.physics.nape.DebugLineStyle;

/**
 * BodyBaseView
 * @author AxGord <axgord@gmail.com>
 */
@:abstract class BodyBaseView<T:BodyBase> extends Sprite implements pony.magic.HasAbstract implements pony.magic.HasSignal {

	@:auto public var onOut:Signal1<BodyBaseView<T>>;
	public var core(default, null):T;
	public var debugLines(default, set):DebugLineStyle;
	private var g:Graphics;

	public function new(core:T) {
		super();
		this.core = core;
		core.onPos << posHandler;
		core.onRotation << rotationHandler;
		core.onOut << out;
		core.onDestroy < destroy.bind(null);
	}

	private function out():Void eOut.dispatch(this);

	public function scl(x:Float, y:Float):Void {
		scale.set(x, y);
		core.scale(x, y);
	}

	private function set_debugLines(v:DebugLineStyle):DebugLineStyle {
		if (debugLines != null) {
			removeChild(g);
			g.destroy();
			g = null;
		}
		if (v != null) {
			g = new Graphics();
			addChild(g);
			g.lineStyle(v.size, v.color);
			drawDebug();
			g.cacheAsBitmap = true;
		}
		return debugLines = v;
	}

	@:abstract private function drawDebug():Void;

	private function posHandler(px:Float, py:Float):Void {
		position.set(px, py);
	}

	private function rotationHandler(r:Float):Void {
		rotation = r;
	}

	override public function destroy(?options:EitherType<Bool, DestroyOptions>):Void {
		if (core == null) return;
		core.destroy();
		core = null;
		if (g != null) {
			removeChild(g);
			g.destroy();
			g = null;
		}
		super.destroy(options);
	}

}