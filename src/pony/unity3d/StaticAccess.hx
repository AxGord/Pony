package pony.unity3d;

import pony.ui.gui.ButtonCore;

// import pony.unity3d.ui.TintButton;
// import pony.unity3d.ui.Button;
import unityengine.GameObject;
import unityengine.Component;

using hugs.HUGSWrapper;

/**
 * StaticAccess
 * Help organize static visual objects from some ide
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class StaticAccess {

	public static inline function component<T:Component>(gameObject: String, cl: Class<T>): T {
		#if debug
		var g: GameObject = GameObject.Find(gameObject);
		if (g == null) {
			trace('Can\'t find $gameObject game object');
			throw null;
		}
		final c = g.getTypedComponent(cl);
		if (c != null) return c;
		trace('Can\'t find component ' + Type.getClassName(cl) + ' in $gameObject game object');
		throw null;
		#else
		return GameObject.Find(gameObject).getTypedComponent(cl);
		#end
	}

	// inline static public function tintButton(gameObject:String):ButtonCore return component(gameObject, TintButton).core;
	// inline static public function button(gameObject:String):ButtonCore return component(gameObject, Button).core;
}
