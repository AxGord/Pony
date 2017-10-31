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
package pony.net.http.sn.php;
import pony.net.http.sn.FBData;

/**
 * FB
 * @author AxGord
 */
class FB implements IFB
{

	public function new(appid:String, secret:String = '', sdk:String = "facebook-php-sdk-v4/autoload.php") 
	{
		var f = Sys.executablePath();
		f = sys.FileSystem.fullPath(f).split('\\').slice(0, -1).join('/') + '/';
		untyped __call__("require_once", f + sdk);
		untyped __call__("\\Facebook\\FacebookSession::setDefaultApplication", appid, secret);
	}
	
	inline public function api(token:String, r:String, cb:Dynamic->Void):Void {
		if (token == null) {
			cb(null);
			return;
		}
		var graphObject = null;
		try {
			var session = untyped __call__("new \\Facebook\\FacebookSession", token);
			var request = untyped __call__("new \\Facebook\\FacebookRequest", session, 'GET', r);
			var response = request.execute();
			graphObject = response.getGraphObject();
		} catch (_:Dynamic) {}
		cb(graphObject);
	}
	
	public function me(token:String, cb:FBData->Void):Void {
		api(token, '/me', function(res) {
			if(res == null || res.error != null) {
				cb(null);
			} else {
				cb({
					id: res.getProperty('id'),
					email: res.getProperty('email'),
					first_name: res.getProperty('first_name'),
					isMale: res.getProperty('gender') == 'male',
					last_name: res.getProperty('last_name'),
					name: res.getProperty('name'),
					link: res.getProperty('link'),
					locale: res.getProperty('locale'),
					timezone: Std.parseInt(res.getProperty('timezone')),
					updated_time: res.getProperty('updated_time'),
					verified: res.getProperty('verified') == 'true'
				});
			}
		});
	}
	
}