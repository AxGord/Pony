package pony.ui;
import pony.Priority;

/**
 * FocusManager
 * @see IFocus
 * @author AxGord <axgord@gmail.com>
 */
class FocusManager {

	private static var list:Map<String, Priority<IFocus>> = new Map<String, Priority<IFocus>>();
	public static var current:IFocus;
	
	public static var p(get, never):Priority<IFocus>;
	
	public static function reg(o:IFocus):Void {
		if (!list.exists(o.focusGroup)) list.set(o.focusGroup, new Priority<IFocus>());
		var g:Priority<IFocus> = list.get(o.focusGroup);
		#if cs
		g.addElement(o, Reflect.field(o, 'focusPriority'));
		#else
		g.addElement(o, o.focusPriority);
		#end
		o.focus.add(newFocus);
	}
	
	public static function unreg(o:IFocus):Void {
		list.get(o.focusGroup).removeElement(o);
		o.focus.remove(newFocus);
	}
	
	private static function newFocus(b:Bool, o:IFocus):Void {
		if (b) {
			if (current != null) current.focus.dispatch(false);
			current = o;
			p.reloop(o);
		} else {
			if (current == o) current = null;
		}
	}
	
	inline public static function selectGroup(name:String=''):Void {
		list.get(name).first.focus.dispatch(true);
	}
	
	public static function next():IFocus {
		if (current == null) return null;
		var e:IFocus = p.loop();
		e.focus.dispatch(true);
		return e;
	}
	
	public static function prev():IFocus {
		if (current == null) return null;
		var e:IFocus = p.backLoop();
		e.focus.dispatch(true);
		return e;
	}
	
	private inline static function get_p():Priority<IFocus> return list.get(current.focusGroup);
	
}