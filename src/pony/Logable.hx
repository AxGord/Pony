package pony;

import pony.time.DTimer;
import haxe.Log;
import haxe.PosInfos;
import pony.ILogable;
import pony.events.Signal2;
import pony.magic.HasSignal;

/**
 * Logable
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Logable implements ILogable implements HasSignal {

	private static inline var DLM: String = ' ';

	private static var origTrace: Null<Dynamic -> ?PosInfos -> Void>;

	public function new() {}

	@:lazy public var onLog: Signal2<String, Null<PosInfos>>;
	@:lazy public var onError: Signal2<String, Null<PosInfos>>;

	public inline function listenError(l: ILogable, ?id: String): Void {
		#if !disableErrors
		if (id != null)
			l.onError << function(s: String, p: PosInfos): Void eError.dispatch(id + DLM + s, p);
		else
			l.onError << eError;
		#end
	}

	public inline function listenLog(l: ILogable, ?id: String): Void {
		#if !disableLogs
		if (id != null)
			l.onLog << function(s: String, p: PosInfos): Void eLog.dispatch(id + DLM + s, p);
		else
			l.onLog << eLog;
		#end
	}

	public inline function listenErrorAndLog(l: ILogable, ?id: String): Void {
		listenError(l, id);
		listenLog(l, id);
	}

	public inline function error(s: String, ?p: PosInfos): Void {
		#if !disableErrors
		eError.dispatch(s, p);
		#end
	}

	public inline function log(s: String, ?p: PosInfos): Void {
		#if !disableLogs
		eLog.dispatch(s, p);
		#end
	}

	public inline function errorf(fn: Void -> String, ?p: PosInfos): Void {
		#if !disableErrors
		if (eError != null && !eError.empty) error(@:nullSafety(Off) fn(), p);
		#end
	}

	public inline function logf(fn: Void -> String, ?p: PosInfos): Void {
		#if !disableLogs
		if (eLog != null && !eLog.empty) log(@:nullSafety(Off) fn(), p);
		#end
	}

	public inline function traceLogs(): Void {
		#if !disableLogs
		onLog << Log.trace;
		#end
	}

	public inline function traceErrors(): Void {
		#if !disableErrors
		onError << Log.trace;
		#end
	}

	public inline function traceAll(): Void {
		traceLogs();
		traceErrors();
	}

	public static function vscodePatchTrace(): Void {
		origTrace = Log.trace;
		Log.trace = vscodeTrace;
	}

	private static function vscodeTrace(v: Dynamic, ?p: PosInfos): Void {
		if (p != null) p.fileName = './' + p.fileName;
		origTrace(v, p);
	}

	public inline function bench(?name: String, f: Void -> Void, ?p: PosInfos): Void {
		#if !disableLogs
		name = name != null ? ': ' + name : '';
		log('Begin bench' + name, p);
		final timer: DTimer = DTimer.fixedClock(0);
		f();
		log('End bench' + name + ' ' + timer.currentTime.totalMs + ' ms', p);
		timer.destroy();
		#end
	}

}