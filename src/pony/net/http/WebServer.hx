package pony.net.http;

import pony.fs.Dir;
import pony.fs.Unit;
import pony.text.tpl.Templates;

typedef Defaults = { template: String, lang: String }

enum EConnect {
	BREAK;
	NOTREG;
	REG(m: ModuleConnect<IModule>);
}

/**
 * WebServer
 * @author AxGord
 */
class WebServer {

	public var modules: Array<IModule>;
	public var tpl: Templates;
	public var _static: Dir;
	public var defaults: Defaults;
	public var usercontent: String;

	public function new(dir: Dir, usercontent: String, modules: Array<IModule>, ?defaults: Defaults) {
		this.usercontent = usercontent;
		this.defaults = defaults != null ? defaults : { template: 'Default', lang: 'en' };
		this.modules = modules;
		tpl = new Templates(dir, WebServerPut, this);
		_static = '${dir}static';
		for (m in modules) m.init(dir, this);
	}

	public function connect(connection: IHttpConnection): Void {
		if (connection.end) return;
		if (connection.url != '' && sendStatic(connection)) return;
		final cpq = new CPQ(connection, usercontent, tpl.get(defaults.template), defaults.lang);
		for (m in modules) {
			switch m.connect(cpq) {
				case BREAK:
					return;
				case REG(obj):
					cpq.modules[Type.getClassName(Type.getClass(obj))] = obj;
				case NOTREG:
			}
		}
		cpq.run();
	}

	private function sendStatic(connection: IHttpConnection): Bool {
		final u: Unit = _static + connection.url;
		if (u.exists) {
			connection.sendFile(u);
			return true;
		}
		final a: Array<String> = connection.url.split('/');
		if (a[0] == 'tpl') {
			a.shift();
			final t: String = a.shift();
			final p: String = a.join('/');
			if (!tpl.exists(t))
				connection.error('Not exists template: $t');
			else if (tpl.get(t)._static.exists(p))
				connection.sendFile(tpl.get(t)._static.get(p));
			else
				connection.error('Not found');
			return true;
		}
		if (a[0] == usercontent) {
			a.shift();
			final p: String = a.join('/');
			final u: Unit = '$usercontent/$p';
			if (u.exists)
				connection.sendFile(u);
			else
				connection.error('Not found');
			return true;
		}
		return false;
	}

}
