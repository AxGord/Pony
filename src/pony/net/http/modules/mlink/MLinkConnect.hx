package pony.net.http.modules.mlink;

import pony.text.tpl.ITplPut;

/**
 * MLinkConnect
 * @author AxGord <axgord@gmail.com>
 */
@:final class MLinkConnect extends ModuleConnect<{}> {

	#if (haxe_ver < 4.2) override #end
	public function tpl(parent: ITplPut): ITplPut return new MLinkPut(this, null, parent);

}