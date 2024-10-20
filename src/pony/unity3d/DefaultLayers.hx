package pony.unity3d;

/**
 * DefaultLayers
 * @author AxGord
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract DefaultLayers(Int) from Int to Int {

	var Default = 0;
	var TransparentFX = 1;
	var IgnoreRaycast = 2;
	var Layer3 = 3;
	var Water = 4;
	var UI = 5;
	var Layer6 = 6;
	var Layer7 = 7;

}