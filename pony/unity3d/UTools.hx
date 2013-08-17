/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import unityengine.Behaviour;
import unityengine.GameObject;
import unityengine.QualitySettings;
import unityengine.Screen;

/**
 * UTools
 * @author AxGord <axgord@gmail.com>
 */
class UTools {


	public static function init(key:String='', camera:String='/Camera', defWidth:Int=800, defHeight:Int=600):Bool {
		var args: { reg:Bool, quality:String, width:String, height:String } = getArgs(['quality', 'width', 'height'], key==''?{}:{ reg:key } );
		if (!args.reg) {
			//Application.Quit();
			return false;
		}
		var cfg: { quality:Int, width:Int, height:Int } = { quality:Std.parseInt(args.quality), width:Std.parseInt(args.width), height:Std.parseInt(args.height) };
		QualitySettings.SetQualityLevel(cfg.quality);
		
		if (cfg.width > 0 && cfg.height > 0)
			Screen.SetResolution(cfg.width, cfg.height, true);
		else
			Screen.SetResolution(defWidth, defHeight, false);
			
		if (camera == null) return true;
		var cam:GameObject = GameObject.Find(camera);
		if (cam == null) return true;
		compEnabled(cam, 'AntialiasingAsPostEffect', cfg.quality >= 1);
		compEnabled(cam, 'NoiseAndGrain', compEnabled(cam, 'DepthOfFieldScatter', compEnabled(cam, 'BloomAndLensFlares', cfg.quality == 2)));
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
		var a:NativeArray<String> = dotnet.system.Environment.GetCommandLineArgs();
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