package pony.ui.xml;

#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract UiTags(String) from String {

	final repeat = 'repeat';
	final object = 'object';
	final sw = 'sw';
	final node = 'node';
	final rect = 'rect';
	final line = 'line';
	final circle = 'circle';
	final image = 'image';
	final layout = 'layout';
	final text = 'text';
	final simpleText = 'simpleText';
	final input = 'input';
	final button = 'button';
	final lightButton = 'lightButton';
	final scrollBox = 'scrollBox';
	final slider = 'slider';

}
