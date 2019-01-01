package pony.xr.modules;

import haxe.xml.Fast;

/**
 * Op
 * @author AxGord <axgord@gmail.com>
 */
class Op implements IXRModule {

	public function new() {
		
	}
	
	public function run(xr:XmlRequest, x:Fast, result:Dynamic->Void):Void {
		switch x.att.n {
			case 'sqrt': xr.rf(x, function(v:Dynamic) result(Math.sqrt(number(v))) );
			case 'sum', '+':
				var a = [for (e in x.elements) e];
				var counter = 0;
				var sum:Float = 0;
				for (i in 0...a.length) {
					xr._run(a[i], function(v:Dynamic) {
						sum += number(v);
						if (++counter == a.length) {
							result(sum);
						}
					});
				}
			case 'neg', '-': xr.rf(x, function(v:Dynamic) result( -number(v)) );
			case '/': xr.ab(x, function(a:Dynamic, b:Dynamic) result(a / b));
			case '*':
				var a = [for (e in x.elements) e];
				var counter = 0;
				var sum:Float = 0;
				for (i in 0...a.length) {
					xr._run(a[i], function(v:Dynamic) {
						if (counter == 0)
							sum = number(v);
						else
							sum *= number(v);
						if (++counter == a.length) {
							result(sum);
						}
					});
				}
			case _: xr._error('Unknown operation '+x.att.n);
		}
	}
	
	inline public static function number(v:Dynamic):Float return Std.is(v, String) ? Std.parseFloat(v): v;
	
}