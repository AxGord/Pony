package pony.net.http.modules.mlang;

import pony.net.http.ModuleConnect;
import pony.text.tpl.ITplPut;

/**
 * MLangConnect
 * @author AxGord <axgord@gmail.com>
 */
@:final class MLangConnect extends ModuleConnect<MLang> {

	override public function tpl(parent:ITplPut):ITplPut {
		return new MLangPut(this, null, parent);
	}
	
	public function translate(from:String, text:String):String {
		return base.langTable.translate(from, cpq.lang, text);
	}
	
}