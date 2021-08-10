package pony;

import haxe.Log;
import haxe.PosInfos;

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

	private static var origTrace: Null<Dynamic -> ?PosInfos -> Void>;

	@:lazy public var onLog: Signal2<String, Null<PosInfos>>;
	@:lazy public var onError: Signal2<String, Null<PosInfos>>;

	public var logActive(get, never): Bool;
	public var errorActive(get, never): Bool;

	private var logPrefix: String;

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
			if (!eError.empty) listen();
			eError.onTake << listen;
			eError.onLost << unlisten;
		} else {
			l.onError << eError;
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
			if (!eLog.empty) listen();
			eLog.onTake << listen;
			eLog.onLost << unlisten;
		} else {
			l.onLog << eLog;
		}
		#end
	}

	public inline function listenErrorAndLog(l: ILogable, ?id: String): Void {
		listenError(l, id);
		listenLog(l, id);
	}

	public inline function error(s: String, ?p: PosInfos): Void {
		#if !disableErrors
		eError.dispatch(logPrefix + s, p);
		#end
	}

	public inline function log(s: String, ?p: PosInfos): Void {
		#if !disableLogs
		eLog.dispatch(logPrefix + s, p);
		#end
	}

	public inline function errorf(fn: Void -> String, ?p: PosInfos): Void {
		#if !disableErrors
		if (errorActive) error(@:nullSafety(Off) fn(), p);
		#end
	}

	public inline function logf(fn: Void -> String, ?p: PosInfos): Void {
		#if !disableLogs
		if (logActive) log(@:nullSafety(Off) fn(), p);
		#end
	}

	public inline function traceLogs(date: Bool = true): Void {
		#if !disableLogs
		onLog << (date ? traceWithDate : Log.trace);
		#end
	}

	public inline function traceErrors(date: Bool = true): Void {
		#if !disableErrors
		onError << (date ? traceWithDate : Log.trace);
		#end
	}

	public inline function traceAll(): Void {
		traceLogs();
		traceErrors();
	}

	public static function traceWithDate(v: String, ?p: PosInfos): Void {
		if (p != null)
			p.fileName = Date.now().toString() + haxe.Timer.stamp()._toFixed(3, -1) + ' ' + p.fileName;
		Log.trace(v, p);
	}

	public static function vscodePatchTrace(): Void {
		origTrace = Log.trace;
		Log.trace = vscodeTrace;
	}

	private static function vscodeTrace(v: Dynamic, ?p: PosInfos): Void {
		if (p != null) {
			var r: SPair<String> = p.fileName.lastSplit(' ');
			p.fileName = r.b != '' ? r.a + ' ./' + r.b : './' + r.a;
		}
		@:nullSafety(Off) origTrace(v, p);
	}

	public inline function bench(?name: String, f: Void -> Void, ?p: PosInfos): Void {
		#if !disableLogs
		name = name != null ? ': ' + name : '';
		log('Begin bench' + name, p);
		var timer: DTimer = DTimer.fixedClock(0);
		f();
		log('End bench' + name + ' ' + timer.currentTime.totalMs + ' ms', p);
		timer.destroy();
		#end
	}

}