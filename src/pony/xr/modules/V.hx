package pony.xr.modules;

import haxe.xml.Fast;
import pony.ICanBeCopied;

/**
 * V
 * @author AxGord <axgord@gmail.com>
 */
class V implements IXRModule implements ICanBeCopied<V> {

	public var values: Map<String, Dynamic> = [];

	public function new() {}

	public function run(xr: XmlRequest, x: Fast, result: Dynamic -> Void): Void {
		xr.rf(
			x,
			if (x.has.set)
				function(v: Dynamic) result(values[x.att.set] = v)
			else if (x.has.get)
				function(_) result(values[x.att.get])
			else
				result
		);
	}

	public function copy(): V {
		final o: V = new V();
		o.values = values;
		return o;
	}

}
