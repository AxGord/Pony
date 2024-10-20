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

	public inline function new(v: Unit) {
		if (v.isFile) throw 'This is not directory';
		this = v;
	}

	private static function checkFilter(filter: Array<String>, unit: String): Bool {
		if (filter == null) return true;
		for (f in filter) if (unit.substr(-f.length) == f) return true;
		return false;
	}

	public function content(?filter: String, allowDir: Bool = false, sortByName: Bool = false): Array<Unit> {
		var result: Map<String, Unit> = new Map<String, Unit>();
		var flt: Array<String> = filter == null ? null : filter.split(' ');
		for (d in this) {
			if (d.exists)
				for (e in FileSystem.readDirectory(d.first)) {
					var np: String = d + '/' + e;
					var isDir: Bool = try FileSystem.isDirectory(np) catch (_:Any) false;
					if ((allowDir || !isDir) && (isDir || checkFilter(flt, e)) && !result.exists(e))
						result[e] = [for (d in this.wayStringIterator()) d + '/$e'];
				}
		}
		var r: Array<Unit> = [for (e in result) e];
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
		return [ for (u in content(filter, false, sortByName)) if (u.isFile) u ];
	}

	public function dirs(?filter: String, sortByName: Bool = false): Array<Dir> {
		return [ for (u in content(filter, true, sortByName)) if (u.isDir) u ];
	}

	public inline function delete(): Void FileSystem.deleteDirectory(first);
	private inline function get_first(): String return this.first;

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
			var w: String = f.fullDir.first.substr(first.length);
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
				var w: String = f.fullDir.first.substr(first.length);
				f.moveToDir(to + w);
			}
		}
	}

	public function createWays(): Void {
		var a = first.split('/');
		var d = a.shift();
		for (e in a) {
			d += '/' + e;
			if (!FileSystem.exists(d)) FileSystem.createDirectory(d);
		}
	}

	public inline function create(): Void FileSystem.createDirectory(first);
	public function file(name: String): File return addString(name);
	@:to inline private function toUnit(): Unit return this;
	@:to inline public function toString(): String return this.toString();
	@:arrayAccess public inline function arrayAccess(key: Int): Dir return this[key];
	public inline function iterator(): Iterator<Dir> return this.iterator();
	@:op(A + B) inline public function addString(a: String): Unit return this.addString(a);

	public static function compareNames(a: Unit, b: Unit): Int {
		var an: String = a.name.toLowerCase();
		var bn: String = b.name.toLowerCase();
		return an == bn ? 0 : an > bn ? 1 : -1;
	}

}
#end