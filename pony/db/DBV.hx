/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.db;

private enum DBVT {
	TInt; TString; TFun(fun:DBVF); TNull;
}

private enum DBVF {
	FNow;
}

/**
 * DBV
 * @author AxGord
 */
abstract DBV({type:DBVT, ?val:Dynamic})
{

	public static var NULL(get, never):DBV;
	public static var NOW(get, never):DBV;
	
	@:extern inline private function new(v) this = v;
	
	public function get(f:String->String):String {
		return switch this.type {
			case TString: f(this.val);
			case TInt: Std.string(this.val);
			case TFun(FNow): 'NOW()';
			case TNull: 'NULL';
		}
	}
	
	@:from @:extern inline public static function fromInt(v:Int):DBV return new DBV({type:TInt, val: v});
	@:from @:extern inline public static function fromString(v:String):DBV return new DBV({type:TString, val: v});
	@:extern inline private static function get_NOW():DBV return new DBV({type:TFun(FNow)});
	@:extern inline private static function get_NULL():DBV return new DBV({type:TNull});
	
}