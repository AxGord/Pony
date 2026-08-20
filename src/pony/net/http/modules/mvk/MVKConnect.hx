package pony.net.http.modules.mvk;

import pony.text.tpl.ITplPut;

/**
 * MVKConnect
 * @author AxGord <axgord@gmail.com>
 */
final class MVKConnect extends ModuleConnect<MVK> {

	public var token(get, set): String;

	private inline function get_token(): String return cpq.connection.sessionStorage['vk_token'];

	private inline function set_token(t: String): String return cpq.connection.sessionStorage['vk_token'] = t;

	#if (haxe_ver < 4.2) override #end
	public function tpl(parent: ITplPut): ITplPut return new MVKPut(this, null, parent);

	public function getCurrentUser(cb: Dynamic -> Void): Void request('users.get', {}, cb);

	public function getId(cb: Int -> Void): Void {
		getCurrentUser(function(r: Dynamic<Array<Dynamic>>) {
			cb(r.response[0].id);
		});
	}

	private function request(f: String, args: Dynamic, cb: String -> Void): Void {
		if (token == null)
			cb(null);
		else {
			base.vk.setToken(token);
			base.vk.request(f, args, cb);
		}
	}

}
