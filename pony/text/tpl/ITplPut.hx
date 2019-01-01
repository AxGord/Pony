package pony.text.tpl;

import pony.text.tpl.Tpl;

/**
 * ITplPut
 * @author AxGord
 */
interface ITplPut {
	var parent:ITplPut;
	function tplData(d:TplData, cb:String->Void):Void;
	function tag(name:String, content:TplData, arg:String, args:Map<String,String>, ?kid:ITplPut, cb:String->Void):Void;
	function shortTag(name:String, arg:String, ?kid:ITplPut, cb:String->Void):Void;
	function sub(o:Dynamic, d:Dynamic, ?cl:Class<ITplPut>, ?content:TplData, cb:String->Void):Void;
}