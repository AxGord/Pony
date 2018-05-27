/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package pony.pixi.ui;

import pixi.core.graphics.Graphics;
import pony.geom.Point;
import pony.math.MathTools;

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