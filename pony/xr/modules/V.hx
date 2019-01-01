package pony.xr.modules;

import haxe.xml.Fast;
import pony.ICanBeCopied;

/**
 * V
 * @author AxGord <axgord@gmail.com>
 */
class V implements IXRModule implements ICanBeCopied<V> {

	public var values:Map<String, Dynamic> = new Map();
	
	public function new() {
		
	}
	
	public function run(xr:XmlRequest, x:Fast, result:Dynamic->Void):Void {
		if (x.has.set) {
			xr.rf(x, function(v:Dynamic) result(values[x.att.set] = v));
		} else if (x.has.get) {
			xr.rf(x, function(_) result(values[x.att.get]) );
			
		} else {
			xr.rf(x, result);
		}
	}
	
	public function copy():V {
		var o = new V();
		o.values = values;
		return o;
	}
	
}