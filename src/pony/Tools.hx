package pony;

import pony.ds.ROArray;
import pony.ds.KeyValue;
import haxe.Constraints.Function;
import haxe.CallStack;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Eof;
import haxe.Log;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;
#end
import pony.text.TextTools;
import pony.math.MathTools;

using Reflect;
using Lambda;

/**
 * Tools
 * @author AxGord
 */
class Tools {

	#if (sys || js)
	public static var isWindows(get, never): Bool;
	#end

	private static inline var SRC: String = 'src';

	#if macro
	private static var _getBuildDate: String;
	#end

	macro public static function getBuildDate(): Expr {
		if (_getBuildDate == null) _getBuildDate = Date.now().toString();
		return Context.makeExpr(_getBuildDate, Context.currentPos());
	}

	#if (js && !nodejs)
	@:extern private static inline function get_isWindows(): Bool return pony.JsTools.os == pony.JsTools.OS.Windows;
	#elseif (sys || nodejs)
	@:extern private static inline function get_isWindows(): Bool return Sys.systemName() == 'Windows';
	#end

	/**
	 * Null Or Empty
	 * @author nadako <nadako@gmail.com>
	 */
	public static inline function nore<T: { var length(default, null): Int; }>(v: T): Bool
		return v == null || v.length == 0;

	public static inline function or<T>(v1: T, v2: T): T return v1 == null ? v2 : v1;

	/**
	 * with
	 * @author Simn <simon@haxe.org>
	 * @link https://gist.github.com/Simn/87948652a840ff544a22
	 */
	macro public static function with(e1:Expr, el:Array<Expr>): Expr {
		var tempName: String = 'tmp';
		var acc: Array<Expr> = [
			macro var $tempName = $e1
		];
		var eThis: Expr = macro $i{tempName};
		for (e in el) {
			var e = switch (e) {
				case macro $i{s}($a{args}):
					macro $eThis.$s($a{args});
				case macro $i{s} = $e:
					macro $eThis.$s = $e;
				case macro $i{s} += $e:
					macro $eThis.$s += $e;
				case macro $i{s} -= $e:
					macro $eThis.$s -= $e;
				case macro $i{s} *= $e:
					macro $eThis.$s *= $e;
				case macro $i{s} /= $e:
					macro $eThis.$s /= $e;
				case _:
					Context.error("Don't know what to do with " + e.toString(), e.pos);
			}
			acc.push(e);
		}
		return macro $b{acc};
	}

	/**
	 * Compare two value
	 * @author	deep <system.grand@gmail.com>
	 * @param	a
	 * @param	b
	 * @param	maxDepth -1 - infinity depth
	 * @return
	 */
	public static function equal(a: Dynamic, b: Dynamic, maxDepth: Int = 1): Bool {
		if (a == b) return true;
		if (maxDepth == 0) return false;
		switch Type.typeof(a) {
			case TInt, TFloat, TBool, TNull: return false;
			case TFunction:
				try {
					return Reflect.compareMethods(a, b);
				} catch (_: Dynamic) {
					return false;
				}
			case TEnum(t):
				if (t != Type.getEnum(b)) return false;
				if (Type.enumIndex(a) != Type.enumIndex(b)) return false;
				var a = Type.enumParameters(a);
				var b = Type.enumParameters(b);
				if (a.length != b.length) return false;
				for (i in 0...a.length)
					if (!equal(a[i], b[i], maxDepth - 1)) return false;
				return true;
			#if (haxe_ver >= 4.100)
			case TObject: if (Std.isOfType(a, Class)) return false;
			#else
			case TObject: if (Std.is(a, Class)) return false;
			#end
			case TUnknown:
			case TClass(t):
				if (t == Array) {
					#if (haxe_ver >= 4.100)
					if (!Std.isOfType(b, Array) || a.length != b.length) return false;
					#else
					if (!Std.is(b, Array) || a.length != b.length) return false;
					#end
					for (i in 0...a.length) if (!equal(a[i], b[i], maxDepth - 1)) return false;
					return true;
				}
		}
		// a is Object on Unknown or Class instance
		switch (Type.typeof(b)) {
			case TInt, TFloat, TBool, TFunction, TEnum(_), TNull: return false;
			#if (haxe_ver >= 4.100)
			case TObject: if (Std.isOfType(b, Class)) return false;
			#else
			case TObject: if (Std.is(b, Class)) return false;
			#end
			case TClass(t): if (t == Array) return false;
			case TUnknown:
		}
		var fields: Array<String> = a.fields();
		if (fields.length == b.fields().length) {
			if (fields.length == 0) return true;
			for (f in fields) if (!b.hasField(f) || !equal(a.field(f), b.field(f), maxDepth - 1)) return false;
				return true;
		}
		return false;
	}

