package pony.fs;

#if (sys || nodejs)
import haxe.io.Bytes;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File as SysFile;

using pony.text.TextTools;

/**
 * File
 * @author AxGord <axgord@gmail.com>
 */
@:forward(exists, firstExists, takeExists, rename, parent)
@:nullSafety(Strict) abstract File(Unit) from Unit {

	public var name(get, never): String;
	public var shortName(get, never): String;
	public var first(get, never): String;
	public var content(get, set): Null<String>;
	public var bytes(get, set): Null<Bytes>;
	public var ext(get, never): String;
	public var withoutExt(get, never): String;
	public var fullPath(get, never): Unit;
	public var fullDir(get, never): Dir;
	public var size(get, never): Int;
	public var mtime(get, never): Null<Date>;

	public inline function new(v: Unit) {
		if (v.isDir) throw 'This is not file';
		this = v;
	}

	private inline function get_mtime(): Null<Date> {
		final e: Null<String> = this.firstExists;
		return e == null ? null : FileSystem.stat(e).mtime;
	}

	private inline function get_size(): Int {
		final e: Null<String> = this.firstExists;
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

	private inline function get_ext(): String return cast Path.extension(first);

	private inline function get_withoutExt(): String return Path.withoutExtension(first);

	public inline function copyToFile(to: Unit): Void {
		final to: File = to.file;
		to.createWays();
		SysFile.copy(first, to.first);
	}

	public inline function copyToDir(to: Dir, ?newname: String): Void {
		if (newname == null) newname = name;
		final to: File = to + newname;
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
			final a: Array<String> = e.first.split('/');
			var d: String = cast a.shift();
			for (e in a) {
				d += '/$e';
				if (!FileSystem.exists(d)) FileSystem.createDirectory(d);
			}
		}
	}

	private inline function get_fullPath(): Unit return this.fullPath;

	private inline function get_fullDir(): Dir {
		return [
			for (e in this.wayStringIterator()) {
				final r: Null<String> = e.allBeforeLastWithNull('/');
				r != null ? (r: String) : '.';
			}
		];
	}

	public function delete(): Void {
		try {
			for (e in this) FileSystem.deleteFile(e.first);
		} catch (_: Dynamic) {
			throw 'Can\'t delete file: $name';
		}
	}

	@:to private inline function toUnit(): Unit return this;

	@:to public inline function toString(): String return this.toString();

	@:to public inline function toArray(): Array<String> return this.toArray();

	@:arrayAccess public inline function arrayAccess(key: Int): File return this[key];

	public inline function iterator(): Iterator<File> return this.iterator();

}
#end
