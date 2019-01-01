package pony.net.http;

import haxe.io.Bytes;
import pony.fs.File;

/**
 * IHttpConnection
 * @author AxGord
 */
interface IHttpConnection {

	var method:String;
	var post:Map<String, String>;
	var fullUrl:String;
	var url:String;
	var params:Map<String, String>;
	var sessionStorage:Map<String, Dynamic>;
	var host:String;
	var protocol:String;
	var languages:Array<String>;
	var cookie:Cookie;
	var end:Bool;
	
	function sendFile(file:File):Void;
	function sendBytes(bytes:Bytes):Void;
	function sendFileOrIndexHtml(path:String):Void;
	function endAction():Void;
	function goto(url:String):Void;
	function endActionPrevPage():Void;
	function error(?message:String):Void;
	function notfound(?message:String):Void;
	function sendHtml(text:String):Void;
	function sendText(text:String):Void;
	function mix():Map<String, String>;
	
}