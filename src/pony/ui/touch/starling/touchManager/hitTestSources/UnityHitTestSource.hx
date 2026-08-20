package pony.ui.touch.starling.touchManager.hitTestSources;

import unityengine.Camera;
import unityengine.Input;
import unityengine.Physics;
import unityengine.Ray;
import unityengine.RaycastHit;
import unityengine.Transform;
import unityengine.Vector3;

/**
 * UnityHitTestSource
 * @author Maletin
 */
class UnityHitTestSource implements IHitTestSource {

	private final _camera: Camera;

	public function new(camera: Camera) {
		_camera = camera;
	}

	public function hitTest(x: Float, y: Float): Dynamic {
		final vHit = new RaycastHit();
		final vRay: Ray = _camera.ScreenPointToRay(new Vector3(x, y, 0));
		// if(Physics.Raycast(vRay, vHit, 1000))
		return Physics.Raycast(vRay, vHit) ? vHit.transform : null;
	}

	public function parent(object: Dynamic): Dynamic {
		return !Std.is(object, Transform) ? null : object.parent;
	}

}
