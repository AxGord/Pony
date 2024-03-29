package pony.net.http.platform.nodejs;

#if (haxe_ver >= '4.0.0')
import js.lib.Error;
#else
import js.Error;
#end
import js.Node;
import js.node.Buffer;
import js.node.Fs;
import js.node.fs.Stats;
import js.node.http.IncomingMessage;
import js.node.http.ServerResponse;
import haxe.io.Bytes;
import pony.fs.File;
import pony.net.http.Cookie;
import pony.net.http.IHttpConnection;
import pony.net.http.ServersideStorage;
import pony.text.ParseBoy;

using Reflect;

/**
 * HttpConnection
 * @author AxGord
 */
@SuppressWarnings('checkstyle:MagicNumber')
class HttpConnection extends pony.net.http.HttpConnection implements IHttpConnection {

	private static var _send(get, never): Dynamic;
	private static var __send: Dynamic;

	private static inline function get__send(): Dynamic return __send != null ? __send : __send = Node.require('send');

	private var res: ServerResponse;
	private var req: IncomingMessage;

	public function new(url: String, storage: ServersideStorage, req: IncomingMessage, res: ServerResponse, post: Map<String, String>) {
		super(url);
		method = req.method;
		this.post = post;
		this.res = res;
		this.req = req;
		if (req.headers.hasField('accept-language')) {
			var pb: ParseBoy<Void> = new ParseBoy<Void>(req.headers.field('accept-language'));
			var n: Int;
			do {
				n = pb.gt([',', ';']);
				var s: String = pb.str();
				if (s.substr(0, 2) == 'q=') continue;
				var a: Array<String> = s.toLowerCase().split('-');
				if (a.length == 1) {
					langPush(a[0] + '-' + a[0]);
					langPush(a[0]);
				} else {
					langPush(a[0] + '-' + a[1]);
					langPush(a[1]);
					langPush(a[0]);
				}
			} while (n != -1);
		}
		cookie = new Cookie(req.headers.get('cookie'));
		sessionStorage = storage.getClient(cookie);
		rePost();
	}

	private function langPush(s: String): Void {
		if (s != '' && Lambda.indexOf(languages, s) == -1) languages.push(s);
	}

	#if (haxe_ver < 4.2) override #end
	public function sendFile(file: File): Void {
		writeCookie();
		var f = file.firstExists;
		Fs.stat(f, function(err: Error, stat: Stats): Void {
			if (err != null) {
				error(err.name);
			} else {
				_send(req, f).pipe(res);
			}
		});
	}

	public function sendBytes(bytes: Bytes): Void {
		writeCookie();
		res.end(new Buffer(bytes.getData()));
	}

	#if (haxe_ver < 4.2) override #end
	public function goto(url: String): Void {
		writeCookie();
		res.setHeader('Location', url);
		res.setHeader('Cache-Control', 'private');
		res.statusCode = 302;
		var t: String = '<html><body><a href="$url">Click here</a></body></html>';
		setLength(t);
		res.end(t);
		end = true;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function setLength(t: String): Void return res.setHeader('Content-Length', Std.string(Buffer.byteLength(t, 'utf8')));

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function setHtmlUtf8(): Void res.setHeader('Content-Type', 'text/html; charset=UTF-8');

	#if (haxe_ver < 4.2) override #end
	public function endActionPrevPage(): Void goto(req.headers.field('referer'));

	#if (haxe_ver < 4.2) override #end
	public function error(?message: String): Void {
		writeCookie();
		setHtmlUtf8();
		res.writeHead(500);
		res.end(message == null ? 'Error' : message);
		end = true;
	}

	#if (haxe_ver < 4.2) override #end
	public function notfound(?message: String): Void {
		writeCookie();
		setHtmlUtf8();
		res.writeHead(404);
		res.end(message == null ? 'Not found' : message);
		end = true;
	}

	public function sendHtml(text: String): Void {
		writeCookie();
		setHtmlUtf8();
		setLength(text);
		res.end(text);
		end = true;
	}

	public function sendText(text: String): Void {
		writeCookie();
		res.setHeader('Content-Type', 'text/plain; charset=UTF-8');
		setLength(text);
		res.end(text);
		end = true;
	}

	private function writeCookie(): Void {
		var s:String = cookie.toString(host.split(':')[0]);
		if (s != '') {
			res.setHeader('Set-Cookie', s);
			//res.setHeader('Cookie Domain', host);
		}
		end = true;
	}

}