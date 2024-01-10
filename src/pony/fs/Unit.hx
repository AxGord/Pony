package pony.fs;

#if (sys || nodejs)
import pony.Priority;
import sys.FileSystem;

/**
 * File system Unit
 * @author AxGord <axgord@gmail.com>
 */
@:forward(map)
@:nullSafety(Strict) abstract Unit(Priority<String>) {

	public var isDir(get, never): Bool;
	public var isFile(get, never): Bool;
	public var exists(get, never): Bool;
	public var fullPath(get, never): Unit;
	public var dir(get, never): Dir;
	public var file(get, never): File;
	public var name(get, never): String;
	public var first(get, never): String;
	public var firstExists(get, never): Null<String>;
	public var takeExists(get, never): Array<String>;

	public inline function new(v: Priority<String>) {
		for (e in v) if (e.length == 0) throw 'Wrong way detected';
		this = v;
	}

	private function get_takeExists(): Array<String> {
		var a: Array<String> = [];
		for (e in this) if (FileSystem.exists(e)) a.push(e);
		return a;
	}

	private inline function get_name(): String return cast this.first.split('/').pop();

	public inline function rename(to: Unit): Void FileSystem.rename(first, to.first);

	private function get_exists(): Bool {
		for (e in this) if (FileSystem.exists(e)) return true;
		return false;
	}

	private function get_isDir(): Bool {
		for (e in this) if (FileSystem.exists(e) && FileSystem.isDirectory(e)) return true;
		return false;
	}

	private function get_isFile(): Bool {
		for (e in this) if (FileSystem.exists(e) && !FileSystem.isDirectory(e)) return true;
		return false;
	}

	private inline function get_fullPath(): Unit return [ for (e in this) StringTools.replace(FileSystem.fullPath(e), '\\', '/') ];
	private inline function get_dir(): Dir return this;
	private inline function get_file(): File return this;
	private inline function get_first(): String return this.first;

	private function get_firstExists(): Null<String> {
		for (e in iterator()) if (e.exists) return e;
		return null;
	}

	@:op(A + B) public inline function addString(a: String): Unit return [for (e in this) e + (a.indexOf('/') == 0 ? '' : '/') + a];
	@:from private static inline function fromString(s: String): Unit return s.split(';').map(StringTools.trim);
	@:from public static inline function join(a: Array<Unit>): Unit return new Priority<String>(cast a);
	@:from private static inline function fromPriority(p: Priority<String>): Unit return new Unit(p);
	@:from private static inline function fromArray(a: Array<String>): Unit return new Priority(a.map(removeLastSlash));
	@:to public inline function toString(): String return this.join('; ');
	@:to public inline function split(): Array<Unit> return cast this.data;
	@:to public inline function toPriority(): Priority<String> return this;
	@:to public inline function toArray(): Array<String> return this.data;
	public inline function wayStringIterator(): Iterator<String> return this.iterator();
	public inline function addWay(way: String, priority: Int = 0): Void this.add(way, priority);
	public inline function addWayArray(way: Array<String>, priority: Int = 0): Void this.addArray(way, priority);

	public function iterator(): Iterator<Unit> {
		var it: Iterator<String> = this.iterator();
		return { hasNext: it.hasNext, next: function(): Unit return it.next() };
	}

	@:arrayAccess public inline function arrayAccess(key: Int): Unit return this.data[key];

	public inline function copyTo(path: String): Void {
		if (isDir)
			dir.copyTo(path);
		else
			file.copyToDir(path);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function delete(): Void {
		if (isDir)
			dir.delete();
		else
			file.delete();
	}

	private static function removeLastSlash(v: String): String return v.substr(-1) == '/' ? removeLastSlash(v.substr(0, -1)) : v;

}
#end