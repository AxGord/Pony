package pony.midi.devices;
import pony.events.Signal2;
import pony.geom.Point.IntPoint;
import pony.ILogable;
import pony.math.Matrix;
import pony.midi.devices.LaunchpadColor;

/**
 * @author AxGord
 */

interface ILaunchpad extends ILogable<ILaunchpad> {
  
	var areaState(default, null):Matrix<LaunchpadColor>;
	var topState(default, null):Array<LaunchpadColor>;
	var rightState(default, null):Array<LaunchpadColor>;
	
	var onArea(default, null):Signal2<ILaunchpad, IntPoint, Bool>;
	var onTop(default, null):Signal2<ILaunchpad, Int, Bool>;
	var onRight(default, null):Signal2<ILaunchpad, Int, Bool>;
	
	function setAreaPoint(p:IntPoint, color:LaunchpadColor = AmberFull):Void;
	function setMatrixCI(m:Matrix<Int>):Void;
	function setMatrix(m:Matrix<LaunchpadColor>):Void;
	function setTop(p:Int, color:LaunchpadColor = AmberFull):Void;
	function setRight(p:Int, color:LaunchpadColor = AmberFull):Void;
	function reset():Void;
}