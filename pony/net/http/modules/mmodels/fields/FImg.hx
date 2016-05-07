/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.http.modules.mmodels.fields;

import pony.db.mysql.Field;
import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.net.http.modules.mmodels.Field;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;

/**
 * FImg
 * @author AxGord <axgord@gmail.com>
 */
class FImg extends Field
{

	public function new(nn:Bool = true)
	{
		super(32);
		isFile = true;
		type = Types.CHAR;
		notnull = nn;
		tplPut = FImgPut;
	}
	
	override public function create():pony.db.mysql.Field
	{
		return {name: name, length: len, type: type, flags: notnull ? [Flags.NOT_NULL] : []};
	}
	
	override public function htmlInput(cl:String, act:String, value:String, hidded:Bool=false):String {
		return
			'<input ' + (cl != null?'class="' + cl + '" ':'') +
			'name="' + model.name + '.' + act + '.' +
			name + '" type="file" value="'+value+'"/>';
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class FImgPut extends pony.text.tpl.TplPut<FImg, Dynamic> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String 
	{
		return @await sub(this, get(name), FImgPutSub, content);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String 
	{
		return get(name);
	}
	
	@:async
	public function html(f:String):String {
		return '<img src="'+get(f)+'" width="200px"/>';
	}
	
	private function get(f:String):String return '/usercontent/' + Reflect.field(b, f);
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class FImgPutSub extends pony.text.tpl.Valuator<FImgPut, String> {
	
	@:async
	override public function valu(name:String, arg:String):String {
		return switch name {
			case 'orig': b;
			case 'small': 'small_' + b;
			case 'html': '<img src="$b"/>';
			case _: null;
		}
	}
	
}