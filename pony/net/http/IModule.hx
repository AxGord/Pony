package pony.net.http;

import pony.fs.Dir;
import pony.text.tpl.ITplPut;
import pony.net.http.WebServer;

/**
 * IModule
 * @author AxGord
 */
interface IModule {
	function connect(cpq:CPQ):EConnect;
	function init(dir:Dir, server:WebServer):Void;
}