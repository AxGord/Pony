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
import pony.net.http.modules.mmodels.Model.ActResult;
import pony.text.tpl.TplData;
import pony.text.tpl.ITplPut;
import pony.net.http.WebServer;

class Action
{
	public var id:Int;
	public var model:Model;
	public var name:String;
	//public var args:Array<{name: String, type: String}>;
	//public var argsNames:Array<String>;
	public var args:Map<String, String>;
	
	private var method:Dynamic;
	private var methodCheck:Dynamic;
	
	public function new(model:Model, name:String, args:Array<{name: String, type: String}>) {
		this.model = model;
		this.name = name;
		this.args = new Map<String, String>();
		for (a in args)
			this.args.set(a.name, a.type);
		id = model.mm.lastActionId++;
		
		method = Reflect.field(model, name);
		methodCheck = Reflect.field(model, name+'Validate');
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
	
	
	
	public function tpl(d:CPQ, parent:ITplPut):ITplPut {
		return new ActionPut(this, d, parent);
	}
	
	public function connect(cpq:CPQ):Bool {
		return false;
	}
	
	public function action(cpq:CPQ, h:Map<String, String>):Bool {
		return false;
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class ActionPut extends pony.text.tpl.TplPut<Action, CPQ> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		return "I can't be showing";
	}
	
}