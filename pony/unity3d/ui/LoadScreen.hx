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