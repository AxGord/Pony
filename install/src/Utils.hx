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
import sys.io.Process;

/**
 * Utils
 * @author AxGord <axgord@gmail.com>
 */
class Utils {

	public static var nodeExists(get, never):Bool;
	public static var codeExists(get, never):Bool;

	private static var _nodeExists:Null<Bool>;
	private static var _codeExists:Null<Bool>;

	private static function get_nodeExists():Bool {
		if (_nodeExists == null)
			_nodeExists = cmdExists('node') && cmdExists('npm');
		return _nodeExists;
	}

	private static function get_codeExists():Bool {
		if (_codeExists == null)
			_codeExists = cmdExists('code');
		return _codeExists;
	}

	public static inline function cmdExists(c:String):Bool return cmdExistsa(c, ['-v']);
	public static inline function cmdExistsa(c:String, a:Array<String>):Bool return new Process(c, a).exitCode() == 0;

}