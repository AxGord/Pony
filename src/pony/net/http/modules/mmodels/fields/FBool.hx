package pony.net.http.modules.mmodels.fields;

import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.net.http.modules.mmodels.Field;

/**
 * FBool
 * @author AxGord
 */
class FBool extends Field {

	public function new()
	{
		super(1);
		type = Types.BIT;
	}
	
	override public function htmlInput(cl:String, act:String, value:String, ?hidden:Null<Bool>):String {
		return
			'<input ' + (cl != null?'class="' + cl + '" ':'') +
			'name="' + model.name + '.' + act + '.' +
			name + '" type="checkbox" value="on" ' + (value != 'on' ? '' : 'checked') +'/>';
	}
	
	override public function create():pony.db.mysql.Field
	{
		return {name: name, length: len, type: type, flags: []};
	}
	
}