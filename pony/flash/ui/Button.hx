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
package pony.flash.ui;

import flash.display.MovieClip;
import pony.flash.FLTools;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.Touchable;

using pony.flash.FLExtends;

/**
 * Button
 * @see pony.ui.ButtonCore
 * @author AxGord
 */
class Button extends MovieClip {
	#if !starling
	//public static var config = {def: 1, focus: 2, press: 3, zone: 4, disabled: 5};
	
	public var core(default, null):ButtonImgN;
	
	private var zone:Button;
	private var visual:Button;
	
	public function new() {
		super();
		FLTools.setTrace();
		stop();
		removeChildren();
		var cl:Class<Button> = Type.getClass(this);
		
		visual = Type.createEmptyInstance(cl);
		visual.gotoAndStop(1);
		visual.mouseEnabled = false;
		visual.mouseChildren = false;
		visual.scaleX = scaleX;
		visual.scaleY = scaleY;
		addChild(visual);
		
		zone = Type.createEmptyInstance(cl);
		zone.gotoAndStop(4);
		zone.buttonMode = true;
		zone.alpha = 0;
		zone.scaleX = scaleX;
		zone.scaleY = scaleY;
		addChild(zone);
		
		
		mouseEnabled = false;
		
		scaleX = 1;
		scaleY = 1;
		
		core = new ButtonImgN(new Touchable(zone));
		core.onImg << change;
	}
	
	private function change(img:Int):Void {
		if (img == 4) {
			zone.buttonMode = false;
			visual.gotoAndStop(5);
			return;
		}
		zone.buttonMode = true;
	
		visual.gotoAndStop(img > 4 ? img + 1 : img);
	}
	
	public function switchMap(a:Array<Int>):Void core.switchMap(a);
	public function bswitch():Void core.bswitch();
	
	#else
	private var _sw:Array<Int>;
	private var _bsw:Bool = false;
	
	public function switchMap(v:Array<Int>):Void _sw = v;
	public function bswitch():Void _bsw = true;
	
	#end
}