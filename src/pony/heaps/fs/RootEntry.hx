package pony.heaps.fs;

import hxd.fs.FileEntry;
import hxd.impl.ArrayIterator;

class RootEntry extends FileEntry {

	private var list: Array<String>;

	public function new(list: Array<String>) this.list = list;

	override public function iterator() : ArrayIterator<FileEntry> return new ArrayIterator<FileEntry>(list.map(binEntity));
	private function binEntity(name: String): FileEntry return cast new BinEntity(name);

}