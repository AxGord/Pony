package pony.net.http;

import pony.net.http.modules.mlink.MLink;
import pony.net.http.modules.mtpl.MTpl;
import pony.net.http.modules.mlang.MLang;

/**
 * DefaultModulePack
 * @author AxGord
 */
class DefaultModulePack {

	@:extern inline public static function create():Array<IModule> {
		return [
			cast new MLang(),
			cast new MTpl(),
			cast new MLink()
		];
	}
	
}