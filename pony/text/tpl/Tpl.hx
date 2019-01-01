package pony.text.tpl;

import pony.magic.Declarator;
import pony.text.tpl.Parse;
import pony.text.tpl.style.DefaultStyle;
import pony.text.tpl.TplData;
import pony.text.tpl.ITplPut;

/**
 * Tpl
 * @author AxGord
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class Tpl {
	
	private var data:TplData;
	private var c:Class<ITplPut>;
	private var o:Dynamic;
	
	public function new(?c:Class<ITplPut>, o:Dynamic, t:String, ?s:TplStyle)
	{
		this.c = c;
		this.o = o;
		if (s == null) s = DefaultStyle.get;
		data = Parse.parse(t, s);
	}
	
	@:async
	public function gen(?d:Dynamic, ?p:ITplPut):String {
		return @await go(o, d, p, c, data);
	}
	
	@:async
	public static function go(o:Dynamic, d:Dynamic, p:ITplPut, ?c:Class<ITplPut>, content:TplData):String {
		if (c == null) {
			c = o.tplPut;
			if (c == null)
				throw 'Need tplPut';
		}
		var r:ITplPut = Type.createInstance(c, [o,d,p]);
		return @await r.tplData(content);
	}
	
}