package pony.net.http;

import pony.fs.File;
import pony.magic.HasAbstract;
import pony.text.ParseBoy;
import sys.FileSystem;

/**
 * HttpConnection
 * @author AxGord
 */
#if (haxe_ver >= 4.2) abstract #end
class HttpConnection implements HasAbstract {

	private static inline final indexFileShort: String = 'index.htm';

	private static inline var indexFile: String = indexFileShort + 'l';

	public var sessionStorage: Map<String, Dynamic> = [];
	public var languages: Array<String> = [];
	public var end: Bool = false;
	public var method: String;
	public var post: Map<String, String>;
	public var fullUrl: String;
	public var url: String;
	public var params: Map<String, String>;
	public var host: String;
	public var protocol: String;
	public var cookie: Cookie;

	public function new(fullUrl: String) {
		// trace(fullUrl);
		this.fullUrl = fullUrl;
		final pb: ParseBoy<Void> = new ParseBoy<Void>(fullUrl);
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
			params = [];
		}
	}

	public function endAction(): Void goto('/$url');

	@:abstract public function endActionPrevPage(): Void;

	@:abstract public function goto(url: String): Void;

	@:abstract public function error(?message: String): Void;

	@:abstract public function notfound(?message: String): Void;

	@:abstract public function sendFile(file: File): Void;

	public function mix(): Map<String, String> {
		final h: Map<String, String> = new Map<String, String>();
		for (k => value in params) h.set(k, value);
		for (k => value in post) h.set(k, value);
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

	private function rePost(): Void {
		if (method == 'POST' && params.exists('re')) {
			sessionStorage['post'] = post;
			endAction();
		} else if (sessionStorage.exists('post')) {
			post = sessionStorage['post'];
			sessionStorage.remove('post');
		}
	}

	private function parseData(pb: ParseBoy<Void>): Map<String, String> {
		final params: Map<String, String> = new Map<String, String>();
		var loop: Bool = true;
		while (loop) {
			switch (pb.gt(['=', '&'])) {
				case 0:
					final v: String = pb.str();
					if (pb.gt(['&']) == -1) loop = false;
					params.set(v, pb.str());
				case 1:
					final p: String = pb.str();
					if (p != '') params.set(p, null);
				case _:
					final p: String = pb.str();
					if (p != '') params.set(p, null);
					loop = false;
			}
		}
		return params;
	}

}
