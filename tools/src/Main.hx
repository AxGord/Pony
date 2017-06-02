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
				new Prepare(Utils.getXml());
				runNode('ponyPrepare');
				
			case 'build':
				build(Utils.parseArgs(args), Utils.getXml());
				
			case 'zip':
				var cfg = Utils.parseArgs(args);
				var xml = Utils.getXml();
				build(cfg, xml);
				new Zip(xml.node.zip, cfg.app, cfg.debug);
				
			case 'ftp':
				var cfg = Utils.parseArgs(args);
				var xml = Utils.getXml();
				build(cfg, xml);
				runNode('ponyFtp', addCfg(cfg));
				
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
				
			case _:
				Utils.error('Unknown command');
		}
		
		Sys.println('Complete');
		
	}
	
	static function build(args:AppCfg, xml:Fast):Void {
		new Build(xml.node.build, args.app, args.debug);
		if (xml.hasNode.uglify)
			runNode('ponyUglify', addCfg(args));
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
		Sys.println('Run: '+name);
		var a = [ponyPath + name + '.js'];
		for (e in args) a.push(e);
		return Sys.command('node', a);
	}
	
}