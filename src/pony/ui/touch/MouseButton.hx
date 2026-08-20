package pony.ui.touch;

/**
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract MouseButton(Int) from Int to Int {

	final LEFT = 0;
	final MIDDLE = 1;
	final RIGHT = 2;

}
