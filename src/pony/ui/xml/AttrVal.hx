package pony.ui.xml;

#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract AttrVal(String) from String to String {

	final stage = 'stage';
	final stageWidth = 'stageWidth';
	final stageHeight = 'stageHeight';
	final dyn = 'dyn';
	final dynWidth = 'dynWidth';
	final dynHeight = 'dynHeight';
	final dynX = 'dynX';
	final dynY = 'dynY';

}
