package pony.net.http.modules.mmodels;

import pony.db.mysql.Field;
import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.text.tpl.ITplPut;

/**
 * Field
 * @author AxGord <axgord@gmail.com>
 */
class Field {

	public var name:String;
	public var model:Model;
	public var type:Types;
	public var notnull:Bool;
	public var len:Int;
	public var hid(default, null):Bool;
	public var isFile:Bool = false;
	
	public var tplPut:Class<ITplPut> = null;
	
	public function new(?len:Int, ?hid:Bool) {
		type = Types.TEXT;
		notnull = false;
		this.len = len;
		this.hid = hid;
	}
	
	public function init(name:String, model:Model):Void {
		this.name = name;
		this.model = model;
		//trace(name);
	}
	
	public function htmlInput(cl:String, act:String, value:String, ?hidden:Null<Bool>):String {
		return '';
	}
	
	public function create():pony.db.mysql.Field {
		return {name: name, type: type, flags: notnull ? [Flags.NOT_NULL] : [], length: len};
	}
	
}