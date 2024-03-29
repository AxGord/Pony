package create.section;

import pony.text.XmlTools;

/**
 * Uglify
 * @author AxGord <axgord@gmail.com>
 */
class Uglify extends Section {

	public var outputPath:String;
	public var outputFile:String;
	public var mapOffset:Int = 0;
	public var c:Bool = true;
	public var m:Bool = true;
	public var libcache: Bool = true;

	public var debugLibs:Array<String> = [];
	public var releaseLibs:Array<String> = [];
	public var libs:Array<String> = [];

	public function new() super('uglify');

	#if (haxe_ver < 4.2) override #end
	public function result():Xml {
		init();
		if (libcache) set('libcache', 'true');

		if (c || m || releaseLibs.length > 0) {
			var release = Xml.createElement('release');
			if (c) release.addChild(Xml.createElement('c'));
			if (m) release.addChild(Xml.createElement('m'));
			for (lib in releaseLibs) release.addChild(XmlTools.node('input', lib));
			xml.addChild(release);
		}

		var debug = Xml.createElement('debug');
		for (lib in debugLibs) debug.addChild(XmlTools.node('input', lib));

		var sm = Xml.createElement('sourcemap');
		sm.addChild(XmlTools.node('input', '$outputPath$outputFile.map'));
		sm.addChild(XmlTools.node('output', '$outputPath$outputFile.map'));
		sm.addChild(XmlTools.node('url', '$outputFile.map'));
		sm.addChild(XmlTools.node('source', outputFile));
		if (mapOffset != null)
			sm.addChild(XmlTools.node('offset', Std.string(mapOffset)));
		debug.addChild(sm);

		xml.addChild(debug);

		for (lib in libs) xml.addChild(XmlTools.node('input', lib));

		xml.addChild(XmlTools.node('input', outputPath + outputFile));
		xml.addChild(XmlTools.node('output', outputPath + outputFile));

		return root;
	}

}