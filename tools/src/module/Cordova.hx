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
package module;

import sys.FileSystem;

/**
 * Cordova module
 * @author AxGord <axgord@gmail.com>
 */
class Cordova extends Module {

	public function new() super('cordova');

	override public function init():Void {
		modules.commands.onCordova << run;
		modules.commands.onAndroid.add(cordovaHandler, -300);
		modules.commands.onAndroid.add(androidHandler, -200);
		modules.commands.onIphone.add(iphoneHandler, -200);
	}

	private function androidHandler():Void modules.build.addFlag('android');
	private function iphoneHandler():Void modules.build.addFlag('iphone');
	private function cordovaHandler():Void modules.build.addHaxelib('cordova');

	private function run(a:String, b:String):Void {
		addToRun(function(){
			if (!FileSystem.exists('config.xml')) {
				error('Cordova not inited');
				Sys.exit(1);
			}
			// var cfg:AppCfg = Utils.parseArgs([a, b]);

			// var cwd = new Cwd(PATH);
			// cwd.sw();
			// Utils.command('cordova', ['emulate']);
			// cwd.sw();

			finishCurrentRun();
		});
	}

}