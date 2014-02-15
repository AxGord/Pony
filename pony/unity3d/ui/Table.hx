package pony.unity3d.ui;

import pony.Color;
import unityengine.Object;
import unityengine.Vector3;
import unityengine.GameObject;

import pony.geom.Point;
import pony.geom.Point.IntPoint;
import pony.geom.Rect.IntRect;
import pony.magic.Declarator;
import pony.ui.FontStyle;

/**
 * Table
 * @author AxGord <axgord@gmail.com>
 */
class Table extends pony.ui.TableCore implements Declarator {
	
	private var gos:List<GameObject> = new List();
	
	@:arg private var startpos:IntPoint;
	@:arg private var fp:Point<Float>;
	@:arg private var z:Float;
	@:arg private var textMargin:IntPoint;

	override private function drawBG(r:IntRect, color:Color):Void {
		gos.push(GUI.rect(new Vector3(fp.x , fp.y, z), r+startpos, color));
	}
	
	override private function drawText(point:IntPoint, text:String, style:FontStyle):Void {
		gos.push(GUI.text(new Vector3(fp.x , fp.y, z+1), point+startpos+textMargin, text, style));
	}
	
	override private function clear():Void {
		for (o in gos) Object.Destroy(o);
	}
	
}