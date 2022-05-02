package create.targets;

import sys.FileSystem;

/**
 * Swf
 * @author AxGord <axgord@gmail.com>
 */
class Swf {

	public static var APP_XML: String = 'air-app.xml';

	public static function swf(project: Project): Void {
		project.build.target = types.HaxeTargets.Swf;
		project.server.active = true;
		project.server.haxe = true;
		share(project);
	}

	public static function adt(project: Project, cert: String): Void {
		swf(project);
		project.run.active = true;
		project.run.command = 'adt -package -storetype pkcs12 -keystore $cert -storepass  -target bundle app $APP_XML ' +
			project.build.getOutputFile();
	}

	public static function swc(project: Project): Void {
		project.build.target = types.HaxeTargets.Swc;
		project.build.args['i'] = 'mylib';
		project.build.args['m'] = "keep('mylib')";
		project.build.cps = [];
		project.build.main = null;
		project.build.hxml = 'swc';
		project.build.outputFile = 'lib';
		share(project);
	}

	private static function share(project: Project): Void {
		project.haxelib.active = true;
		project.haxelib.addLib({name: 'pony', version: Utils.ponyHaxelibVersion});
		project.build.active = true;
		project.build.flags.push('fdb');
		project.build.flags.push('swf-compress-level=9');
		project.build.args['swf-version'] = '33'; // (33 == 44)
	}

}