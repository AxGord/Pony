import haxe.xml.Fast;
import sys.io.File;
/**
 * Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {
	
	static function main() {
		
		var PD = Sys.systemName() == 'Windows' ? '\\' : '/';
		var a = Sys.executablePath().split(PD);
		a.pop();
		var ponyPath = a.join(PD) + PD;
		
		var args = Sys.args();
		switch args.shift() {
			case null:
				Sys.println('Pony Command-Line Tools (0.0.1)');
			
			case 'watch':
				Sys.command('start', ['node', ponyPath + 'ponyWatch.js']);
				
			case 'prepare':
				Sys.command('node', [ponyPath + 'ponyPrepare.js']);
				
			case 'build':
				
				var xml = new Fast(Xml.parse(File.getContent('pony.xml'))).node.project;
				var debug = args.indexOf('debug') != -1;
				var app:String = null;
				for (a in args) if (a != 'debug') {
					app = a;
					break;
				}
				
				new Build(xml.node.build, app, debug);
				if (xml.hasNode.uglify) {
					Sys.println('Uglify');
					Sys.command('node', debug ? [ponyPath + 'ponyUglify.js', 'debug'] : [ponyPath + 'ponyUglify.js']);
				}
				
			case _:
				Sys.println('Unknown command');
				return;
		}
		
		Sys.println('Complete');
		
	}
	
}