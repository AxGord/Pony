package pony.heaps;

import haxe.Log;
import haxe.PosInfos;
import h2d.Object;
import hxd.res.DefaultFont;

/**
 * Console with traces
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Console extends h2d.Console {

	public static inline var DEFAULT_FONT_SIZE: UInt = 28;
	public static inline var DEFAULT_TRACE_COLOR: UInt = 0xBBBBFF;

	@:nullSafety(Off) private var origTrace: Dynamic -> ?PosInfos -> Void;
	private var traceColor: Int = -1;

	public function new(?font: h2d.Font, size: UInt = DEFAULT_FONT_SIZE, ?parent: Object) {
		if (font == null) {
			font = DefaultFont.get();
			font.resizeTo(size);
		}
		super(font, parent);
		addCommand('trace', 'Switch listen trace', [], swListenTrace);
	}

	public function listenTrace(color: UInt = DEFAULT_TRACE_COLOR): Void {
		if (origTrace == null) {
			traceColor = color;
			origTrace = Log.trace;
			Log.trace = traceHandler;
		}
	}

	public function unlistenTrace(): Void {
		if (origTrace != null) {
			Log.trace = cast origTrace;
			@:nullSafety(Off) origTrace = null;
		}
	}

	public function swListenTrace(): Void {
		if (origTrace == null) {
			log('Listen trace');
			listenTrace(traceColor == -1 ? DEFAULT_FONT_SIZE : traceColor);
		} else {
			log('Unlisten trace');
			unlistenTrace();
		}
	}

	private function traceHandler(v: Dynamic, ?p: PosInfos): Void {
		origTrace(v, p);
		log(
			p == null ? v :
			'${p.fileName}:${p.lineNumber}: $v' + (p.customParams != null ? ', ' + p.customParams.join(', ') : ''),
			traceColor
		);
	}

}