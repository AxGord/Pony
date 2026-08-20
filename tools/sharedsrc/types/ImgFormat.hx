package types;

@SuppressWarnings('checkstyle:MagicNumber')
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract ImgFormat(String) to String {

	final PNG = 'png';
	final JPG = 'jpg';
	final WEBP = 'webp';

}
