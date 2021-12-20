package pony.heaps;

import h2d.Tile;

import hxd.res.Atlas;
import hxd.res.Loader;

import pony.ui.BinaryAtlas;

using pony.text.TextTools;

/**
 * Heaps binary atlas
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class HeapsBinaryAtlas extends Atlas {

	override public function getContents(): Map<String,Array<{ t: Tile, width: Int, height: Int }>> {
		if (contents != null) return contents;
		var data: BinaryAtlas = BinaryAtlas.fromBytes(entry.getBytes());
		var basePath: String = entry.path.allBeforeLast('/') + '/';
		var file: Tile = Loader.currentInstance.load(basePath + data.file).toTile();
		var scale: Float = file.width / data.width;
		@:nullSafety(Off) return [ for (key in data.contents.keys())
			key => [ for (p in data.contents[key]) {
				var t: Tile = file.sub(Std.int(p.x * scale), Std.int(p.y * scale), Std.int(p.w * scale), Std.int(p.h * scale), p.dx, p.dy);
				if (scale != 1) t.scaleToSize(p.w, p.h);
				{ t: t, width: p.origW, height: p.origH }
			} ]
		];
	}

}