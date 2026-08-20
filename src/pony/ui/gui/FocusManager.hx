package pony.ui.gui;

import pony.Priority;

/**
 * Focus manager
 * @see IFocus
 * @author AxGord <axgord@gmail.com>
 */
class FocusManager {

	/**
	 * Current focused element.
	 */
	public static var current: IFocus;

	/**
	 * Priority list for current group.
	 */
	public static var p(get, never): Priority<IFocus>;

	private static final list: Map<String, Priority<IFocus>> = [];

	private static inline function get_p(): Priority<IFocus> return list[current.focusGroup];

	/**
	 * Select group.
	 * @param	name group name.
	 */
	public static inline function selectGroup(name: String = ''): Void {
		list[name].first.focus();
	}

	/**
	 * Register element for focus control.
	 * @param	o element.
	 */
	public static function reg(o: IFocus): Void {
		if (!list.exists(o.focusGroup)) list[o.focusGroup] = new Priority<IFocus>();
		final g: Priority<IFocus> = list[o.focusGroup];
		#if cs
		g.add(o, Reflect.field(o, 'focusPriority'));
		#else
		g.add(o, o.focusPriority);
		#end
		(o.onFocus + o).add(newFocus, -5);
	}

	/**
	 * Unregister element for focus control.
	 * @param	o element.
	 */
	public static function unreg(o: IFocus): Void {
		list[o.focusGroup].remove(o);
		o.onFocus + o >> newFocus;
	}

	/**
	 * Select next element in current group.
	 * @return current focused element.
	 */
	public static function next(): IFocus {
		if (current == null) return null;
		final e: IFocus = p.loop();
		e.focus();
		return e;
	}

	/**
	 * Select previos element in current group.
	 * @return current focused element.
	 */
	public static function prev(): IFocus {
		if (current == null) return null;
		final e: IFocus = p.backLoop();
		e.focus();
		return e;
	}

	private static function newFocus(b: Bool, o: IFocus): Void {
		if (b) {
			if (current != null) current.unfocus();
			current = o;
			p.reloop(o);
		} else if (current == o)
			current = null;
	}

}
