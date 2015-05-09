package pony.net.http.platform.php;

/**
 * HttpServer
 * @author AxGord
 */
class HttpServer 
{

	public function new(host:String=null, port:Int=80, ?spdyConf:Dynamic) 
	{
		
	}
	
	public dynamic function request(connection:IHttpConnection):Void {
		connection.sendText('Hell world');
	}
	
	public function run(storage:ServersideStorageDB):Void {
		request(new HttpConnection(storage));
		storage.save();
	}
	
}