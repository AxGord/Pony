/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.http.modules.mfb;
import pony.fs.Dir;
import pony.net.http.IModule;
import pony.net.http.ModuleConnect;
import pony.net.http.sn.FB;
import pony.net.http.sn.FBData;
import pony.net.http.WebServer.CPQ;
import pony.text.TextTools;
import pony.text.tpl.ITplPut;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;


/**
 * MFB
 * @author AxGord
 */
class MFB implements IModule
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
		new Tpl(MFBPrePut, this, s).gen(appid, null, function(r) buttonData = r);
	}
	
	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
	}
	
	public function connect(cpq:CPQ):Bool {
		if (cpq.connection.params.exists('fbauth')) {
			cpq.connection.sessionStorage.set('fb_token', cpq.connection.params['fbauth']);
			cpq.connection.params.remove('fbauth');
			cpq.connection.endAction();
			return true;
		} else {
			cpq.data['MFB'] = new MFBConnect(this, cpq);
			return false;
		}
	}
	
	inline public function tpl(cpq:CPQ, parent:ITplPut):ITplPut {
		return cpq.data['MFB'].tpl(parent);
	}
	
	
}

class MFBConnect extends ModuleConnect<MFB>
{

	public var token(get, set):String;
	
	private var data:FBData;
	
	inline public function tpl(parent:ITplPut):ITplPut
		return new MFBPut(this, null, parent);
	
	inline private function get_token():String
		return cpq.connection.sessionStorage['fb_token'];
	
	inline private function set_token(t:String):String
		return cpq.connection.sessionStorage['fb_token'] = t;
	
	public function getBaseData(cb:FBData->Void):Void {
		if (data != null) {
			cb(data);
		} else {
			if (token == null) {
				cb(null);
			} else
				base.fb.me(token, function(d:FBData) {
					if (d == null) {
						token = null;
						cpq.connection.endAction();
						return;
					} else
						cb(data = d);
				});
		}
	}
	
	public function getId(cb:String->Void):Void
		getBaseData(function(d) cb(d == null?'0':d.id));
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class MFBPrePut extends TplPut<MFB, String> {
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		switch (name) {
			case 'appid':
				return datad;
			case _:
				return @await super.shortTag(name, arg, kid);
		}
	}
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class MFBPut extends TplPut<MFBConnect, {}> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'facebook') {
			if (content == null) {
				return Std.string(data.token);
			} else {
				return @await sub(data, null, MFBPutSub, content);
			}
		} else {
			return @await super.tag(name, content, arg, args, kid);
		}
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class MFBPutSub extends TplPut<MFBConnect, {}> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'ready') {
			var token = data.token;
			if (args.exists('!')) {
				if (token == null) {
					return @await sub(data, null, MFBPutSub, content);
				} else {
					return '';
				}
			} else {
				if (token == null) {
					return '';
				} else {
					return @await sub(data, null, MFBPutSub, content);	
				}
			}
			
		} else {
			return @await super.tag(name, content, arg, args, kid);
		}
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		return switch (name) {
			case 'token': Std.string(data.token);
			case 'button': data.token != null ? '' : data.base.buttonData;
			case 'appid': data.base.appid;
			case 'id': @await data.getId();
			default: @await super.shortTag(name, arg, kid);
		}
	}
}