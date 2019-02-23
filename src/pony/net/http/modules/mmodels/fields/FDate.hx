package pony.net.http.modules.mmodels.fields;

import pony.db.mysql.Field;
import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.net.http.modules.mmodels.Field;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;

/**
 * FDate
 * @author AxGord <axgord@gmail.com>
 */
class FDate extends Field {

	public function new(nn:Bool = true)
	{
		super();
		type = Types.INT;
		len = 10;
		notnull = nn;
		tplPut = CDatePut;
	}
	
	override public function create():pony.db.mysql.Field
	{
		return {name: name, length: len, type: type, flags: notnull ? [Flags.UNSIGNED, Flags.NOT_NULL] : [Flags.UNSIGNED]};
	}
	
}

/**
 * CDatePut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:keep class CDatePut extends pony.text.tpl.TplPut<FDate, Dynamic> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String 
	{
		var v = Date.fromTime(Std.int(Reflect.field(b, name))*1000);
		if (content.length == 1) switch content[0] {
			case TplContent.Text(t) if (t != ''):
				return DateTools.format(v, StringTools.replace(t,'$','%'));
			case _:
				return v.toString();
		} else
			return v.toString();
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String 
	{
		return @await tag(name, [], arg, new Map(), kid);
	}
	
	@:async
	public function html(f:String):String {
		var v = Date.fromTime(Std.int(Reflect.field(b, f))*1000);
		return v.toString();
	}
	
}