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
package pony.flash.starling.ui;

import starling.display.Sprite;
import starling.display.DisplayObject;

/**
 * StarlingWindows
 * @author Maletin
 */
class StarlingWindows implements Dynamic<StarlingWindow>
{
	private var map:Map<String, StarlingWindow>;
	private var st:Sprite;

	public function new(st:Sprite) 
	{
		map = new Map<String, StarlingWindow>();
		this.st = st;
		var windows:Array<StarlingWindow> = new Array<StarlingWindow>();
		for (i in 0...st.numChildren)
		{
			var child = st.getChildAt(i);
			if (Std.is(child, StarlingWindow)) windows.push(cast child);
		}
		
		for (i in 0...windows.length)
		{
			map.set(windows[i].name, windows[i]);
			windows[i].initm(this);
			//TODO With this code buttons don't work. Either fix it or always place windows on top of everything else
			//st.removeChild(windows[i]);
			//st.stage.addChild(windows[i]);
		}
	}
	
	inline public function resolve(field:String):StarlingWindow return map.get(field);
	
	public function blurOn():Void {
		//var filter = new BlurFilter();
		//filter.quality = 3;
		//switch (st.stage.quality) {
			//case StageQuality.LOW:
			//case StageQuality.MEDIUM:
				//Lib.current.alpha = 0.05;
			//default:
				//Lib.current.filters = [filter];
				//Lib.current.alpha = 0.05;		
		//}
		//Lib.current.mouseEnabled = false;
		//Lib.current.mouseChildren = false;
	}
	
	public function blurOff():Void {
		//Lib.current.filters = [];
		//Lib.current.alpha = 1;
		//Lib.current.mouseEnabled = true;
		//Lib.current.mouseChildren = true;
	}
	
}