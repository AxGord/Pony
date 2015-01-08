package pony.touchManager.touchInputs;
import pony.time.DeltaTime;
import unityengine.Vector3;
import unityengine.Input;

/**
 * UnityTouchInput
 * @author Maletin
 */
class UnityTouchInput
{
	public function new() 
	{
		DeltaTime.update.add(update);
	}
	
	public function update():Void
	{
		var mousePos = Input.mousePosition;

		if (Input.GetMouseButtonDown(0))
		{
			TouchManager.down(mousePos.x, mousePos.y, false);
		}
		else if (Input.GetMouseButtonUp(0))
		{
			TouchManager.up(mousePos.x, mousePos.y, false);
		}
		else
		{
			TouchManager.move(mousePos.x, mousePos.y, false);
		}
		
		//TODO: Mousewheel
	}
	
}