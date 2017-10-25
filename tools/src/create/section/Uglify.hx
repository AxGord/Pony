package create.section;
import pony.text.XmlTools;

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
		for (lib in releaseLibs) release.addChild(XmlTools.node('input', lib));
		xml.addChild(release);

		var debug = Xml.createElement('debug');
		for (lib in debugLibs) debug.addChild(XmlTools.node('input', lib));

		var sm = Xml.createElement('sourcemap');
		sm.addChild(XmlTools.node('input', '$outputPath$outputFile.map'));
		sm.addChild(XmlTools.node('output', '$outputPath$outputFile.map'));
		sm.addChild(XmlTools.node('url', '$outputFile.map'));
		sm.addChild(XmlTools.node('source', outputFile));
		debug.addChild(sm);

		xml.addChild(debug);

		for (lib in libs) xml.addChild(XmlTools.node('input', lib));

		xml.addChild(XmlTools.node('input', outputPath + outputFile));
		xml.addChild(XmlTools.node('output', outputPath + outputFile));

		return xml;
	}

}