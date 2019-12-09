package pony.ui.gui;

import pony.events.Signal1;

/**
 * IFocus
 * @see pony.ui.FocusManager
 * @author AxGord <axgord@gmail.com>
 */
interface IFocus {

	public var onFocus(get, never): Signal1<Bool>;
	public var focusPriority(default, null): Int;
	public var focusGroup(default, null): String;
	public function focus(): Void;
	public function unfocus(): Void;

}