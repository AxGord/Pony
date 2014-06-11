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
package pony.fs;
import haxe.io.Bytes;
import sys.FileSystem;

/**
 * File
 * @author AxGord <axgord@gmail.com>
 */
abstract File(Unit) {

	public var name(get, never):String;
	public var exists(get, never):Bool;
	public var first(get, never):String;
	public var content(get, set):String;
	public var bytes(get, set):Bytes;
	public var ext(get, never):String;
	public var fullPath(get, never):Unit;
	public var fullDir(get, never):Unit;
	
	inline public function new(v:Unit) {
		if (v.isDir) throw 'This is not file';
		this = v;
	}
	
	public function get_content():String {
		for (f in this) if (f.exists) return sys.io.File.getContent(f.first);
		return null;
	}
	
	public function set_content(c:String):String {
		sys.io.File.saveContent(first, c);
		return c;
	}
	
	public function get_bytes():Bytes {
		for (f in this) if (f.exists) return sys.io.File.getBytes(f.first);
			return null;
	}
	
	public function set_bytes(b:Bytes):Bytes {
		sys.io.File.saveBytes(first, b);
		return b;
	}
	
	inline private function get_name():String return this.name;
	
	inline private function get_exists():Bool return this.exists;
	
	inline private function get_first():String return this.first;
	
	inline private function get_ext():String return first.split('.').pop();
	
	inline public function copyTo(to:Unit):Void {
		var to:File = to.isDir ? to + name : to;
		to.createWays();
		sys.io.File.copy(first, to.first);
	}
	
	inline public function copyFrom(from:File):Void {
		createWays();
		sys.io.File.copy(from.first, first);
	}
	
	public function createWays():Void {
		for (e in fullDir) {
			var a = e.first.split('/');
			var d = a.shift();
			for (e in a) {
				d += '/' + e;
				if (!FileSystem.exists(d)) FileSystem.createDirectory(d);
			}
		}
	}
	
	inline private function get_fullPath():Unit return this.fullPath;
	inline private function get_fullDir():Unit return [for (e in this.fullPath.wayStringIterator()) e.substr(0, e.lastIndexOf('/'))];
	
	public function delete():Void {
		try {
			for (e in this) if (e.exists) FileSystem.deleteFile(e.first);
		} catch (_:Dynamic) {
			throw "Can't delete file: "+name;
		}
	}
	
	@:from inline public static function fromUnit(u:Unit):File return new File(u);
	@:to inline private function toUnit():Unit return this;
	
	@:to inline public function toString():String return this.toString();
	
	@:to inline public function toArray():Array<String> return this.toArray();
	
	@:arrayAccess public inline function arrayAccess(key:Int):File return this[key];
	
	public inline function iterator():Iterator<File> return this.iterator();
	
}