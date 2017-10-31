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

import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.extras.BitmapText;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ui.gui.BaseLayoutCore;

using pony.pixi.PixiExtends;

/**
 * BaseLayout
 * @author AxGord <axgord@gmail.com>
 */
class BaseLayout<T:BaseLayoutCore<Container>> extends Sprite implements IWH {

	public var layout(default, null):T;
	public var size(get, never):Point<Float>;
	
	public function new() {
		super();
		layout.load = load;
		layout.getSize = getSize;
		layout.getSizeMod = getSizeMod;
		layout.setXpos = setXpos;
		layout.setYpos = setYpos;
	}
	
	public function add(obj:Container):Void {
		addChild(obj);
		layout.add(obj);
	}
	
	public function addAt(obj:Container, index:Int):Void {
		addChildAt(obj, index);
		layout.add(obj);
	}
	
	public function addToBegin(obj:Container):Void {
		addChildAt(obj, 0);
		layout.addToBegin(obj);
	}
	
	private function load(obj:Container):Void {
		if (Std.is(obj, Sprite)) {
			layout.tasks.add();
			cast(obj, Sprite).loaded(layout.tasks.end);
		}
	}
	
	private function destroyChild(obj:Container):Void {
		if (Std.is(obj, DisplayObject)) {
			var s:DisplayObject = cast obj;
			removeChild(s);
			s.destroy();
		}
	}
	
	private function setXpos(obj:Container, v:Float):Void obj.x = v;
	private function setYpos(obj:Container, v:Float):Void obj.y = v;
	
	public function wait(cb:Void->Void):Void layout.wait(cb);
	
	private function getSize(o:Container):Point<Float> {
		return if (Std.is(o, BitmapText))
			new Point(untyped o.textWidth, untyped o.textHeight);
		else
			new Point(o.width * o.scale.x, o.height * o.scale.y);
	}
	
	private static function getSizeMod(o:Container, p:Point<Float>):Point<Float> return new Point(p.x * o.scale.x, p.y * o.scale.y);
	
	inline private function get_size():Point<Float> return visible ? layout.size : new Point<Float>(0, 0);
	
	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		layout.destroy();
		layout = null;
		super.destroy(options);
	}
	
	public function destroyIWH():Void destroy();
	
}