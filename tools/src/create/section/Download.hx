package create.section;

using StringTools;

/**
 * Download
 * @author AxGord <axgord@gmail.com>
 */
class Download extends Section {

	public static var LIBS:Map<String, Library> = [
		'stacktrace' => new Library('https://raw.githubusercontent.com/stacktracejs/stacktrace.js/v{v}/dist/stacktrace.min.js', '1.3.1'),
		'pixijs' => new Library('https://pixijs.download/v{v}/pixi.min.js', '4.8.8', 'pixi.js - v{v}'),
		'docready' => new Library('https://raw.githubusercontent.com/jfriend00/docReady/master/docready.js'),
		'hlwin' => new Library('https://github.com/HaxeFoundation/hashlink/releases/download/{v}/hl-{v}.0-win.zip', '1.12')
	];

	public var list:Array<Library> = [];
	public var path:String = 'libs/';

	public function new() super('download');

	public function addLib(name:String):Void list.push(LIBS[name]);

	#if (haxe_ver < 4.2) override #end
	public function result():Xml {
		init();
		set('path', path);
		for (lib in list) {
			xml.addChild(lib.xml());
		}
		return xml;
	}

	public function getLibFinal(name:String):String return path + LIBS[name].getFinal();

}

private class Library {

	var url:String;
	var version:String;
	var check:String;

	public function new(url:String, ?version:String, ?check:String) {
		this.url = url;
		this.version = version;
		this.check = check;
	}

	public function xml():Xml {
		var unit = Xml.createElement('unit');
		unit.set('url', url);
		if (version != null)
			unit.set('v', version);
		if (check != null)
			unit.set('check', check);
		return unit;
	}

	public function getFinal():String return url.substr(url.lastIndexOf('/') + 1).replace('{v}', version);

}