package pony.xr;

import haxe.xml.Fast;
import pony.ICanBeCopied;
import pony.Logable;
import pony.xr.modules.V;

using pony.Tools;
using pony.text.TextTools;

/**
 * XmlRequest
 * @author AxGord <axgord@gmail.com>
 */
class XmlRequest extends Logable<XmlRequest> implements ICanBeCopied<XmlRequest> {
	
	public var modules:Map<String, IXRModule>;
	
	public function new(modules:Array<IXRModule>) {
		this.modules = [ for (m in modules) Type.getClassName(Type.getClass(m)).split('.').last().toLowerCase() => m ];
		super();
	}
	
	public function copy():XmlRequest {
		var o = new XmlRequest([]);
		o.modules = [ for (m in modules.mkv()) m.key => (Std.is(m.value, ICanBeCopied) ? untyped m.value.copy() : m.value) ];
		o.error.add(error, 1);
		o.log.add(log);
		return o;
	}
	
	inline public function run(x:Fast, initModules:Array < Class<Dynamic>->IXRModule->Void >, result:Dynamic->Void, ?gxr:XmlRequest->Void):Void {
		var xr = copy();
		if (gxr != null) gxr(xr);
		for (m in xr.modules.mkv()) if (Std.is(m.value, ICanBeCopied)) for (im in initModules) im(Type.getClass(m.value), m.value);
		var it = x.elements;
		if (!it.hasNext()) {
			_error('Empty');
			return;
		}
		function next(v:Dynamic):Void if (it.hasNext()) xr._run(it.next(), next) else result(v);
		xr._run(it.next(), next);
	}
	
	public function _run(x:Fast, result:Dynamic->Void):Void {
		if (!modules.exists(x.name)) {
			_error('Unknown module: ' + x.name);
		} else
			modules[x.name].run(this, x, result);
	}
	
	public function rf(x:Fast, result:Dynamic->Void):Void {
		var it = x.elements;
		if (it.hasNext()) {
			var e = it.next();
			if (it.hasNext()) _error('Not single node');
			else _run(e, result);
		} else {
			var d:String = try {
				x.innerData;
			} catch (_:Dynamic) null;
			try {
				if (d == null) result(null);
				else {
					if (d.charAt(0) == '%' && d.last() == '%') {
						var d = d.substr(1, d.length - 2);
						var m:V = cast modules['v'];
						result(m.values[d]);
					} else
						result(d);
				}
			} catch (e:Dynamic) _error(e);
		}
	}
	
	public function ab(x:Fast, result:Dynamic->Dynamic->Void):Void {
		var it = x.elements;
		if (it.hasNext()) {
			var e = it.next();
			if (!it.hasNext()) {
				_error('Not two node');
				return;
			}
			var e2 = it.next();
			if (it.hasNext()) _error('Not two node');
			else {
				var ready:Bool = false;
				var r:Dynamic = null;
				_run(e, function(d:Dynamic) {
					if (ready) {
						result(d, r);
					} else {
						r = d;
						ready = true;
					}
				} );
				_run(e2, function(d:Dynamic) {
					if (ready) {
						result(r, d);
					} else {
						r = d;
						ready = true;
					}
				} );
			}
		} else {
			_error('Not two node');
		}
	}
	
}