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
package pony.pixi.ui;

import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ImmutableArray;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.Touchable;
import pony.events.WaitReady;

using pony.pixi.PixiExtends;

/**
 * Button
 * @author AxGord <axgord@gmail.com>
 */
class Button extends Sprite implements IWH {

	public var core(default, null):ButtonImgN;
	public var size(get, never):Point<Float>;
	private var hideDisabled:Bool;
	public var touchActive(get, set):Bool;
	
	private var list:Array<Sprite>;
	private var zone:Sprite;
	private var prev:Int = 0;
	private var wr:WaitReady;
	
	public function new(imgs:ImmutableArray<String>, ?offset:Point<Float>, useSpriteSheet:Bool=false) {
		var imgs = imgs.copy();
		wr = new WaitReady();
		if (imgs[0] == null) throw 'Need first img';
		if (imgs[1] == null)
			imgs[1] = imgs[2] != null ? imgs[2] : imgs[0];
		if (imgs[2] == null) imgs[2] = imgs[1];
		
		var z = imgs.length > 3 ? imgs.splice(3, 1)[0] : null;
		if (z == null) z = imgs[0];
		hideDisabled = imgs[3] == null;
		var i = 4;
		while (i < imgs.length) {
			if (imgs[i+1] == null)
				imgs[i+1] = imgs[i+2] != null ? imgs[i+2] : imgs[i];
			if (imgs[i+2] == null) imgs[i+2] = imgs[i+1];
			i += 3;
		}
		list = [for (img in imgs) img == null ? null : (useSpriteSheet ? Sprite.fromFrame(StringTools.replace(img,'/','_')) : Sprite.fromImage(img))];
		if (offset != null) {
			for (e in list) if (e != null) {
				e.x = -offset.x;
				e.y = -offset.y;
			}
		}
		super();
		zone = useSpriteSheet ? Sprite.fromFrame(StringTools.replace(z, '/', '_')) : Sprite.fromImage(z);
		if (useSpriteSheet)
			wr.ready();
		else
			zone.texture.loaded(wr.ready);
		addChild(zone);
		zone.buttonMode = true;
		zone.alpha = 0;
		core = new ButtonImgN(new Touchable(zone));
		core.onImg << imgHandler;
		core.onDisable << disableHandler;
		core.onEnable << enableHandler;
		addChild(list[0]);
	}
	
	private function disableHandler():Void touchActive = false;
	private function enableHandler():Void touchActive = true;
	
	inline public function wait(cb:Void->Void):Void wr.wait(cb);
	inline private function get_size():Point<Float> return new Point(zone.width, zone.height);
	
	private function imgHandler(n:Int):Void {
		if (n == 4 && hideDisabled) {
			visible = false;
			return;
		} else {
			visible = true;
		}
		if (prev != -1) removeChild(list[prev]);
		addChild(list[prev = n - 1]);
	}
	
	override public function destroy():Void {
		core.destroy();
		core = null;
		
		for (e in list) {
			removeChild(e);
			e.destroy();
		}
		list = null;
		removeChild(zone);
		zone.destroy();
		zone = null;
		
		wr = null;
		
		super.destroy();
	}
	
	inline private function get_touchActive():Bool return zone.interactive;
	inline private function set_touchActive(v:Bool):Bool return zone.interactive = v;
	
}