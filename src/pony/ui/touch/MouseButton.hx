package pony.ui.touch;

/**
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract MouseButton(Int) from Int to Int {

	var LEFT = 0;
	var MIDDLE = 1;
	var RIGHT = 2;

}