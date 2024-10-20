package pony.js;

import pony.events.Signal0;
import pony.magic.HasSignal;

/**
 * Perform
 * @author AxGord <axgord@gmail.com>
 */
class Perform implements HasSignal {

	#if perf.js
	private static inline var SHOW_ALPHA:String = '0.8';
	private static inline var HIDE_ALPHA:String = '0.1';

	@:auto public static var onStats:Signal0;
	#end

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function show(?info:String):Void {
		#if perf.js
		var perf = new Perf();
		var elements = [perf.fps, perf.ms];
		if (info != null) {
			perf.addInfo(info);
			elements.push(perf.info);
		}
		if (perf.memory != null)
			elements.push(perf.memory);
		function change() {
			eStats.dispatch();
			for (e in elements) e.style.opacity = e.style.opacity != HIDE_ALPHA ? HIDE_ALPHA : SHOW_ALPHA;
		}
		for (e in elements) {
			#if !debug
			e.style.opacity = HIDE_ALPHA;
			#else
			e.style.opacity = SHOW_ALPHA;
			#end
			e.onclick = change;
		}
		#end
	}

}
