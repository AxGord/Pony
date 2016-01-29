/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.unity3d.ui;

import pony.color.Color;
import pony.color.UColor;
import pony.ui.gui.TextTableCore;
import unityengine.Object;
import unityengine.Vector3;
import unityengine.GameObject;

import pony.geom.Point;
import pony.geom.Point.IntPoint;
import pony.geom.Rect.IntRect;
import pony.magic.Declarator;
import pony.ui.gui.FontStyle;

/**
 * Table
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class TextTable extends pony.ui.gui.TextTableCore implements Declarator {
	
	private var gos:List<GameObject> = new List();
	
	@:arg private var startpos:IntPoint;
	@:arg private var fp:Point<Float>;
	@:arg private var z:Float;
	@:arg private var textMargin:IntPoint;

	override private function drawBG(r:IntRect, color:UColor):Void {
		gos.push(GUI.rect(new Vector3(fp.x , fp.y, z), r+startpos, color));
	}
	
	override private function drawText(point:IntRect, text:String, style:FontStyle):Void {
		gos.push(GUI.text(new Vector3(fp.x , fp.y, z+1), point+startpos+textMargin, text, style));
	}
	
	override private function clear():Void {
		for (o in gos) Object.Destroy(o);
	}
	
}