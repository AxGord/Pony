/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
import haxe.xml.Fast;
import sys.FileSystem;
import sys.io.File;

/**
 * Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {
	
	static function main() {
		
		var startTime = Sys.time();
		
		var args = Sys.args();
		switch args.shift() {
			case null:
				Sys.println(haxe.Resource.getString('logo'));
				Sys.println('');
				Sys.println('Command-Line Tools');
				Sys.println('Library version ' + Utils.ponyVersion);
				Sys.println('https://github.com/AxGord/Pony');
				Sys.println('http://lib.haxe.org/p/pony');
				Sys.println('pony help - for help');
				Sys.exit(0);

			case 'help':
				Sys.println('Visit https://github.com/AxGord/Pony/wiki/Pony-Tools for more info');
				Sys.exit(0);		

			case 'watch':
				runNode('ponyWatch');
				
			case 'prepare':
				var cfg = Utils.parseArgs(args);

				var xml = Utils.getXml();
				new Prepare(xml, cfg.app, cfg.debug);

				if (xml.hasNode.poeditor)
					Utils.command('npm', ['install', 'git+https://github.com/janjakubnanista/poeditor-client.git']);

				runNode('ponyPrepare');
				
			case 'build':
				build(Utils.parseArgs(args), Utils.getXml());

			case 'run':
				var xml = Utils.getXml();
				build(Utils.parseArgs(args), xml);
				if (!xml.hasNode.run)
					Utils.error('Not exists run section');					
				var r = xml.node.run;
				if (r.has.path)
					Sys.setCwd(r.att.path);
				var args = r.innerData.split(' ');
				var cmd = args.shift();
				Utils.command(cmd, args);
				
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
				create.Create.run(args);
				
			case 'server':
				runNode('ponyServer');

			case 'haxelib':
				Haxelib.run(args);

			case 'lines':
				Lines.run(args);

			case 'license':
				License.run(args);

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
		var a = [Utils.toolsPath + name + '.js'];
		for (e in args) a.push(e);
		return Sys.command('node', a);
	}
	
}