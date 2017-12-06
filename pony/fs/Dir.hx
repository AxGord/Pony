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
package pony.fs;
#if (neko || cpp || nodejs || php)
import pony.Priority.Priority;
import sys.FileSystem;
using Lambda;
/**
 * Directory
 * @author AxGord <axgord@gmail.com>
 */
@:forward(addWay, addWayArray, name)
abstract Dir(Unit) from Unit {

	public var first(get, never):String;
	
	inline public function new(v:Unit) {
		if (v.isFile) throw 'This is not directory';
		this = v;
	}
		
	public function content(?filter:String, allowDir:Bool = false):Array<Unit> {
		var result:Map<String, Unit> = new Map<String, Unit>();
		for (d in this) {
			if (d.exists) for (e in FileSystem.readDirectory(d.first)) {
				if (!result.exists(e) &&
						(filter == null || e.substr( -filter.length) == filter ||
						(allowDir && FileSystem.isDirectory(d + '/' + e))))
					result[e] = [for (d in this.wayStringIterator()) d + '/' + e];
			}
		}
		return [for (e in result) e];
	}

	public function deleteContent():Void {
		for (e in contentRecursiveFiles()) e.delete();
		for (e in contentRecursiveDirs()) e.delete();
	}
	
	public function files(?filter:String):Array<File> return [for (u in content(filter)) if (u.isFile) u];
	public function dirs(?filter:String):Array<Dir> return [for (u in content(filter)) if (u.isDir) u];
	
	inline public function delete():Void FileSystem.deleteDirectory(first);

	inline private function get_first():String return this.first;
	
	public function contentRecursiveFiles(?filter:String):Array<File> {
		var result:Array<File> = [];
		for (u in content(filter, true)) {
			if (u.isDir) {
				result = result.concat(u.dir.contentRecursiveFiles(filter));
			} else {
				result.push(u.file);
			}
		}
		
		return result;
	}

	public function contentRecursiveDirs(?filter:String):Array<Dir> {
		var result:Array<Dir> = [];
		for (u in content(filter, true)) {
			if (u.isDir) {
				result = result.concat(u.dir.contentRecursiveDirs(filter));
				result.push(u.dir);
			}
		}
		
		return result;
	}
	
	public function file(name:String):File return addString(name);
	
	@:to inline private function toUnit():Unit return this;
	
	@:to inline public function toString():String return this.toString();
	
	@:arrayAccess public inline function arrayAccess(key:Int):Dir return this[key];
	
	public inline function iterator():Iterator<Dir> return this.iterator();
	
	@:op(A + B) inline public function addString(a:String):Unit return this.addString(a);
}
#end