package pony.net.http.modules.mmodels.fields;
import pony.db.mysql.Flags;
import pony.db.mysql.Types;

/**
 * FInt
 * @author AxGord
 */
class FInt extends Field
{

	public function new(?len:Int=10)
	{
		super(len);
		type = Types.INT;
	}
	
	override public function htmlInput(cl:String, act:String, value:String):String {
		return
			'<input ' + (cl != null?'class="' + cl + '" ':'') +
			'name="' + model.name + '.' + act + '.' +
			name + '" type="text" value="'+value+'"/>';
	}
	
	override public function create():pony.db.mysql.Field
	{
		return {name: name, length: len, type: type, flags: notnull ? [Flags.UNSIGNED, Flags.NOT_NULL] : [Flags.UNSIGNED]};
	}
	
}