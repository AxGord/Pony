package pony;

/**
 * Encode/decode string
 * @author AxGord
 */
class TextCoder {
	
	static private var chars:String = '0123456789QWERTYUIOPASDFGHJKLZXCVBNM';
	
	private var key:String;
	
	public function new(key:String) {
		this.key = key.toUpperCase();
	}
	
	public function encode(text:String):String {
		var s:String = core(text);
		if (text.toUpperCase() == core(s, -1))
			return s;
		else
			return null;
	}
	
	public function decode(text:String, k=null):String {
		var s:String = core(text, -1);
		if (text.toUpperCase() == core(s))
			return s;
		else
			return null;
	}
	
	private function core(text:String, mode:Int = 1):String {
		if (text == '') return null;
		var n:Int = 0;
		text = text.toUpperCase();
		var s:String = '';
		for (i in 0...text.length) {
			if (n >= key.length)
				n = 0;
			var tp:Int = chars.indexOf(text.charAt(i));
			var kp:Int = chars.indexOf(key.charAt(n));
			var np:Int = tp + kp * mode;
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