	public static function clone<T: Dynamic>(obj: T): T {
		return switch Type.typeof(obj) {
			case TEnum(t):
				Type.createEnumIndex(t, Type.enumIndex(obj), [for (e in Type.enumParameters(obj)) clone(e)]);
			#if (haxe_ver >= 4.100)
			case TObject if (!Std.isOfType(obj, Class)):
			#else
			case TObject if (!Std.is(obj, Class)):
			#end
				_clone(obj);
			case TClass(Array):
				var obj:Array<Dynamic> = cast obj;
				cast [for (i in 0...obj.length) clone(obj[i])];
			case TClass(String):
				obj;
			case TClass(haxe.ds.IntMap):
				var obj:Map<Int, Dynamic> = obj;
				cast [for (k in obj.keys()) k => clone(obj[k])];
			case TClass(_):
				cast _clone(obj);
			case _:
				obj;
		}
	}

	private static function _clone<T: Dynamic>(obj: T): T {
		var n: T = cast {};
		for (p in obj.fields()) n.setField(p, clone(obj.field(p)));
		return n;
	}

	public static function superIndexOf<T>(it: Iterable<T>, v: T, maxDepth: Int = 1): Int {
		var i: Int = 0;
		if (maxDepth == 0) { //Avoiding extra function calls on maxDepth == 0
			for (e in it) {
				if (e == v) return i;
				i++;
			}
		} else {
			for (e in it) {
				if (equal(e, v, maxDepth)) return i;
				i++;
			}
		}
		return -1;
	}

	public static function superMultyIndexOf<T>(it: Iterable<T>, av: Array<T>, maxDepth: Int = 1): Int {
		var i: Int = 0;
		for (e in it) {
			for (v in av) if (equal(e, v, maxDepth)) return i;
			i++;
		}
		return -1;
	}

	public static function multyIndexOf<T>(it: Iterable<T>, av: Array<T>): Int {
		var i: Int = 0;
		for (e in it) {
			for (v in av) if (e == v) return i;
			i++;
		}
		return -1;
	}

	public static function joinBytes(bs: Array<Bytes>): Bytes {
		var bo: BytesOutput = new BytesOutput();
		for (b in bs) bo.write(b);
		return bo.getBytes();
	}

	/**
	 * @author BoBaH6eToH
	 * @param	b
	 * @return
	 */
	public static function cut(inp: BytesInput): BytesInput {
		var out: BytesOutput = new BytesOutput();
		var cntNull: Int = 0;
		var flagNull: Bool = true;
		var cur: Int = -99;
		while (true) {
			try {
				cur = inp.readByte();
			} catch (_: Dynamic) {
				break;
			}
			if (cur == 0) {
				if (!flagNull)
					flagNull = true;
				cntNull++;
			} else {
				if (flagNull)
					while (cntNull-- > 0)
						out.writeByte(0);
				flagNull = false;
				out.writeByte(cur);
			}
		}
		out.close();
		return new BytesInput(out.getBytes());
	}

	macro public static function usedLibs(): Expr {
		var d: Map<String, String> = Context.getDefines();
		var r: Map<String, String> = [];
		for (k in d.keys()) {
			var prev: String = null;
			for (line in new sys.io.Process('haxelib', ['path', k]).stdout.readAll().toString().split('\n')) {
				if (prev != null && line == '-D $k=${d[k]}') {
					r[k] = prev;
					break;
				}
				prev = line;
			}
		}
		return macro $v{r};
	}

	macro public static function currentFile(): Expr {
		var f: String = Context.getPosInfos(Context.currentPos()).file;
		f = sys.FileSystem.fullPath(f);
		return macro $v{f};
	}

	macro public static function currentDir(): Expr {
		var f: String = Context.getPosInfos(Context.currentPos()).file;
		f = StringTools.replace(sys.FileSystem.fullPath(f), '\\', '/').split('/').slice(0, -1).join('/') + '/';
		return macro $v{f};
	}

