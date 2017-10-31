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
package pony.net.http.sn.nodejs;
import js.Node;
import pony.net.http.sn.FBData;
import pony.net.http.sn.IFB;

/**
 * FB
 * @author AxGord
 */
class FB implements IFB
{
	public var fb:Dynamic;
	
	public function new(appid:String, secret:String = '') 
	{
		fb = Node.require('fb');
	}
	
	inline public function api(token:String, r:String, cb:Dynamic->Void):Void {
		if (token == null) cb(null);
		else {
			fb.setAccessToken(token);
			fb.api(r, cb);
		}
	}
	
	public function me(token:String, cb:FBData->Void):Void {
		api(token, '/me', function(res) {
			if(res == null || res.error != null) {
				cb(null);
			} else {
				cb({
					id: res.id,
					email: res.email,
					first_name: res.first_name,
					isMale: res.gender == 'male',
					last_name: res.last_name,
					name: res.name,
					link: res.link,
					locale: res.locale,
					timezone: Std.parseInt(res.timezone),
					updated_time: res.updated_time,
					verified: res.verified == 'true'
				});
			}
		});
	}
	
}