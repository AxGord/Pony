package pony.unity3d;
import unityengine.Component;
import unityengine.GameObject;
import unityengine.Transform;

using hugs.HUGSWrapper;
/**
 * UnityHelper
 * @author AxGord <axgord@gmail.com>
 */
class UnityHelper {

	inline public static function getOrAddTypedComponent<T>(c:Component, type:Class<T>):T
		return UnityHelperGO.getOrAddTypedComponent(c.gameObject, type);
		
	inline public static function getChildGameObject(c:Component, name:String):GameObject
	return UnityHelperGO.getChildGameObject(c.gameObject, name);
}

class UnityHelperGO {

	public static function getOrAddTypedComponent<T>(c:GameObject, type:Class<T>):T {
		var o:T = c.getTypedComponent(type);
		return o == null ? c.gameObject.addTypedComponent(type) : o;
	}
	
	public static function getChildGameObject(gameObject:GameObject, name:String):GameObject {
		for (t in gameObject.getComponentsInChildrenOfType(Transform)) if (t.gameObject.name == name) return t.gameObject;
		return null;
    }

}