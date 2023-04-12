package pony.net.http.modules.mtpl;

import pony.net.http.ModuleConnect;
import pony.text.tpl.ITplPut;

/**
 * MTplConnect
 * @author AxGord <axgord@gmail.com>
 */
@:final class MTplConnect extends ModuleConnect<MTpl> {

	#if (haxe_ver < 4.2) override #end
	public function tpl(parent: ITplPut): ITplPut return new MTplPut(base, cpq, parent);

}