package create.section;

import pony.text.XmlTools;
import types.*;

/**
 * Cordova
 * @author AxGord <axgord@gmail.com>
 */
class Cordova extends Section {

	public var title:String = null;
	public var versionBuildDate:Bool = true;
	public var androidVersionIncrement:Bool = true;

	public function new() super('cordova');

	public function result():Xml {
		init();

		if (title != null) add('id', 'org.apache.cordova.pony.' + StringTools.replace(title, ' ', ''));

		if (versionBuildDate) {
			var version = Xml.createElement('version');
			version.set('buildDate', 'true');
			xml.addChild(version);
		}

		if (title != null || androidVersionIncrement) {
			var release = Xml.createElement('release');
			if (title != null) release.addChild(XmlTools.node('name', title));
			if (androidVersionIncrement) {
				var av = Xml.createElement('androidVersionCode');
				av.set('increment', 'true');
				release.addChild(av);
			}
			xml.addChild(release);
		}

		if (title != null) {
			var debug = Xml.createElement('debug');
			debug.addChild(XmlTools.node('name', title + ' Debug'));
			xml.addChild(debug);
		}

		return xml;
	}

}