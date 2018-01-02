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
package pony.pixi;

import pixi.core.display.Container;
import pixi.core.text.Text;
import pixi.extras.BitmapText;
import pony.pixi.ETextStyle;

enum EUniversalText {
	TEXT(t:Text);
	BITMAP_TEXT(t:BitmapText);
}

/**
 * UniversalText
 * @author AxGord <axgord@gmail.com>
 */
abstract UniversalText(EUniversalText) from EUniversalText to EUniversalText {

	public var text(get, set):String;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var textWidth(get, set):Float;
	public var textHeight(get, set):Float;
	
	@:extern inline public function new(t:String, s:ETextStyle) {
		this = switch s {
			case TEXT_STYLE(s): TEXT(new Text(t, s));
			case BITMAP_TEXT_STYLE(s): BITMAP_TEXT(new BitmapText(t, s));
		}
	}
	
	@:to @:extern inline public function toContainer():Container {
		return switch this {
			case TEXT(t): cast t;
			case BITMAP_TEXT(t): cast t;
		}
	}

	@:extern inline private function get_text():String {
		return switch this {
			case TEXT(t): t.text;
			case BITMAP_TEXT(t): t.text;
		}
	}
	
	@:extern inline private function set_text(v:String):String {
		return switch this {
			case TEXT(t): t.text = v;
			case BITMAP_TEXT(t): t.text = v;
		}
	}
	
	@:extern inline private function get_x():Float {
		return switch this {
			case TEXT(t): t.x;
			case BITMAP_TEXT(t): t.x;
		}
	}
	
	@:extern inline private function set_x(v:Float):Float {
		return switch this {
			case TEXT(t): t.x = v;
			case BITMAP_TEXT(t): t.x = v;
		}
	}
	
	@:extern inline private function get_y():Float {
		return switch this {
			case TEXT(t): t.y;
			case BITMAP_TEXT(t): t.y;
		}
	}
	
	@:extern inline private function set_y(v:Float):Float {
		return switch this {
			case TEXT(t): t.y = v;
			case BITMAP_TEXT(t): t.y = v;
		}
	}
	
	@:extern inline private function get_width():Float {
		return switch this {
			case TEXT(t): t.width;
			case BITMAP_TEXT(t): t.width;
		}
	}
	
	@:extern inline private function set_width(v:Float):Float {
		return switch this {
			case TEXT(t): t.width = v;
			case BITMAP_TEXT(t): t.width = v;
		}
	}
	
	@:extern inline private function get_height():Float {
		return switch this {
			case TEXT(t): t.height;
			case BITMAP_TEXT(t): t.height;
		}
	}
	
	@:extern inline private function set_height(v:Float):Float {
		return switch this {
			case TEXT(t): t.height = v;
			case BITMAP_TEXT(t): t.height = v;
		}
	}
	
	@:extern inline private function get_textWidth():Float {
		return switch this {
			case TEXT(t): t.width;
			case BITMAP_TEXT(t): t.textWidth;
		}
	}
	
	@:extern inline private function set_textWidth(v:Float):Float {
		return switch this {
			case TEXT(t): t.width = v;
			case BITMAP_TEXT(t): t.textWidth = v;
		}
	}
	
	@:extern inline private function get_textHeight():Float {
		return switch this {
			case TEXT(t): t.height;
			case BITMAP_TEXT(t): t.textHeight;
		}
	}
	
	@:extern inline private function set_textHeight(v:Float):Float {
		return switch this {
			case TEXT(t): t.height = v;
			case BITMAP_TEXT(t): t.textHeight = v;
		}
	}
	
}