package create.section;

/**
 * Download
 * @author AxGord <axgord@gmail.com>
 */
class Download extends Section {

	public static var LIBS:Map<String, Library> = [
		'stacktrace' => new Library('https://raw.githubusercontent.com/stacktracejs/stacktrace.js/v{v}/dist/stacktrace.min.js', '1.3.1'),
		'pixijs' => new Library('https://pixijs.download/v{v}/pixi.min.js', '4.8.4', 'pixi.js - v{v}'),
		'docready' => new Library('https://raw.githubusercontent.com/jfriend00/docReady/master/docready.js'),
	];

	public var list:Array<Library> = [];
	public var path:String = 'jslib/';

	public function new() super('download');

	public function addLib(name:String):Void list.push(LIBS[name]);

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
	var verison:String;
	var check:String;

	public function new(url:String, ?verison:String, ?check:String) {
		this.url = url;
		this.verison = verison;
		this.check = check;
	}

	public function xml():Xml {
		var unit = Xml.createElement('unit');
		unit.set('url', url);
		if (verison != null)
			unit.set('v', verison);
		if (check != null)
			unit.set('check', check);
		return unit;
	}

	public function getFinal():String return url.substr(url.lastIndexOf('/') + 1);

}