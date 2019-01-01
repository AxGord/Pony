package pony.net.http.modules.mfb;

import pony.net.http.sn.FBData;
import pony.text.tpl.ITplPut;

/**
 * MFBConnect
 * @author AxGord <axgord@gmail.com>
 */
@:final class MFBConnect extends ModuleConnect<MFB> {

	public var token(get, set):String;
	
	private var data:FBData;
	
	override public function tpl(parent:ITplPut):ITplPut
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