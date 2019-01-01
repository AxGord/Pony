package pony.net.http;

/**
 * HttpTools
 * @author AxGord
 */
class HttpTools {

	public static var get:String->(String->Void)->Void =
	#if nodejs
	pony.net.http.platform.nodejs.HttpTools.get;
	#else
	null;
	#end
	
	public static var getJson:String->(Dynamic->Void)->Void =
	#if nodejs
	pony.net.http.platform.nodejs.HttpTools.getJson;
	#elseif js
	pony.net.http.platform.js.HttpTools.getJson;
	#else
	null;
	#end
}