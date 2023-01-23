package pony;

import haxe.Log;
import haxe.PosInfos;
import haxe.Timer;

import pony.ILogable;
import pony.SPair;
import pony.events.Listener2;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.time.DTimer;

using Lambda;

using pony.Tools;
using pony.text.TextTools;

/**
 * Logable
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Logable implements ILogable implements HasSignal {

	private static inline var DLM: String = ' ';
	private static inline var MS: String = ' ms';
	private static inline var MS_LEN: UInt = 1000;
	private static inline var FRACTION_TO_ROUND: UInt = 100;

	@:nullSafety(Off) private static var l_usedLibs: Map<String, String> = null;
	private static var l_origTrace: Null<Dynamic -> ?PosInfos -> Void>;
	private static var l_debugObjects: Array<{}> = [];

	@:lazy public var onLog: Signal2<String, Null<PosInfos>>;
	@:lazy public var onError: Signal2<String, Null<PosInfos>>;

	public var logActive(get, never): Bool;
	public var errorActive(get, never): Bool;

	private var logPrefix: String;
	private var l_benches: Map<String, Float> = new Map<String, Float>();

	public function new(?prefix: String) {
		logPrefix = prefix == null ? '' : prefix + DLM;
	}

	private inline function get_logActive(): Bool {
		#if disableLogs
		return false;
		#else
		return eLog != null && !eLog.empty;
		#end
	}

	private inline function get_errorActive(): Bool {
		#if disableErrors
		return false;
		#else
		return eError != null && !eError.empty;
		#end
	}

	public function listenError(l: ILogable, ?id: String): Void {
		#if !disableErrors
		onError; // init signal
		if (id == null && logPrefix == '') {
			l.onError << eError;
		} else {
			var listener: Listener2<String, PosInfos> = id != null ? function(s: String, p: PosInfos): Void error(id + DLM + s, p) : error;
			function listen(): Void l.onError << listener;
			function unlisten(): Void l.onError >> listener;
			if (!eError.empty) l.onError << listener;
			eError.onTake << listen;
			eError.onLost << unlisten;
		}
		#end
	}

	public function listenLog(l: ILogable, ?id: String): Void {
		#if !disableLogs
		onLog; // init signal
		if (id == null && logPrefix == '') {
			l.onLog << eLog;
		} else {
			var listener: Listener2<String, PosInfos> = id != null ? function(s: String, p: PosInfos): Void log(id + DLM + s, p) : log;
			function listen(): Void l.onLog << listener;
			function unlisten(): Void l.onLog >> listener;
			if (!eLog.empty) l.onLog << listener;
			eLog.onTake << listen;
			eLog.onLost << unlisten;
		}
		#end
	}

	public inline function listenErrorAndLog(l: ILogable, ?id: String): Void {
		listenError(l, id);
		listenLog(l, id);
	}

	public inline function error(s: String, ?p: PosInfos): Void {
		#if !disableErrors
		if (errorActive) eError.dispatch(logPrefix + s, p);
		#end
	}

	public inline function log(s: String, ?p: PosInfos): Void {
		#if !disableLogs
		if (logActive) eLog.dispatch(logPrefix + s, p);
		#end
	}

	public inline function errorf(fn: Void -> String, ?p: PosInfos): Void {
		#if !disableErrors
		if (errorActive) eError.dispatch(@:nullSafety(Off) fn(), p);
		#end
	}

	public inline function logf(fn: Void -> String, ?p: PosInfos): Void {
		#if !disableLogs
		if (logActive) eLog.dispatch(@:nullSafety(Off) fn(), p);
		#end
	}

	public inline function traceLogs(time: Bool = true, date: Bool = false): Void {
		#if !disableLogs
		onLog << (date ? traceWithDate : time ? traceWithTime : Log.trace);
		#end
	}

	public inline function traceErrors(time: Bool = true, date: Bool = false): Void {
		#if !disableErrors
		onError << (date ? traceErrorWithDate : time ? traceErrorWithTime : traceError);
		#end
	}

	private function l_pathErrorPosInfos(p: Null<PosInfos>): Null<PosInfos> {
		return if (p != null) {
			final params: Array<Dynamic> = ['color: darkred'];
			if (p.customParams != null) params.concat(p.customParams);
			{
				fileName: p.fileName,
				customParams: params,
				methodName: p.methodName,
				className: p.className,
				lineNumber: p.lineNumber
			};
		} else {
			null;
		}
	}

	public inline function traceAll(): Void {
		traceLogs();
		traceErrors();
	}

	public inline function stopTraceLogs(): Void {
		#if !disableLogs
		onLog >> traceWithDate;
		onLog >> traceWithTime;
		onLog >> Log.trace;
		#end
	}

	public inline function stopTraceErrors(): Void {
		#if !disableErrors
		onError >> traceErrorWithDate;
		onError >> traceErrorWithTime;
		onError >> traceError;
		#end
	}

	public inline function stopTraceAll(): Void {
		stopTraceLogs();
		stopTraceErrors();
	}

	public static function traceWithDate(v: String, ?p: PosInfos): Void Log.trace(v, addDateToPosInfosFileName(p));
	public static function traceWithTime(v: String, ?p: PosInfos): Void Log.trace(v, addTimeToPosInfosFileName(p));

	public static function traceErrorWithDate(v: String, ?p: PosInfos): Void {
		traceError(v, addDateToPosInfosFileName(p));
	}

	public static function traceErrorWithTime(v: String, ?p: PosInfos): Void {
		traceError(v, addTimeToPosInfosFileName(p));
	}

	public static function traceError(value: String, ?pos: PosInfos): Void {
		#if js
		if (l_usedLibs != null)
			l_vscodeError(value, pos);
		else
			js.Browser.console.error(formatPosWithSpace(pos) + value);
		#else
		Log.trace(value, pos);
		#end
	}

	public static inline function addDateToPosInfosFileName(p: Null<PosInfos>): Null<PosInfos> {
		return addToPosInfosFileName(Date.now().toString() + haxe.Timer.stamp()._toFixed(3, -1), p);
	}

	public static inline function addTimeToPosInfosFileName(p: Null<PosInfos>): Null<PosInfos> {
		return addToPosInfosFileName(DateTools.format(Date.now(), '%H:%M:%S') + haxe.Timer.stamp()._toFixed(3, -1), p);
	}

	public static inline function addToPosInfosFileName(v: String, p: Null<PosInfos>): Null<PosInfos> {
		return p == null ? null : {
			fileName: '$v ${p.fileName}',
			customParams: p.customParams,
			methodName: p.methodName,
			className: p.className,
			lineNumber: p.lineNumber
		};
	}

	public static function vscodePatchTrace(): Void {
		@SuppressWarnings('checkstyle:MagicNumber')
		#if (haxe_ver > 4.2)
		l_usedLibs = Tools.usedLibsDirs();
		#else
		l_usedLibs = new Map();
		#end
		l_origTrace = Log.trace;
		Log.trace = l_vscodeTrace;
	}

	private static inline function l_replaceLibPath(path: String): String {
		var p: SPair<String> = path.firstSplit('/');
		var lib: Null<String> = l_usedLibs[p.a];
		return (lib != null ? lib : './') + path;
	}

	private static inline function l_patchFileName(p: Null<PosInfos>): Null<PosInfos> {
		return if (p == null) null else {
			var r: SPair<String> = p.fileName.lastSplit(' ');
			{
				fileName: r.b != '' ? r.a + ' ' + l_replaceLibPath(r.b) : l_replaceLibPath(r.a),
				customParams: p.customParams,
				methodName: p.methodName,
				className: p.className,
				lineNumber: p.lineNumber
			}
		};
	}

	public static inline function formatPos(p: Null<PosInfos>): String return p != null ? '${p.fileName}:${p.lineNumber}:' : '';
	public static inline function formatPosWithSpace(p: Null<PosInfos>): String return p != null ? formatPos(p) + ' ' : '';

	public static function l_vscodeTrace(value: Dynamic, ?pos: PosInfos): Void {
		#if js
		l_vscodeTraceBase(js.Browser.console.log, value, pos);
		#else
		@:nullSafety(Off) l_origTrace(value, pos);
		#end
	}

	public static function l_vscodeError(value: Dynamic, ?pos: PosInfos): Void {
		#if js
		l_vscodeTraceBase(js.Browser.console.error, value, pos);
		#else
		@:nullSafety(Off) l_origTrace(value, pos);
		#end
	}

	#if js
	private static function l_vscodeTraceBase(method: haxe.extern.Rest<Dynamic> -> Void, value: Dynamic, ?p: PosInfos): Void {
		var p: Null<PosInfos> = l_patchFileName(p);
		var place: String = '';
		var prms: Array<Dynamic> = [value];
		if (p != null) {
			place = formatPos(p);
			if (p.customParams != null) prms = prms.concat(p.customParams);
		}
		if (prms.foreach(isSimpleType)) {
			#if nodejs
			prms.unshift('\x1b[2m$place\x1b[0m');
			#else
			prms.unshift('color: gray');
			prms.unshift('%c' + place);
			#end
		} else {
			prms.unshift(place);
		}
		try {
			Reflect.callMethod(js.Browser.console, method, prms);
		} catch (_: Any) {}
	}
	#end

	public inline function bench(?name: String, f: Void -> Void, ?p: PosInfos): Void {
		#if !disableLogs
		if (!logActive) return;
		name = name != null ? ': ' + name : '';
		log('Begin bench' + name, p);
		var time: Float = Timer.stamp();
		f();
		log('End bench' + name + ' ' + l_benchTime(time) + MS, p);
		#end
	}

	public inline function benchAsync(?name: String, f: (Void -> Void) -> Void, ?p: PosInfos): Void {
		#if !disableLogs
		if (!logActive) return;
		name = name != null ? ': ' + name : '';
		log('Begin async bench' + name, p);
		var time: Float = Timer.stamp();
		f(function(): Void log('End async bench' + name + ' ' + l_benchTime(time) + MS, p));
		#end
	}

	public inline function benchStart(name: String, ?p: PosInfos): Void {
		#if !disableLogs
		if (!logActive) return;
		log('Begin bench: ' + name, p);
		l_benches[name] = Timer.stamp();
		#end
	}

	public inline function benchComplete(name: String, ?p: PosInfos): Void {
		#if !disableLogs
		if (!logActive) return;
		var time: Null<Float> = l_benches[name];
		if (time == null) {
			error('Bench $name completed or not started');
		} else {
			l_benches.remove(name);
			log('End bench: ' + name + ' ' + l_benchTime(time)  + MS, p);
		}
		#end
	}

	private static inline function l_benchTime(time: Float): Float {
		return Std.int((Timer.stamp() - time) * FRACTION_TO_ROUND * MS_LEN) / FRACTION_TO_ROUND;
	}

	public static inline function debugGetObjectId(obj: {}): UInt {
		var id: Int = l_debugObjects.indexOf(obj);
		return id == -1 ? l_debugObjects.push(obj) - 1 : id;
	}

	public static inline function debugClearObjectsId(): Void l_debugObjects.resize(0);

	public function destroy(): Void destroySignals();

	private static function isSimpleType(value: Dynamic): Bool {
		@SuppressWarnings('checkstyle:MagicNumber')
		#if (haxe_ver >= 4.100)
		return value == null || Std.isOfType(value, String) || Std.isOfType(value, Float);
		#else
		return value == null || Std.is(value, String) || Std.is(value, Float);
		#end
	}

}