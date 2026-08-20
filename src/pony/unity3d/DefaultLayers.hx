package pony.unity3d;

/**
 * DefaultLayers
 * @author AxGord
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract DefaultLayers(Int) from Int to Int {

	final Default = 0;
	final TransparentFX = 1;
	final IgnoreRaycast = 2;
	final Layer3 = 3;
	final Water = 4;
	final UI = 5;
	final Layer6 = 6;
	final Layer7 = 7;

}
