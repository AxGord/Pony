/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import neko.FileSystem;
import pony.fs.SimplePath;
import pony.macro.MacroExtensions;

using pony.macro.MacroExtensions;
#end
class Classes
{

	@:macro public static function dir(pack:String, dir:String):Expr {
		MacroExtensions.pos = null;
		var d:String = SimplePath.dir(Inform.file()) + dir + '/';
		var list:Array<Expr> = [];
		var p:Array<String> = (pack != '' ? pack.split('.') : []).concat(dir.split('/'));
		for (e in FileSystem.readDirectory(d))
			if (SimplePath.ext(e) == 'hx') {
				var ex:Expr = null;
				for (s in p)
					if (ex == null)
						ex = EConst(CIdent(s)).expr();
					else
						ex = EField(ex, s).expr();
				ex = EType(ex, SimplePath.withoutExtension(e)).expr();
				list.push(ex);
			}
		return EArrayDecl(list).expr();
	}
	
}