/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.unity3d;

import cs.NativeArray;
import pony.WordWrap;
import unityEngine.Color;
import unityEngine.Font;
import unityEngine.FontStyle;
import unityEngine.GameObject;
import unityEngine.GUIText;
import unityEngine.GUITexture;
import unityEngine.GUITexture;
import unityEngine.MonoBehaviour;
import unityEngine.Texture;
import unityEngine.Time;
import unityEngine.Resources;
import unityEngine.Vector3;
import unityEngine.Input;
import unityEngine.Screen;
import unityEngine.GUILayout;
import unityEngine.Rect;
using UnityHelper;

/**
 * ...
 * @author AxGord
 */

class Tooltip extends MonoBehaviour {

	public var text:String = 'tooltip';
	public var lightPower:Single = 0.2;
	public var texture:Texture;
	
	public static var border:Single = 5;
	
	private var overed:Int = 0;
	private var savedColor:Color;
	
	public static var textObject:GameObject;
	public static var guiTextObject:GUIText;
	public static var guiTextureObject:GUITexture;
	
	private static var _texture:Texture;
	
	private function Start():Void {
		if (_texture == null) _texture = texture;
	}
	
	private function Update():Void {
		if (textObject != null) {
			textObject.transform.position = new Vector3(Input.mousePosition.x/Screen.width, (Input.mousePosition.y+20)/Screen.height);
			
		}
		if (overed == 0) return;
		overed--;
		if (overed == 0) {
			hideText();
			//trace('out');
			lightDown();
		}
	}
	
	private function OnMouseOver():Void {
		if (overed == 2) return;
		if (overed == 0) {
			showText(text);
			//trace('over');
			lightUp();
		}
		overed = 2;
	}
	
	public function lightUp():Void {
		if (savedColor != null) return;
		savedColor = getRenderer().material.color;
		getRenderer().material.color = new Color(savedColor.r+lightPower, savedColor.g+lightPower, savedColor.b+lightPower);
		
	}
	
	public function lightDown():Void {
		if (savedColor == null) return;
		getRenderer().material.color = savedColor;
		savedColor = null;
	}
	
	
	public static function showText(text:String):Void {
		if (textObject == null) {
			
			
			textObject = new GameObject("GUIText Tooltip");
			textObject.transform.position = new Vector3(0.5, 0.5);
			guiTextObject = cast textObject.AddComponent('GUIText');
			guiTextObject.material.color = new Color(1, 1, 1.0);
			//guiTextObject.font = cast Resources.Load('ARIAL');
			guiTextObject.fontSize = 18;
			//guiTextObject.fontStyle = FontStyle.Bold;
			
			guiTextureObject = cast textObject.AddComponent('GUITexture');
			guiTextureObject.texture = _texture;
			guiTextureObject.color = new Color(0, 0, 0, 0.2);
		}
		guiTextObject.enabled = true;
		guiTextureObject.enabled = true;
		//guiTextObject.text = text;
		guiTextObject.text = WordWrap.wordWrap(text, 10);
		//formatGuiTextArea(guiTextObject, 100);
		
		var r:Rect = guiTextObject.GetScreenRect();
		var w = Screen.width;
		var h = Screen.height;
		guiTextureObject.pixelInset = new Rect(w/2-border,h/2 - r.height-border,-w + r.width + border*2,-h + r.height + border*2);
	}
	
	
	public static function hideText():Void {
		if (textObject == null) return;
		guiTextObject.enabled = false;
		guiTextureObject.enabled = false;
	}
	
	private function OnGUI() {
		if (overed > 0) {
			GUILayout.BeginArea(new Rect(Input.mousePosition.x, Screen.height - Input.mousePosition.y, Screen.width, Screen.height));
			GUILayout.FlexibleSpace();
			GUILayout.Box(text);
			//GUILayout.FlexibleSpace();
			GUILayout.EndArea();
		}
	}
	
}