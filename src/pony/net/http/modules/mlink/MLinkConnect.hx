package pony.net.http.modules.mlink;

import pony.text.tpl.ITplPut;

/**
 * MLinkConnect
 * @author AxGord <axgord@gmail.com>
 */
@:final class MLinkConnect extends ModuleConnect<{}> {
	
	override public function tpl(parent:ITplPut):ITplPut {
		return new MLinkPut(this, null, parent);
	}
	
}