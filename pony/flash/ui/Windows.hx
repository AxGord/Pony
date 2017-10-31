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
package pony.flash.ui;

import flash.display.BlendMode;
import flash.display.MovieClip;
import flash.filters.BlurFilter;
import flash.Lib;
import flash.display.StageQuality;

using pony.flash.FLTools;

/**
 * Windows
 * @author AxGord <axgord@gmail.com>
 */
class Windows implements Dynamic<Window> {

	private var map:Map<String, Window>;
	private var st:MovieClip;
	
	public function new(st:MovieClip) {
		map = new Map<String, Window>();
		this.st = st;
		var chs = [for (e in st.childrens()) e];
		for (ch in chs) if (Std.is(ch, Window)) {
			var e:Window = cast ch;
			map.set(e.name, e);
			e.initm(this);
			st.removeChild(e);
			st.stage.addChild(e);
		}
	}
	
	inline public function resolve(field:String):Window return map.get(field);
	
	public function blurOn():Void {
		var filter = new BlurFilter();
		filter.quality = 3;
		switch (st.stage.quality) {
			case StageQuality.LOW:
			case StageQuality.MEDIUM:
				Lib.current.alpha = 0.05;
			default:
				Lib.current.filters = [filter];
				Lib.current.alpha = 0.05;		
		}
		Lib.current.mouseEnabled = false;
		Lib.current.mouseChildren = false;
	}
	
	public function blurOff():Void {
		Lib.current.filters = [];
		Lib.current.alpha = 1;
		Lib.current.mouseEnabled = true;
		Lib.current.mouseChildren = true;
	}
	
}