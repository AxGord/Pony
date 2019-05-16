package pony.js;

import pony.events.Signal0;
import pony.magic.HasSignal;

class Perform implements HasSignal {

	private static inline var SHOW_ALPHA:String = '0.8';
	private static inline var HIDE_ALPHA:String = '0.1';

	@:auto public static var onStats:Signal0;

	@:extern public static inline function show(?info:String):Void {
		var perf = new Perf();
		if (info != null) perf.addInfo(info);
		var elements = [perf.fps, perf.info, perf.ms];
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
	}

}
