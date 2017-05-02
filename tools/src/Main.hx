import haxe.xml.Fast;
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
				Sys.println('Pony Command-Line Tools (0.0.1)');
			
			case 'watch':
				Sys.command('start', ['node', ponyPath + 'ponyWatch.js']);
				
			case 'prepare':
				new Prepare(getXml());
				Sys.command('node', [ponyPath + 'ponyPrepare.js']);
				
			case 'build':
				build(parseArgs(args), getXml());
				
			case 'zip':
				var cfg = parseArgs(args);
				var xml = getXml();
				build(cfg, xml);
				new Zip(xml.node.zip, cfg.app, cfg.debug);
				
			case _:
				Sys.println('Unknown command');
				return;
		}
		
		Sys.println('Complete');
		
	}
	
	static function getXml():Fast return new Fast(Xml.parse(File.getContent('pony.xml'))).node.project;
	
	static function parseArgs(args:Array<String>):AppCfg {
		var debug = args.indexOf('debug') != -1;
		var app:String = null;
		for (a in args) if (a != 'debug' && a != 'release') {
			app = a;
			break;
		}
		return {app: app, debug:debug};
	}
	
	static function build(args:AppCfg, xml:Fast):Void {
		new Build(xml.node.build, args.app, args.debug);
		if (xml.hasNode.uglify) {
			Sys.println('Uglify');
			Sys.command('node', args.debug ? [ponyPath + 'ponyUglify.js', 'debug'] : [ponyPath + 'ponyUglify.js']);
		}
	}
	
}