/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.magic;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import sys.FileSystem;
using pony.macro.Tools;
#end
class Classes
{

	macro public static function dir(pack:String, dir:String):Expr {
		var f:String = Context.getPosInfos(Context.currentPos()).file;
		f = sys.FileSystem.fullPath(f).split('\\').slice(0, -1).join('/') + '/';
		
		var d:String = f + dir + '/';
		trace(d);
		var list:Array<Expr> = [];
		var p:Array<String> = (pack != '' ? pack.split('.') : []).concat(dir.split('/'));
		for (e in FileSystem.readDirectory(d))
			if (e.substr(-3) == '.hx') {
				var ex:Expr = null;
				for (s in p)
					if (ex == null)
						ex = {expr: EConst(CIdent(s)), pos: Context.currentPos()};
					else
						ex = {expr: EField(ex, s), pos: Context.currentPos()};
				trace(e.substr(0, e.length-3));
				ex = {expr: EField(ex, e.substr(0, e.length-3)), pos: Context.currentPos()};
				list.push(ex);
			}
		return {expr: EArrayDecl(list), pos: Context.currentPos()};
	}
	
}