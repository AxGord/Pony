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
package pony.fs;

/**
 * ...
 * @author AxGord
 */

class Files<T>
{
	private var list:Hash<T>;
	
	public function new(dir:Dir, ?er:EReg, ?ext:String, ?reg:File->T)
	{
		if (reg == null) reg = ret;
		list = new Hash<T>();
		for (f in dir.filesR(er, ext)) {
			add(f.n, f.f, reg);
		}
		dir.onAddFileR.addListener(function(n:String, f:File):Void {
			n = n.substr(n.indexOf('/') + 1);
			if (
					(ext == null || SimplePath.ext(n) == ext) &&
					(er == null || er.match(n))
				) {
					if (ext != null) {
						n = SimplePath.withoutExtension(n);
					}
					trace('Add file: '+n);
					add(n, f, reg);
				}
		});
	}
	
	public inline function get(key:String):T return list.get(key)
	
	public inline function exists(key:String):Bool return list.exists(key)
	
	private function ret(f:File):T return cast f
	
	private function add(name:String, file:File, func:File-> T):Void {
		list.set(name, func(file));
		var r:Void->Void = null, u:Void->Void = null;
		r = function() {
			trace('Remove file: '+name);
			list.remove(name);
			file.onRemove.removeListener(r);
			file.onUpdate.removeListener(u);
		};
		u = function() {
			trace('Update file: '+name);
			list.set(name, func(file));
		};
		file.onRemove.addListener(r);
		file.onUpdate.addListener(u);
	}
	
	public function toString():String {
		var a:Array<String> = [];
		for (k in list.keys())
			a.push(k);
		return a.toString();
	}
	
}