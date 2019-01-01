package pony.ui;

import haxe.rtti.Meta;
#if pixijs
import pony.pixi.PixiAssets;
#elseif openfl
import pony.openfl.OpenflAssets;
#end
import pony.Or;
import pony.Tasks;
import pony.math.MathTools;
import pony.time.DeltaTime;
using Lambda;

/**
 * AssetManager
 * @author AxGord <axgord@gmail.com>
 */
class AssetManager {

	public static var baseUrl:String = '';
	private static var loadedAssets:Array<String> = [];
	private static var globalLoad:Map<String, Array<Void->Void>> = new Map();
	
	public static var local:String = '';
	
	@:extern inline public static function getPath(asset:String):String {
		return baseUrl + StringTools.replace(asset, '{local}', local);
	}
	
	public static dynamic function monitor(current:Int, total:Int):Void {}
	
	public static function loadPack(pathes:Array<String>, assets:Array<String>, cb:Int->Int->Void):Void {
		if (assets.length == 0) {
			cb(0, 0);
			return;
		}
		if (pathes.length == 0) {
			loadPath(assets, cb);
			return;
		} else if (pathes.length == 1) {
			loadPath([for (a in assets) pathes[0] + '/' + a], cb);
			return;
		}
		var total = pathes.length * assets.length;
		var loaded:Array<Int> = [];
		var i = 0;
		function update() {
			var s = 0;
			for (l in loaded) s += l;
			cb(s, total);
		}
		var called:Bool = false;
		for (path in pathes) {
			loaded.push(0);
			var n = i++;
			loadPath(path, assets, function(a:Int, _) {
				if (a == 0) return;
				loaded[n] = a;
				update();
				called = true;
			});
		}
		if (!called) cb(0, total);
	}
	
	public static function loadPath(path:String = '', assets:Array<String>, cb:Int->Int->Void):Void {
		var i = 0;
		var l = assets.length;
		for (asset in assets) {
			load(path, asset, function() cb(++i, l));
		}
		if (i == 0) cb(0, l);
	}
	
	public static function load(path:String, asset:Or<String,Array<String>>, cb:Void->Void):Void {
		switch asset {
			case OrState.A(asset):
				asset = (path == '' ? '' : path + '/') + asset;
				if (loadedAssets.indexOf(asset) != -1) {
					cb();
					return;
				}
				if (globalLoad.exists(asset)) {
					globalLoad[asset].push(cb);
				} else {
					globalLoad[asset] = [];
					_load(asset, function() {
						cb();
						globalLoaded(asset);
					});
				}
			case OrState.B(assets):
				var tasks:Tasks = new Tasks(cb);
				tasks.add();
				for (asset in assets) {
					tasks.add();
					load(path, asset, tasks.end);
				}
				tasks.end();
		}
	}
	
	private static function globalLoaded(asset:String):Void {
		loadedAssets.push(asset);
		for (f in globalLoad[asset]) f();
		globalLoad[asset] = null;
		monitor(loadedAssets.length, globalLoad.count());
	}
	
	public static function backLoad(asset:String):Void {
		if (loadedAssets.indexOf(asset) != -1) return;
		if (!globalLoad.exists(asset)) {
			globalLoad[asset] = [];
			_load(asset, globalLoaded.bind(asset));
		}
	}
	
	public static function loadPackWithChilds(cl:String, pathes:Array<String>, assets:Array<String>, cb:Int->Int->Void):Void {
		var chs = Meta.getType(Type.resolveClass(cl)).assets_childs;
		if (chs == null) {
			loadPack(pathes, assets, cb);
			return;
		}
		var p = cbjoin(cb);
		loadPack(pathes, assets, p.a);
		loadChildPack(chs, p.b);
	}
	
	private static function loadChildPack(chs:Array<Dynamic>, cb:Int->Int->Void):Void {
		var f = cb;
		for (i in 0...(chs.length-1)) {
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

	public static function cbjoin(cb:Int->Int->Void):Pair<Int->Int->Void, Int->Int->Void> {
		var aCurrent:Int = 0;
		var aTotal:Int = 1;
		var bCurrent:Int = 0;
		var bTotal:Int = 1;
		function a(c:Int, t:Int) {
			aCurrent = c;
			aTotal = t;
			cb(bCurrent+c, bTotal+t);
		}
		function b(c:Int, t:Int) {
			bCurrent = c;
			bTotal = t;
			cb(aCurrent+c, aTotal+t);
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
	
	inline private static function allCountChilds(chs:Array<Dynamic>):Int {
		var sum = 0;
		for (ch in chs) {
			var s = Type.resolveClass(ch);
			sum += Reflect.getProperty(s, 'countAllAssets')(true);
		}
		return sum;
	}
	
	inline public static function allCount(pathes:Array<String>, assets:Array<String>):Int {
		return pathes.length * assets.length;
	}
	
	public static function loadComplete(source:(Int->Int->Void)->Void, cb:Void->Void):Void {
		var last:Bool = true;
		var check = function(c:Int, t:Int) last = c == t;
		source(function(c:Int, t:Int) check(c, t));
		DeltaTime.fixedUpdate < function() {
			if (last) cb();
			else check = function(c:Int, t:Int) if (c == t) cb();
		}
	}
	
	public static function loadList(count:Int, cb:Int->Int->Void):Array<Int->Int->Void> {
		var totals:Array<Int> = [for (_ in 0...count) 1];
		var currents:Array<Int> = [for (_ in 0...count) 0];
		return [for (i in 0...count) function(c:Int, t:Int) {
			currents[i] = c;
			totals[i] = t;
			cb(MathTools.arraySum(currents), MathTools.arraySum(totals));
		}];
	}
	
	#if pixijs
	@:extern inline public static function _load(asset:String, cb:Void->Void):Void PixiAssets.load(asset, cb);
	@:extern inline public static function image(asset:String, ?name:String) return PixiAssets.image(asset, name);
	@:extern inline public static function texture(asset:String, ?name:String) return PixiAssets.texture(asset, name);
	@:extern inline public static function sound(asset:String) return PixiAssets.sound(asset);
	@:extern inline public static function spine(asset:String) return PixiAssets.spine(asset);
	@:extern inline public static function text(asset:String) return PixiAssets.text(asset);
	@:extern inline public static function json(asset:String) return PixiAssets.json(asset);
	#elseif openfl
	@:extern inline public static function _load(asset:String, cb:Void->Void):Void OpenflAssets.load(asset, cb);
	@:extern inline public static function image(asset:String, ?name:String) return OpenflAssets.image(asset);
	@:extern inline public static function texture(asset:String, ?name:String) return asset;
	#else
	@:extern inline public static function _load(asset:String, cb:Void->Void):Void trace('Load: $asset');
	@:extern inline public static function image(asset:String, ?name:String) return asset;
	@:extern inline public static function texture(asset:String, ?name:String) return asset;
	#end
}