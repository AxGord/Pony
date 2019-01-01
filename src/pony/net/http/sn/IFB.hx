package pony.net.http.sn;

/**
 * @author AxGord
 */
interface IFB 
{
	function api(token:String, r:String, cb:Dynamic->Void):Void;
	function me(token:String, cb:FBData->Void):Void;
}