/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.ui.touch.starling;

import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;
import pony.ui.touch.TouchebleBase;

/**
 * Toucheble
 * todo: over after mouse down
 * @author AxGord <axgord@gmail.com>
 */
class Toucheble extends TouchebleBase {

	public var leave:Bool = false;
	private var prev:TouchEventType;
	
	public function new(object:Dynamic) {
		super();
		TouchManager.addListener(object, eventHandler);
	}
	
	private function eventHandler(event:TouchManagerEvent):Void {
		switch event.type {
			case TouchEventType.Hover: dispatchOver(event.touchID); leave = false; //trace('Hover');
			case TouchEventType.HoverOut: dispatchOut(event.touchID); leave = true; //trace('HoverOut');
			case TouchEventType.Over: dispatchOverDown(event.touchID); leave = false; //trace('Over');
			case TouchEventType.Out: dispatchOutDown(event.touchID); leave = true; //trace('Out');
			case TouchEventType.Down: dispatchDown(event.touchID, event.globalX, event.globalY); //trace('Down');
			case TouchEventType.Up: leave ? dispatchOutUp(event.touchID) : dispatchUp(); //trace('Up');
			case _:
		}
		prev = event.type;
	}
	
}