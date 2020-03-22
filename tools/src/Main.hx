import pony.Fast;
import pony.Tools;
import module.Module;
import pony.time.MainLoop;

using pony.text.TextTools;

/**
 * Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {

	static var commands: Commands = new Commands();

	static function showLogo(): Void {
		Sys.println(Utils.ansiForeground(haxe.Resource.getString('logo'), AnsiForeground.LightGray));
		Sys.println('');
		Sys.println('Command-Line Tools');
		Sys.println(
			Utils.ansiForeground('Library version: ', AnsiForeground.LightGray) +
			Utils.ponyVersion + ' [' + Utils.getHaxelibVersion() + ']'
		);
		Sys.println(Utils.ansiForeground('Library path: ', AnsiForeground.LightGray) + Utils.libPath);
		Sys.println(Utils.ansiForeground('Build date: ', AnsiForeground.LightGray) + Tools.getBuildDate());
		Sys.println(Utils.ansiUnderlined('https://github.com/AxGord/Pony'));
		Sys.println(Utils.ansiUnderlined('http://lib.haxe.org/p/pony'));
		Sys.println('Type:' + Utils.ansiForeground('pony help', AnsiForeground.LightCyan).quote().quote(' ') + '- for help');
		Utils.exit();
	}

	static function showHelp(): Void {
		Sys.println('\n' + (Utils.isWindows ? commands.helpData.join('\n\n') : commands.helpAnsiData.join('\n\n')) + '\n');
		Utils.exit();
	}

	static function trySubProjects(args: Array<String>): Bool {
		if (args.indexOf('all') != -1) {
			runSubProjects(args);
			return true;
		} else {
			return false;
		}
	}

	static function tryOtherPath(args: Array<String>): Bool {
		var expath: String = new String(@:privateAccess Sys.sys_exe_path());
		var p: String = Utils.path(expath);
		p = p.substr(0, p.lastIndexOf(Utils.PD) + 1);
		if (p != Utils.toolsPath) {
			var pony: String = Utils.toolsPath + 'pony';
			if (Utils.isWindows) pony += '.exe';
			Utils.exit(Sys.command(pony, args));
			return true;
		} else {
			return false;
		}
	}

	static function main(): Void {
		var startTime: Float = Sys.time();
		var args: Array<String> = Sys.args();
		if (trySubProjects(args) || tryOtherPath(args)) return;

		commands.onError << Utils.error.bind(_, 1);
		commands.onLog << Sys.println;
		registerCommands();

		var modules: Modules = new Modules(commands);
		registerModules(modules);
		modules.init();

		Module.onEndQueue < MainLoop.stop;

		Module.lockQueue();
		commands.runArgs(setGroupsPerm(args, modules));
		Module.unlockQueue();

		if (Module.busy) {
			MainLoop.init();
			MainLoop.start();
		}

		Sys.println('Total time: ' + Std.int((Sys.time() - startTime) * 1000) / 1000);
	}

	static function registerCommands(): Void {
		commands.onNothing < showLogo;
		commands.onHelp < showHelp;
		commands.onCreate < create.Create.run;
		commands.onLines < Lines.run;
		commands.onChars < Chars.run;
		commands.onLicense < License.run;
		commands.onHaxelib < Haxelib.run;
		commands.onGenerate << Generate.run;
	}

	static function registerModules(modules: Modules): Void {
		modules.register(new module.Haxelib());
		modules.register(new module.Npm());
		modules.register(new module.Texturepacker());
		modules.register(new module.Build());
		modules.register(new module.Cordova());
		modules.register(new module.Electron());
		modules.register(new module.Uglify());
		modules.register(new module.Wrapper());
		modules.register(new module.Test());
		modules.register(new module.Clean());
		modules.register(new module.Unpack());
		modules.register(new module.Server());
		modules.register(new module.Remote());
		modules.register(new module.Hash());
		modules.register(new module.Zip());
		modules.register(new module.Bmfont());
		modules.register(new module.Imagemin());
		modules.register(new module.Poeditor());
		modules.register(new module.Ftp());
		modules.register(new module.Download());
		modules.register(new module.Copy());
		modules.register(new module.Move());
		modules.register(new module.Url());
		modules.register(new module.Run());
	}

	static function setGroupsPerm(args: Array<String>, modules: Modules): Array<String> {
		var nArgs: Array<String> = [];
		var deny: Array<String> = [];
		var allow: Array<String> = [];
		for (a in args) switch a.charAt(0) {
			case '-': deny.push(a.substr(1));
			case '+': allow.push(a.substr(1));
			case _: nArgs.push(a);
		}
		modules.deny = deny;
		modules.allow = allow;
		return nArgs;
	}

	static function addCfg(?a: Array<String>, args: AppCfg): Array<String> {
		if (a == null) a = [];
		if (args.app != null) a.push(args.app);
		if (args.debug) a.push('debug');
		return a;
	}

	static function runSubProjects(args: Array<String>): Void {
		var xml: Fast = Utils.getXml();
		if (xml == null) {
			Utils.error(Utils.MAIN_FILE + ' not exists');
		} else {
			var startTime = Sys.time();
			var apps: Array<String> = searchApps(xml.node.build);
			var uapps: Array<String> = [];
			for (app in apps) if (uapps.indexOf(app) == -1) uapps.push(app);
			var argsBefore: Array<String> = [];
			var argsAfter: Array<String> = [];
			var arg: String = null;
			while (args.length > 0) {
				arg = args.shift();
				if (arg == 'all')
					break;
				argsBefore.push(arg);
			}
			while (args.length > 0) {
				arg = args.shift();
				argsAfter.push(arg);
			}
			for (app in uapps) Utils.command('pony', argsBefore.concat([app]).concat(argsAfter));
			Sys.println('All total time: ' + Std.int((Sys.time() - startTime) * 1000) / 1000);
		}
	}

	static function searchApps(x: Fast): Array<String> {
		var apps: Array<String> = [];
		if (x.hasNode.apps) {
			for (node in x.node.apps.elements) apps.push(node.name);
		} else {
			for (node in x.elements) apps = apps.concat(searchApps(node));
		}
		return apps;
	}

}