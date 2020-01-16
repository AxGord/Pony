package pony;

import haxe.Log;
import haxe.PosInfos;
import pony.events.Signal2;
import pony.ILogable;
import pony.magic.HasSignal;

/**
 * Logable
 * @author AxGord <axgord@gmail.com>
 */
class Logable implements ILogable implements HasSignal {

	public function new() {}

	@:lazy public var onLog: Signal2<String, PosInfos>;
	@:lazy public var onError: Signal2<String, PosInfos>;

	public inline function listenError(l: ILogable): Void {
		#if !disableErrors
		l.onError << eError;
		#end
	}

	public inline function listenLog(l: ILogable): Void {
		#if !disableLogs
		l.onLog << eLog;
		#end
	}

	public inline function listenErrorAndLog(l: ILogable): Void {
		listenError(l);
		listenLog(l);
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

}