package pony;

import haxe.Log;
import haxe.PosInfos;
import haxe.Timer;

import pony.SPair;
import pony.ILogable;
import pony.time.DTimer;
import pony.events.Signal2;
import pony.events.Listener2;
import pony.magic.HasSignal;

using pony.text.TextTools;
using pony.Tools;

/**
 * Logable
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Logable implements ILogable implements HasSignal {

	private static inline var DLM: String = ' ';

	@:nullSafety(Off) private static var l_usedLibs: Map<String, String>;
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
		#if disableLogs
		return false;
		#else
		return eError != null && !eError.empty;
		#end
	}

	public inline function listenError(l: ILogable, ?id: String): Void {
		#if !disableErrors
		onError; // init signal
		if (id != null) {
			var listener: Listener2<String, PosInfos> = function(s: String, p: PosInfos): Void error(id + DLM + s, p);
			function listen(): Void l.onError << listener;
			function unlisten(): Void l.onError >> listener;
			if (!eError.empty) l.onError << listener;
			eError.onTake << listen;
			eError.onLost << unlisten;
		} else {
			if (logPrefix == '') {
				l.onError << eError;
			} else {
				function listen(): Void l.onError << error;
				function unlisten(): Void l.onError >> error;
				if (!eError.empty) l.onError << error;
				eError.onTake << listen;
				eError.onLost << unlisten;
			}
		}
		#end
	}

	public inline function listenLog(l: ILogable, ?id: String): Void {
		#if !disableLogs
		onLog; // init signal
		if (id != null) {
			var listener: Listener2<String, PosInfos> = function(s: String, p: PosInfos): Void log(id + DLM + s, p);
			function listen(): Void l.onLog << listener;
			function unlisten(): Void l.onLog >> listener;
			if (!eLog.empty) l.onLog << listener;
			eLog.onTake << listen;
			eLog.onLost << unlisten;
		} else {
			if (logPrefix == '') {
				l.onLog << eLog;
			} else {
				function listen(): Void l.onLog << log;
				function unlisten(): Void l.onLog >> log;
				if (!eLog.empty) l.onLog << log;
				eLog.onTake << listen;
				eLog.onLost << unlisten;
			}
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
		#if (js && !nodejs)
		onError << (date ? l_errorWithDate : time ? l_errorWithTime : l_errorLogTrace);
		#else
		onError << (date ? traceWithDate : time ? traceWithTime : Log.trace);
		#end
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

	private function l_errorWithDate(v: String, ?p: PosInfos): Void {
		if (p != null) v = '%c$v';
		traceWithDate(v, l_pathErrorPosInfos(p));
	}

	private function l_errorWithTime(v: String, ?p: PosInfos): Void {
		if (p != null) v = '%c$v';
		traceWithTime(v, l_pathErrorPosInfos(p));
	}

	private function l_errorLogTrace(v: String, ?p: PosInfos): Void {
		if (p != null) v = '%c$v';
		Log.trace(v, l_pathErrorPosInfos(p));
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
		onError >> traceWithDate;
		onError >> traceWithTime;
		onError >> Log.trace;
		#end
	}

	public inline function stopTraceAll(): Void {
		stopTraceLogs();
		stopTraceErrors();
	}

	public static function traceWithDate(v: String, ?p: PosInfos): Void Log.trace(v, addDateToPosInfosFileName(p));
	public static function traceWithTime(v: String, ?p: PosInfos): Void Log.trace(v, addTimeToPosInfosFileName(p));

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
		l_usedLibs = Tools.usedLibs();
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

	private static function l_vscodeTrace(v: Dynamic, ?p: PosInfos): Void {
		var p: Null<PosInfos> = l_patchFileName(p);
		#if (js && !nodejs)
		var place: String = '';
		var prms: Array<Dynamic> = [];
		if (p != null) {
			place = formatPos(p);
			var n: Int = 0;
			if (p.customParams != null) prms = p.customParams;
		}
		var c: js.lib.Function = cast js.Browser.console.log;
		if (prms.length == 0 && Std.is(v, String))
			c = c.bind(js.Browser.console, '%c' + place, 'color: gray', v);
		else if (prms.length == 1 && v.startsWith('%c'))
			c = c.bind(js.Browser.console, '%c' + place + ' ' + v, 'color: gray');
		else
			c = c.bind(js.Browser.console, place, v);
		for (param in prms) c = c.bind(js.Browser.console, param);
		try {
			js.Syntax.code('queueMicrotask({0})', c);
		} catch (_: Any) {}
		#else
		@:nullSafety(Off) l_origTrace(v, p);
		#end
	}

	public inline function bench(?name: String, f: Void -> Void, ?p: PosInfos): Void {
		#if !disableLogs
		if (!logActive) return;
		name = name != null ? ': ' + name : '';
		log('Begin bench' + name, p);
		var time: Float = Timer.stamp();
		f();
		log('End bench' + name + ' ' + l_benchTime(time) + ' ms', p);
		#end
	}

	public inline function benchAsync(?name: String, f: (Void -> Void) -> Void, ?p: PosInfos): Void {
		#if !disableLogs
		if (!logActive) return;
		name = name != null ? ': ' + name : '';
		log('Begin async bench' + name, p);
		var time: Float = Timer.stamp();
		f(function(): Void log('End async bench' + name + ' ' + l_benchTime(time) + ' ms', p));
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
			log('End bench: ' + name + ' ' + l_benchTime(time)  + ' ms', p);
		}
		#end
	}

	private static inline function l_benchTime(time: Float): Float return Std.int((Timer.stamp() - time) * 100000) / 100;

	public static inline function debugGetObjectId(obj: {}): UInt {
		var id: Int = l_debugObjects.indexOf(obj);
		return id == -1 ? l_debugObjects.push(obj) - 1 : id;
	}

	public static inline function debugClearObjectsId(): Void l_debugObjects.resize(0);

}