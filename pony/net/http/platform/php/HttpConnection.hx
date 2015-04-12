package pony.net.http.platform.php;
import pony.fs.File;

/**
 * HttpConnection
 * @author AxGord
 */
class HttpConnection extends pony.net.http.HttpConnection implements IHttpConnection {

	public function new() 
	{
		post = new Map();
		super('http://server'+php.Web.getURI());
	}
	
	public function sendFile(file:File):Void {
		php.Web.setHeader('Content-Description', 'File Transfer');
		php.Web.setHeader('Content-Type', Mime.get[file.ext]);
		//php.Web.setHeader('Content-Disposition', 'attachment; filename=' + file.name);
		php.Web.setHeader('Content-Transfer-Encoding', 'binary');
		php.Web.setHeader('Expires', '0');
		php.Web.setHeader('Cache-Control', 'must-revalidate, post-check=0, pre-check=0');
		php.Web.setHeader('Pragma', 'public');
		php.Web.setHeader('Content-Length', Std.string(file.size));
		untyped __call__('readfile', file.firstExists);
		untyped __call__('exit');
		
	}
	public function endAction():Void {}
	public function error(?message:String):Void php.Lib.print('Error '+(message!=null?message:''));
	public function sendHtml(text:String):Void {
		php.Web.setHeader('Content-Type', 'text/html; charset=utf-8');
		php.Lib.print(text);
	}
	public function sendText(text:String):Void php.Lib.print(text);
}