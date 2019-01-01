package pony.net.http.modules.mkeyauth;

import pony.text.tpl.ITplPut;

/**
 * MKeyAuthConnect
 * @author AxGord <axgord@gmail.com>
 */
@:final class MKeyAuthConnect extends ModuleConnect<MKeyAuth> {

	override public function tpl(parent:ITplPut):ITplPut {
		return new MKeyAuthPut(this, null, parent);
	}
	
	public function authed():Bool return cpq.connection.sessionStorage[MKeyAuth.SESSION] == true;
	
}