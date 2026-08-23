package pony.ui.gui.slices;

import pony.time.Time;

using StringTools;
using pony.text.TextTools;

/**
 * SliceTools
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:nullSafety(Strict)
class SliceTools {

	/** Prefixes that tell an `{anim...}` extra field apart from a plain delay. */
	private static inline final REST: String = 'rest';

	private static inline final MAX: String = 'max';
	private static inline final BOOST: String = 'boost';

	public static function parseSliceName(name: String): SliceData {
		return if (check(name, 2, 'v'))
			SliceData.Vert2(slice(name, 2, 'v'));
		else if (check(name, 2, 'h'))
			SliceData.Hor2(slice(name, 2, 'h'));
		else if (check(name, 3, 'v'))
			SliceData.Vert3(slice(name, 3, 'v'));
		else if (check(name, 3, 'h'))
			SliceData.Hor3(slice(name, 3, 'h'));
		else if (check(name, 4))
			SliceData.Four(slice(name, 4));
		else if (check(name, 6, 'v'))
			SliceData.Vert6(slice(name, 6, 'v'));
		else if (check(name, 6, 'h'))
			SliceData.Hor6(slice(name, 6, 'h'));
		else if (check(name, 9))
			SliceData.Nine(slice(name, 9));
		else
			SliceData.Not(name);
	}

	public static function getType(name: String): SliceData {
		return if (check(name, 2, 'v'))
			SliceData.Vert2();
		else if (check(name, 2, 'h'))
			SliceData.Hor2();
		else if (check(name, 3, 'v'))
			SliceData.Vert3();
		else if (check(name, 3, 'h'))
			SliceData.Hor3();
		else if (check(name, 4))
			SliceData.Four();
		else if (check(name, 6, 'v'))
			SliceData.Vert6();
		else if (check(name, 6, 'h'))
			SliceData.Hor6();
		else if (check(name, 9))
			SliceData.Nine();
		else if (checkAnim(name))
			parseAnimSpeed(name);
		else
			SliceData.Not();
	}

	public static function getNames(name: String): Array<String> {
		return if (check(name, 2, 'v'))
			slice(name, 2, 'v');
		else if (check(name, 2, 'h'))
			slice(name, 2, 'h');
		else if (check(name, 3, 'v'))
			slice(name, 3, 'v');
		else if (check(name, 3, 'h'))
			slice(name, 3, 'h');
		else if (check(name, 4))
			slice(name, 4);
		else if (check(name, 6, 'v'))
			slice(name, 6, 'v');
		else if (check(name, 6, 'h'))
			slice(name, 6, 'h');
		else if (check(name, 9))
			slice(name, 9);
		else
			[name];
	}

	public static function clean(name: String): String {
		return if (check(name, 2, 'v'))
			remove(name, 2, 'v');
		else if (check(name, 2, 'h'))
			remove(name, 2, 'h');
		else if (check(name, 3, 'v'))
			remove(name, 3, 'v');
		else if (check(name, 3, 'h'))
			remove(name, 3, 'h');
		else if (check(name, 4))
			remove(name, 4);
		else if (check(name, 6, 'v'))
			remove(name, 6, 'v');
		else if (check(name, 6, 'h'))
			remove(name, 6, 'h');
		else if (check(name, 9))
			remove(name, 9);
		else if (checkAnim(name))
			removeAnim(name);
		else
			name;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function checkAnim(name: String): Bool {
		return name.indexOf('{anim') != -1;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function check(name: String, n: Int, letter: String = ''): Bool {
		return index(name, n, letter) != -1;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function index(name: String, n: Int, letter: String = ''): Int {
		return name.indexOf('{slice$n$letter}');
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function remove(name: String, n: Int, letter: String = ''): String {
		return name.substr(0, index(name, n, letter));
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function removeAnim(name: String): String {
		final p: SPair<String> = name.firstSplit('{anim');
		return p.a + p.b.allAfter('}');
	}

	/**
	 * `{anim<speed>}` plus any number of comma-separated extras, told apart by their prefix:
	 * `rest<frame>` parks the sheet on that frame until something spins it, `boost<k>` makes a spin
	 * backlog speed it up, `max<fps>` caps that speed-up, and anything else is the delay between loops.
	 */
	private static function parseAnimSpeed(name: String): SliceData {
		final r: Null<String> = name.extract('{anim', '}');
		if (r == null) return SliceData.Anim();
		final fields: Array<String> = r.split(',');
		var delay: Null<Time> = null;
		var rest: Null<Int> = null;
		var maxSpeed: Null<Float> = null;
		var boost: Null<Float> = null;
		for (i in 1...fields.length) {
			final field: String = fields[i].trim();
			if (field.startsWith(REST))
				rest = parseField(Std.parseInt(field.substr(REST.length)), field);
			else if (field.startsWith(MAX))
				maxSpeed = parseField(nanToNull(Std.parseFloat(field.substr(MAX.length))), field);
			else if (field.startsWith(BOOST))
				boost = parseField(nanToNull(Std.parseFloat(field.substr(BOOST.length))), field);
			else if (field != '') {
				// Every time Time understands opens with a digit or a minus, so anything else here
				// is a misspelled field name rather than a delay, and reads far better as one.
				final time: Null<String> = startsWithNumber(field) ? field : null;
				delay = parseField(time, field);
			}
		}
		return SliceData.Anim(Std.parseFloat(fields[0]), delay, rest, boost, maxSpeed);
	}

	/** A malformed field can only come from a typo in the markup — silence would just hide it. */
	private static inline function parseField<T>(value: Null<T>, field: String): T {
		if (value == null) throw 'Bad anim field: $field';
		return value;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function nanToNull(value: Float): Null<Float> return Math.isNaN(value) ? null : value;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function startsWithNumber(value: String): Bool {
		final code: Int = value.fastCodeAt(0);
		return code == '-'.code || (code >= '0'.code && code <= '9'.code);
	}

	private static function slice(name: String, n: Int, letter: String = ''): Array<String> {
		final s: Array<String> = name.split('{slice$n$letter}');
		return [for (i in 0...n) s[0] + i + s[1]];
	}

}
