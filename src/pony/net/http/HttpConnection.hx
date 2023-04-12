package pony.net.http;

import sys.FileSystem;

import pony.fs.File;
import pony.magic.HasAbstract;
import pony.text.ParseBoy;

/**
 * HttpConnection
 * @author AxGord
 */
#if (haxe_ver >= 4.2) abstract #end
class HttpConnection implements HasAbstract {

	private static inline var indexFileShort: String = 'index.htm';
	private static inline var indexFile: String = indexFileShort + 'l';

	public var method: String;
	public var post: Map<String, String>;
	public var fullUrl: String;
	public var url: String;
	public var params: Map<String, String>;
	public var sessionStorage: Map<String, Dynamic>;
	public var host: String;
	public var protocol: String;
	public var languages: Array<String>;
	public var cookie: Cookie;
	public var end: Bool;

	public function new(fullUrl: String) {
		// trace(fullUrl);
		end = false;
		languages = [];
		sessionStorage = new Map<String, Dynamic>();
		this.fullUrl = fullUrl;
		var pb: ParseBoy<Void> = new ParseBoy<Void>(fullUrl);
		pb.gt(['://']);
		protocol = pb.str();
		pb.gt(['/']);
		host = pb.str();
		params = null;
		if (pb.gt(['?']) == 0) {
			url = pb.str();
			params = parseData(pb);
		} else {
			url = pb.str();
			params = new Map<String, String>();
		}
	}

	private function rePost(): Void {
		if (method == 'POST' && params.exists('re')) {
			sessionStorage.set('post', post);
			endAction();
		} else if (sessionStorage.exists('post')) {
			post = sessionStorage.get('post');
			sessionStorage.remove('post');
		}
	}

	public function endAction(): Void goto('/$url');

	@:abstract public function endActionPrevPage(): Void;
	@:abstract public function goto(url: String): Void;
	@:abstract public function error(?message: String): Void;
	@:abstract public function notfound(?message: String): Void;
	@:abstract public function sendFile(file: File): Void;

	private function parseData(pb: ParseBoy<Void>): Map<String, String> {
		var params = new Map<String, String>();
		var loop: Bool = true;
		while (loop) {
			switch (pb.gt(['=', '&'])) {
				case 0:
					var v: String = pb.str();
					if (pb.gt(['&']) == -1) loop = false;
					params.set(v, pb.str());
				case 1:
					var p: String = pb.str();
					if (p != '') params.set(p, null);
				default:
					var p: String = pb.str();
					if (p != '') params.set(p, null);
					loop = false;
			}
		}
		return params;
	}

	public function mix(): Map<String, String> {
		var h = new Map<String, String>();
		for (k in params.keys())
			h.set(k, params.get(k));
		for (k in post.keys())
			h.set(k, post.get(k));
		return h;
	}

	public function sendFileOrIndexHtml(f: String): Void {
		if (FileSystem.exists(f)) {
			if (FileSystem.isDirectory(f)) {
				if (FileSystem.exists(f + indexFileShort))
					sendFile(f + indexFileShort);
				else if (FileSystem.exists(f + indexFile))
					sendFile(f + indexFile);
				else
					notfound();
			} else {
				sendFile(f);
			}
		} else {
			notfound();
		}
	}

}