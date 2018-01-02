/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
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