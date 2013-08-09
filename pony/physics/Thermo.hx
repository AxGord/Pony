/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.physics;


import pony.DeltaTime;


using pony.Tools;
/**
 * Termo Box Logic
 * @author AxGord
 */
class Thermo {


	static public var ROOM_TEMP:Float = 20;
	static public var ROOM_WET:Float = 0.5;


	inline static public var AIR_P:Float = 1.2;//плотность воздуха
	inline static public var K:Float = 1 / 3;//коэффициент запаса 
	inline static public var KK:Float = 0.00028 * K;
	inline static public var AIR_C_MIN:Float = 1.005;//air 0% wet
	inline static public var AIR_C_MAX:Float = 1.0301;//air 100% wet
	inline static public var HOUR:Float = 3600;
	//inline static public var WATER_C:Float = 4.183;


	public var temp(default, null):Float;
	public var tempTarget:Null<Float>;
	public var air:Float;
	public var wet(default, null):Float;


	@:isVar public var enabled(get, set):Bool = false;


	public var wetTarget:Null<Float>;
	public var smoke:Float;


	public var v:Float;
	public var evaporatorV:Float;


	//Energy
	public var kwTotal:Float;
	public var kw:Float;
	public var maxkw:Float;


	public var cooler:Float = 0.100;


	//Evaporator
	public var spentWater:Float;
	public var pumpPower:Float = 0;
	public var maxPump:Float = 1.040 / 2;
	public var maxLiter:Float = 1 / 2;


	public var dehumidifierPower:Float = 0;
	public var dehumidifierMaxPower:Float = 0.120;
	public var dehumidifierEfficiency:Float = 0.125;//Litres


	//Energy conversion efficiency
	public var ece:Float = 0.8;


	public function new(v:Float=9) {
		this.v = v;
		air = smoke = 0;
		kwTotal = kw = 0;
		temp = ROOM_TEMP;
		wet = ROOM_WET;
		maxkw = v / 2;
		evaporatorV = v / 10;
		pumpPower = 0;
		DeltaTime.update.add(roomUpdate);
		DeltaTime.update.add(coolerUpdate);
	}


	inline private function get_enabled():Bool return enabled;


	private function set_enabled(value:Bool):Bool {
		if (enabled != value) value ? enable() : disable();
		return enabled = value;
	}


	private function enable():Void {
		DeltaTime.update.add(termoUpdate);
		DeltaTime.update.add(evaporatorUpdate);
		DeltaTime.update.add(dehumidifierUpdate);


	}


	private function disable():Void {
		DeltaTime.update.remove(termoUpdate);
		DeltaTime.update.remove(evaporatorUpdate);
		DeltaTime.update.remove(dehumidifierUpdate);
	}


	private function roomUpdate(dt:Float):Void {
		if (temp > ROOM_TEMP) {
			temp -= (temp - ROOM_TEMP) * (getAirC() - 1) / 5 * dt;
			if (temp < ROOM_TEMP) temp = ROOM_TEMP;
		}
	}




	private function termoUpdate(dt:Float):Void {
		if (tempTarget != null) {
			if (tempTarget > temp) {
				kw = (1-temp/tempTarget/2) * maxkw;
				if (kw > maxkw) kw = maxkw;
			} else
				kw = 0;
		}
		kwTotal += kw * dt / HOUR;
		var t = kw / (KK * getAirC() * getAirM() * ece);
		temp += t * dt / HOUR;


	}


	private function evaporatorUpdate(dt:Float):Void {
		if (wetTarget != null) {
			if (wet < wetTarget) {
				pumpPower = wetTarget / wet;
				if (pumpPower > 1) pumpPower = 1;
			} else
				pumpPower = 0;
		}


		var p = pumpPower * maxPump;//kw-hour
		var l = pumpPower * maxLiter;//Litre in second
		kwTotal += p * dt / HOUR;
		var wt = l * 10 / 100 / v * dt;
		if (wet + wt < 1) wet += wt;
		else wet = 1;
	}


	private function dehumidifierUpdate(dt:Float):Void {
		if (wetTarget != null) {
			if (wet > wetTarget) {
				dehumidifierPower = wet / wetTarget;
				if (dehumidifierPower > 1) dehumidifierPower = 1;
			} else
				dehumidifierPower = 0;
		}


		var p = dehumidifierPower * dehumidifierMaxPower;
		var l = dehumidifierPower * dehumidifierEfficiency;
		kwTotal += p * dt / HOUR;
		var wt = l * 10 / 100 / v * dt;
		if (wet - wt > 0) wet -= wt;
		else wet = 0;
	}


	private function coolerUpdate(dt:Float):Void {
		if (kw > 0 || dehumidifierPower > 0 || pumpPower > 0) {
			kwTotal += cooler * dt / HOUR;
		}
	}


	inline private function getAirC():Float return wet.percentCalc(AIR_C_MIN, AIR_C_MAX);
	inline private function getAirM():Float return AIR_P * v;

}