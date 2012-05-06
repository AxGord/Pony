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
package pony.tpl;
import pony.fs.Dir;
import pony.fs.File;
import pony.fs.Files;
import pony.fs.SimpleDir;
import pony.magic.async.AsyncAuto;
import pony.tpl.Tpl;

/**
 * ...
 * @author AxGord
 */

class TplDir implements AsyncAuto
{
	//private var h:Hash<Tpl>;
	private var h:Files<Tpl>;
	
	public function new(dir:Dir, ?c:Class<Dynamic>, o:Dynamic, ?s:TplStyle)
	{
		/*
		h = new Hash<Tpl>();
		//trace(SimpleDir.readFiles(dir.list.first, 'tpl'));
		//trace(dir.file('index.tpl').ext.charAt(2));
		for (f in dir.filesR('tpl')) {
			h.set(f.n, new Tpl(c, o, f.f.content, s));
		}
		*/
		h = new Files<Tpl>(dir, 'tpl', function(f:File):Tpl return new Tpl(c, o, f.content, s) );
	}
	
	@AsyncAuto
	public inline function gen(n:String, ?d:Dynamic, ?p:Dynamic):String {
		return h.get(n).gen(d, p);
	}
	
	public inline function exists(n:String):Bool return h.exists(n)
	
}