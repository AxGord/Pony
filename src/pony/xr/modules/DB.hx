package pony.xr.modules;

import haxe.xml.Fast;
import pony.db.mysql.MySQL;
import pony.db.mysql.Table;

/**
 * @author AxGord <axgord@gmail.com>
 */
class DB implements IXRModule implements ICanBeCopied<DB> {

	public var source:Dynamic<MySQL>;
	public var table:Table;
	
	public function new(source:Dynamic<MySQL>) {
		this.source = source;
	}
	
	inline public function setTable(name:String):Void table = source.resolve(name);
	
	inline public function copy():DB return new DB(source);
	
	public function run(xr:XmlRequest, x:Fast, result:Dynamic->Void):Void {
		var n = x.has.n ? x.att.n : 'default';
		var table = x.has.table ? x.att.table : table;
		var mode = x.has.mode ? x.att.mode : 'stream';
		//todo
	}
	
}