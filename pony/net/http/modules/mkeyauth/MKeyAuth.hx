/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.net.http.modules.mkeyauth;

import pony.fs.Dir;
import pony.net.http.WebServer.EConnect;

/**
 * MKeyAuth
 * @author AxGord <axgord@gmail.com>
 */
@:final class MKeyAuth implements IModule {

	inline public static var PARAM:String = 'authkey';
	inline public static var SESSION:String = 'keyAuthed';
	
	private var keys:Array<String>;
	public var server:WebServer;
	
	public function new(keys:Array<String>) this.keys = keys;
	
	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
	}
	
	public function connect(cpq:CPQ):EConnect {
		if (cpq.connection.params.exists(PARAM)) {
			var key:String = cpq.connection.params.get(PARAM);
			if (key == null) {
				cpq.connection.sessionStorage[SESSION] = false;
				cpq.connection.params.remove(PARAM);
				cpq.connection.endAction();
			} else if (keys.indexOf(key) != -1) {
				cpq.connection.sessionStorage[SESSION] = true;
				cpq.connection.params.remove(PARAM);
				cpq.connection.endAction();
			} else {
				cpq.connection.error('Access error');
			}
			return BREAK;
		} else {
			return REG(cast new MKeyAuthConnect(this, cpq));
		}
	}
	
}