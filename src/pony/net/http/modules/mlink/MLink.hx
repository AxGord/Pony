package pony.net.http.modules.mlink;

import pony.fs.Dir;
import pony.net.http.WebServer.EConnect;

/**
 * MLink
 * @author AxGord <axgord@gmail.com>
 */
@:final class MLink implements IModule
{

	public function new() {}
	
	public function init(dir:Dir, server:WebServer):Void {}
	
	public function connect(cpq:CPQ):EConnect return REG(cast new MLinkConnect(this, cpq));
	
}