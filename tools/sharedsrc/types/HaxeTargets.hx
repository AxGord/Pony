package types;

@:enum abstract HaxeTargets(String) from String to String {

	var JS = 'js';
	var Neko = 'neko';
	var Swf = 'swf';
	var Swc = 'swc';

}