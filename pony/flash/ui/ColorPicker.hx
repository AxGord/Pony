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
package pony.flash.ui;

import flash.display.*;
import flash.geom.Matrix;
import pony.magic.HasSignal;
import pony.ui.touch.Touchable;
import pony.ui.touch.Touch;
import pony.geom.Point;

class ColorPicker extends Sprite implements HasSignal {
	
	private static var COLORS:Array<UInt> = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
	private static var BRIGHTESS_COLORS:Array<UInt> = [0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000];
	private static var BRIGHTESS_ALPHAS:Array<Float> = [1, 0, 0, 1];
	private static var BRIGHTESS_PARTS:Array<Float> = [0, 0x88, 0x88, 0xFF];

	@:bindable public var color:UInt;

	private var ratios:Array<Float>;
	private var alphas:Array<Float>;

	private var bitmapData:BitmapData;
	private var bitmap:Bitmap;

	private var marker:Sprite = new Sprite();
	private var markerColor:UInt = 1;

	private var touchable:Touchable;
	private var prevX:Int;
	private var prevY:Int;

	public function new(?size:Point<UInt>) {
		super();

		var part:Float = 0xFF / (COLORS.length - 1);
		ratios = [for (i in 0...COLORS.length) part * i];
		alphas = [for (_ in 0...COLORS.length) 1];

		if (size != null) draw(size.x, size.y);
		
		touchable = new Touchable(this);
		touchable.onDown < downHandler;
	}

	private function downHandler(t:Touch):Void {
		marker.cacheAsBitmap = false;
		moveHandler();
		t.onMove << moveHandler;
		t.onUp < upHandler;
		t.onOutUp < upHandler;
	}

	private function moveHandler():Void {
		if (bitmap == null) return;
		var px:Int = Std.int(mouseX);
		var py:Int = Std.int(mouseY);
		if (px < 0) px = 0;
		if (py < 0) py = 0;
		if (px > bitmapData.width) px = bitmapData.width;
		if (py > bitmapData.height) py = bitmapData.height;
		if (px == prevX && py == prevY) return;
		prevX = px;
		prevY = py;
		marker.x = px;
		marker.y = py;
		drawMarker(py > bitmapData.height / 2 ? 0xFFFFFF : 0);
		color = bitmapData.getPixel(px, py);
	}

	private function upHandler(t:Touch):Void {
		t.onMove >> moveHandler;
		t.onUp >> upHandler;
		t.onOutUp >> upHandler;
		marker.cacheAsBitmap = true;
		touchable.onDown < downHandler;
	}

	private function drawMarker(color:UInt):Void {
		if (color == markerColor) return;
		markerColor = color;
		marker.graphics.clear();
		marker.graphics.lineStyle(2, color);
		marker.graphics.drawCircle(0, 0, 2);
	}

	public inline function removeMarker():Void {
		markerColor = 1;
		marker.graphics.clear();
	}

	public inline function clear():Void {
		if (bitmap != null) {
			removeChild(bitmap);
			bitmapData.dispose();
		}
	}

	public function draw(w:UInt, h:UInt):Void {
		clear();
		removeMarker();
		var m:Matrix = new Matrix();
		m.createGradientBox(w, h);
		graphics.beginGradientFill(GradientType.LINEAR, COLORS, alphas, ratios, m);
		graphics.drawRect(0, 0, w, h);

		var m:Matrix = new Matrix();
		m.createGradientBox(w, h, Math.PI / 2);
		graphics.beginGradientFill(GradientType.LINEAR, BRIGHTESS_COLORS, BRIGHTESS_ALPHAS, BRIGHTESS_PARTS, m);
		graphics.drawRect(0, 0, w, h);
		graphics.endFill();

		bitmapData = new BitmapData(w, h, true, 0);
		bitmapData.draw(this);
		graphics.clear();
		bitmap = new Bitmap(bitmapData);
		addChild(bitmap);
		addChild(marker);
	}

}