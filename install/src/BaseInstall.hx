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

/**
 * BaseInstall
 * @author AxGord <axgord@gmail.com>
 */
class BaseInstall {

	private static var YCODE:Int = 'y'.charCodeAt(0);
	private static var NCODE:Int = 'n'.charCodeAt(0);

	private var n:String;
	private var hard:Bool;

	public function new(n:String, ?qn:String, q:Bool, hard:Bool) {
		this.n = n;
		this.hard = hard;
		if (qn == null) qn = n;
		if (q) {
			switch Config.questionState(qn) {
				case InstallQuestion.No: return;
				case InstallQuestion.Yes: q = false;
				case InstallQuestion.Say: q = true;
			}
		}
		if (!q || question()) {
			log('');
			log('Install $n');
			run();
			log('Complete install $n');
		}
	}

	private function run():Void {}

	private inline function question():Bool {
		var r:Int = null;
		do {
			log('');
			log('Do you want install $n? (y/n)');
			r = Sys.getChar(true);
			log('');
		} while (r != YCODE && r != NCODE);
		return r == YCODE;
	}

	private function listInstall(c:String, a:Array<String>, l:Array<String>):Void {
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

	private inline function log(s:String):Void Sys.println(s);

	private inline function graylog(s:String):Void {
		Utils.beginColor(90);
		Sys.println(s);
		Utils.endColor();
	}

	private inline function cmd(c:String, a:Array<String>):Void hard ? hardCmd(c, a) : softCmd(c, a);

	private inline function softCmd(c:String, a:Array<String>):Void {
		log([c].concat(a).join(' '));
		Sys.command(c, a);
	}

	private inline function hardCmd(c:String, a:Array<String>):Void {
		log([c].concat(a).join(' '));
		var r = Sys.command(c, a);
		if (r != 0) Sys.exit(r);
	}

	private inline function makedir(path:String):Void {
		softCmd('sudo', ['mkdir', '-m', '777', '-p', path]);
	}

}