	macro public static function getHashFile(): Expr {
		var pony: String = 'pony.xml';
		if (!sys.FileSystem.exists(pony)) return macro null;
		Context.registerModuleDependency(Context.getLocalModule(), pony);
		var xml = new Fast(Xml.parse(sys.io.File.getContent(pony))).elements.next();
		if (!xml.hasNode.hash) return macro null;
		var hash: Fast = xml.node.hash;
		var root: String = hash.has.root ? hash.att.root : '';
		var path: String = hash.node.output.innerData;
		var asset: String = StringTools.startsWith(path, root) ? path.substr(root.length) : path;
		var version: String = haxe.crypto.Base64.urlEncode(haxe.crypto.Sha1.make(sys.io.File.getBytes(path)));
		var r: String = asset + '?' + version;
		return macro $v{r};
	}

	#if (!macro && (nodejs || sys))
	public static inline function ponyPath(): String {
		return libPath('pony');
	}

	public static function libPath(lib: String): String {
		var pd: String = '/';
		var libPath: String = null;
		#if nodejs
		var o: String = Std.string(js.node.ChildProcess.execSync('haxelib path $lib'));
		var lines: Array<String> = o.split('\n');
		do libPath = lines.shift() while (libPath == null || StringTools.startsWith(libPath, '-'));
		#elseif neko
		var out: haxe.io.Input = new sys.io.Process('haxelib', ['path', lib]).stdout;
		do libPath = out.readLine() while (libPath == null || StringTools.startsWith(libPath, '-'));
		#else
		throw 'Not supported';
		#end
		// remove src
		if (libPath.substr(-SRC.length) == SRC) {
			libPath = libPath.substr(0, -SRC.length);
		} else {
			var src:String = SRC + pd;
			if (libPath.substr(-src.length) == src) {
				libPath = libPath.substr(0, -src.length);
			} else if (isWindows) {
				var pd: String = '\\';
				var src:String = SRC + pd;
				if (libPath.substr(-src.length) == src)
					libPath = libPath.substr(0, -src.length);
			}
		}
		return StringTools.endsWith(libPath, '\\') ? libPath : TextTools.setLast(libPath, pd);
	}
	#end

	public static inline function exists<T>(a: Iterable<T>, e: T): Bool return a.indexOf(e) != -1;

	public static inline function bytesIterator(b: Bytes): Iterator<Byte> {
		var i: Int = 0;
		return {
			hasNext: function(): Bool return i < b.length,
			next: function(): Byte return b.get(i++)
		};
	}

	public static inline function bytesInputIterator(b: BytesInput): Iterator<Byte> {
		return {
			hasNext: function(): Bool return b.position < b.length,
			next: function(): Byte return b.readByte()
		};
	}

	macro public static function ifsw(e: Expr): Expr {
		var d: Array<Expr> = [];
		switch e.expr {
			case ESwitch(ex, cases, edef):
				for (c in cases) {
					var cond: Expr = { expr: EBinop(OpEq, ex, c.values[0]), pos: Context.currentPos() };
					d.push(macro if ($cond) ${c.expr});
				}
			default: throw 'This is not switch';
		}
		return { expr: EBlock(d), pos: Context.currentPos() };
	}

	public static function setFields(a: Dynamic, b: {}): Void {
		for (p in b.fields()) {
			var d:Dynamic = b.field(p);
			if (a.hasField(p) && d.isObject() &&
				#if (haxe_ver >= 4.100)
				!Std.isOfType(d, String) && !Std.isOfType(d, Array)
				#else
				!Std.is(d, String) && !Std.is(d, Array)
				#end
			)
				setFields(a.field(p), d);
			else
				a.setField(p, d);
		}
	}

	public static inline function copyFields(a: {}, b: {}): Void for (p in b.fields()) a.setField(p, b.field(p));

	public static function parsePrefixObjects(a: Dynamic<String>, delimiter: String = '_'): Dynamic<Dynamic> {
		var result: Dynamic<Dynamic> = {};
		for (f in a.fields()) {
			var d = f.split(delimiter);
			var obj: Dynamic<Dynamic> = result;
			for (i in 0...d.length - 1) {
				if (obj.hasField(d[i])) {
					obj = obj.field(d[i]);
				} else {
					var newObj: Dynamic<Dynamic> = {};
					obj.setField(d[i], newObj);
					obj = newObj;
				}
			}
			obj.setField(d.pop(), a.field(f));
		}
		return result;
	}

