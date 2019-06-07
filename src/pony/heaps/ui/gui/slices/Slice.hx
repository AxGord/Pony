package pony.heaps.ui.gui.slices;

import h2d.Tile;
import pony.ui.gui.slices.SliceTools;
import pony.ui.gui.slices.SliceData;

/**
 * Slice
 * @author AxGord <axgord@gmail.com>
 */
class Slice {
	
	public static function create(tiles:Array<Tile>, ?src:String, ?repeat:Bool, ?vert:Bool, ?parent:h2d.Object):Node {
		if (src == null) {
			return switch tiles.length {
				case 1 if (repeat):
					new NodeRepeat(tiles[0], parent);
				case 1:
					new NodeBitmap(tiles[0], parent);
				case 2 if (vert):
					new Slice2V(tiles, repeat, parent);
				case 2:
					new Slice2H(tiles, repeat, parent);
				case 3 if (vert):
					new Slice3V(tiles, repeat, parent);
				case 3:
					new Slice3H(tiles, repeat, parent);
				case 4:
					new Slice4(tiles, repeat, parent);
				case 6 if (vert):
					new Slice6V(tiles, repeat, parent);
				case 6:
					new Slice6H(tiles, repeat, parent);
				case 9:
					new Slice9(tiles, repeat, parent);
				case _:
					throw 'Not supported';
			}
		} else {
			return switch SliceTools.getType(src) {
				case Not() if (repeat):
					new NodeRepeat(tiles[0], parent);
				case Not():
					new NodeBitmap(tiles[0], parent);
				case Hor2():
					new Slice2H(tiles, repeat, parent);
				case Hor3():
					new Slice3H(tiles, repeat, parent);
				case Vert2():
					new Slice2V(tiles, repeat, parent);
				case Vert3():
					new Slice3V(tiles, repeat, parent);
				case Four():
					new Slice4(tiles, repeat, parent);
				case Hor6():
					new Slice6H(tiles, repeat, parent);
				case Vert6():
					new Slice6V(tiles, repeat, parent);
				case Nine():
					new Slice9(tiles, repeat, parent);
				case _:
					throw 'Not supported';
				
			}
		}
	}

}