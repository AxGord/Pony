package pony.physics;

import pony.DeltaTime;

using pony.Tools;
/**
 * Termo Box Logic
 * @author AxGord
 */
class Termo {

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
		air = wet = smoke = 0;
		kwTotal = kw = 0;
		temp = ROOM_TEMP;
		wet = ROOM_WET;
		maxkw = v / 2;
		evaporatorV = v / 10;
		pumpPower = 0;
		DeltaTime.update.add(termoUpdate);
		DeltaTime.update.add(evaporatorUpdate);
		DeltaTime.update.add(dehumidifierUpdate);
		DeltaTime.update.add(coolerUpdate);
	}
	
	private function termoUpdate(dt:Float):Void {
		var m = 50 / v;
		if (m < 1) m = 1;
		if (temp > ROOM_TEMP) {
			temp -= (temp - ROOM_TEMP) * (getAirC() - 1) / 5 * dt;
			if (temp < ROOM_TEMP) temp = ROOM_TEMP;
		}
		if (tempTarget != null) {
			if (tempTarget > temp) {
				kw = Math.floor(tempTarget / temp * 100) / 100 / m;
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