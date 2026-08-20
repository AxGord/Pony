package pony.html;

import haxe.Log;
import haxe.PosInfos;
import js.Browser;
import js.html.Element;
import pony.ILogable;

using StringTools;
using pony.text.TextTools;

private enum LastLogMessage {
	None;
	Normal(m: LastLogMessageObj);
	Error(m: LastLogMessageObj);
}

private typedef LastLogMessageObj = {
	text: String,
	pos: Null<PosInfos>,
	count: UInt
}

@:nullSafety(Strict) class HtmlLog {

	public var visible(get, set): Bool;

	public final container: Element;

	private final origTrace: Null<Dynamic -> ?PosInfos -> Void> = Log.trace;
	private final reverse: Bool;

	private var lastMessage: LastLogMessage = None;

	public function new(
		containerId: String = 'log', ?obj: ILogable, handleTrace: Bool = true, handleGlobalError: Bool = true, reverse: Bool = false,
		objLogs: Bool = false
	) {
		this.reverse = reverse;
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

	public inline function get_visible(): Bool return container != null ? !container.hidden : false;

	public inline function set_visible(value: Bool): Bool {
		if (container != null) container.hidden = !value;
		return value;
	}

	public inline function print(message: String): Void addLogToContainer(message, null);

	public dynamic function traceFilter(pos: Null<PosInfos>): Bool return true;

	public function traceHandler(v: Dynamic, ?p: PosInfos): Void {
		if (!traceFilter(p)) return;
		(
			'$v'.startsWith('Catch error') ? errorHandler : logHandler
		)(['$v'].concat(p != null && p.customParams != null ? p.customParams.map(Std.string) : []).join(', '), p);
		@:nullSafety(Off) origTrace(v, p);
	}

	public function addLogToContainer(message: String, count: Int = 1, ?pos: PosInfos): Void {
		if (container == null) return;
		final current: LastLogMessageObj = { text: message, pos: pos, count: count };
		switch lastMessage {
			case Normal(m) if (equalMessageObj(m, current)):
				if (reverse)
					container.firstElementChild.remove();
				else
					container.lastElementChild.remove();
				count += m.count;
				current.count = count;
			case _:
		}
		lastMessage = Normal(current);
		addToContainer(
			pos != null
				? '<p><span class="gray">${pos.fileName}:${pos.lineNumber}:</span> <span>$message</span>${renderCount(count)}</p>'
				: '<p><span>$message</span>${renderCount(count)}</p>'
		);
	}

	public function addErrorToContainer(message: String, count: Int = 1, ?pos: PosInfos): Void {
		if (container == null) return;
		final current: LastLogMessageObj = { text: message, pos: pos, count: count };
		switch lastMessage {
			case Error(m) if (equalMessageObj(m, current)):
				if (reverse)
					container.firstElementChild.remove();
				else
					container.lastElementChild.remove();
				count += m.count;
				current.count = count;
			case _:
		}
		lastMessage = Error(current);
		addToContainer(
			pos != null
				? '<p><span class="gray">${pos.fileName}:${pos.lineNumber}:</span> <span class="error">$message</span>'
					+ '${renderCount(count)}</p>'
				: '<p><span class="error">$message</span>${renderCount(count)}</p>'
		);
	}

	private inline function addToContainer(s: String): Void {
		if (container != null) {
			if (reverse)
				container.innerHTML = s + container.innerHTML;
			else
				container.innerHTML += s;
		}
	}

	private function logHandler(message: String, ?pos: PosInfos): Void {
		addLogToContainer(message, Logable.addTimeToPosInfosFileName(pos));
	}

	private function errorHandler(message: String, ?pos: PosInfos): Void {
		addErrorToContainer(message, Logable.addTimeToPosInfosFileName(pos));
	}

	private function windowsErrorHandler(_, _, _, _, _): Bool {
		lastMessage = None;
		addToContainer('<p><span class="error">Fatal error</span></p>');
		return false;
	}

	private static function renderCount(count: UInt): String {
		return count > 1 ? ' <span class="gray">(${count})</span>' : '';
	}

	@:nullSafety(Off)
	private static function equalMessageObj(a: LastLogMessageObj, b: LastLogMessageObj): Bool {
		return a.text == b.text
			&& ((a.pos == null && b.pos == null)
				|| (a.pos.lineNumber == b.pos.lineNumber && a.pos.fileName.allAfterLast(' ') == b.pos.fileName.allAfterLast(' ')));
	}

}
