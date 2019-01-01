package pony.text.tpl;

import haxe.xml.Fast;
import pony.fs.Dir;
import pony.fs.File;
import pony.text.tpl.TplSystem;

/**
 * Templates
 * @author AxGord
 */
class Templates {
	
	private var list:Map<String, TplSystem>;

	public function new(dir:Dir, ?c:Class<ITplPut>, o:Dynamic) {
		list = new Map<String, TplSystem>();
		var td:Dir = dir + 'templates';
		for (d in td.dirs()) {
			var mf:File = d + 'manifest.xml';
			if (mf.exists) {
				var manifest:Manifest = TplSystem.parseManifest(mf);
				if (manifest.title == null) manifest.title = d.name;
				for (e in manifest._extends) {
					//d.list.repriority(1);
					//d.list.change(d.list.first, -1);
					d.addWayArray(td + e);
				}
				//trace(d);
				var ts:TplSystem = new TplSystem(d, c, o);
				ts.manifest = manifest;
				list.set(d.name, ts);
			} else
				list.set(d.name, new TplSystem(d, c, o));
		}
	}
	
	public inline function exists(key:String):Bool return list.exists(key);
	
	public inline function get(key:String):TplSystem return list.get(key);
	
	public inline function iterator():Iterator<TplSystem> {
		return list.iterator();
	}
	
}