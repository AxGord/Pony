/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.http;
import pony.magic.Declarator;
import pony.text.tpl.TplSystem;

/**
 * CPQ
 * @author AxGord <axgord@gmail.com>
 */
class CPQ implements Declarator {

	@:arg public var connection:IHttpConnection;
	@:arg public var usercontent:String;
	public var page: String = '';
	public var query: Array<String> = [];
	@:arg public var template: TplSystem;
	@:arg public var lang: String;
	public var modules:Map<String, ModuleConnect<IModule>> = new Map<String,ModuleConnect<IModule>>();
	
	public function run() {
		var a:Array<String> = connection.url.split('/');
		var u:Array<String> = [];
		while (a.length != 0) {
			var n:String = a.join('/');
			if (template.exists(n + '/index')) {
				page = n;
				query = u;
				tpl(n+'/index');
				return;
			} else if (template.exists(n)) {
				page = n;
				query = u;
				tpl(n);
				return;
			} else
				u.push(a.pop());
		}
		if (template.exists('index')) {
			query = u;
			tpl('index');
		} else
			error('Not exists index.tpl');
	}
	
	@:extern inline public function tpl(name:String):Void {
		template.gen(name, this, connection.sendHtml);
	}
	
	public function error(message:String):Void {
		connection.error(message);
	}
	
	@:extern inline public function getModule<T>(cl:Class<T>):T return cast modules[Type.getClassName(cl)];
	
}