package pony.text.tpl;

import pony.fs.Dir;
import pony.fs.File;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData.TplStyle;

/**
 * TplDir
 * @author AxGord
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class TplDir {

	private var h:Map<String,Tpl>;
	
	public function new(dir:Dir, ?c:Class<ITplPut>, o:Dynamic, ?s:TplStyle) {
		h = [for (f in dir.contentRecursiveFiles('.tpl'))
			(f.fullDir.toString().length > dir.toString().length ?
			f.fullDir.toString().substr(dir.toString().length+1) + '/' : '') + f.shortName => new Tpl(c, o, f.content)];
	}
	
	inline public function gen(n:String, ?d:Dynamic, ?p:Dynamic, cb:String->Void):Void {
		return h[n].gen(d, p, cb);
	}
	
	public inline function exists(n:String):Bool return h.exists(n);
	
}