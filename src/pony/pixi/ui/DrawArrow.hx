package pony.pixi.ui;

import pixi.core.graphics.Graphics;
import pony.geom.Point;
import pony.math.MathTools;

/**
 * DrawArrow
 * @author AxGord <axgord@gmail.com>
 */
class DrawArrow {

	public var linew:Float = 6;
	public var arrowheadAngle:Float = 30;
	public var arrowheadLen:Float = 40;
	public var g:Graphics;
	public var color:Int;

	public function new(?g:Graphics, linew:Float = 6, arrowheadAngle:Float = 30, arrowheadLen:Float = 40, color:Int = 0) {
		this.g = g;
		this.linew = linew;
		this.arrowheadAngle = arrowheadAngle;
		this.arrowheadLen = arrowheadLen;
		this.color = color;
	}
	
	public function draw(?g:Graphics, a:Point<Float>, b:Point<Float>, color:Int = -1):Void {
		if (g == null) g = this.g;
		if (color == -1) color = this.color;
		g.moveTo(a.x, a.y);
		g.lineStyle(linew, color);
		g.lineTo(b.x, b.y);
		drawHead(g, a, b, color);
	}

	public function drawHead(?g:Graphics, a:Point<Float>, b:Point<Float>, color:Int = -1):Void {
		if (g == null) g = this.g;
		if (color == -1) color = this.color;
		var dx = b.x - a.x;
		var dy = b.y - a.y;
		var angle:Float = Math.atan2(dy, dx);
		var bangle = angle - arrowheadAngle * MathTools.DEG2RAD;
		var cangle = angle + arrowheadAngle * MathTools.DEG2RAD;
		var b1:Float = b.x - arrowheadLen * Math.cos(bangle);
		var b2:Float = b.y - arrowheadLen * Math.sin(bangle);
		var c1:Float = b.x - arrowheadLen * Math.cos(cangle);
		var c2:Float = b.y - arrowheadLen * Math.sin(cangle);
		g.lineStyle(linew, color);
		g.beginFill(color);
		g.moveTo(b.x, b.y);
		g.lineTo(b1, b2);
		g.lineTo(c1, c2);
		g.lineTo(b.x, b.y);
		g.endFill();
	}

}