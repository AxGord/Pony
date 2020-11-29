package create.targets;

/**
 * Swf
 * @author AxGord <axgord@gmail.com>
 */
class Swf {

	public static var APP_XML: String = 'air-app.xml';

	public static function set(project: Project, cert: String): Void {
		project.server.active = true;
		project.server.haxe = true;
		project.haxelib.active = true;
		project.haxelib.addLib('pony', Utils.ponyHaxelibVersion);
		project.build.active = true;
		project.build.target = types.HaxeTargets.Swf;
		project.build.fdb = true;
		project.run.active = true;
		project.run.command = 'adt -package -storetype pkcs12 -keystore $cert -storepass  -target bundle app $APP_XML ' +
			project.build.getOutputFile();
	}

}