package pony.unity3d;

import pony.geom.Rect;
import pony.time.DeltaTime;
import pony.events.LV.LV;
import pony.geom.Rect.Rect;
import pony.text.WordWrap;
import unityengine.Color;
import unityengine.GameObject;
import unityengine.GUIText;
import unityengine.GUITexture;
import unityengine.Input;
import unityengine.Rect;
import unityengine.Screen;
import unityengine.Texture;
import unityengine.Vector3;

using hugs.HUGSWrapper;
using pony.Tools;
using pony.math.MathTools;

/**
 * Tooltip
 * Static class, helper for scene and ui tooltips
 * @author AxGord
 * @author BoBaH6eToH
 */
@:nativeGen class Tooltip {
	
	public static var panelMode:Bool = false;
	
	public static var limitBorder:Float = 50;
	public static var border:Single = 5;
	public static var textObject:GameObject;
	private static var textureObject:GameObject;
	private static var guiTextObject:GUIText;
	private static var guiTextureObject:GUITexture;
	public static var r:Rect;
	public static var lr:Rect;
	
	private static var longTextObject:GameObject;
	private static var guiLongTextObject:GUIText;
	
	public static var texture:Texture;
	public static var defaultColorMod:LV<Color> = new LV(null);
	public static var panel:Bool = false;
	
	private static var target:Dynamic;
	private static var longTextDY:Float = 0;
	private static var distanceToLong:Float = 5;
		
	private static function init():Void {
		
		textureObject = new GameObject("GUIText Tooltip Texture");
		guiTextureObject = cast textureObject.AddComponent('GUITexture');
		guiTextureObject.texture = texture;
		
		textObject = new GameObject("GUIText Tooltip");
		textObject.transform.position = new Vector3(0.5, 0.5);
		guiTextObject = cast textObject.AddComponent('GUIText');
		guiTextObject.material.color = new Color(0, 0, 0);
		//guiTextObject.font = cast Resources.Load('ARIAL');
		guiTextObject.fontSize = 14;
		
		longTextObject = new GameObject("GUIText Tooltip Long");
		longTextObject.transform.position = new Vector3(0.5, 0.5);
		guiLongTextObject = cast longTextObject.AddComponent('GUIText');
		guiLongTextObject.material.color = new Color(0, 0, 0);
		guiLongTextObject.fontSize = 10;
			
			
	}
	
	public static function showText(text:String, bigText:String, obj:Dynamic, layer:Null<Int>, ?panel:Bool = false):Void {
		if (panelMode) panel = true;
		target = obj;
		if (textObject == null) {
			init();
		}
		Tooltip.panel = panel;
		if (layer != null) {
			textObject.layer = layer;
			textureObject.layer = layer;
			longTextObject.layer = layer;
		}
				
		guiTextObject.enabled = true;
		guiTextureObject.enabled = true;
		
		
		guiTextObject.text = WordWrap.wordWrap(text, bigText == "" ? 30 : 50);
		
		//formatGuiTextArea(guiTextObject, 100);
		
		r = guiTextObject.GetScreenRect();
		
		var w = panel && Fixed2dCamera.exists ? Fixed2dCamera.SIZE : Screen.width - Fixed2dCamera.SIZE;
		var h = Screen.height;
		
		var rectWidth:Float = r.width;
		var rectHeight:Float = r.height;
		
		if ( bigText != "" )
		{
			guiLongTextObject.enabled = true;
			guiLongTextObject.text = WordWrap.wordWrap(bigText, 75);	
			lr = guiLongTextObject.GetScreenRect();
			longTextDY = r.height + distanceToLong;
			rectHeight = r.height + lr.height + distanceToLong;
			rectWidth = Math.max(r.width, lr.width);
			r = new Rect(r.x, r.y, rectWidth, rectHeight);
			
		} else
			guiLongTextObject.enabled = false;
		guiTextureObject.pixelInset = new Rect(w / 2 - border, h / 2 - r.height - border, -w + r.width + border * 2, -h + r.height + border * 2);
			
		if (panel && Fixed2dCamera.exists) {
			DeltaTime.update.add(moveTextPanel);
			moveTextPanel();
		} else {
			DeltaTime.update.add(moveText);
			moveText();			
		}
	}
	
	private static function moveTextPanel():Void {
		textObject.transform.position = new Vector3(1 - (Screen.width - Input.mousePosition.x + r.width/2) / Fixed2dCamera.SIZE, (Input.mousePosition.y+r.height + border*2)/Screen.height, 500);
		textureObject.transform.position = new Vector3(1 - (Screen.width - Input.mousePosition.x + r.width / 2) / Fixed2dCamera.SIZE, (Input.mousePosition.y + r.height + border * 2) / Screen.height, 499);
	
		//longTextObject.transform.position = new Vector3(1 - (Screen.width - Input.mousePosition.x + lr.width / 2) / Fixed2dCamera.SIZE, (Input.mousePosition.y + lr.height + border * 2) / Screen.height, 499);
	}
	
	private static function moveText():Void {
		var limx:Float = limitBorder / (Screen.width - Fixed2dCamera.SIZE);
		var limy:Float = limitBorder / Screen.height;
		var x:Float = (Input.mousePosition.x - r.width / 2) / (Screen.width - Fixed2dCamera.SIZE);
		var y:Float = (Input.mousePosition.y + r.height + border * 2) / Screen.height;
		var dw:Float = 1 - r.width / (Screen.width - Fixed2dCamera.SIZE);
		var dh:Float = r.height / Screen.height;
		x = x.limit(limx, dw-limx);
		y = y.limit(dh+limy, 1-limy);
		textObject.transform.position = new Vector3(x, y, 500);
		textureObject.transform.position = new Vector3(x, y, 499);
		y -= longTextDY / Screen.height;
		longTextObject.transform.position = new Vector3(x, y, 500);
	}
	
	public static function hideText(obj:Dynamic):Void {
		if (target != obj) return;
		if (textObject == null) return;
		guiTextObject.enabled = false;
		guiTextureObject.enabled = false;
		guiLongTextObject.enabled = false;
		DeltaTime.update.remove(moveText);
		DeltaTime.update.remove(moveTextPanel);
	}
}