/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package pony.net.http.modules.mmodels;

import pony.db.Table;
import pony.net.http.CPQ;
import pony.text.tpl.ITplPut;

/**
 * ModelConnect
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.net.http.modules.mmodels.Builder.build())
#end
class ModelConnect extends ModuleConnect<Model> {

	private var db:Table;
	public var actions:Map<String, ActionConnect>;
	public var subactions:Map<String, ISubActionConnect>;
	
	private function new(base:Model, cpq:CPQ) {
		super(base, cpq);
		db = base.db.error(cpq.error);
	}
	
	public function action(h:Map<String, Map<String, String>>):Bool {
		for (k in h.keys()) {
			if (actions[k].runAction(h.get(k))) return true;
		}
		return false;
	}
	
	override public function tpl(parent:ITplPut):ITplPut {
		return new ModelPut(this, null, parent);
	}
	
}