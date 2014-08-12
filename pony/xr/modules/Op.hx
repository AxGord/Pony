/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.xr.modules ;
import haxe.xml.Fast;

/**
 * ...
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