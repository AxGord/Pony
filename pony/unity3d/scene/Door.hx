package pony.unity3d.scene;

using hugs.HUGSWrapper;

/**
 * DoorUCore
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class Door extends OpenClose {
	
	@:meta(UnityEngine.HideInInspector)
	private var mh:MouseHelper;
	
	override private function Start():Void {
		super.Start();
		mh = getOrAddTypedComponent(MouseHelper);
		mh.down.add(change);
	}
	
}