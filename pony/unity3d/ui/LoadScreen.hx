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


import pony.Loader;
import pony.unity3d.Fixed2dCamera;
import unityengine.GameObject;
import unityengine.GUITexture;
import unityengine.MonoBehaviour;
import unityengine.Object;
import unityengine.Rect;
import unityengine.Texture;
import unityengine.Vector3;
using hugs.HUGSWrapper;

/**
 * LoadScreen
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class LoadScreen extends MonoBehaviour {
	
	public static var lastLoader:Loader = null;
	
	public var fastLoad:Bool = false;
	
	private var background:Texture;
	private var main:Texture;
	
	private var bgTextureObject:GameObject;
	private var mainTextureObject:GameObject;
	private var up:GameObject;
	
	private var progress:ProgressBar;
	public var loader:Loader;
	
	public function new() {
		super();
		loader = new Loader(1, 100);
		LoadScreen.lastLoader = loader;
	}
	
	private function Start():Void {
		#if !debug
			fastLoad = false;
		#end
		
		Fixed2dCamera.visible = false;
		
		if (background != null) {
			bgTextureObject = new GameObject("GUITexture LoadScreen Background");
			var guiTextureObject:GUITexture = cast bgTextureObject.AddComponent('GUITexture');
			guiTextureObject.texture = background;
			bgTextureObject.transform.position = new Vector3(0.5, 0.5, 100);
		}
		
		if (main != null) {
			mainTextureObject = new GameObject("GUITexture LoadScreen Main");
			var mguiTextureObject:GUITexture = cast mainTextureObject.AddComponent('GUITexture');
			mguiTextureObject.texture = main;
			mguiTextureObject.transform.localScale = new Vector3(0, 0);
			mguiTextureObject.pixelInset = new Rect(-main.width/2, -main.height/2, main.width, main.height);
			mainTextureObject.transform.position = new Vector3(0.5, 0.5, 101);
		}
		
		if (progress != null) {
			loader.onProgress.add(progress.set);
		}
		loader.onComplete.once(end);
		loader.init(fastLoad);
	}
	
	public function end():Void {
		Fixed2dCamera.visible = true;
		if (bgTextureObject != null) Object.Destroy(bgTextureObject);
		if (mainTextureObject != null) Object.Destroy(mainTextureObject);
		if (progress != null) {
			loader.onProgress.remove(progress.set);
			Object.Destroy(progress.gameObject);
		}
		if (up != null) Object.Destroy(up);
	}
	
}