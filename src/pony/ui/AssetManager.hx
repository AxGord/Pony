package pony.ui;

import haxe.rtti.Meta;
#if heaps
import pony.heaps.HeapsAssets;
#elseif pixijs
import pony.pixi.PixiAssets;
#elseif openfl
import pony.openfl.OpenflAssets;
#end
import pony.Or;
import pony.Tasks;
import pony.math.MathTools;
import pony.time.DeltaTime;
import pony.ui.gui.slices.SliceTools;

using Lambda;

/**
 * AssetManager
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
class AssetManager {

	public static inline var MAX_ASSET_PROGRESS: Int = 10;

	public static var baseUrl: String = '';
	private static var loadedAssets: Array<String> = [];
	private static var globalLoad: Map<String, Array<Int -> Int -> Void>> = new Map();

	public static var local: String = '';

	public static function resetAll(): Void {
		for (e in loadedAssets.copy()) reset(e);
	}

	public static inline function reset(asset: String): Void {
		loadedAssets.remove(asset);
		_reset(asset);
	}

	@:extern public static inline function getPath(asset: String): String {
		return baseUrl + StringTools.replace(asset, '{local}', local);
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
		var loaded:Array<Int> = [for (_ in 0...pathes.length) 0];
		var totals:Array<Int> = [for (_ in 0...pathes.length) MAX_ASSET_PROGRESS];
		var i:Int = 0;
		var prevLoaded:Int = 0;
		var prevTotals:Int = 0;
		for (path in pathes) {
			var n:Int = i++;
			load(path, assets, function(a:Int, t:Int) {
				loaded[n] = a;
				totals[n] = t;
				var loadedSum = sum(loaded);
				var totalSum = sum(totals);
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
				var r:Array<String> = parseInterval(a);
				if (r.length == 1)
					r = SliceTools.getNames(r[0]);
				if (r.length > 1) asset = OrState.B(r);
			case OrState.B(a):
				if (a.length == 1)
					return load(path, OrState.A(a[0]), cb);
				else if (a.length == 0)
					return cb(0, 0);
		}
		switch asset {
			case OrState.A(asset):
				asset = (path == '' ? '' : path + '/') + asset;
				if (loadedAssets.indexOf(asset) != -1) {
					cb(MAX_ASSET_PROGRESS, MAX_ASSET_PROGRESS);
					return;
				}
				var a: Null<Array<(Int, Int) -> Void>> = globalLoad[asset];
				if (a != null) {
					cb(0, MAX_ASSET_PROGRESS);
					a.push(cb);
				} else {
					globalLoad[asset] = [];
					var called:Bool = false;
					_load(asset, function(c:Int, t:Int) {
						cb(c, t);
						globalLoaded(asset, c, t);
						called = true;
					});
					if (!called) cb(0, MAX_ASSET_PROGRESS);
				}
			case OrState.B(assets):
				var loaded:Array<Int> = [for (_ in 0...assets.length) 0];
				var totals:Array<Int> = [for (_ in 0...assets.length) MAX_ASSET_PROGRESS];
				var i:Int = 0;
				var prevLoaded:Int = 0;
				var prevTotals:Int = 0;
				for (asset in assets) {
					var n:Int = i++;
					load(path, asset, function(c:Int, t:Int) {
						loaded[n] = c;
						totals[n] = t;
						var loadedSum = sum(loaded);
						var totalSum = sum(totals);
						if (loadedSum != prevLoaded || totalSum != prevTotals) {
							prevLoaded = loadedSum;
							prevTotals = totalSum;
							cb(loadedSum, totalSum);
						}
					});
				}
		}
	}

	private static function sum(a: Array<Int>): Int return Lambda.fold(a, _sum, 0);
	private static function _sum(v: Int, p: Int): Int return v + p;

	private static function globalLoaded(asset: String, c: Int, t: Int): Void {
		var a: Null<Array<(Int, Int) -> Void>> = globalLoad[asset];
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

	public static function isLoaded(asset: String):  Bool return loadedAssets.indexOf(asset) != -1;

	public static function loadPackWithChilds(cl: String, pathes: Array<String>, assets: Array<String>, cb: Int -> Int -> Void): Void {
		var chs = Meta.getType(Type.resolveClass(cl)).assets_childs;
		if (chs == null) {
			loadPack(pathes, assets, cb);
			return;
		}
		var p = cbjoin(cb);
		loadPack(pathes, assets, p.a);
		loadChildPack(chs, p.b);
	}

	private static function loadChildPack(chs: Array<Dynamic>, cb: Int -> Int -> Void): Void {
		var f = cb;
		for (i in 0...(chs.length - 1)) {
			var p = cbjoin(f);
			f = p.a;
			var s = Type.resolveClass(chs[i]);
			if (s != null)
				Reflect.getProperty(s, 'loadAllAssets')(true, p.b);
			else
				p.b(0, 0); //skip load
		}
		var s = Type.resolveClass(chs[chs.length - 1]);
		if (s != null)
			Reflect.getProperty(s, 'loadAllAssets')(true, f);
		else
			f(0, 0); //skip load
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

	public static function allCountWithChilds(cl:String, pathes:Array<String>, assets:Array<String>):Int {
		var chs = Meta.getType(Type.resolveClass(cl)).assets_childs;
		if (chs == null) {
			return allCount(pathes, assets);
		}
		return allCount(pathes, assets) + allCountChilds(chs);
	}

	private static inline function allCountChilds(chs: Array<Dynamic>): Int {
		var sum: UInt = 0;
		for (ch in chs) {
			var s = Type.resolveClass(ch);
			sum += Reflect.getProperty(s, 'countAllAssets')(true);
		}
		return sum;
	}

	public static inline function allCount(pathes: Array<String>, assets: Array<String>): Int {
		return pathes.length * assets.length;
	}

	public static function loadComplete(source: (Int -> Int -> Void) -> Void, cb: Void -> Void): Void {
		var last: Bool = true;
		var check = function(c: Int, t: Int) last = c == t;
		source(function(c: Int, t: Int) check(c, t));
		DeltaTime.fixedUpdate < function() {
			if (last) cb();
			else check = function(c: Int, t: Int) if (c == t) cb();
		}
	}

	public static function loadList(count: Int, cb: Int -> Int -> Void): Array<Int -> Int -> Void> {
		var totals: Array<Int> = [for (_ in 0...count) 1];
		var currents: Array<Int> = [for (_ in 0...count) 0];
		return [for (i in 0...count) function(c: Int, t: Int) {
			currents[i] = c;
			totals[i] = t;
			cb(MathTools.arraySum(currents), MathTools.arraySum(totals));
		}];
	}

	@:nullSafety(Off)
	public static function parseInterval(asset: String): Array<String> {
		var a: Array<String> = asset.split('...');
		if (a.length != 2) return [asset];
		var right: Array<String> = a.pop().split('}');
		var left: Array<String> = a.pop().split('{');
		var begin: Int = Std.parseInt(left.pop());
		var sBegin: String = left.pop();
		var sEnd: String = right.pop();
		var end: Int = Std.parseInt(right.pop());
		return [for (i in begin...end) sBegin + i + sEnd];
	}

	public static inline function removeBase(path: String): String {
		return path.substr(baseUrl.length);
	}

	#if heaps
	@:extern public static inline function _load(asset: String, cb: Int -> Int -> Void): Void HeapsAssets.load(asset, cb);
	@:extern public static inline function _reset(asset: String): Void HeapsAssets.reset(asset);
	@:extern public static inline function image(asset: String, ?name: String) return HeapsAssets.image(asset, name);
	@:extern public static inline function texture(asset: String, ?name: String) return HeapsAssets.texture(asset, name);
	@:extern public static inline function animation(asset: String, ?name: String) return HeapsAssets.animation(asset, name);
	@:extern public static inline function clip(asset: String, ?name: String) return HeapsAssets.clip(asset, name);
	@:extern public static inline function text(asset: String): String return HeapsAssets.text(asset);
	@:extern public static inline function sound(asset: String) return asset;
	@:extern public static inline function spine(asset: String) return asset;
	#elseif pixijs
	@:extern public static inline function _load(asset: String, cb: Int -> Int -> Void): Void
		PixiAssets.load(asset, cb.bind(MAX_ASSET_PROGRESS, MAX_ASSET_PROGRESS));
	@:extern public static inline function _reset(asset: String): Void PixiAssets.reset(asset);
	@:extern public static inline function image(asset: String, ?name: String) return PixiAssets.image(asset, name);
	@:extern public static inline function texture(asset: String, ?name: String) return PixiAssets.texture(asset, name);
	@:extern public static inline function animation(asset: String, ?name: String) return asset;
	@:extern public static inline function clip(asset: String, ?name: String) return asset;
	@:extern public static inline function sound(asset: String) return PixiAssets.sound(asset);
	@:extern public static inline function spine(asset: String) return PixiAssets.spine(asset);
	@:extern public static inline function text(asset: String): String return PixiAssets.text(asset);
	@:extern public static inline function json(asset: String) return PixiAssets.json(asset);
	#elseif openfl
	@:extern public static inline function _load(asset: String, cb: Int -> Int -> Void): Void
		OpenflAssets.load(asset, cb.bind(1MAX_ASSET_PROGRESS, MAX_ASSET_PROGRESS));
	@:extern public static inline function _reset(asset: String): Void trace('Reset: $asset');
	@:extern public static inline function image(asset: String, ?name: String) return OpenflAssets.image(asset);
	@:extern public static inline function texture(asset: String, ?name: String) return asset;
	@:extern public static inline function animation(asset: String, ?name: String) return asset;
	@:extern public static inline function clip(asset: String, ?name: String) return asset;
	@:extern public static inline function sound(asset: String) return asset;
	@:extern public static inline function spine(asset: String) return asset;
	#else
	@:extern public static inline function _load(asset: String, cb: Int -> Int -> Void): Void trace('Load: $asset');
	@:extern public static inline function _reset(asset: String): Void trace('Reset: $asset');
	@:extern public static inline function image(asset: String, ?name: String) return asset;
	@:extern public static inline function texture(asset: String, ?name: String) return asset;
	@:extern public static inline function animation(asset: String, ?name: String) return asset;
	@:extern public static inline function clip(asset: String, ?name: String) return asset;
	@:extern public static inline function sound(asset: String) return asset;
	@:extern public static inline function spine(asset: String) return asset;
	#end
}