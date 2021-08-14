package pony.heaps.fs;

import hxd.fs.FileSystem;
import hxd.fs.FileEntry;

class FS implements FileSystem {

	private var list: Array<String>;

	public function new(list: Array<String>) this.list = list;

	public function getRoot(): FileEntry return new RootEntry(list.filter(function(e: String) return e.indexOf('/') == -1));
	public function get(path: String): FileEntry return new BinEntity(path);
	public function exists(path: String): Bool return true;
	public function dispose(): Void list = null;
	public function dir(path: String): Array<FileEntry> return [];

}