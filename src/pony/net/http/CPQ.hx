package pony.net.http;

import pony.magic.Declarator;
import pony.text.tpl.TplSystem;

/**
 * CPQ
 * @author AxGord <axgord@gmail.com>
 */
class CPQ implements Declarator {

	@:arg public var connection: IHttpConnection;
	@:arg public var usercontent: String;
	public var page: String = '';
	public var query: Array<String> = [];
	@:arg public var template: TplSystem;
	@:arg public var lang: String;
	public var modules: Map<String, ModuleConnect<IModule>> = new Map<String, ModuleConnect<IModule>>();

	public function run(): Void {
		var a: Array<String> = connection.url.split('/');
		var u: Array<String> = [];
		while (a.length != 0) {
			var n: String = a.join('/');
			if (template.exists(n + '/index')) {
				page = n;
				query = u;
				tpl(n + '/index');
				return;
			} else if (template.exists(n)) {
				page = n;
				query = u;
				tpl(n);
				return;
			} else
				u.unshift(a.pop());
		}
		if (template.exists('index')) {
			query = u;
			tpl('index');
		} else
			error('Not exists index.tpl');
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function tpl(name: String): Void template.gen(name, this, connection.sendHtml);

	public function error(message: String): Void connection.error(message);

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function getModule<T>(cl: Class<T>): T return cast modules[Type.getClassName(cl)];

}