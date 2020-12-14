package pony.heaps;

import h2d.Tile;
import haxe.Json;

using Reflect;

/**
 * CDBHeapsImages
 * @author AxGord <axgord@gmail.com>
 */
abstract CDBHeapsImages(Dynamic) {

	public inline function new(data: Dynamic) this = data;

	@:arrayAccess public function get(hash: String): Tile return HeapsUtils.base64ToTile(this.field(hash));

	#if (haxe_ver >= '4.0.0')
	public inline function keyValueIterator(): KeyValueIterator<String, Tile> {
		final it: Iterator<String> = this.fields().iterator();
		return {
			hasNext: it.hasNext,
			next: () -> {
				final key: String = it.next();
				return { key: key, value: get(key) };
			}
		};
	}
	#end

	@:from public static inline function fromString(s: String): CDBHeapsImages return new CDBHeapsImages(Json.parse(s));

}