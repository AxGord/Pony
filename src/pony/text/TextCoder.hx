package pony.text;

/**
 * Encode/decode string
 * @author AxGord
 */
class TextCoder {

	private static var numbers: String = '0123456789';
	private static var letters: String = 'QWERTYUIOPASDFGHJKLZXCVBNM';
	private static var symbols: String = '~!@#$%^&*()_+|{:"<>?`-=\\[];\',./№';

	private var key: String;
	private var allowLowercase: Bool;
	private var chars: String;

	public function new(key: String, ?allowLowercase: Bool, ?allowSymbols: Bool) {
		this.key = allowLowercase ? key : key.toUpperCase();
		this.allowLowercase = allowLowercase;
		chars = numbers + letters;
		if (allowLowercase) chars += letters.toLowerCase();
		if (allowSymbols) chars += symbols;
	}

	public function encode(text: String): String {
		if (!allowLowercase) text = text.toUpperCase();
		var s: String = core(text);
		if (text == core(s, -1))
			return s;
		else
			return null;
	}

	public function decode(text: String, k = null): String {
		if (!allowLowercase) text = text.toUpperCase();
		var s: String = core(text, -1);
		if (text == core(s))
			return s;
		else
			return null;
	}

	private function core(text: String, mode: Int = 1): String {
		if (text == '') return null;
		var n: Int = 0;
		var s: String = '';
		for (i in 0...text.length) {
			if (n >= key.length)
				n = 0;
			var tp: Int = chars.indexOf(text.charAt(i));
			var kp: Int = chars.indexOf(key.charAt(n));
			var np: Int = tp + kp * mode;
			if (np >= chars.length)
				np -= chars.length;
			if (np < 0)
				np += chars.length;
			s += chars.charAt(np);
			n++;
		}
		return s;
	}

}