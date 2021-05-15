package create.section;

using pony.text.XmlTools;

class Hashlink extends Section {

	public var buildName: String = 'app';
	public var buildDir: String = 'builds/';
	public var outputDir: String;
	public var outputFile: String;
	public var assets: String = 'assets/';
	public var libs: String;
	public var win: String;
	public var mac: Bool = true;

	public function new() super('hl');

	override public function result():Xml {
		init();
		var r: Xml = add('release');
		r.addChild('main'.node(outputDir + outputFile));
		var d: Xml = 'data'.node(assets);
		d.set('from', outputDir);
		r.addChild(Xml.createComment(d.toString()));
		var a: Xml = 'apps'.node();
		r.addChild(a);
		if (win != null) {
			var w: Xml = 'win'.node();
			a.addChild(w);
			w.addChild(getOutputXml(buildName));
			w.addChild('hl'.node(libs + win));
		}
		if (mac) {
			var m: Xml = 'mac'.node();
			a.addChild(m);
			m.addChild(getOutputXml(buildName + '.app'));
			m.addChild('hl'.node('mac'));
		}
		return xml;
	}

	private function getOutputXml(name: String): Xml {
		var output: Xml = 'output'.node(buildDir + name);
		output.set('clean', '${true}');
		return output;
	}

}