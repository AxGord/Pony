package pony.heaps.fs;

import haxe.io.Bytes;

import hxd.fs.FileEntry;

class BinEntity extends FileEntry {

	public function new(name: String) this.name = name;

	override private function get_path(): String return '';
	override public function getBytes(): Bytes return HeapsAssets.bin(name);

}