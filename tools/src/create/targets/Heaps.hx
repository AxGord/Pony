package create.targets;

import create.section.Config.ConfigOptions;
import create.section.Download;

/**
 * Heaps
 * @author AxGord <axgord@gmail.com>
 */
class Heaps {

	public static var HLSDL_VERSION: String = '1.10.0';
	public static var WIN_HL_VERSION: String = 'hl_ver:1.11.0';
	public static var HL_VERSION: String = 'hl_ver:1.12.0';
	public static var UNSAFE: String = 'heaps_unsafe_events';

	public static function setJs(project: Project, ?second: Bool): Void {
		JS.set(project, second);
		project.config.active = true;
		project.config.stringmapAllowed = false;
		project.config.options['width'] = '1280';
		project.config.options['height'] = '1024';
		project.config.options['background'] = '#1A1A1A';
		var defBaseUrl: ConfigOptions = ['baseUrl' => 'assets/'];
		var androidBaseUrl: ConfigOptions = ['baseUrl' => ''];
		project.config.options['apps'] = ([
			'mac' => defBaseUrl,
			'win' => defBaseUrl,
			'js' => defBaseUrl,
			'android' => androidBaseUrl
		]: ConfigOptions);
		project.haxelib.addLib('heaps', '1.9.1');

	}

	public static function set(project: Project, ?second: Bool): Void {
		if (second) throw "Can't be second";
		setJs(project);
		project.build.hxml = 'js';
		project.build.appNode = 'js';
		project.build.flags.push(UNSAFE);
		project.uglify.appNode = 'js';
		project.haxelib.addLib('hldx', HLSDL_VERSION, true);
		project.haxelib.addLib('hlsdl', HLSDL_VERSION, true);
		project.download.addLib('hlwin');
		project.secondbuild.active = true;
		project.secondbuild.appNode = 'win';
		project.secondbuild.hxml = 'win';
		project.secondbuild.target = types.HaxeTargets.HL;
		project.secondbuild.addLib('hldx', HLSDL_VERSION);
		project.secondbuild.flags.push(UNSAFE);
		project.secondbuild.flags.push(WIN_HL_VERSION);
		project.secondbuild.flags.push('desktop');
		project.secondbuild.flags.push('win');
		project.thirdbuild.active = true;
		project.thirdbuild.appNode = 'mac';
		project.thirdbuild.hxml = 'mac';
		project.thirdbuild.target = types.HaxeTargets.HL;
		project.thirdbuild.addLib('hlsdl', HLSDL_VERSION);
		project.thirdbuild.flags.push(UNSAFE);
		project.thirdbuild.flags.push(HL_VERSION);
		project.secondbuild.flags.push('desktop');
		project.secondbuild.flags.push('mac');
		project.fourthbuild.active = true;
		project.fourthbuild.appNode = 'android';
		project.fourthbuild.hxml = 'android';
		project.fourthbuild.target = types.HaxeTargets.HLC;
		project.fourthbuild.outputPath += 'android/app/src/haxe/';
		project.fourthbuild.outputFile = 'main';
		project.fourthbuild.addLib('hlsdl', HLSDL_VERSION);
		project.fourthbuild.flags.push(UNSAFE);
		project.fourthbuild.flags.push(HL_VERSION);
		project.fourthbuild.flags.push('mobile');
		project.fourthbuild.flags.push('android');
		project.hashlink.active = true;
		project.hashlink.win = Download.LIBS['hlwin'].getFinal();
		project.hashlink.libs = project.download.path;
		project.hashlink.outputDir = project.secondbuild.outputPath;
		project.hashlink.outputFile = project.secondbuild.getOutputFile();
	}

}