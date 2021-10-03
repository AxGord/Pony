package pony.text.tpl;

import pony.text.tpl.Tpl;
import pony.text.tpl.TplPut;
import pony.text.tpl.ValuePut;

/**
 * Valuator
 * @author AxGord
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class Valuator<C1, C2> extends TplPut<C1, C2> {

	public function new(data:C1, datad:C2, parent:ITplPut = null) {
		super(data, datad, parent);
	}

	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		var b:Null<Bool> = @await valuBool(name);
		if (b != null) {
			if (args.exists('!'))
				return b ? '' : @await tplData(content);
			else
				return b ? @await tplData(content) : '';
		} else {
			var v:String = @await valu(name, arg);
			if (v != null) {
				if (args.exists('htmlEscape'))
					v = StringTools.htmlEscape(v);
				if (v == '') {
					if (args.exists('!'))
						return @await tplData(content);
					else
						return '';
				} else if (!args.exists('!'))
					return @await sub(v, null, ValuePut, content);
				else
					return '';
			} else
				return @await super.tag(name, content, arg, args, kid);
		}
	}

	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		var v:String = @await valu(name, arg);
		if (v != null)
			return v;
		else
			return @await super.shortTag(name, arg, kid);
	}

	@:async
	public function valu(name:String, arg:String):String {
		return null;
	}

	@:async
	public function valuBool(name:String):Null<Bool> {
		return null;
	}

}