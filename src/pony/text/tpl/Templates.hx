package pony.text.tpl;

import pony.fs.Dir;
import pony.fs.File;
import pony.text.tpl.TplSystem;

/**
 * Templates
 * @author AxGord
 */
class Templates {

	private final list: Map<String, TplSystem>;

	public function new(dir: Dir, ?c: Class<ITplPut>, o: Dynamic) {
		list = [];
		final td: Dir = dir + 'templates';
		for (d in td.dirs()) {
			final mf: File = d + 'manifest.xml';
			if (mf.exists) {
				final manifest: Manifest = TplSystem.parseManifest(mf);
				if (manifest.title == null) manifest.title = d.name;
				for (e in manifest._extends) {
					// d.list.repriority(1);
					// d.list.change(d.list.first, -1);
					d.addWayArray(td + e);
				}
				// trace(d);
				final ts: TplSystem = new TplSystem(d, c, o);
				ts.manifest = manifest;
				list[d.name] = ts;
			} else
				list[d.name] = new TplSystem(d, c, o);
		}
	}

	public inline function exists(key: String): Bool return list.exists(key);

	public inline function get(key: String): TplSystem return list[key];

	public inline function iterator(): Iterator<TplSystem> {
		return list.iterator();
	}

}
