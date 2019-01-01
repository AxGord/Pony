package pony.net.http.sn.nodejs;

import js.Node;
import pony.net.http.sn.FBData;
import pony.net.http.sn.IFB;

/**
 * FB
 * @author AxGord
 */
class FB implements IFB {

	public var fb:Dynamic;
	
	public function new(appid:String, secret:String = '') {
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