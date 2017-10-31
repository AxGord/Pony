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
package pony.net.http.modules.mfb;

import pony.fs.Dir;
import pony.net.http.IModule;
import pony.net.http.sn.FB;
import pony.net.http.CPQ;
import pony.net.http.WebServer.EConnect;
import pony.text.TextTools;
import pony.text.tpl.ITplPut;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplPut;

/**
 * MFB
 * @author AxGord
 */
@:final class MFB implements IModule
{
	public var fb:FB;
	
	public var appid:String;
	public var server:WebServer;
	public var buttonData:String;
	
	public function new(appid:String, secret:String = '', phpsdk:String = "facebook-php-sdk-v4/autoload.php") {
		#if php
			fb = new FB(appid, secret, phpsdk);
		#else
			fb = new FB(appid, secret);
		#end
		this.appid = appid;
		var s = TextTools.includeFileFromCurrentDir('mfb.tpl');
		new Tpl(MFBPrePut, appid, s).gen(null, null, function(r) buttonData = r);
	}
	
	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
	}
	
	public function connect(cpq:CPQ):EConnect {
		if (cpq.connection.params.exists('fbauth')) {
			cpq.connection.sessionStorage.set('fb_token', cpq.connection.params['fbauth']);
			cpq.connection.params.remove('fbauth');
			cpq.connection.endAction();
			return BREAK;
		} else {
			return REG(cast new MFBConnect(this, cpq));
		}
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MFBPrePut extends TplPut<String,{}> {
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		switch (name) {
			case 'appid':
				return a;
			case _:
				return @await super.shortTag(name, arg, kid);
		}
	}
}