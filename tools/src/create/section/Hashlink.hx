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
	public var android: String = 'android/';

	public function new() super('hl');

	#if (haxe_ver < 4.2) override #end
	public function result():Xml {
		init();
		var r: Xml = add('release');
		r.addChild('main'.node(outputDir + outputFile));
		var d: Xml = 'data'.node(assets);
		d.set('from', outputDir);
		var a: Xml = 'apps'.node();
		r.addChild(a);
		if (win != null) {
			var w: Xml = 'win'.node();
			a.addChild(w);
			w.addChild(getOutputXml(buildName));
			w.addChild('hl'.node(libs + win));
			w.addChild(Xml.createComment(d.toString()));
		}
		if (mac) {
			var m: Xml = 'mac'.node();
			a.addChild(m);
			m.addChild(getOutputXml(buildName + '.app'));
			m.addChild('hl'.node('mac'));
			m.addChild(Xml.createComment(d.toString()));
		}
		if (android != null) {
			var m: Xml = 'android'.node();
			add('apps').addChild(m);
			var d: Xml = 'data'.node();
			d.set('from', outputDir + assets);
			m.addChild(Xml.createComment(d.toString()));
			m.addChild('output'.node(outputDir + 'android'));
			m.addChild('hl'.node('android'));
			m.addChild('title'.node('Pony App'));
			m.addChild('id'.node('io.github.axgord.pony'));
			m.addChild('version'.node('1'));
			m.addChild('versionName'.node('1.0'));
			m.addChild('storeFile'.node('bin/testcert.p12'));
			m.addChild('storePassword'.node(''));
			m.addChild('keyAlias'.node('test'));
			m.addChild('keyPassword'.node(''));
			m.addChild('abiFilters'.node('x86'));
			m.addChild(Xml.createComment('abiFilters'.node('armeabi-v7a').toString()));
		}
		return xml;
	}

	private function getOutputXml(name: String): Xml {
		var output: Xml = 'output'.node(buildDir + name);
		output.set('clean', '${true}');
		return output;
	}

	public function needClean(): Bool return android != null;

	public function getClean(): Xml {
		var clean: Xml = 'clean'.node();
		var before: Xml = 'before'.node();
		clean.addChild(before);
		var build: Xml = 'build'.node();
		before.addChild(build);
		var apps: Xml = 'apps'.node();
		build.addChild(apps);
		var androidNode: Xml = 'android'.node();
		apps.addChild(androidNode);
		var dir: Xml = 'dir'.node('$outputDir${android}app/src/main/assets/');
		androidNode.addChild(dir);
		dir.set('rimraf', '${true}');
		return clean;
	}

}