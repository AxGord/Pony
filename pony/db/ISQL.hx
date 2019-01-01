package pony.db;

import haxe.PosInfos;
import pony.db.mysql.Field;
import pony.events.WaitReady;
import pony.ILogable;

/**
 * @author AxGord <axgord@gmail.com>
 */
interface ISQL extends ILogable
{
	var connected:WaitReady;
	var hack:String;
	function escapeId(s:String):String;
	function escape(s:String):String;
	function destroy():Void;
	function stream(q:String, ?p:PosInfos):Stream<Dynamic>;
	function query(q:String, ?p:PosInfos, cb:Dynamic->Dynamic->Array<Field>->Void):Void;
	function action(q:String, ?actName:String, ?p:PosInfos, result:Bool->Void):Void;
}