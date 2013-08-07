package pony.unity3d;
import unityengine.Component;
import unityengine.GameObject;

using hugs.HUGSWrapper;
/**
 * UnityHelper
 * @author AxGord <axgord@gmail.com>
 */
class UnityHelper {

	inline public static function getOrAddTypedComponent<T>(c:Component, type:Class<T>):T
		return UnityHelperGO.getOrAddTypedComponent(c.gameObject, type);
		
}

class UnityHelperGO {

	public static function getOrAddTypedComponent<T>(c:GameObject, type:Class<T>):T {
		var o:T = c.getTypedComponent(type);
		return o == null ? c.gameObject.addTypedComponent(type) : o;
	}
}