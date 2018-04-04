class Flags {

	public static var NOTP:Bool = false;

	public static function set(name:String):Void {
		switch name {
			case 'notp': NOTP = true;
			case _:
		}
	}

}