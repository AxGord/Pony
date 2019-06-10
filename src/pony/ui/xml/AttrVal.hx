package pony.ui.xml;

@:enum abstract AttrVal(String) from String to String {
	var stage = 'stage';
	var stageWidth = 'stageWidth';
	var stageHeight = 'stageHeight';
	var dyn = 'dyn';
	var dynWidth = 'dynWidth';
	var dynHeight = 'dynHeight';
	var dynX = 'dynX';
	var dynY = 'dynY';
}