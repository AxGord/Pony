package pony.fs;
#if (neko || cpp || nodejs || php)
import haxe.io.Bytes;
import sys.FileSystem;

/**
 * File
 * @author AxGord <axgord@gmail.com>
 */
@:forward(exists, firstExists, takeExists, rename)
abstract File(Unit) from Unit {

	public var name(get, never):String;
	public var shortName(get, never):String;
	public var first(get, never):String;
	public var content(get, set):String;
	public var bytes(get, set):Bytes;
	public var ext(get, never):String;
	public var fullPath(get, never):Unit;
	public var fullDir(get, never):Unit;
	public var size(get, never):Int;
	
	inline public function new(v:Unit) {
		if (v.isDir) throw 'This is not file';
		this = v;
	}
	
	private function get_size():Int return FileSystem.stat(this.firstExists).size;
	
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
		#if !nodejs
		sys.io.File.saveBytes(first, b);
		#end
		return b;
	}
	
	inline private function get_name():String return this.name;
	
	inline private function get_shortName():String return name.split('.')[0];
	
	inline private function get_first():String return this.first;
	
	inline private function get_ext():String return first.split('.').pop();
	
	inline public function copyToFile(to:Unit):Void {
		var to:File = to.file;
		to.createWays();
		sys.io.File.copy(first, to.first);
	}

	inline public function copyToDir(to:Dir, ?newname:String):Void {
		if (newname == null) newname = name;
		var to:File = to + newname;
		to.createWays();
		sys.io.File.copy(first, to.first);
	}

	inline public function moveToDir(to:Dir, ?newname:String):Void {
		to.createWays();
		if (newname == null) newname = name;
		this.rename(to + newname);
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
	inline private function get_fullDir():Unit return [for (e in this.wayStringIterator()) e.substr(0, e.lastIndexOf('/'))];
	
	public function delete():Void {
		try {
			for (e in this) if (e.exists) FileSystem.deleteFile(e.first);
		} catch (_:Dynamic) {
			throw "Can't delete file: " + name;
		}
	}
	
	@:to inline private function toUnit():Unit return this;
	
	@:to inline public function toString():String return this.toString();
	
	@:to inline public function toArray():Array<String> return this.toArray();
	
	@:arrayAccess public inline function arrayAccess(key:Int):File return this[key];
	
	public inline function iterator():Iterator<File> return this.iterator();
	
}
#end