	public static function convertObject(a: {}, fun: Dynamic -> Dynamic): Dynamic<Dynamic> {
		var result: Dynamic<Dynamic> = {};
		for (p in a.fields()) {
			var d: Dynamic = a.field(p);
			result.setField(
				p, d.isObject() &&
				#if (haxe_ver >= 4.100)
				!Std.isOfType(d, String)
				#else
				!Std.is(d, String)
				#end
				? convertObject(d, fun) : fun(d)
			);
		}
		return result;
	}

	public static inline function traceThrow(e: String): Void {
		Log.trace(e, null);
		Log.trace(CallStack.toString(CallStack.exceptionStack()), null);
	}

	public static inline function writeStr(b: BytesOutput, s: String): Void {
		b.writeInt32(s.length);
		b.writeString(s);
	}

	public static function readStr(b: BytesInput): String {
		try {
			return b.readString(b.readInt32());
		} catch (_: Dynamic) return null;
	}

	public static function hexToBytes(hex: String): Bytes {
		var output: BytesOutput = new BytesOutput();
		for (i in 0...Std.int(hex.length / 2))
			output.writeByte(Std.parseInt(('0x' + hex.substr(i * 2, 2))));
		return output.getBytes();
	}

	#if (haxe_ver >= 3.300)
	@:generic public static inline function sget<A, B:haxe.Constraints.Constructible<Void -> Void>>(m: Map<A, B>, key: A): B
	#else
	@:generic public static inline function sget<A, B: { function new(): Void; }>(m: Map<A, B>, key: A): B
	#end
		return m.exists(key) ? m[key] : m[key] = new B();

	#if !cs
	public static inline function reverse<K: Dynamic, V: Dynamic>(map: Map<K, V>): Map<V, K> return [ for (k in map.keys()) map[k] => k ];
	#end
	public static inline function min(it: IntIterator): Int return it.field('min');
	public static inline function max(it: IntIterator): Int return it.field('max');
	public static inline function copy(it: IntIterator): IntIterator return it.field('min')...it.field('max');

	public static function nullFunction0(): Void return;
	public static function nullFunction1(_: Dynamic): Void return;
	public static function nullFunction2(_: Dynamic, _: Dynamic): Void return;
	public static function nullFunction3(_: Dynamic, _: Dynamic, _: Dynamic): Void return;
	public static function nullFunction4(_: Dynamic, _: Dynamic, _: Dynamic, _: Dynamic): Void return;
	public static function nullFunction5(_: Dynamic, _: Dynamic, _: Dynamic, _: Dynamic, _: Dynamic): Void return;
	public static function errorFunction(e: Dynamic): Void throw e;

	public static function own(c1: Class<Dynamic>, c2: Class<Dynamic>): Bool {
		var p: Class<Dynamic> = c2;
		while (p != null) {
			if (c1 == p) return true;
			p = Type.getSuperClass(c2);
		}
		return false;
	}

	#if (js || flash)
	@:extern inline
	#end
	public static function functionLength(f: Function): Int {
		#if php
		var rf = untyped __php__('new ReflectionMethod($f[0], $f[1])');
		return rf.getNumberOfParameters();
		#elseif (js || flash)
		return untyped f.length;
		#elseif cpp
		return Std.parseInt(Std.string(f).substr(10));
		#elseif neko
		return Std.parseInt(Std.string(f).split(':')[1]);
		#else
		return throw 'Function not work for current platform';
		#end
	}
}

class IterableTools {

	public static inline function calcCount<T>(it: Iterable<T>, fn: T -> UInt): UInt {
		var r: UInt = 0;
		for (e in it) r += fn(e);
		return r;
	}

	public static inline function array<T>(it: Iterator<T>): Array<T> return [ for (e in it) e ];

}

class ArrayTools {

	public static inline function exists<T>(a: Array<T>, e: T): Bool return a.indexOf(e) != -1;

	public static inline function existsOrPush<T>(a: Array<T>, e: T): Bool {
		var r: Bool = exists(a, e);
		if (!r) a.push(e);
		return r;
	}

