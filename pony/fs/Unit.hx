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
package pony.fs;
#if (neko || cpp || nodejs || php)
import pony.Priority;
import sys.FileSystem;

/**
 * File system Unit
 * @author AxGord <axgord@gmail.com>
 */
abstract Unit(Priority<String>) {

	public var isDir(get, never):Bool;
	public var isFile(get, never):Bool;
	public var exists(get, never):Bool;
	public var fullPath(get, never):Unit;
	public var dir(get, never):Dir;
	public var file(get, never):File;
	public var name(get,never):String;
	public var first(get, never):String;
	public var firstExists(get, never):String;
	public var takeExists(get, never):Array<String>;
	
	inline public function new(v:Priority<String>) {
		for (e in v) if (e.length == 0) throw 'Wrong way detected';
		this = v;
	}
	
	private function get_takeExists():Array<String> {
		var a = [];
		for (e in this) if (FileSystem.exists(e)) a.push(e);
		return a;
	}
	
	inline private function get_name():String return this.first.split('/').pop();
	
	private function get_exists():Bool {
		for (e in this) if (FileSystem.exists(e)) return true;
		return false;
	}
	
	private function get_isDir():Bool {
		for (e in this) if (FileSystem.exists(e) && FileSystem.isDirectory(e)) return true;
		return false;
	}
	
	private function get_isFile():Bool {
		for (e in this) if (FileSystem.exists(e) && !FileSystem.isDirectory(e)) return true;
		return false;
	}
	
	inline private function get_fullPath():Unit return [for (e in this) StringTools.replace(FileSystem.fullPath(e), '\\', '/')];
	
	inline private function get_dir():Dir return this;
	inline private function get_file():File return this;
	
	inline private function get_first():String return this.first;
	private function get_firstExists():String {
		for (e in iterator()) if (e.exists) return e;
		return null;
	}
	
	@:from inline static private function fromString(s:String):Unit return s.split(';').map(StringTools.trim);
	@:to inline public function toString():String return this.join('; ');
	
	@:to inline public function split():Array<Unit> return cast this.data;
	@:from inline static public function join(a:Array<Unit>):Unit return new Priority <String> (cast a);
	
	@:from inline static private function fromPriority(p:Priority<String>):Unit return new Unit(p);
	@:to inline public function toPriority():Priority<String> return this;
	
	@:from inline static private function fromArray(a:Array<String>):Unit return new Priority(a);
	@:to inline public function toArray():Array<String> return this.data;
	
	inline public function wayStringIterator():Iterator<String> return this.iterator();
	
	inline public function addWay(way:String, priority:Int = 0):Void this.add(way, priority);
	inline public function addWayArray(way:Array<String>, priority:Int = 0):Void this.addArray(way, priority);
	
	public function iterator():Iterator<Unit> {
		var it = this.iterator();
		return {
			hasNext: it.hasNext,
			next: function():Unit return it.next()
		};
	}
	
	@:arrayAccess public inline function arrayAccess(key:Int):Unit return this.data[key];
	
	@:op(A + B) inline public function addString(a:String):Unit return [for (e in this) e+'/'+a];
}
#end