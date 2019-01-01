package pony.net.http.modules.mtpl;

import pony.net.http.ModuleConnect;
import pony.text.tpl.ITplPut;

/**
 * MTplConnect
 * @author AxGord <axgord@gmail.com>
 */
@:final class MTplConnect extends ModuleConnect<MTpl> {

	override public function tpl(parent:ITplPut):ITplPut {
		return new MTplPut(base, cpq, parent);
	}
	
}