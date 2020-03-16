/**
 * Config
 * @author AxGord <axgord@gmail.com>
 */
class Config {

	public static var settings(default, null): Settings;

	public static var ENVKEY: String;
	public static var OS: TargetOS;
	public static var PD: String;
	public static var SRC: String;
	public static var BIN: String;
	public static var ARGS: Array<String>;
	public static var INSTALL: Bool;

	public static function init(): Void {
		settings = haxe.Json.parse(haxe.Resource.getString('settings.json'));
		ENVKEY = settings.envkey;
		OS = TargetOS.createByName(Sys.systemName());
		PD = OS == Windows ? '\\' : '/';
		SRC = Sys.getCwd() + 'tools';
		SRC = StringTools.replace(SRC, '/', PD);
		BIN = SRC + PD + 'bin' + PD;
		ARGS = Sys.args();
		INSTALL = ARGS[0] == 'install';
		if (INSTALL) ARGS.shift();
	}

	public static function questionState(name: String): InstallQuestion {
		return if (!INSTALL) InstallQuestion.Say;
		else if (ARGS.indexOf('-' + name) != -1) InstallQuestion.No;
		else if (ARGS.indexOf('+' + name) != -1) InstallQuestion.Yes;
		else InstallQuestion.Say;
	}

}