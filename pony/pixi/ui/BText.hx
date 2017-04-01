/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pixi.extras.BitmapText;
import pixi.filters.blur.BlurFilter;
import pony.geom.IWH;
import pony.geom.Point;
import pony.text.TextTools;
import pony.time.DeltaTime;

/**
 * Text
 * @author AxGord <axgord@gmail.com>
 */
class BText extends Sprite implements IWH {

	private static var blurFilter:BlurFilter = new BlurFilter();
	
	public var t(get, set):String;
	public var size(get, never):Point<Float>;
	private var ansi:String;
	private var current:BTextLow;
	private var currentShadow:BTextLow;
	private var style:BitmapTextStyle;
	public var color(get, set):UInt;
	private var defColor:UInt;
	private var shadow:Bool = false;
	private var shadowStyle:BitmapTextStyle;
	
	public function new(text:String, ?style:BitmapTextStyle, ?ansi:String, shadow:Bool = false) {
		super();
		this.style = style;
		this.ansi = ansi;
		this.shadow = shadow;
		if (shadow)
			shadowStyle = {font:style.font, tint:0x000000};
		defColor = style.tint;
		t = text;
	}
	
	private function get_size():Point<Float> return current == null ? null : current.size;
	
	public function wait(cb:Void->Void):Void cb();
	
	@:extern inline public function get_t():String return current == null ? null : current.text;
	
	@:extern inline public function safeSet(s:String):Void {
		t = StringTools.replace(s, ' ', '').length == 0 ? null : s;
	}
	
	public function set_t(s:String):String {
		destroyIfExists();
		if (s == null) return s;
		current = new BTextLow(s, style, ansi);
		if (shadow) {
			currentShadow = new BTextLow(s, shadowStyle, ansi);
			currentShadow.filters = [blurFilter];
			addChild(currentShadow);
		}
		addChild(current);
		return s;
	}
	
	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		destroyIfExists();
		ansi = null;
		style = null;
		super.destroy(options);
	}
	
	@:extern inline private function destroyIfExists():Void {
		if (current != null) {
			removeChild(current);
			current.destroy();
		}
		if (currentShadow != null) {
			removeChild(currentShadow);
			currentShadow.destroy();
		}
	}
	
	@:extern inline private function get_color():UInt return style.tint;
	
	private function set_color(v:Null<UInt>):Null<UInt> {
		if (v == null) v = defColor;
		style.tint = v;
		if (current == null) return v;
		if (!current.nocache) current.cacheAsBitmap = false;
		current.tint = v;
		if (!current.nocache) current.cacheAsBitmap = true;
		return v;
	}
	
	public function destroyIWH():Void destroy();
	
}