/**
 * Flags
 * @author AxGord <axgord@gmail.com>
 */
class Flags {

	public static var NOTP(default, null):Bool = false;
	public static var NOFNT(default, null):Bool = false;
	public static var ONLYPO(default, null):Bool = false;

	public static function set(name:String):Void {
		switch name {
			case 'notp': NOTP = true;
			case 'nofnt': NOFNT = true;
			case 'onlypo': ONLYPO = true;
			case _:
		}
	}

}