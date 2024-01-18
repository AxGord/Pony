package types;

@SuppressWarnings('checkstyle:MagicNumber')
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract HaxeTargets(String) from String to String {
	var JS = 'js';
	var Neko = 'neko';
	var Swf = 'swf';
	var Swc = 'swc';
	var HL = 'hl';
	var HLC = 'hlc';
}