	public static function thereIs<T>(a: Iterable<Array<T>>, b: Array<T>): Bool {
		for (e in a) if (Tools.equal(e, b)) return true;
		return false;
	}

	public static function kv<T>(a: Array<T>): Iterator < KeyValue< Int, T >> {
		var i: Int = 0;
		var it: Iterator<T> = a.iterator();
		return {
			hasNext: it.hasNext,
			next: function() {
				var p = new Pair(i, it.next());
				i++;
				return p;
			}
		};
	}

	public static function pair<A, B>(a: Iterable<A>, b: Iterable<B>): Iterator<Pair<A, B>> {
		var itA: Iterator<A> = a.iterator();
		var itB: Iterator<B> = b.iterator();
		return {
			hasNext: function() return itA.hasNext() && itB.hasNext(),
			next: function() return new Pair(itA.next(), itB.next())
		};
	}

	public static inline function toBytes(a: Array<Int>): BytesOutput {
		var b: BytesOutput = new BytesOutput();
		for (e in a) b.writeByte(e);
		return b;
	}

	/**
	 * Randomize
	 * Warning: This function modifies original array
	 */
	public static inline function randomize<T>(a: Array<T>): Array<T> {
		a.sort(randomizeSort);
		return a;
	}

	private static function randomizeSort(_: Dynamic, _: Dynamic): Int return Math.random() > 0.5 ? 1 : -1;

	public static inline function last<T: Dynamic>(a: Array<T>): T return a[a.length - 1];

	public static function swap<T>(array: Array<T>, a: Int, b: Int): Array<T> {
		if (a > b) return swap(array, b, a);
		else if (a == b) return array;
		var v1 = array[a];
		var v2 = array[b];
		var p1 = a == 0 ? [] : array.slice(0, a);
		var p2 = array.slice(a + 1, b);
		var p3 = array.slice(b + 1);
		p1.push(v2);
		p2.push(v1);
		return p1.concat(p2).concat(p3);
	}

	public static function delete<T>(array: Array<T>, index: Int): Array<T> {
		var na:Array<T> = array.copy();
		na.splice(index, 1);
		return na;
	}

	public static function fIndexOf<T>(a :Array<T>, f: T -> Bool): Int {
		var i: Int = 0;
		for (e in a) {
			if (f(e)) return i;
			i++;
		}
		return -1;
	}

	public static function sum<T: Float>(a: Array<T>): T {
		var sum: T = cast 0;
		for (v in a) sum += v;
		return sum;
	}

	public static function strlen(a: Array<String>): UInt {
		var sum: UInt = 0;
		for (v in a) sum += a.length;
		return sum;
	}

}

class MapTools {

	public static function kv<K, T>(a: Map<K, T>): Iterator<KeyValue<K, T>> {
		var it: Iterator<K> = a.keys();
		return {
			hasNext: it.hasNext,
			next: function() {
				var k: K = it.next();
				return new Pair(k, a[k]);
			}
		};
	}

	public static function toDynamic<T>(map: Map<String, T>): Dynamic<T> {
		var r: Dynamic<T> = {};
		for (e in kv(map)) r.setField(e.key, e.value);
		return r;
	}

	public static function toMap<T>(d: Dynamic<T>): Map<String, T> {
		var fields: Array<String> = d.fields();
		return [ for (field in fields) field => d.field(field) ];
	}

	public static inline function pushToMap<K, T>(map: Map<K, Array<T>>, key: K, value: T): Bool {
		var element: Null<Array<T>> = map[key];
		if (element == null) {
			map[key] = [value];
			return true;
		} else {
			map[key].push(value);
			return false;
		}
	}

	public static inline function pushToMapIfExists<K, T>(map: Map<K, Array<T>>, key: K, value: T): Bool {
		var element: Null<Array<T>> = map[key];
		if (element != null) {
			map[key].push(value);
			return true;
		} else {
			return false;
		}
	}

	public static inline function addToMap<A, B: Int, T>(map: Map<A, Map<B, T>>, a: A, b: B, value: T): Bool {
		var element: Null<Map<B, T>> = map[a];
		if (element == null) {
			map[a] = [ b => value ];
			return true;
		} else {
			map[a][b] = value;
			return false;
		}
	}

