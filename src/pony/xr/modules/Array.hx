package pony.xr.modules;

import haxe.xml.Fast;

/**
 * @author AxGord <axgord@gmail.com>
 */
class Array implements IXRModule {

	public function new() {}
	
	public function run(xr:XmlRequest, x:Fast, result:Dynamic->Void):Void {
		var a = [for (e in x.elements) e];
		var counter = 0;
		var r = [];
		for (i in 0...a.length) {
			xr._run(a[i], function(v:Dynamic) {
				r[i] = v;
				if (++counter == a.length) {
					result(r);
				}
			});
		}
	}
	
}