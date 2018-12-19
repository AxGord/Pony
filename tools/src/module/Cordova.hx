/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package module;

import pony.fs.File;
import pony.text.XmlTools;
import haxe.xml.Fast;
import sys.FileSystem;
import types.BAConfig;
import types.BASection;

typedef CordovaConfig = { > BAConfig,
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

	private static inline var PRIORITY:Int = 0;
	private static inline var AVC:String = 'android-versionCode';
	private static inline var OPEN_WIDGET_TAG:String = '<widget';
	private static inline var CLOSE_WIDGET_TAG:String = '</widget>';

	private var configFile:File = 'config.xml';

	public function new() super('cordova');

	override public function init():Void {
		initSections(PRIORITY, BASection.Cordova);
		modules.commands.onCordova.add(cordovaHandler, -300);
		modules.commands.onAndroid.add(androidHandler, -200);
		modules.commands.onIphone.add(iphoneHandler, -200);
		modules.commands.onAndroid.add(androidBuildHandler, 200);
		modules.commands.onIphone.add(iphoneBuildHandler, 200);
	}

	private function androidHandler():Void modules.build.addFlag('android');
	private function iphoneHandler():Void modules.build.addFlag('iphone');

	private function cordovaHandler(a:String, b:String):Void {
		modules.build.addHaxelib('cordova');
		var cfg:AppCfg = Utils.parseArgs([a, b]);
		if (cfg.debug) {
			modules.commands.onAndroid >> androidBuildHandler;
			modules.commands.onIphone >> iphoneBuildHandler;
		}
	}

	private function androidBuildHandler():Void addToRun(androidBuild);
	private function iphoneBuildHandler():Void addToRun(iphoneBuild);
	
	private function androidBuild():Void {
		Utils.command('cordova', ['build', 'android', '--release']);
		finishCurrentRun();
	}

	private function iphoneBuild():Void {
		Utils.command('cordova', ['build', 'ios', '--release']);
		finishCurrentRun();
	}

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
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
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:CordovaConfig):Void {
		if (!configFile.exists) {
			error('Cordova not inited');
			Sys.exit(1);
		}

		var content:String = configFile.content;
		var contentLines:Array<String> = content.split('\n');
		var wline:Int = 0;
		var wfounded:Bool = false;
		for (s in contentLines) {
			s = StringTools.trim(s);
			if (s.substr(0, OPEN_WIDGET_TAG.length) == OPEN_WIDGET_TAG) {
				if (s.substr(-1) != '>') {
					error('Widget tag close on other line, please fix $configFile');
					Sys.exit(1);
				} else if (s.substr(-2) == '/>') {
					error('Widget error, please fix $configFile');
					Sys.exit(1);
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
			Sys.exit(1);
		}
		var widgetLineXml:Fast = XmlTools.fast(contentLines[wline] + CLOSE_WIDGET_TAG).node.widget;
		var changes:Bool = false;
		var widgetLineChanged:Bool = false;

		if (cfg.id != null && cfg.id != widgetLineXml.att.id) {
			widgetLineXml.att.id = cfg.id;
			widgetLineChanged = true;
		}

		if (cfg.versionBuildDate) {
			var date:String = Date.now().toString();
			date = StringTools.replace(date, ' ', '_');
			date = StringTools.replace(date, ':', '-');
			widgetLineXml.att.version = date;
			widgetLineChanged = true;
		}

		if (cfg.incrementAndroidVersionCode) {
			var currentVersion:Int = widgetLineXml.has.resolve(AVC) ? Std.parseInt(widgetLineXml.att.resolve(AVC)) : 0;
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
			var nc:String = XmlTools.intagReplace(content, 'name', cfg.name);
			if (nc != content) {
				content = nc;
				changes = true;
			}
		}

		if (cfg.desc != null) {
			var nc:String = XmlTools.intagReplace(content, 'description', cfg.desc);
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

	override private function clean():Void {
		cfg.name = null;
		cfg.desc = null;
		cfg.id = null;
		cfg.versionBuildDate = false;
		cfg.incrementAndroidVersionCode = false;
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'name': cfg.name = normalize(xml.innerData);
			case 'id': cfg.id = normalize(xml.innerData);
			case 'version': cfg.versionBuildDate = XmlTools.isTrue(xml, 'buildDate');
			case 'androidVersionCode': cfg.incrementAndroidVersionCode = XmlTools.isTrue(xml, 'increment');
			case _: super.readNode(xml);
		}
	}

}