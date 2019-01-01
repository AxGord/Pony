package pony.unity3d;

import cs.NativeArray;
import unityengine.Behaviour;
import unityengine.GameObject;
import unityengine.QualitySettings;
import unityengine.Screen;

/**
 * UTools
 * Tools for unity3d
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class UTools {

	public static function init(key:String='', camera:String='/Camera', defWidth:Int=800, defHeight:Int=600, fs:Bool=true):Bool {
		var args: { reg:Bool, quality:String, width:String, height:String } = getArgs(['quality', 'width', 'height'], key==''?{}:{ reg:key } );
		if (key.length > 0 && !args.reg) {
			//Application.Quit();
			return false;
		}
		var cfg: { quality:Int, width:Int, height:Int } = { quality:Std.parseInt(args.quality), width:Std.parseInt(args.width), height:Std.parseInt(args.height) };
		QualitySettings.SetQualityLevel(cfg.quality);
		
		if (cfg.width > 0 && cfg.height > 0)
			Screen.SetResolution(cfg.width, cfg.height, fs);
		else
			Screen.SetResolution(defWidth, defHeight, false);
			
		if (camera == null) return true;
		var cam:GameObject = GameObject.Find(camera);
		if (cam == null) return true;
		compEnabled(cam, 'AntialiasingAsPostEffect', cfg.quality >= 1);
		compEnabled(cam, 'NoiseAndGrain', compEnabled(cam, 'DepthOfFieldScatter', compEnabled(cam, 'BloomAndLensFlares', compEnabled(cam, 'NoiseAndGrain', compEnabled(cam, 'DepthOfFieldScatter', compEnabled(cam, 'SSAOEffect', cfg.quality == 2))))));
		return true;
	}
	
	public static function getArgs(?vs:Array<String>, ?ks:Dynamic<String>):Dynamic {
		var r:Dynamic = { };
		var vls:Map<String,String> = new Map<String,String>();
		if (ks != null) for (f in Reflect.fields(ks)) {
			Reflect.setField(r, f, false);
			vls.set('-'+Reflect.field(ks, f), f);
		}
		var pvs:Array<String> = [];
		if (vs != null) {
			for (v in vs) {
				Reflect.setField(r, v, null);
				pvs.push('-' + v);
			}
		}
		var a:NativeArray<String> = cs.system.Environment.GetCommandLineArgs();
		var skip:Bool = true;
		for (i in 0...a.Length) if (skip) skip = false; else {
			if (Lambda.indexOf(pvs, a[i]) != -1) {
				Reflect.setField(r, a[i].substr(1), a[i+1]);
				skip = true;
			} else if (vls.exists(a[i])) {
				Reflect.setField(r, vls.get(a[i]), true);
			}
		}
		return r;
	}
	
	public static function compEnabled(g:GameObject, name:String, enabled:Bool):Bool {
		var c:Behaviour = cast(g.GetComponent(name), Behaviour);
		if (c != null) c.enabled = enabled;
		return enabled;
	}
	
}