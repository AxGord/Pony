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
package pony.pixijs.ui;

import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pony.events.Signal0;
import pony.geom.Border;
import pony.magic.HasSignal;
import pony.ui.gui.ButtonCore;

using pony.pixijs.PixijsExtends;

/**
 * LabelButton
 * @author AxGord <axgord@gmail.com>
 */
class LabelButton extends Sprite implements HasSignal {

	public var core(get, never):ButtonCore;
	public var layout:Layout;
	@:auto public var onReady:Signal0;
	public var w(get, never):Float;
	public var h(get, never):Float;
	
	private var button:Button;
	private var objects:Array<Container>;
	private var vert:Bool;
	private var border:Border<Int>;
	
	public function new(imgs:Array<String>, objects:Array<Container>, vert:Bool = false, ?border:Border<Int>) {
		super();
		visible = false;
		this.objects = objects;
		this.vert = vert;
		this.border = border;
		button = new Button(imgs);
		addChild(button);
		button.textures[0].loaded(init);
	}
	
	private function init():Void {
		visible = true;
		layout = new Layout(w, h, objects, vert, border);
		addChild(layout);
		objects = null;
		layout.onUpdate < eReady;
	}
	
	@:extern inline private function get_core():ButtonCore return button.core;
	
	override public function destroy():Void {
		button.destroy();
		button = null;
		destroySignals();
		layout.destroy();
		super.destroy();
	}
	
	@:extern inline private function get_w():Float return button.width;
	@:extern inline private function get_h():Float return button.height;
	
}