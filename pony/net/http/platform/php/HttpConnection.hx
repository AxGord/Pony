package pony.net.http.platform.php;
import pony.fs.File;
import pony.text.ParseBoy;

/**
 * HttpConnection
 * @author AxGord
 */
class HttpConnection extends pony.net.http.HttpConnection implements IHttpConnection {

	public function new(storage:ServersideStorageDB) 
	{
		post = new Map();
		super('http://' + php.Web.getHostName() + php.Web.getURI() + '?' + php.Web.getParamsString());
		
		method = php.Web.getMethod();
		post = parseData(new ParseBoy<Void>(php.Web.getPostData()));
		
		cookie = new Cookie(php.Web.getCookies());
		sessionStorage = storage.getClient(cookie);
		rePost();
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
	
	override public function endAction():Void {
		writeCookie();
		php.Web.setHeader('Location', '/'+url);
		php.Web.setHeader('Cache-Control', 'private');
		php.Web.setReturnCode(302);
		php.Lib.print('<html><body><a href=".">Click here</a></body></html>');
		end = true;
		
	}
	public function error(?message:String):Void {
		php.Lib.print('Error '+(message!=null?message:''));
		end = true;
	}
	public function sendHtml(text:String):Void {
		writeCookie();
		php.Web.setHeader('Content-Type', 'text/html; charset=utf-8');
		php.Lib.print(text);
		end = true;
	}
	public function sendText(text:String):Void {
		writeCookie();
		php.Lib.print(text);
		end = true;
	}
	
	private function writeCookie():Void {
		var s:String = cookie.toString();
		if (s != '') {
			php.Web.setHeader('Set-Cookie', s);
			php.Web.setHeader('Cookie Domain', host);
		}
		end = true;
	}
}