	public static inline function addToMapStr<A, T>(map: Map<A, Map<String, T>>, a: A, b: String, value: T): Bool {
		var element: Null<Map<String, T>> = map[a];
		if (element == null) {
			map[a] = [ b => value ];
			return true;
		} else {
			@:nullSafety(Off) map[a][b] = value;
			return false;
		}
	}

	public static inline function addToMapIfExists<A, B, T>(map: Map<A, Map<B, T>>, a: A, b: B, value: T): Bool {
		var element: Null<Map<B, T>> = map[a];
		if (element != null) {
			map[a][b] = value;
			return true;
		} else {
			return false;
		}
	}

	public static function minMaxKey<T>(map: Map<Int, T>): SPair<Int> {
		var max: Int = 0;
		var min: Int = MathTools.MAX_INT;
		for (len in map.keys()) {
			max = MathTools.cmax(max, len);
			min = MathTools.cmin(min, len);
		}
		return new SPair<Int>(min, max);
	}

	public static function minKey<T>(map: Map<Int, T>): Int {
		var min: Int = MathTools.MAX_INT;
		for (len in map.keys()) min = MathTools.cmin(min, len);
		return min;
	}

	public static function maxKey<T>(map: Map<Int, T>): Int {
		var max: Int = 0;
		for (len in map.keys()) max = MathTools.cmax(max, len);
		return max;
	}

	public static inline function mapCalcCount<K, T>(map: Map<K, T>, fn: K -> T -> UInt): UInt {
		var r: UInt = 0;
		#if (haxe_ver >= 4.000)
		for (k => v in map) r += fn(k, v);
		#else
		for (k in map.keys()) r += fn(k, map[k]);
		#end
		return r;
	}

	public static inline function changeKey<K, T>(map: Map<K, T>, from: K, to: K): Void {
		var v: T = map[from];
		map.remove(from);
		map[to] = v;
	}

	public static inline function merge<K, T>(a: Map<K, T>, b: Map<K, T>): Void {
		#if (haxe_ver >= 4.000)
		for (k => v in b) a[k] = v;
		#else
		for (k in b.keys()) a[k] = b[k];
		#end
	}

	public static inline function getOrEmptyMap<K: Int, A: Int, B>(map: Map<K, Map<A, B>>, k: K): Map<A, B> {
		var r: Null<Map<A, B>> = map[k];
		return r == null ? new Map<A, B>() : r;
	}

	public static inline function getOrEmptyArray<K: Int, B>(map: Map<K, ROArray<B>>, k: K): ROArray<B> {
		var r: Null<ROArray<B>> = map[k];
		return r == null ? [] : r;
	}

	public static inline function keysArray<T>(m: Map<T, Any>): Array<T> return [for (k in m.keys()) k];

}

class FloatTools {

	/**
	 * todo: negative numbers
	 * @param	ex
	 * @param	mask
	 * @return
	 */
	macro public static function toFixed(ex: Expr, mask: String): Expr {
		var s: String = if (mask.indexOf('.') != -1) '.';
			else if (mask.indexOf(',') != -1) ',';
			else '!';
		var a: Array<String> = s == '!' ? [mask, ''] : mask.split(s);
		if (s == '!') s = '.';
		var beginS: String = a[0].length > 0 ? a[0].charAt(0) : '0';
		var endS: String = a[1].length > 0 ? a[1].charAt(0) : '0';
		return macro FloatTools._toFixed($a{[$ex, $v{a[1].length}, $v{a[0].length}, $v{s}, $v{beginS}, $v{endS}]});
	}

	public static function _toFixed(v: Float, n: Int, begin: Int = 0, d: String = '.', beginS: String = '0', endS: String = '0'): String {
		if (begin > 0) {
			var s: String = _toFixed(v, n, 0, d, beginS, endS);
			var a: Array<String> = s.split(d);
			var d: Int = begin - a[0].length;
			return TextTools.repeat(beginS, d) + s;
		}
		if (n == 0) return Std.string(Std.int(v));
		var p: Float = Math.pow(10, n);
		v = Math.floor(v * p) / p;
		var s: String = Std.string(v);
		var a: Array<String> = s.split('.');
		if (a.length <= 1)
			return (begin == -1 ? '' : s) + d + TextTools.repeat(endS, n);
		else
			return (begin == -1 ? '' : a[0]) + d + a[1] + TextTools.repeat(endS, n - a[1].length);
	}

}