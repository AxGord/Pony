/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import haxe.xml.Fast;
import pony.fs.Dir;
import pony.fs.File;
import pony.text.tpl.TplSystem;

/**
 * Templates
 * @author AxGord
 */

class Templates
{
	
	private var list:Map<String, TplSystem>;

	public function new(dir:Dir, ?c:Class<ITplPut>, o:Dynamic)
	{
		list = new Map<String, TplSystem>();
		var td:Dir = dir + 'templates';
		for (d in td.dirs()) {
			var mf:File = d + 'manifest.xml';
			if (mf.exists) {
				var manifest:Manifest = TplSystem.parseManifest(mf);
				if (manifest.title == null) manifest.title = d.name;
				for (e in manifest._extends) {
					//d.list.repriority(1);
					//d.list.change(d.list.first, -1);
					d.addWayArray(td + e);
				}
				//trace(d);
				var ts:TplSystem = new TplSystem(d, c, o);
				ts.manifest = manifest;
				list.set(d.name, ts);
			} else
				list.set(d.name, new TplSystem(d, c, o));
		}
	}
	
	public inline function exists(key:String):Bool return list.exists(key);
	
	public inline function get(key:String):TplSystem return list.get(key);
	
	public inline function iterator():Iterator<TplSystem> {
		return list.iterator();
	}
	
}