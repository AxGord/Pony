package pony.ui.xml;

@:enum abstract UiTags(String) from String {
	var node = 'node';
	var rect = 'rect';
	var line = 'line';
	var circle = 'circle';
	var image = 'image';
	var layout = 'layout';
}
