package pony.heaps;

#if !hl
typedef BinaryLoader = hxd.net.BinaryLoader;
#else

import haxe.io.Bytes;
import sys.io.File;

class BinaryLoader {

	public var url: String;

	public function new(url: String) this.url = url;
	public dynamic function onError(msg: String): Void {}
	public dynamic function onProgress(cur: Int, max: Int): Void {}
	public dynamic function onLoaded(bytes: Bytes): Void {}
	public inline function load(): Void onLoaded(File.getBytes(url));

}
#end