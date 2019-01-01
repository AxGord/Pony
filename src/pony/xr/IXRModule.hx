package pony.xr;

import haxe.xml.Fast;

/**
 * @author AxGord <axgord@gmail.com>
 */
interface IXRModule {
	function run(xr:XmlRequest, x:Fast, result:Dynamic->Void):Void;
}