package pony.net.http.modules.mmodels.fields;

import pony.net.http.modules.mmodels.Field;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;

/**
 * FText
 * @author AxGord <axgord@gmail.com>
 */
class FText extends Field {

	public function new(?len:Int, notnull:Bool=true)
	{
		super(len);
		this.notnull = notnull;
		type = 'Text';
		tplPut = CTextPut;
	}
	
	override public function htmlInput(cl:String, act:String, value:String, hidden:Bool=false):String {
		return
			'<textarea ' + (cl != null?'class="' + cl + '" ':'') +
			'name="' + model.name + '.' + act + '.' +
			name + '">'+value+'</textarea>';
	}
	
}

/**
 * CTextPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:keep class CTextPut extends pony.text.tpl.TplPut<FText, Dynamic> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String 
	{
		if (args.exists('noesc'))
			return Reflect.field(b, name);
		else
			return @await html(name);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String 
	{
		return @await tag(name, [], arg, new Map(), kid);
	}
	
	@:async
	public function html(f:String):String {
		return StringTools.replace(StringTools.htmlEscape(Std.string(Reflect.field(b, f))), '\r\n', '<br/>');
	}
	
}