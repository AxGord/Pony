package pony.ui.xml;

@:enum abstract UiTags(String) from String {
	var repeat = 'repeat';
	var object = 'object';
	var sw = 'sw';
	var node = 'node';
	var rect = 'rect';
	var line = 'line';
	var circle = 'circle';
	var image = 'image';
	var layout = 'layout';
	var text = 'text';
	var simpleText = 'simpleText';
	var input = 'input';
	var button = 'button';
	var lightButton = 'lightButton';
	var scrollBox = 'scrollBox';
	var slider = 'slider';
}
