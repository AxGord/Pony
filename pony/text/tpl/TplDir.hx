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
package pony.text.tpl;
import pony.fs.Dir;
import pony.fs.File;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData.TplStyle;

/**
 * TplDir
 * @author AxGord
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class TplDir
{
	private var h:Map<String,Tpl>;
	
	public function new(dir:Dir, ?c:Class<ITplPut>, o:Dynamic, ?s:TplStyle)
	{
		h = [for (f in dir.contentRecursiveFiles('.tpl'))
			(f.fullDir.toString().length > dir.toString().length ?
			f.fullDir.toString().substr(dir.toString().length+1) + '/' : '') + f.shortName => new Tpl(c, o, f.content)];
	}
	
	inline public function gen(n:String, ?d:Dynamic, ?p:Dynamic, cb:String->Void):Void {
		return h[n].gen(d, p, cb);
	}
	
	public inline function exists(n:String):Bool return h.exists(n);
	
}