package pony.net.http.sn.php;

import pony.net.http.sn.FBData;

/**
 * FB
 * @author AxGord
 */
class FB implements IFB {

	public function new(appid:String, secret:String = '', sdk:String = "facebook-php-sdk-v4/autoload.php") {
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