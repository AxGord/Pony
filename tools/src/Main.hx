/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pony.Tools;
import module.Module;
import pony.time.MainLoop;

using pony.text.TextTools;

/**
 * Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {
	
	static var commands:Commands = new Commands();

	static function showLogo():Void {
		Sys.println(Utils.ansiForeground(haxe.Resource.getString('logo'), AnsiForeground.LightGray));
		Sys.println('');
		Sys.println('Command-Line Tools');
		Sys.println(Utils.ansiForeground('Library version: ', AnsiForeground.LightGray) + Utils.ponyVersion + ' [' + Utils.getHaxelibVersion() + ']');
		Sys.println(Utils.ansiForeground('Library path: ', AnsiForeground.LightGray) + Utils.libPath);
		Sys.println(Utils.ansiForeground('Build date: ', AnsiForeground.LightGray) + Tools.getBuildDate());
		Sys.println(Utils.ansiUnderlined('https://github.com/AxGord/Pony'));
		Sys.println(Utils.ansiUnderlined('http://lib.haxe.org/p/pony'));
		Sys.println('Type:' + Utils.ansiForeground('pony help', AnsiForeground.LightCyan).quote().quote(' ') + '- for help');
		Sys.exit(0);
	}

	static function showHelp():Void {
		Sys.println('\n' + (Utils.isWindows ? commands.helpData.join('\n\n') : commands.helpAnsiData.join('\n\n')) + '\n');
		Sys.exit(0);
	}

	static function ftp(cfg:AppCfg):Void {
		var startTime = Sys.time();
		Utils.runNode('ponyFtp', addCfg(cfg));
		Sys.println('Ftp time: ' + Std.int((Sys.time() - startTime) * 1000) / 1000);
	}

	static function cfgAndCall(a:String, b:String, f:AppCfg -> Void):Void {
		f(Utils.parseArgs([a, b]));
	}

	static function main():Void {
		MainLoop.init();
		var p = Utils.path(Sys.executablePath());
		p = p.substr(0, p.lastIndexOf(Utils.PD) + 1);
		if (p != Utils.toolsPath) {
			var pony = Utils.toolsPath + 'pony';
			if (Utils.isWindows) pony += '.exe';
			Sys.exit(Sys.command(pony, Sys.args()));
			return;
		}
		
		var startTime = Sys.time();

		commands.onError << Utils.error.bind(_, 1);
		commands.onLog << Sys.println;

		var modules:Modules = new Modules(commands);
		modules.register(new module.Haxelib());
		modules.register(new module.Npm());
		modules.register(new module.Texturepacker());
		modules.register(new module.Build());
		modules.register(new module.Cordova());
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
		modules.register(new module.Download());
		modules.register(new module.Copy());
		modules.register(new module.Url());
		modules.register(new module.Run());
		modules.init();

		commands.onNothing < showLogo;
		commands.onHelp < showHelp;
		commands.onFtp < cfgAndCall.bind(_, _, ftp);

		commands.onCreate < create.Create.run;
		commands.onLines < Lines.run;
		commands.onChars < Chars.run;
		commands.onLicense < License.run;
		commands.onHaxelib < Haxelib.run;
		Module.onEndQueue < MainLoop.stop;

		Module.lockQueue();
		commands.runArgs(grabFlags(Sys.args()));
		Module.unlockQueue();
		
		if (Module.busy) MainLoop.start();

		Sys.println('Total time: ' + Std.int((Sys.time() - startTime) * 1000) / 1000);
	}
	
	static function addCfg(?a:Array<String>, args:AppCfg):Array<String> {
		if (a == null) a = [];
		if (args.app != null) a.push(args.app);
		if (args.debug) a.push('debug');
		return a;
	}

	static function grabFlags(args:Array<String>):Array<String> {
		var na:Array<String> = [];
		for (a in args) {
			if (a.charAt(0) == '-')
				Flags.set(a.substr(1));
			else
				na.push(a);
		}
		return na;
	}
	
}