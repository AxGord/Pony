package pony.touchManager.hitTestSources;
import unityengine.Camera;
import unityengine.RaycastHit;
import unityengine.Ray;
import unityengine.Physics;
import unityengine.Vector3;
import unityengine.Input;
import unityengine.Transform;

/**
 * UnityHitTestSource
 * @author Maletin
 */
class UnityHitTestSource implements IHitTestSource
{
	private var _camera:Camera;
	
	public function new(camera:Camera) 
	{
		_camera = camera;
	}
	
	public function hitTest(x:Float, y:Float):Dynamic 
	{
		var vHit = new RaycastHit();
		var vRay:Ray = _camera.ScreenPointToRay(new Vector3(x, y, 0));
		//if(Physics.Raycast(vRay, vHit, 1000)) 
		if(Physics.Raycast(vRay, vHit)) 
		{
			return vHit.transform;
		}
		
		return null;
	}
	
	public function parent(object:Dynamic):Dynamic
	{
		if (!Std.is(object, Transform)) return null;
		var objectsParent = object.parent;
		return objectsParent;
	}
	
}