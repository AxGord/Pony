package pony.text.tpl;

import pony.fs.Dir;
import pony.fs.File;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData.TplStyle;

/**
 * TplDir
 * @author AxGord
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class TplDir {

	private final h: Map<String, Tpl> = [];

	public function new(dir: Dir, ?c: Class<ITplPut>, o: Dynamic, ?s: TplStyle) {
		for (f in dir.contentRecursiveFiles('.tpl')) {
			for (e in f.fullDir) {
				var brk: Bool = false;
				for (d in dir) {
					final l: Int = d.toString().length;
					if (e.toString().substr(0, l) != d.toString()) continue;
					var k = e.toString().substr(l + 1);
					if (k.length > 0) k += '/';
					final n: String = f.shortName;
					if (n == '') break; // skip empty name
					h[k + n] = new Tpl(c, o, f.content);
					brk = true;
					break;
				}
				if (brk) break;
			}
		}
	}

	public inline function gen(n: String, ?d: Dynamic, ?p: Dynamic, cb: String -> Void): Void {
		return h[n].gen(d, p, cb);
	}

	public inline function exists(n: String): Bool {
		return h.exists(n);
	}

}
