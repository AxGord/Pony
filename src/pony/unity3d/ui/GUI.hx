package pony.unity3d.ui;

import pony.color.Color;
import pony.color.UColor;
import pony.geom.Rect.IntRect;
import unityengine.Vector3;
import unityengine.Vector2;
import unityengine.GUITexture;
import unityengine.GUIText;
import unityengine.GameObject;
import unityengine.Object;
import unityengine.Rect;
import unityengine.Texture2D;
import unityengine.Resources;
import unityengine.Font;
import pony.geom.Point.IntPoint;
import pony.ui.gui.FontStyle;
import hugs.HUGS;

using hugs.HUGSWrapper;

/**
 * GUI
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class GUI {
	
	static private var textures:Map<Int, Dynamic> = new Map<Int, Texture2D>();

	public static function text(f:Vector3, point:IntPoint, text:String, style:FontStyle):GameObject {
		var b = new GameObject();
		b.name = 'gui_text';
		b.transform.position = f;
		b.transform.localScale = new Vector3(0, 0, 0);
		var g = b.addTypedComponent(GUIText);
		g.pixelOffset = new Vector2(point.x, -point.y);
		g.text = text;
		g.font = HUGS.fonts.get(style.font);
		g.fontSize = Math.ceil(style.size);
		g.fontStyle = switch [style.bold, style.italic] {
			case [false, false]: unityengine.FontStyle.Normal;
			case [true, false]: unityengine.FontStyle.Bold;
			case [false, true]: unityengine.FontStyle.Italic;
			case [true, true]: unityengine.FontStyle.BoldAndItalic;
		};
		g.material.color = cast style.color;
		return b;
	}
	
	public static function rect(f:Vector3, r:IntRect, color:UColor):GameObject {
		if (!textures.exists(color)) {
			var t:Texture2D = new Texture2D(1, 1);
			t.SetPixel(0,0,color);
			t.Apply();
			textures.set(color, t);
		}
		var b = new GameObject();
		b.name = 'gui_rect';
		var g = b.addTypedComponent(GUITexture);
		b.guiTexture.texture = textures.get(color);
		b.transform.position = f;
		b.transform.localScale = new Vector3(0, 0, 0);
		g.pixelInset = new Rect(r.x, -r.y, r.width, -r.height);
		return b;
	}
	
	public static function brect(f:Vector3, r:IntRect, color:Color, border:Int, bcolor:Color):Array<GameObject> {
		return [
			rect(f, r, color),
			rect(new Vector3(f.x, f.y, f.z+1), {x:r.x,y:r.y,width:border,height:r.height}, bcolor),
			rect(new Vector3(f.x, f.y, f.z+1), {x:r.x,y:r.y,width:r.width,height:border}, bcolor),
			rect(new Vector3(f.x, f.y, f.z+1), {x:r.x+r.width,y:r.y,width:border,height:r.height}, bcolor),
			rect(new Vector3(f.x, f.y, f.z+1), {x:r.x,y:r.y+r.height,width:r.width,height:border}, bcolor),
		];
	}
	
}