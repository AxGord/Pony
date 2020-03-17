/**
 * BaseInstall
 * @author AxGord <axgord@gmail.com>
 */
class BaseInstall {

	private inline static var YCODE: Int = 'y'.code;
	private inline static var NCODE: Int = 'n'.code;
	private inline static var ACODE: Int = 'a'.code;
	private inline static var QCODE: Int = 'q'.code;

	private static var allEnabled: Bool = false;

	private var n: String;
	private var hard: Bool;

	public function new(n: String, ?qn: String, q: Bool, hard: Bool) {
		this.n = n;
		this.hard = hard;
		if (qn == null) qn = n;
		if (q) switch Config.questionState(qn) {
			case InstallQuestion.No: return;
			case InstallQuestion.Yes: q = false;
			case InstallQuestion.Say: q = true;
		}
		if (!q || question()) {
			log('');
			log('Install $n');
			run();
			log('Complete install $n');
		}
	}

	private function run(): Void {}

	private function question(): Bool {
		if (allEnabled) return true;
		var r: Int = null;
		do {
			log('');
			log('Do you want install $n? (y/n/a/q)');
			r = Sys.getChar(true);
			log('');
			switch r {
				case YCODE:
					return true;
				case NCODE:
					return false;
				case ACODE:
					allEnabled = true;
					return true;
				case QCODE:
					Utils.exit(0);
					return false;
			}
		} while (true);
		return false;
	}

	private function listInstall(c: String, a: Array<String>, l: Array<String>): Void {
		for (e in l) {
			if (e.charAt(0) == '!') {
				if (Config.OS == TargetOS.Windows)
					cmd(c, a.concat(e.substr(1).split(' ')));
				else
					cmd('sudo', [c].concat(a.concat(e.substr(1).split(' '))));
			} else {
				cmd(c, a.concat(e.split(' ')));
			}
		}
	}

	private inline function log(s: String): Void Sys.println(s);

	private inline function graylog(s: String): Void {
		Utils.beginColor(90);
		Sys.println(s);
		Utils.endColor();
	}

	private inline function cmd(c: String, a: Array<String>): Void hard ? hardCmd(c, a) : softCmd(c, a);

	private inline function softCmd(c: String, a: Array<String>): Void {
		log([c].concat(a).join(' '));
		Sys.command(c, a);
	}

	private inline function hardCmd(c: String, a: Array<String>): Void {
		log([c].concat(a).join(' '));
		var r: Int = Sys.command(c, a);
		if (r != 0) Utils.exit(r);
	}

	private inline function makedir(path: String): Void softCmd('sudo', ['mkdir', '-m', '777', '-p', path]);

}