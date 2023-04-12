package pony.unity3d.ui;

import pony.color.Color;
import pony.color.UColor;
import pony.geom.Point.IntPoint;
import pony.geom.Point;
import pony.geom.Rect.IntRect;
import pony.magic.Declarator;
import pony.ui.gui.FontStyle;
import pony.ui.gui.TextTableCore;

import unityengine.GameObject;
import unityengine.Object;
import unityengine.Vector3;

/**
 * Table
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class TextTable extends pony.ui.gui.TextTableCore implements Declarator {

	private var gos: List<GameObject> = new List();

	@:arg private var startpos: IntPoint;
	@:arg private var fp: Point<Float>;
	@:arg private var z: Float;
	@:arg private var textMargin: IntPoint;

	#if (haxe_ver < 4.2) override #end
	private function drawBG(r: IntRect, color: UColor): Void {
		gos.push(GUI.rect(new Vector3(fp.x, fp.y, z), r + startpos, color));
	}

	#if (haxe_ver < 4.2) override #end
	private function drawText(point: IntRect, text: String, style: FontStyle): Void {
		gos.push(GUI.text(new Vector3(fp.x, fp.y, z + 1), point + startpos + textMargin, text, style));
	}

	#if (haxe_ver < 4.2) override #end
	private function clear(): Void {
		for (o in gos)
			Object.Destroy(o);
	}

}