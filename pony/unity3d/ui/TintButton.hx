package pony.unity3d.ui;

import pony.events.Event;
import pony.ui.gui.ButtonCore;
import unityengine.Color;
import unityengine.Texture;
import unityengine.GameObject;

/**
 * Tint Button
 * This button use tint effect for over and press.
 * @see Button
 * @see pony.ui.ButtonCore
 * @author AxGord
 */
@:nativeGen class TintButton extends Button {

	private var tint:Single = 0.2;
	
	@:meta(UnityEngine.HideInInspector)
	private var sclr:Color;
	
	override function Start():Void {
		super.Start();
		sclr = guiTexture.color;
		
		core.changeVisual.sub(Focus, 1).add(cancle);
		core.changeVisual.sub(Leave, 1).add(cancle);
		core.changeVisual.sub(Press, 1).add(cancle);
		core.changeVisual.sub(Default, 1).add(cancle);
		
		core.changeVisual.sub(Focus).add(tfocus);
		core.changeVisual.sub(Leave).add(tleave);
		core.changeVisual.sub(Press).add(tpress);
		core.changeVisual.sub(Default).add(restoreColor);
		
		core.sendVisual();
	}
	
	private function tfocus():Void guiTexture.color = new Color(sclr.r + tint, sclr.g + tint, sclr.b + tint);
	private function tpress():Void guiTexture.color = new Color(sclr.r - tint, sclr.g - tint, sclr.b - tint);
	private function tleave():Void guiTexture.color = new Color(sclr.r - tint / 2, sclr.g - tint / 2, sclr.b - tint / 2);
	private function restoreColor():Void guiTexture.color = new Color(sclr.r, sclr.g, sclr.b);
	
	private function cancle(e:Event):Void {
		restoreColor();
		e.stopPropagation();
	}
	
}