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
import pixi.extras.BitmapText;
import pony.geom.IWH;
import pony.geom.Point;
import pony.text.TextTools;
import pony.time.DeltaTime;

/**
 * Text
 * @author AxGord <axgord@gmail.com>
 */
class BText extends Sprite implements IWH {

	public var t(get, set):String;
	public var size(get, never):Point<Float>;
	private var ansi:String;
	private var current:BTextLow;
	private var style:BitmapTextStyle;
	public var color(get, set):UInt;
	private var defColor:UInt;
	
	public function new(text:String, ?style:BitmapTextStyle, ?ansi:String) {
		super();
		this.style = style;
		this.ansi = ansi;
		defColor = style.tint;
		firstset(text);
	}
	
	private function get_size():Point<Float> return current.size;
	
	public function wait(cb:Void->Void):Void cb();
	
	@:extern inline public function get_t():String return current.text;
	
	public function set_t(s:String):String {
		removeChild(current);
		current.destroy();
		current = new BTextLow(s, style, ansi);
		addChild(current);
		return s;
	}
	
	private function firstset(s:String):Void {
		current = new BTextLow(s, style, ansi);
		addChild(current);
	}
	
	override public function destroy():Void {
		removeChild(current);
		current.destroy();
		ansi = null;
		style = null;
		super.destroy();
	}
	
	private function get_color():UInt return style.tint;
	
	private function set_color(v:Null<UInt>):Null<UInt> {
		if (v == null) v = defColor;
		style.tint = v;
		current.cacheAsBitmap = false;
		current.tint = v;
		current.cacheAsBitmap = true;
		return v;
	}
	
}