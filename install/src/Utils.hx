import sys.io.Process;

/**
 * Utils
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety @:final class Utils {

	public static var nodeExists(get, never): Bool;
	public static var codeExists(get, never): Bool;
	public static var codeInsidersExists(get, never): Bool;
	public static var npmPath(get, never): String;
	public static var homePath(get, never): String;
	public static var homeNpm(get, never): String;
	public static var userId(get, never): Int;
	public static var isSuper(get, never): Bool;

	private static var _nodeExists: Null<Bool>;
	private static var _codeExists: Null<Bool>;
	private static var _codeInsidersExists: Null<Bool>;
	private static var _npmPath: Null<String>;
	private static var _homePath: Null<String>;
	private static var _homeNpm: Null<String>;
	private static var _userId: Null<Int>;

	private static function get_nodeExists(): Bool {
		if (_nodeExists == null) _nodeExists = cmdExists('node') && cmdExists('npm');
		return _nodeExists;
	}

	private static function get_codeExists(): Bool {
		if (_codeExists == null) _codeExists = cmdExists('code');
		return _codeExists;
	}

	private static function get_codeInsidersExists(): Bool {
		if (_codeInsidersExists == null) _codeInsidersExists = cmdExists('code-insiders');
		return _codeInsidersExists;
	}

	private static function get_npmPath(): String {
		if (_npmPath == null) _npmPath = processLine('npm', ['prefix', '-g']) + '/lib/node_modules';
		return _npmPath;
	}

	private static function get_homePath(): String {
		if (_homePath == null) _homePath = Sys.getEnv('HOME');
		return _homePath;
	}

	private static function get_homeNpm(): String {
		if (_homeNpm == null) _homeNpm = homePath + '/.npm';
		return _homeNpm;
	}

	private static function get_userId(): Int {
		if (_userId == null) _userId = processInt('id', ['-u']);
		return _userId;
	}

	private static inline function get_isSuper(): Bool return _userId == 0;

	private static inline function processLine(process: String, args: Array<String>): String {
		return new Process(process, args).stdout.readLine();
	}

	private static inline function processInt(process: String, args: Array<String>): Int {
		return try {
			Std.parseInt(processLine(process, args));
		} catch (err: Dynamic) {
			-1;
		}
	}

	public static inline function cmdExists(c: String): Bool return cmdExistsa(c, ['-v']);

	public static function cmdExistsa(c: String, a: Array<String>): Bool {
		beginColor(90);
		Sys.print(c + ' ');
		var r: Bool = Sys.command(c, a) == 0;
		endColor();
		return r;
	}

	public static inline function beginColor(c: Int): Void if (Config.OS != Windows) Sys.print('\x1b[${c}m');

	public static inline function endColor(): Void beginColor(0);

	public static inline function md(dir: String): Int {
		try {
			@:nullSafety(Off) return isSuper ? new Process('mkdir', [dir]).exitCode() : new Process('sudo', ['mkdir', dir]).exitCode();
		} catch (err: Dynamic) {
			return -1;
		}
	}

	public static inline function getPerm(dir: String): Int {
		return processInt('sudo', Config.OS == TargetOS.Mac ? ['stat', '-f', '%A', dir] : ['stat', '-c', '%a', dir]);
	}

	public static function setPerm(dir: String, v: Int, r: Bool = false): Void {
		beginColor(90);
		Sys.println('Set perm $v for $dir');
		var a: Array<String> = ['chmod'];
		if (r) a.push('-R');
		a.push(Std.string(v));
		a.push(dir);
		Sys.command('sudo', a);
		endColor();
	}

	public static function exit(errCode:Int = 0): Void {
		#if neko
		if (Config.OS == Linux) Sys.sleep(0.3); // finish print messages
		#end
		Sys.exit(errCode);
	}

}