package pony.heaps.ui.gui.slices;

import h2d.Object;
import h2d.Tile;

import pony.geom.Border;
import pony.ui.gui.slices.SliceData;
import pony.ui.gui.slices.SliceTools;

/**
 * Slice
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
class Slice {

	public static function create(
		tiles: Array<Tile>, ?src: String, repeat: Bool = false, vert: Bool = false, ?border: Border<Int>, ?parent: Object
	): Node {
		if (src == null) {
			return switch tiles.length {
				case 0: throw 'Tiles not found';
				case 1 if (repeat):
					new NodeRepeat(tiles[0], parent);
				case 1:
					new NodeBitmap(tiles[0], border, parent);
				case _:
					new NodeAnim(tiles, parent);
			}
		} else {
			return switch SliceTools.getType(src) {
				case Not() if (repeat):
					new NodeRepeat(tiles[0], parent);
				case Not():
					new NodeBitmap(tiles[0], border, parent);
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
				case Anim(speed, delay):
					new NodeAnim(tiles, speed, delay, parent);
				case _:
					throw 'Not supported';

			}
		}
	}

}