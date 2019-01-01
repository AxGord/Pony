package pony.net.http.modules.mmodels;

import pony.magic.Classes;

/**
 * DefaultActionsPack
 * @author AxGord <axgord@gmail.com>
 */
class DefaultActionsPack {
	public static var list:Array<Dynamic>;
	public static function __init__() {
		//list = new Hash<Dynamic>();
		//list.set('Many', pony.net.http.modules.mmodels.actions.Many);
		list = (Classes.dir('pony.net.http.modules.mmodels', 'actions'));
	}
}