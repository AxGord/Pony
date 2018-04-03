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
 * Config
 * @author AxGord <axgord@gmail.com>
 */
class Config {
	
	public static var settings(default, null):Settings;

	public static var ENVKEY:String;
	public static var OS:TargetOS;
	public static var PD:String;
	public static var SRC:String;
	public static var BIN:String;
	public static var ARGS:Array<String>;
	public static var INSTALL:Bool;

	public static function init():Void {
		settings = haxe.Json.parse(haxe.Resource.getString('settings.json'));
		ENVKEY = settings.envkey;

		OS = TargetOS.createByName(Sys.systemName());
		PD = OS == Windows ? '\\' : '/';
		SRC = Sys.getCwd() + 'tools';
		SRC = StringTools.replace(SRC, '/', PD);
		BIN = SRC + PD + 'bin' + PD;
		ARGS = Sys.args();
		INSTALL = ARGS[0] == 'install';
		if (INSTALL) ARGS.shift();
	}

	public static function questionState(name:String):InstallQuestion {
		if (!INSTALL)
			return InstallQuestion.Say;
		if (ARGS.indexOf('-' + name) != -1)
			return InstallQuestion.No;
		if (ARGS.indexOf('+' + name) != -1)
			return InstallQuestion.Yes;
		return InstallQuestion.Say;
	}

}