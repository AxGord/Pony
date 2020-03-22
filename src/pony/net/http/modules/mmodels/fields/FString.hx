package pony.net.http.modules.mmodels.fields;

import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.net.http.modules.mmodels.Field;

/**
 * FString
 * @author AxGord <axgord@gmail.com>
 */
class FString extends Field {

	public function new(?len:Int=32, hid:Bool = false) {
		super(len, hid);
		type = Types.CHAR;
	}

	override public function htmlInput(cl:String, act:String, value:String, ?hidden:Null<Bool>):String {
		if (hidden == null) hidden = hid;
		var h = hidden ? 'type="hidden" ' : 'type="text" ';
		return
			'<input ' + h + (cl != null?'class="' + cl + '" ':'') +
			'name="' + model.name + '.' + act + '.' +
			name + '" value="'+value+'"/>';
	}

	override public function create():pony.db.mysql.Field
	{
		return {name: name, type: type, length: len, flags: notnull ? [Flags.NOT_NULL] : []};
	}

}