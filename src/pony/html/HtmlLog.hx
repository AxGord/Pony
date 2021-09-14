package pony.html;

import haxe.Log;
import haxe.PosInfos;
import pony.ILogable;
import js.html.Element;
import js.Browser;

@:nullSafety(Strict) class HtmlLog {

	private final origTrace: Null<Dynamic -> ?PosInfos -> Void>;
	private final container: Element;

	public function new(containerId: String = 'log', obj: ILogable = null, handleTrace: Bool = true, handleGlobalError: Bool = true) {
		container = Browser.document.getElementById(containerId);
		if (handleTrace) {
			origTrace = Log.trace;
			Log.trace = traceHandler;
			if (obj != null) @:nullSafety(Off) {
				obj.onLog << origTrace;
				obj.onError << origTrace;
			}
		}
		if (obj != null) {
			obj.onLog << logHandler;
			obj.onError << errorHandler;
		}
		if (handleGlobalError) Browser.window.onerror = windowsErrorHandler;
	}

	private function traceHandler(v: Dynamic, ?p: PosInfos): Void {
		logHandler([Std.string(v)].concat(p != null && p.customParams != null ? p.customParams.map(Std.string) : []).join(', '), p);
		@:nullSafety(Off) origTrace(v, p);
	}

	private function logHandler(message: String, ?pos: PosInfos): Void {
		container.innerHTML += pos != null ?
			'<p><span class="gray">${pos.fileName}:${pos.lineNumber}:</span> <span>$message</span></p>' :
			'<p><span>$message</span></p>';
	}

	private function errorHandler(message: String, ?pos: PosInfos): Void {
		container.innerHTML += pos != null ?
			'<p><span class="gray">${pos.fileName}:${pos.lineNumber}:</span> <span class="error">$message</span></p>' :
			'<p><span class="error">$message</span></p>';
	}

	private function windowsErrorHandler(_, _, _, _, _): Bool {
		container.innerHTML += '<p><span class="error">Fatal error</span></p>';
		return false;
	}

}