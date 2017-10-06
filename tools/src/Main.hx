import haxe.xml.Fast;
import sys.FileSystem;
import sys.io.File;

/**
 * Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {
	
	static var ponyPath:String;
	
	static function main() {
		
		var startTime = Sys.time();
		
		var PD = Sys.systemName() == 'Windows' ? '\\' : '/';
		var a = Sys.executablePath().split(PD);
		a.pop();
		ponyPath = a.join(PD) + PD;
		
		var args = Sys.args();
		switch args.shift() {
			case null:
				Sys.println(haxe.Resource.getString('logo'));
				Sys.println('');
				Sys.println('Command-Line Tools');
				Sys.exit(0);
			case 'watch':
				runNode('ponyWatch');
				
			case 'prepare':
				var cfg = Utils.parseArgs(args);
				new Prepare(Utils.getXml(), cfg.app, cfg.debug);
				runNode('ponyPrepare');
				
			case 'build':
				build(Utils.parseArgs(args), Utils.getXml());
				
			case 'zip':
				var cfg = Utils.parseArgs(args);
				var xml = Utils.getXml();
				build(cfg, xml);
				var startTime = Sys.time();
				new Zip(xml.node.zip, cfg.app, cfg.debug);
				Sys.println('Zip time: ' + Std.int((Sys.time() - startTime) * 1000)/1000);
				
			case 'ftp':
				var cfg = Utils.parseArgs(args);
				var xml = Utils.getXml();
				build(cfg, xml);
				var startTime = Sys.time();
				runNode('ponyFtp', addCfg(cfg));
				Sys.println('Ftp time: ' + Std.int((Sys.time() - startTime) * 1000)/1000);
				
			case 'create':
				if (FileSystem.exists(Utils.MAIN_FILE)) Utils.error(Utils.MAIN_FILE + ' exists');
				
				var content = Xml.createDocument();
				var root = Xml.createElement('project');
				var name = args[0];
				if (name != null) root.set('name', name);
				root.addChild(Xml.createComment('Put configuration here'));
				content.addChild(root);
				var r = '<?xml version="1.0" encoding="utf-8" ?>\n';
				r += haxe.xml.Printer.print(content, true);
				File.saveContent(Utils.MAIN_FILE, r);
				
			case 'server':
				var xml = Utils.getXml();
				if (xml.hasNode.server && xml.node.server.hasNode.haxe) {
					var cfg = Utils.parseArgs(args);
					new Build(xml, cfg.app, cfg.debug).writeConfigIfNeed();
				}
				runNode('ponyServer');

			case _:
				Utils.error('Unknown command');
		}
		
		Sys.println('Total time: ' + Std.int((Sys.time() - startTime) * 1000)/1000);
		
	}
	
	static function build(args:AppCfg, xml:Fast):Void {
		var startTime = Sys.time();
		new Build(xml, args.app, args.debug).run();
		Sys.println('Compile time: ' + Std.int((Sys.time() - startTime) * 1000)/1000);
		if (xml.hasNode.uglify) {
			var startTime = Sys.time();
			runNode('ponyUglify', addCfg(args));
			Sys.println('Uglify time: ' + Std.int((Sys.time() - startTime) * 1000)/1000);
		}
		if (xml.hasNode.wrapper) {
			new Wrapper(xml.node.wrapper, args.app, args.debug);
		}
	}
	
	static function addCfg(?a:Array<String>, args:AppCfg):Array<String> {
		if (a == null) a = [];
		if (args.app != null) a.push(args.app);
		if (args.debug) a.push('debug');
		return a;
	}
	
	static function runNode(name:String, ?args:Array<String>):Int {
		if (args == null) args = [];
		Sys.println('Run: $name.js');
		var a = [ponyPath + name + '.js'];
		for (e in args) a.push(e);
		return Sys.command('node', a);
	}
	
}