/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.ui.gui;
import pony.Priority;

/**
 * Focus manager
 * @see IFocus
 * @author AxGord <axgord@gmail.com>
 */
class FocusManager {

	private static var list:Map < String, Priority<IFocus> > = new Map < String, Priority<IFocus> > ();
	/**
	 * Current focused element.
	 */
	public static var current:IFocus;
	
	/**
	 * Priority list for current group.
	 */
	public static var p(get, never):Priority<IFocus>;
	
	/**
	 * Register element for focus control.
	 * @param	o element.
	 */
	public static function reg(o:IFocus):Void {
		if (!list.exists(o.focusGroup)) list.set(o.focusGroup, new Priority<IFocus>());
		var g:Priority<IFocus> = list.get(o.focusGroup);
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
	public static function unreg(o:IFocus):Void {
		list.get(o.focusGroup).remove(o);
		o.onFocus + o >> newFocus;
	}
	
	private static function newFocus(b:Bool, o:IFocus):Void {
		if (b) {
			if (current != null) current.unfocus();
			current = o;
			p.reloop(o);
		} else {
			if (current == o) current = null;
		}
	}
	
	/**
	 * Select group.
	 * @param	name group name.
	 */
	inline public static function selectGroup(name:String=''):Void {
		list.get(name).first.focus();
	}
	
	/**
	 * Select next element in current group.
	 * @return current focused element.
	 */
	public static function next():IFocus {
		if (current == null) return null;
		var e:IFocus = p.loop();
		e.focus();
		return e;
	}
	
	/**
	 * Select previos element in current group.
	 * @return current focused element.
	 */
	public static function prev():IFocus {
		if (current == null) return null;
		var e:IFocus = p.backLoop();
		e.focus();
		return e;
	}
	
	private inline static function get_p():Priority<IFocus> return list.get(current.focusGroup);
	
}