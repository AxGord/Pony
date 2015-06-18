/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.net.http.modules.mmodels;

import pony.Errors;
import pony.net.http.CPQ;
import pony.net.http.ModuleConnect;
import pony.net.http.modules.mmodels.Model.ActResult;
import pony.text.tpl.ITplPut;

/**
 * ActionConnect
 * @author AxGord <axgord@gmail.com>
 */
class ActionConnect extends ModuleConnect<Action> {
	
	private var method:Dynamic;
	private var methodCheck:Dynamic;
	public var model:ModelConnect;
	
	public function new(base:Action, cpq:CPQ, model:ModelConnect) {
		super(base, cpq);
		this.model = model;
		method = Reflect.field(model, base.name);
		methodCheck = Reflect.field(model, base.name+'Validate');
	}
	
	override public function tpl(parent:ITplPut):ITplPut {
		return new ActionPut(base, cpq, parent);
	}
	
	public function action(h:Map<String, String>):Bool {
		return false;
	}
	
	public function call(args:Array<Dynamic>, cb:Dynamic->Void):Void {
		Reflect.callMethod(model, method, args.concat([cb]));
	}
	
	public function _callCheck(args:Array<Dynamic>):Errors {	
		return Reflect.callMethod(model, methodCheck, args);
	}
		
	public function callCheck(args:Array<Dynamic>, cb:ActResult->Void):Void {
		if (methodCheck != null) {
			var r = _callCheck(args);
			if (r.empty()) {
				call(args, function(b:Bool) cb(b ? OK : DBERROR));
			} else {
				cb(ERROR(r.result));
			}
		} else
			call(args, function(b:Bool) cb(b ? OK : DBERROR));
	}

	
}