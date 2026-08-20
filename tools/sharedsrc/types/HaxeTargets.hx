package types;

@SuppressWarnings('checkstyle:MagicNumber')
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract HaxeTargets(String) from String to String {

	final JS = 'js';
	final Neko = 'neko';
	final Swf = 'swf';
	final Swc = 'swc';
	final HL = 'hl';
	final HLC = 'hlc';

}
