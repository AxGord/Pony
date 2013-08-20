package pony.unity3d;

import unityengine.GameObject;

using hugs.HUGSWrapper;
/**
 * StaticAccess
 * @author AxGord <axgord@gmail.com>
 */
class StaticAccess {

	inline static public function component<T>(gameObject:String, cl:Class<T>):T {
		return GameObject.Find(gameObject).getTypedComponent(cl);
	}
	
}