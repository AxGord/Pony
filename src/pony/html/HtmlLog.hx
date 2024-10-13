package pony.html;

import haxe.Log;
import haxe.PosInfos;
import pony.ILogable;
import js.html.Element;
import js.Browser;

using StringTools;

@:nullSafety(Strict) class HtmlLog {

	public var visible(get, set):Bool;

	private final origTrace: Null<Dynamic -> ?PosInfos -> Void>;
	private final container: Element;
	private final reverse: Bool;

	public function new(
		containerId: String = 'log', obj: ILogable = null,
		handleTrace: Bool = true, handleGlobalError: Bool = true,
		reverse: Bool = false, objLogs: Bool = false
	) {
		this.reverse = reverse;
		origTrace = Log.trace;
		container = Browser.document.getElementById(containerId);
		if (container == null) return;
		if (handleTrace) {
			Log.trace = traceHandler;
			if (obj != null) @:nullSafety(Off) {
				if (objLogs) obj.onLog << origTrace;
				obj.onError << origTrace;
			}
		}
		if (obj != null) {
			if (objLogs) obj.onLog << logHandler;
			obj.onError << errorHandler;
		}
		if (handleGlobalError) Browser.window.onerror = windowsErrorHandler;
	}

	public inline function get_visible():Bool return container != null ? !container.hidden : false;

	public inline function set_visible(value:Bool):Bool {
		if (container != null) container.hidden = !value;
		return value;
	}

	public dynamic function traceFilter(pos:Null<PosInfos>):Bool return true;

	public function traceHandler(v: Dynamic, ?p: PosInfos): Void {
		if (!traceFilter(p)) return;
		('$v'.startsWith('Catch error') ? errorHandler : logHandler)(
			[Std.string(v)].concat(p != null && p.customParams != null ? p.customParams.map(Std.string) : []).join(', '), p
		);
		@:nullSafety(Off) origTrace(v, p);
	}

	public inline function print(message: String): Void if (container != null) logHandler(message, null);

	private function logHandler(message: String, ?pos: PosInfos): Void {
		pos = Logable.addTimeToPosInfosFileName(pos);
		addToContainer(pos != null ?
			'<p><span class="gray">${pos.fileName}:${pos.lineNumber}:</span> <span>$message</span></p>' :
			'<p><span>$message</span></p>');
	}

	private function errorHandler(message: String, ?pos: PosInfos): Void {
		pos = Logable.addTimeToPosInfosFileName(pos);
		addToContainer(pos != null ?
			'<p><span class="gray">${pos.fileName}:${pos.lineNumber}:</span> <span class="error">$message</span></p>' :
			'<p><span class="error">$message</span></p>');
	}

	private function windowsErrorHandler(_, _, _, _, _): Bool {
		addToContainer('<p><span class="error">Fatal error</span></p>');
		return false;
	}

	private inline function addToContainer(s: String): Void {
		if (container != null) {
			if (reverse)
				container.innerHTML = s + container.innerHTML;
			else
				container.innerHTML += s;
		}
	}

}