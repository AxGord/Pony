package pony.fs;

#if (neko || cpp || nodejs || php)
import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File as SysFile;

/**
 * File
 * @author AxGord <axgord@gmail.com>
 */
@:forward(exists, firstExists, takeExists, rename)
@:nullSafety(Strict) abstract File(Unit) from Unit {

	public var name(get, never): String;
	public var shortName(get, never): String;
	public var first(get, never): String;
	public var content(get, set): Null<String>;
	public var bytes(get, set): Null<Bytes>;
	public var ext(get, never): String;
	public var fullPath(get, never): Unit;
	public var fullDir(get, never): Unit;
	public var size(get, never): Int;

	inline public function new(v: Unit) {
		if (v.isDir) throw 'This is not file';
		this = v;
	}

	private function get_size(): Int {
		var e: Null<String> = this.firstExists;
		return e == null ? -1 : FileSystem.stat(e).size;
	}

	public function get_content(): Null<String> {
		for (f in this) if (f.exists) return SysFile.getContent(f.first);
		return null;
	}

	public function set_content(c: Null<String>): Null<String> {
		if (c == null)
			delete();
		else
			SysFile.saveContent(first, c);
		return c;
	}

	public function get_bytes(): Null<Bytes> {
		for (f in this) if (f.exists) return SysFile.getBytes(f.first);
		return null;
	}

	public function set_bytes(b: Null<Bytes>): Null<Bytes> {
		#if !nodejs
		if (b == null)
			delete();
		else
			SysFile.saveBytes(first, b);
		#end
		return b;
	}

	private inline function get_name(): String return this.name;
	private inline function get_shortName(): String return name.split('.')[0];
	private inline function get_first(): String return this.first;
	private inline function get_ext(): String return cast first.split('.').pop();

	public inline function copyToFile(to: Unit): Void {
		var to: File = to.file;
		to.createWays();
		SysFile.copy(first, to.first);
	}

	public inline function copyToDir(to: Dir, ?newname: String): Void {
		if (newname == null) newname = name;
		var to: File = to + newname;
		to.createWays();
		SysFile.copy(first, to.first);
	}

	public inline function moveToDir(to: Dir, ?newname: String): Void {
		to.createWays();
		if (newname == null) newname = name;
		this.rename(to + newname);
	}

	public inline function copyFrom(from: File): Void {
		createWays();
		SysFile.copy(from.first, first);
	}

	public function createWays(): Void {
		for (e in fullDir) {
			var a: Array<String> = e.first.split('/');
			var d: String = cast a.shift();
			for (e in a) {
				d += '/' + e;
				if (!FileSystem.exists(d)) FileSystem.createDirectory(d);
			}
		}
	}

	private inline function get_fullPath(): Unit return this.fullPath;
	inline private function get_fullDir(): Unit return [ for (e in this.wayStringIterator()) e.substr(0, e.lastIndexOf('/')) ];

	public function delete(): Void {
		try {
			for (e in this) if (e.exists) FileSystem.deleteFile(e.first);
		} catch (_:Dynamic) {
			throw "Can't delete file: " + name;
		}
	}

	@:to inline private function toUnit(): Unit return this;
	@:to inline public function toString(): String return this.toString();
	@:to inline public function toArray(): Array<String> return this.toArray();
	@:arrayAccess public inline function arrayAccess(key: Int): File return this[key];
	public inline function iterator(): Iterator<File> return this.iterator();

}
#end