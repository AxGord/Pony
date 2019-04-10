package pony.net.http.modules.mmodels.fields;

import pony.db.mysql.Field;
import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.net.http.modules.mmodels.Field;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;

/**
 * FImg
 * @author AxGord <axgord@gmail.com>
 */
class FImg extends Field {

	public function new(nn:Bool = true)
	{
		super(32);
		isFile = true;
		type = Types.CHAR;
		notnull = nn;
		tplPut = FImgPut;
	}
	
	override public function create():pony.db.mysql.Field
	{
		return {name: name, length: len, type: type, flags: notnull ? [Flags.NOT_NULL] : []};
	}
	
	override public function htmlInput(cl:String, act:String, value:String, ?hidden:Null<Bool>):String {
		return
			'<input ' + (cl != null ? 'class="' + cl + '" ' : '') +
			'name="' + model.name + '.' + act + '.' +
			name + '" type="file" value="' + value + '"/>';
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:keep class FImgPut extends pony.text.tpl.TplPut<FImg, Dynamic> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String 
	{
		return @await sub(this, get(name), FImgPutSub, content);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String 
	{
		return get(name);
	}
	
	@:async
	public function html(f:String):String {
		return '<img src="' + get(f) + '" width="200px"/>';
	}
	
	private function get(f:String):String return '/usercontent/' + Reflect.field(b, f);
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:keep class FImgPutSub extends pony.text.tpl.Valuator<FImgPut, String> {
	
	@:async
	override public function valu(name:String, arg:String):String {
		return switch name {
			case 'orig': b;
			case 'small': 'small_' + b;
			case 'html': '<img src="$b"/>';
			case _: null;
		}
	}
	
}