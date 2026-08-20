package pony.fs;

#if (sys || nodejs)
import pony.Priority;
import sys.FileSystem;

using Lambda;

/**
 * Directory
 * @author AxGord <axgord@gmail.com>
 */
@:forward(addWay, addWayArray, name, rename, exists, parent)
abstract Dir(Unit) from Unit {

	public var first(get, never): String;

	/** Recursive sum of all files' sizes in bytes — triggers full directory walk. */
	public var size(get, never): Int;

	public inline function new(v: Unit) {
		if (v.isFile) throw 'This is not directory';
		this = v;
	}

	private inline function get_first(): String return this.first;

	private function get_size(): Int {
		var result: Int = 0;
		for (f in contentRecursiveFiles()) result += f.size;
		return result;
	}

	public inline function delete(): Void FileSystem.deleteDirectory(first);

	public inline function create(): Void FileSystem.createDirectory(first);

	@:to public inline function toString(): String return this.toString();

	@:arrayAccess public inline function arrayAccess(key: Int): Dir return this[key];

	public inline function iterator(): Iterator<Dir> return this.iterator();

	@:op(A + B) public inline function addString(a: String): Unit return this.addString(a);

	public function content(?filter: String, allowDir: Bool = false, sortByName: Bool = false): Array<Unit> {
		final result: Map<String, Unit> = [];
		final flt: Array<String> = filter == null ? null : filter.split(' ');
		for (d in this) {
			if (d.exists) for (e in FileSystem.readDirectory(d.first)) {
				final np: String = d + '/' + e;
				final isDir: Bool = try FileSystem.isDirectory(np) catch (_: Any) false;
				if ((allowDir || !isDir) && (isDir || checkFilter(flt, e)) && !result.exists(e))
					result[e] = [for (d in this.wayStringIterator()) d + '/$e'];
			}
		}
		final r: Array<Unit> = [for (e in result) e];
		if (sortByName) r.sort(compareNames);
		return r;
	}

	public function deleteContent(?keepFiles: Array<String>): Void {
		if (keepFiles == null) {
			for (e in contentRecursiveFiles()) e.delete();
			for (e in contentRecursiveDirs()) e.delete();
		} else {
			for (e in contentRecursiveFiles()) if (!keepFiles.contains(e.first)) e.delete();
			for (e in contentRecursiveDirs()) if (e.content().length == 0) e.delete();
		}
	}

	public function files(?filter: String, sortByName: Bool = false): Array<File> {
		return [for (u in content(filter, false, sortByName)) if (u.isFile) u];
	}

	public function dirs(?filter: String, sortByName: Bool = false): Array<Dir> {
		return [for (u in content(filter, true, sortByName)) if (u.isDir) u];
	}

	public function contentRecursiveFiles(?filter: String, sortByName: Bool = false): Array<File> {
		var result: Array<File> = [];
		for (u in content(filter, true, sortByName)) {
			if (u.isDir) {
				result = result.concat(u.dir.contentRecursiveFiles(filter, sortByName));
			} else {
				result.push(u.file);
			}
		}
		return result;
	}

	public function contentRecursiveDirs(?filter: String, sortByName: Bool = false): Array<Dir> {
		var result: Array<Dir> = [];
		for (u in content(filter, true, sortByName)) {
			if (u.isDir) {
				result = result.concat(u.dir.contentRecursiveDirs(filter, sortByName));
				result.push(u.dir);
			}
		}
		return result;
	}

	public function copyTo(to: Dir, ?filter: String): Void {
		for (f in contentRecursiveFiles(filter)) {
			final w: String = f.fullDir.first.substr(first.length);
			f.copyToDir(to + w);
		}
	}

	public function moveTo(to: Dir, ?filter: String): Void {
		to = FileSystem.absolutePath(to.first) + '/' + this.name;
		if (filter == null) {
			to.createWays();
			this.rename(to);
		} else {
			for (f in contentRecursiveFiles(filter)) {
				final w: String = f.fullDir.first.substr(first.length);
				f.moveToDir(to + w);
			}
		}
	}

	public function createWays(): Void {
		final a: Array<String> = first.split('/');
		var d: Null<String> = a.shift();
		for (e in a) {
			d += '/' + e;
			if (!FileSystem.exists(d)) FileSystem.createDirectory(d);
		}
	}

	public function file(name: String): File return addString(name);

	@:to private inline function toUnit(): Unit return this;

	public static function compareNames(a: Unit, b: Unit): Int {
		final an: String = a.name.toLowerCase();
		final bn: String = b.name.toLowerCase();
		return if (an == bn)
			0
		else if (an > bn)
			1
		else
			-1;
	}

	private static function checkFilter(filter: Array<String>, unit: String): Bool {
		return filter == null || filter.exists(f -> unit.substr(-f.length) == f);
	}

}
#end
