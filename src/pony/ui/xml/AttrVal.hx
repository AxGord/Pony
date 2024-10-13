package pony.ui.xml;

#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract AttrVal(String) from String to String {
	var stage = 'stage';
	var stageWidth = 'stageWidth';
	var stageHeight = 'stageHeight';
	var dyn = 'dyn';
	var dynWidth = 'dynWidth';
	var dynHeight = 'dynHeight';
	var dynX = 'dynX';
	var dynY = 'dynY';
}