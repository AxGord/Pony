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
import pony.geom.Rect.IntRect;
import unityengine.Vector3;
import unityengine.Vector2;
import unityengine.GUITexture;
import unityengine.GUIText;
import unityengine.GameObject;
import unityengine.Object;
import unityengine.Rect;
import unityengine.Texture2D;
import unityengine.Resources;
import unityengine.Font;

import pony.geom.Point.IntPoint;
import pony.ui.FontStyle;
import hugs.HUGS;
using hugs.HUGSWrapper;

/**
 * GUI
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class GUI {
	
	static private var textures:Map<Int, Dynamic> = new Map<Int, Texture2D>();

	public static function text(f:Vector3, point:IntPoint, text:String, style:FontStyle):GameObject {
		var b = new GameObject();
		b.name = 'gui_text';
		b.transform.position = f;
		b.transform.localScale = new Vector3(0, 0, 0);
		var g = b.addTypedComponent(GUIText);
		g.pixelOffset = new Vector2(point.x, -point.y);
		g.text = text;
		g.font = HUGS.fonts.get(style.font);
		g.fontSize = Math.ceil(style.size);
		g.fontStyle = switch [style.bold, style.italic] {
			case [false, false]: unityengine.FontStyle.Normal;
			case [true, false]: unityengine.FontStyle.Bold;
			case [false, true]: unityengine.FontStyle.Italic;
			case [true, true]: unityengine.FontStyle.BoldAndItalic;
		};
		g.material.color = cast style.color;
		return b;
	}
	
	public static function rect(f:Vector3, r:IntRect, color:UColor):GameObject {
		if (!textures.exists(color)) {
			var t:Texture2D = new Texture2D(1, 1);
			t.SetPixel(0,0,color);
			t.Apply();
			textures.set(color, t);
		}
		var b = new GameObject();
		b.name = 'gui_rect';
		var g = b.addTypedComponent(GUITexture);
		b.guiTexture.texture = textures.get(color);
		b.transform.position = f;
		b.transform.localScale = new Vector3(0, 0, 0);
		g.pixelInset = new Rect(r.x, -r.y, r.width, -r.height);
		return b;
	}
	
	public static function brect(f:Vector3, r:IntRect, color:Color, border:Int, bcolor:Color):Array<GameObject> {
		return [
			rect(f, r, color),
			rect(new Vector3(f.x, f.y, f.z+1), {x:r.x,y:r.y,width:border,height:r.height}, bcolor),
			rect(new Vector3(f.x, f.y, f.z+1), {x:r.x,y:r.y,width:r.width,height:border}, bcolor),
			rect(new Vector3(f.x, f.y, f.z+1), {x:r.x+r.width,y:r.y,width:border,height:r.height}, bcolor),
			rect(new Vector3(f.x, f.y, f.z+1), {x:r.x,y:r.y+r.height,width:r.width,height:border}, bcolor),
		];
	}
	
}