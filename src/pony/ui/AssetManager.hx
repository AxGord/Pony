package pony.ui;

import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.rtti.Meta;
import pony.Or;
import pony.events.Signal1;
import pony.magic.HasLink;
import pony.math.MathTools;
import pony.time.DeltaTime;
import pony.ui.gui.slices.SliceTools;
#if heaps
import pony.heaps.HeapsAssets;
#elseif pixijs
import pony.pixi.PixiAssets;


#elseif openfl
import pony.openfl.OpenflAssets;
#end

using Lambda;
using StringTools;
using pony.text.TextTools;

/**
 * AssetManager
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:nullSafety(Strict)
class AssetManager implements HasLink {

	public static inline final MAX_ASSET_PROGRESS: Int = 10;

	#if heaps
	public static var onError(link, never): Signal1<String> = HeapsAssets.onError;
	#end

	public static var baseUrl: String = '';
	public static var local: String = '';
	private static var units: Map<String, Bytes> = [];
	private static var loadedAssets: Array<String> = [];
	private static var globalLoad: Map<String, Array<Int -> Int -> Void>> = [];
	private static var changedNames: Bool = false;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function initHash(cb: Void -> Void): Void {
		#if (hxbitmini && js)
		final url: Null<String> = Tools.getHashFileWithHash();
		if (url != null) {
			final url: String = url;
			load(
				'', url, (c: Int, t: Int) -> if (c == t) {
					units = Hash.fromBytes(bin(url.allBefore('?'))).units;
					cb();
				}
			);
		} else {
			cb();
		}
		#else
		cb();
		#end
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function initHashVersion(url: Null<String>, cb: Void -> Void): Void {
		#if (hxbitmini && js)
		if (url != null) {
			changedNames = true;
			final url: String = url;
			load(
				'', url, (c: Int, t: Int) -> if (c == t) {
					units = Hash.fromBytes(bin(extractHash(url).a)).units;
					cb();
				}
			);
		} else {
			cb();
		}
		#else
		cb();
		#end
	}

	public static function resetAll(): Void {
		for (e in loadedAssets.copy()) reset(e);
	}

	public static inline function reset(asset: String): Void {
		loadedAssets.remove(asset);
		_reset(asset);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function getPath(asset: String): String {
		asset = asset.replace('@', '');
		return baseUrl + asset.replace('{local}', local);
	}

	public static dynamic function monitor(current: Int, total: Int): Void {}

	public static function loadPack(pathes: Array<String>, assets: Array<String>, cb: Int -> Int -> Void): Void {
		if (assets.length == 0) {
			cb(0, 0);
			return;
		}
		if (pathes.length == 0) {
			load(assets, cb);
			return;
		} else if (pathes.length == 1) {
			if (pathes[0] != '')
				load([for (a in assets) pathes[0] + '/' + a], cb);
			else
				load(assets, cb);
			return;
		}
		final loaded: Array<Int> = [for (_ in 0...pathes.length) 0];
		final totals: Array<Int> = [for (_ in 0...pathes.length) MAX_ASSET_PROGRESS];
		var i: Int = 0;
		var prevLoaded: Int = 0;
		var prevTotals: Int = 0;
		for (path in pathes) {
			final n: Int = i++;
			load(path, assets, (a: Int, t: Int) -> {
				loaded[n] = a;
				totals[n] = t;
				final loadedSum: Int = sum(loaded);
				final totalSum: Int = sum(totals);
				if (loadedSum != prevLoaded || totalSum != prevTotals) {
					prevLoaded = loadedSum;
					prevTotals = totalSum;
					cb(loadedSum, totalSum);
				}
			});
		}
	}

	public static function load(path: String = '', asset: Or<String, Array<String>>, cb: Int -> Int -> Void): Void {
		switch asset {
			case OrState.A(a):
				var r: Array<String> = parseInterval(a);
				if (r.length == 1) r = SliceTools.getNames(r[0]);
				if (r.length > 1) asset = OrState.B(r);
			case OrState.B(a):
				if (a.length == 1)
					return load(path, OrState.A(a[0]), cb);
				else if (a.length == 0)
					return cb(0, 0);
		}
		switch asset {
			case OrState.A(asset):
				asset = (path == '' ? '' : path.charAt(path.length - 1) == '/' ? path : '$path/') + asset;
				if (loadedAssets.indexOf(asset) != -1) {
					cb(MAX_ASSET_PROGRESS, MAX_ASSET_PROGRESS);
					return;
				}
				final a: Null<Array<(Int, Int) -> Void>> = globalLoad[asset];
				if (a != null) {
					cb(0, MAX_ASSET_PROGRESS);
					a.push(cb);
				} else {
					globalLoad[asset] = [];
					var called: Bool = false;
					_load(asset, (c: Int, t: Int) -> {
						cb(c, t);
						globalLoaded(asset, c, t);
						called = true;
					});
					if (!called) cb(0, MAX_ASSET_PROGRESS);
				}
			case OrState.B(assets):
				final loaded: Array<Int> = [for (_ in 0...assets.length) 0];
				final totals: Array<Int> = [for (_ in 0...assets.length) MAX_ASSET_PROGRESS];
				var i: Int = 0;
				var prevLoaded: Int = 0;
				var prevTotals: Int = 0;
				for (asset in assets) {
					final n: Int = i++;
					load(path, asset, (c: Int, t: Int) -> {
						loaded[n] = c;
						totals[n] = t;
						final loadedSum: Int = sum(loaded);
						final totalSum: Int = sum(totals);
						if (loadedSum != prevLoaded || totalSum != prevTotals) {
							prevLoaded = loadedSum;
							prevTotals = totalSum;
							cb(loadedSum, totalSum);
						}
					});
				}
		}
	}

	private static function sum(a: Array<Int>): Int return a.fold(_sum, 0);

	private static function _sum(v: Int, p: Int): Int return v + p;

	private static function globalLoaded(asset: String, c: Int, t: Int): Void {
		final a: Null<Array<(Int, Int) -> Void>> = globalLoad[asset];
		if (a == null) return;
		for (f in a) f(c, t);
		if (c == t) {
			loadedAssets.push(asset);
			globalLoad.remove(asset);
			monitor(loadedAssets.length, globalLoad.count());
		}
	}

	public static function backLoad(asset: String): Void {
		if (isLoaded(asset)) return;
		if (!globalLoad.exists(asset)) {
			globalLoad[asset] = [];
			_load(asset, globalLoaded.bind(asset));
		}
	}

	public static function isLoaded(asset: String): Bool return loadedAssets.indexOf(asset) != -1;

	public static function loadPackWithChilds(cl: String, pathes: Array<String>, assets: Array<String>, cb: Int -> Int -> Void): Void {
		final chs = Meta.getType(Type.resolveClass(cl)).assets_childs;
		if (chs == null) {
			loadPack(pathes, assets, cb);
			return;
		}
		final p: pony.Pair<(Int, Int) -> Void, (Int, Int) -> Void> = cbjoin(cb);
		loadPack(pathes, assets, p.a);
		loadChildPack(chs, p.b);
	}

	private static function loadChildPack(chs: Array<Dynamic>, cb: Int -> Int -> Void): Void {
		var f: Int -> Int -> Void = cb;
		for (i in 0...(chs.length - 1)) {
			final p: pony.Pair<(Int, Int) -> Void, (Int, Int) -> Void> = cbjoin(f);
			f = p.a;
			final s = Type.resolveClass(chs[i]);
			if (s != null)
				@:nullSafety(Off) Reflect.getProperty(s, 'loadAllAssets')(true, p.b);
			else
				p.b(0, 0); // skip load
		}
		final s = Type.resolveClass(chs[chs.length - 1]);
		if (s != null)
			@:nullSafety(Off) Reflect.getProperty(s, 'loadAllAssets')(true, f);
		else
			f(0, 0); // skip load
	}

	public static function cbjoin(cb: Int -> Int -> Void): Pair<Int -> Int -> Void, Int -> Int -> Void> {
		var aCurrent: Int = 0;
		var aTotal: Int = 1;
		var bCurrent: Int = 0;
		var bTotal: Int = 1;
		function a(c: Int, t: Int) {
			aCurrent = c;
			aTotal = t;
			cb(bCurrent + c, bTotal + t);
		}
		function b(c: Int, t: Int) {
			bCurrent = c;
			bTotal = t;
			cb(aCurrent + c, aTotal + t);
		}
		return new Pair(a, b);
	}

	public static function allCountWithChilds(cl: String, pathes: Array<String>, assets: Array<String>): Int {
		final chs = Meta.getType(Type.resolveClass(cl)).assets_childs;
		if (chs == null) {
			return allCount(pathes, assets);
		}
		return allCount(pathes, assets) + allCountChilds(chs);
	}

	private static inline function allCountChilds(chs: Array<Dynamic>): Int {
		var sum: UInt = 0;
		for (ch in chs) {
			final s = Type.resolveClass(ch);
			sum += @:nullSafety(Off) Reflect.getProperty(s, 'countAllAssets')(true);
		}
		return sum;
	}

	public static inline function allCount(pathes: Array<String>, assets: Array<String>): Int {
		return pathes.length * assets.length;
	}

	public static function loadComplete(source: (Int -> Int -> Void) -> Void, cb: Void -> Void): Void {
		var last: Bool = true;
		var check: (c:Int, t:Int) -> Void = function(c: Int, t: Int) last = c == t;
		source((c: Int, t: Int) -> check(c, t));
		DeltaTime.fixedUpdate < function() {
			if (last)
				cb();
			else
				check = function(c: Int, t: Int) if (c == t) cb();
		}
	}

	public static function loadList(count: Int, cb: Int -> Int -> Void): Array<Int -> Int -> Void> {
		final totals: Array<Int> = [for (_ in 0...count) 1];
		final currents: Array<Int> = [for (_ in 0...count) 0];
		return [
			for (i in 0...count) function(c: Int, t: Int) {
				currents[i] = c;
				totals[i] = t;
				cb(MathTools.arraySum(currents), MathTools.arraySum(totals));
			}
		];
	}

	@:nullSafety(Off)
	public static function parseInterval(asset: String): Array<String> {
		final a: Array<String> = asset.split('...');
		if (a.length != 2) return [asset];
		final right: Array<String> = a.pop().split('}');
		final left: Array<String> = a.pop().split('{');
		final begin: Int = Std.parseInt(left.pop());
		final sBegin: String = left.pop();
		final sEnd: String = right.pop();
		final end: Int = Std.parseInt(right.pop());
		return [for (i in begin ... end) sBegin + i + sEnd];
	}

	public static inline function removeBase(path: String): String {
		return path.substr(baseUrl.length);
	}

	public static inline function _load(asset: String, cb: Int -> Int -> Void): Void {
		final bytes: Null<Bytes> = units[asset.endsWith('.atlas.bin') || asset.endsWith('.wav.bin') || asset.endsWith('.mp3.bin')
			|| asset.endsWith('.ogg.bin')
			? asset.substr(0, -4)
			: asset];
		__load(bytes == null ? asset : hashNameConvert(asset, Base64.urlEncode(bytes)), cb);
	}

	public static function hashNameConvert(asset: String, hash: String): String {
		if (hash.length == 0) return asset;
		if (changedNames) {
			var p: SPair<String> = asset.lastSplit('.');
			return [p.a, hash, p.b].join('.');
		} else {
			return '$asset?$hash';
		}
	}

	public static function extractHash(asset: String): SPair<String> {
		if (changedNames) {
			final a: Array<String> = asset.split('.');
			@:nullSafety(Off) var ext: String = a.pop();
			final hash: Null<String> = a.pop();
			a.push(ext);
			return a.length > 0 && ![null, 'atlas', 'wav', 'mp3', 'ogg'].contains(hash) ? new Pair(a.join('.'), hash) : new Pair(asset, '');
		} else {
			return asset.firstSplit('?');
		}
	}

	#if heaps
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function __load(asset: String, cb: Int -> Int -> Void): Void HeapsAssets.load(asset, cb);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function _reset(asset: String): Void HeapsAssets.reset(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function image(asset: String, ?name: String) return HeapsAssets.image(asset, name);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function texture(asset: String, ?name: String) return HeapsAssets.texture(asset, name);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function animation(asset: String, ?name: String) return HeapsAssets.animation(asset, name);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function clip(asset: String, ?name: String) return HeapsAssets.clip(asset, name);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function text(asset: String): String return HeapsAssets.text(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function bin(asset: String): Bytes return HeapsAssets.bin(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function font(asset: String): h2d.Font return HeapsAssets.font(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function sound(asset: String) return HeapsAssets.sound(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function spine(asset: String) return asset;
	#elseif pixijs
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function __load(asset: String, cb: Int -> Int -> Void): Void
		PixiAssets.load(asset, cb.bind(MAX_ASSET_PROGRESS, MAX_ASSET_PROGRESS));

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function _reset(asset: String): Void PixiAssets.reset(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function image(asset: String, ?name: String) return PixiAssets.image(asset, name);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function texture(asset: String, ?name: String) return PixiAssets.texture(asset, name);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function animation(asset: String, ?name: String) return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function clip(asset: String, ?name: String) return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function sound(asset: String) return PixiAssets.sound(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function spine(asset: String) return PixiAssets.spine(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function text(asset: String): String return PixiAssets.text(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function json(asset: String) return PixiAssets.json(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function font(asset: String) return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function bin(asset: String) return asset;
	#elseif openfl
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function __load(asset: String, cb: Int -> Int -> Void): Void
		OpenflAssets.load(asset, cb.bind(1 MAX_ASSET_PROGRESS, MAX_ASSET_PROGRESS));

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function _reset(asset: String): Void trace('Reset: $asset');

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function image(asset: String, ?name: String) return OpenflAssets.image(asset);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function texture(asset: String, ?name: String) return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function animation(asset: String, ?name: String) return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function clip(asset: String, ?name: String) return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function sound(asset: String) return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function spine(asset: String) return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function font(asset: String) return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function bin(asset: String) return asset;
	#else
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function __load(asset: String, cb: Int -> Int -> Void): Void trace('Load: $asset');

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function _reset(asset: String): Void trace('Reset: $asset');

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function image(asset: String, ?name: String): String return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function texture(asset: String, ?name: String): String return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function animation(asset: String, ?name: String): String return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function clip(asset: String, ?name: String): String return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function sound(asset: String): String return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function spine(asset: String): String return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function font(asset: String): String return asset;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function bin(asset: String): String return asset;
	#end

}
