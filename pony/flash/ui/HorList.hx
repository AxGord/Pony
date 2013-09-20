/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.flash.ui;

import flash.display.MovieClip;
import flash.text.TextField;
import pony.ui.ButtonCore;

/**
 * HorList
 * Horizontal list switchable elements
 * @author AxGord <axgord@gmail.com>
 */
class HorList extends MovieClip {

	private var bPrev(get,never):ButtonCore;
	private var bNext(get,never):ButtonCore;
	private var text(get,never):TextField;
	
	public var elemets(default, set):Array<String>;
	public var current(default, set):Int = 0;
	
	public function new() {
		super();
		elemets = [];
		bPrev.mode = 1;
		bNext.mode = 1;
		text.text = '';
		bPrev.click.sub([0]).add(prev);
		bNext.click.sub([0]).add(next);
	}
	
	inline private function get_bPrev():ButtonCore return untyped this['bPrev'].core;
	inline private function get_bNext():ButtonCore return untyped this['bNext'].core;
	inline private function get_text():TextField return untyped this['text'];
	
	public function set_current(n:Int):Int {
		if (current == n) return n;
		bPrev.mode = n > 0 ? 0 : 1;
		bNext.mode = n < elemets.length-1 ? 0 : 1;
		text.text = elemets[n];
		return current = n;
	}
	
	public function set_elemets(a:Array<String>):Array<String> {
		if (a.length == 0) {
			current = 0;
			bPrev.mode = 1;
			bNext.mode = 1;
			text.text = '';
		} else {
			bNext.mode = current < a.length - 1 ? 0 : 1;
			text.text = a[current];
		}
		return elemets = a;
	}
	
	inline public function next():Void if (current < elemets.length-1) current++;
	inline public function prev():Void if (current > 0) current--;
	
}