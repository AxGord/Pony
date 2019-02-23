package pony.fs;

#if (neko || cpp || nodejs || php)
import pony.Priority;
import sys.FileSystem;
using Lambda;

/**
 * Directory
 * @author AxGord <axgord@gmail.com>
 */
@:forward(addWay, addWayArray, name, rename)
abstract Dir(Unit) from Unit {

	public var first(get, never):String;
	
	inline public function new(v:Unit) {
		if (v.isFile) throw 'This is not directory';
		this = v;
	}

	private static function checkFilter(filter:Array<String>, unit:String):Bool {
		if (filter == null) return true;
		for (f in filter) if (unit.substr( -f.length) == f) return true;
		return false;
	}
		
	public function content(?filter:String, allowDir:Bool = false):Array<Unit> {
		var result:Map<String, Unit> = new Map<String, Unit>();
		var flt:Array<String> = filter == null ? null : filter.split(' ');
		for (d in this) {
			if (d.exists) for (e in FileSystem.readDirectory(d.first)) {
				var np:String = d + '/' + e;
				var isDir:Bool = try FileSystem.isDirectory(np) catch (_:Any) false;
				if (
					(allowDir || !isDir) &&
					(isDir || checkFilter(flt, e)) &&
					!result.exists(e)
				)
					result[e] = [for (d in this.wayStringIterator()) d + '/$e'];
			}
		}
		return [for (e in result) e];
	}

	public function deleteContent():Void {
		for (e in contentRecursiveFiles()) e.delete();
		for (e in contentRecursiveDirs()) e.delete();
	}
	
	public function files(?filter:String):Array<File> return [for (u in content(filter)) if (u.isFile) u];
	public function dirs(?filter:String):Array<Dir> return [for (u in content(filter, true)) if (u.isDir) u];
	
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

	public function copyTo(to:Dir, ?filter:String):Void {
		for (f in contentRecursiveFiles(filter)) {
			var w:String = f.fullDir.first.substr(first.length);
			f.copyToDir(to + w);
		}
	}

	public function moveTo(to:Dir, ?filter:String):Void {
		to = FileSystem.absolutePath(to.first) + '/' + this.name;
		if (filter == null) {
			to.createWays();
			this.rename(to);
		} else {
			for (f in contentRecursiveFiles(filter)) {
				var w:String = f.fullDir.first.substr(first.length);
				f.moveToDir(to + w);
			}
		}
	}

	public function createWays():Void {
		var a = first.split('/');
		var d = a.shift();
		for (e in a) {
			d += '/' + e;
			if (!FileSystem.exists(d)) FileSystem.createDirectory(d);
		}
	}
	
	public function file(name:String):File return addString(name);
	
	@:to inline private function toUnit():Unit return this;
	
	@:to inline public function toString():String return this.toString();
	
	@:arrayAccess public inline function arrayAccess(key:Int):Dir return this[key];
	
	public inline function iterator():Iterator<Dir> return this.iterator();
	
	@:op(A + B) inline public function addString(a:String):Unit return this.addString(a);

}
#end