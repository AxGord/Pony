package create.section;

import pony.text.XmlTools;
import types.*;

using StringTools;

/**
 * Cordova
 * @author AxGord <axgord@gmail.com>
 */
class Cordova extends Section {

	public var title: String = null;
	public var versionBuildDate: Bool = true;
	public var androidVersionIncrement: Bool = true;

	public function new() super('cordova');

	#if (haxe_ver < 4.2) override #end
	public function result(): Xml {
		init();

		if (title != null) add('id', 'org.apache.cordova.pony.${title.replace(' ', '')}');

		if (versionBuildDate) {
			final version: Xml = Xml.createElement('version');
			version.set('buildDate', 'true');
			xml.addChild(version);
		}

		if (title != null || androidVersionIncrement) {
			final release: Xml = Xml.createElement('release');
			if (title != null) release.addChild(XmlTools.node('name', title));
			if (androidVersionIncrement) {
				final av: Xml = Xml.createElement('androidVersionCode');
				av.set('increment', 'true');
				release.addChild(av);
			}
			xml.addChild(release);
		}

		if (title != null) {
			final debug: Xml = Xml.createElement('debug');
			debug.addChild(XmlTools.node('name', '$title Debug'));
			xml.addChild(debug);
		}

		return xml;
	}

}
