package pony.net.http;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * WebServerPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class WebServerPut extends TplPut<WebServer, CPQ> {
	
	private var t:ITplPut;
	
	public function new(o:WebServer, d:CPQ, parent:ITplPut) {
		super(o, d, parent);
		t = parent;
		for (m in d.modules) {
			t = m.tpl(t);
		}
	}
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		return @await t.tag(name, content, arg, args, kid);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		return @await t.shortTag(name, arg, kid);
	}
	
}