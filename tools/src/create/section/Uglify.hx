package create.section;

class Uglify extends Section {

	public var outputPath:String;
	public var outputFile:String;

	public var debugLibs:Array<String> = [];
	public var releaseLibs:Array<String> = [];
	public var libs:Array<String> = [];

	public function new() super('uglify');

	public function result():Xml {
		init();
		set('libcache', 'true');

		var release = Xml.createElement('release');
		release.addChild(Xml.createElement('c'));
		release.addChild(Xml.createElement('m'));
		for (lib in releaseLibs) release.addChild(Utils.xmlSimple('input', lib));
		xml.addChild(release);

		var debug = Xml.createElement('debug');
		for (lib in debugLibs) debug.addChild(Utils.xmlSimple('input', lib));

		var sm = Xml.createElement('sourcemap');
		sm.addChild(Utils.xmlSimple('input', '$outputPath$outputFile.map'));
		sm.addChild(Utils.xmlSimple('output', '$outputPath$outputFile.map'));
		sm.addChild(Utils.xmlSimple('url', '$outputFile.map'));
		sm.addChild(Utils.xmlSimple('source', outputFile));
		debug.addChild(sm);

		xml.addChild(debug);

		for (lib in libs) xml.addChild(Utils.xmlSimple('input', lib));

		xml.addChild(Utils.xmlSimple('input', outputPath + outputFile));
		xml.addChild(Utils.xmlSimple('output', outputPath + outputFile));

		return xml;
	}

}