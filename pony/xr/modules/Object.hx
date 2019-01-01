package pony.xr.modules;

import haxe.xml.Fast;

using Reflect;

/**
 * Object
 * @author AxGord <axgord@gmail.com>
 */
class Object implements IXRModule {

	public function new() {}
	
	public function run(xr:XmlRequest, x:Fast, result:Dynamic->Void):Void {
		var a = [for (e in x.elements) e];
		var counter = 0;
		var r:Dynamic = { };
		for (i in 0...a.length) {
			if (a[i].name != 'e' || !a[i].has.n) {
				xr._error('Wrong tag');
				return;
			}
			xr.rf(a[i], function(v:Dynamic) {
				r.setField(a[i].att.n, v);
				if (++counter == a.length) {
					result(r);
				}
			});
		}
	}
}