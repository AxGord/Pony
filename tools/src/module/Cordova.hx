package module;

import pony.Fast;
import pony.fs.File;
import pony.text.XmlTools;

import types.BAConfig;
import types.BASection;

typedef CordovaConfig = {
	> BAConfig,
	name: String,
	desc: String,
	id: String,
	versionBuildDate: Bool,
	incrementAndroidVersionCode: Bool
}

/**
 * Cordova module
 * @author AxGord <axgord@gmail.com>
 */
class Cordova extends CfgModule<CordovaConfig> {

	private static inline var PRIORITY: Int = 0;
	private static inline var AVC: String = 'android-versionCode';
	private static inline var OPEN_WIDGET_TAG: String = '<widget';
	private static inline var CLOSE_WIDGET_TAG: String = '</widget>';

	private var configFile: File = 'config.xml';

	public function new() super('cordova');

	override public function init(): Void {
		initSections(PRIORITY, BASection.Cordova);
		modules.commands.onCordova.add(cordovaHandler, -300);
		modules.commands.onAndroid.add(androidHandler, -200);
		modules.commands.onIphone.add(iphoneHandler, -200);
		modules.commands.onAndroid.add(androidBuildHandler, Move.PRIORITY);
		modules.commands.onIphone.add(iphoneBuildHandler, Move.PRIORITY);
	}

	private function androidHandler(): Void modules.build.addFlag('android');
	private function iphoneHandler(): Void modules.build.addFlag('iphone');

	private function cordovaHandler(a: String, b: String): Void {
		modules.build.addHaxelib('cordova');
		var cfg: AppCfg = Utils.parseArgs([a, b]);
		if (cfg.debug) {
			modules.commands.onAndroid >> androidBuildHandler;
			modules.commands.onIphone >> iphoneBuildHandler;
		}
	}

	private function androidBuildHandler(): Void addToRun(androidBuild);
	private function iphoneBuildHandler(): Void addToRun(iphoneBuild);

	private function androidBuild(): Void {
		Utils.command('cordova', ['build', 'android', '--release']);
		finishCurrentRun();
	}

	private function iphoneBuild(): Void {
		Utils.command('cordova', ['build', 'ios', '--release']);
		finishCurrentRun();
	}

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new CordovaReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Cordova,
			name: null,
			desc: null,
			id: null,
			versionBuildDate: false,
			incrementAndroidVersionCode: false,
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: CordovaConfig): Void {
		if (!configFile.exists) {
			error('Cordova not inited');
			Utils.exit(1);
		}

		var content: String = configFile.content;
		var contentLines: Array<String> = content.split('\n');
		var wline: Int = 0;
		var wfounded: Bool = false;
		for (s in contentLines) {
			s = StringTools.trim(s);
			if (s.substr(0, OPEN_WIDGET_TAG.length) == OPEN_WIDGET_TAG) {
				if (s.substr(-1) != '>') {
					error('Widget tag close on other line, please fix $configFile');
					Utils.exit(1);
				} else if (s.substr(-2) == '/>') {
					error('Widget error, please fix $configFile');
					Utils.exit(1);
				} else {
					wfounded = true;
					break;
				}
			} else {
				wline++;
			}
		}
		if (!wfounded) {
			error('Widget tag not founded, please fix $configFile');
			Utils.exit(1);
		}
		var widgetLineXml: Fast = XmlTools.fast(contentLines[wline] + CLOSE_WIDGET_TAG).node.widget;
		var changes: Bool = false;
		var widgetLineChanged: Bool = false;

		if (cfg.id != null && cfg.id != widgetLineXml.att.id) {
			widgetLineXml.att.id = cfg.id;
			widgetLineChanged = true;
		}

		if (cfg.versionBuildDate) {
			widgetLineXml.att.version = Utils.getBuildString();
			widgetLineChanged = true;
		}

		if (cfg.incrementAndroidVersionCode) {
			var currentVersion: Int = widgetLineXml.has.resolve(AVC) ? Std.parseInt(widgetLineXml.att.resolve(AVC)) : 0;
			currentVersion++;
			widgetLineXml.x.set(AVC, Std.string(currentVersion));
			widgetLineChanged = true;
		}

		if (widgetLineChanged) {
			changes = true;
			var c = widgetLineXml.x.toString().substr(0, -CLOSE_WIDGET_TAG.length);
			contentLines[wline] = c;
			content = contentLines.join('\n');
		}

		if (cfg.name != null) {
			var nc: String = XmlTools.intagReplace(content, 'name', cfg.name);
			if (nc != content) {
				content = nc;
				changes = true;
			}
		}

		if (cfg.desc != null) {
			var nc: String = XmlTools.intagReplace(content, 'description', cfg.desc);
			if (nc != content) {
				content = nc;
				changes = true;
			}
		}

		if (changes) {
			configFile.content = content;
			log('$configFile updated');
		}
	}

}

private class CordovaReader extends BAReader<CordovaConfig> {

	override private function clean(): Void {
		cfg.name = null;
		cfg.desc = null;
		cfg.id = null;
		cfg.versionBuildDate = false;
		cfg.incrementAndroidVersionCode = false;
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'name': cfg.name = normalize(xml.innerData);
			case 'id': cfg.id = normalize(xml.innerData);
			case 'version': cfg.versionBuildDate = XmlTools.isTrue(xml, 'buildDate');
			case 'androidVersionCode': cfg.incrementAndroidVersionCode = XmlTools.isTrue(xml, 'increment');
			case _: super.readNode(xml);
		}
	}

}