package pony.net.http;

import pony.net.http.modules.mlink.MLink;
import pony.net.http.modules.mtpl.MTpl;
import pony.net.http.modules.mlang.MLang;

/**
 * DefaultModulePack
 * @author AxGord
 */
class DefaultModulePack {

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function create():Array<IModule> {
		return [
			cast new MLang(),
			cast new MTpl(),
			cast new MLink()
		];
	}

}