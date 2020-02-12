import sys.io.Process;

/**
 * Utils
 * @author AxGord <axgord@gmail.com>
 */
class Utils {

	public static var nodeExists(get, never): Bool;
	public static var codeExists(get, never): Bool;
	public static var codeInsidersExists(get, never): Bool;
	public static var npmPath(get, never): String;
	public static var homePath(get, never): String;
	public static var homeNpm(get, never): String;

	private static var _nodeExists: Null<Bool>;
	private static var _codeExists: Null<Bool>;
	private static var _codeInsidersExists: Null<Bool>;
	private static var _npmPath: String;
	private static var _homePath: String;
	private static var _homeNpm: String;

	private static function get_nodeExists(): Bool {
		if (_nodeExists == null)
			_nodeExists = cmdExists('node') && cmdExists('npm');
		return _nodeExists;
	}

	private static function get_codeExists(): Bool {
		if (_codeExists == null)
			_codeExists = cmdExists('code');
		return _codeExists;
	}

	private static function get_codeInsidersExists(): Bool {
		if (_codeInsidersExists == null)
			_codeInsidersExists = cmdExists('code-insiders');
		return _codeInsidersExists;
	}

	private static function get_npmPath(): String {
		if (_npmPath == null)
			_npmPath = new Process('npm', ['prefix', '-g']).stdout.readLine() + '/lib/node_modules';
		return _npmPath;
	}

	private static function get_homePath(): String {
		if (_homePath == null)
			_homePath = Sys.getEnv('HOME');
		return _homePath;
	}

	private static function get_homeNpm(): String {
		if (_homeNpm == null)
			_homeNpm = homePath + '/.npm';
		return _homeNpm;
	}

	public static inline function cmdExists(c: String): Bool return cmdExistsa(c, ['-v']);

	public static function cmdExistsa(c: String, a: Array<String>): Bool {
		beginColor(90);
		Sys.print(c + ' ');
		var r: Bool = Sys.command(c, a) == 0;
		endColor();
		return r;
	}

	public static inline function beginColor(c: Int): Void
		if (Config.OS != Windows)
			Sys.print('\x1b[${c}m');

	public static inline function endColor(): Void beginColor(0);

	public static inline function md(dir: String): Int return new Process('sudo', ['mkdir', dir]).exitCode();

	public static function getPerm(dir: String): Int {
		return if (Config.OS == TargetOS.Mac)
			Std.parseInt(new Process('sudo', ['stat', '-f', '%A', dir]).stdout.readLine());
		else
			Std.parseInt(new Process('sudo', ['stat', '-c', '%a', dir]).stdout.readLine());
	}

	public static function setPerm(dir: String, v: Int, r: Bool = false): Void {
		beginColor(90);
		Sys.println('Set perm $v for $dir');
		var a = ['chmod'];
		if (r)
			a.push('-R');
		a.push(Std.string(v));
		a.push(dir);
		Sys.command('sudo', a);
		endColor();
	}

}