/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package text.tpl;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.text.tpl.Tpl;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;
#if neko
import pony.text.tpl.TplSystem;
import pony.text.tpl.TplDir;
import pony.fs.Dir;
#end
import pony.Tools;

class TplTest
{
	
	public var tplPut:Class<ITplPut>;
	
	@Before
	public function setup():Void {
		tplPut = Ttt;
	}
	
	@Test
	public function test():Void {
		var t:Tpl = new Tpl(this, '123 < _ f=", ">%id%</_f>  e% qwe = "15%df% <_n2>weg</_n2>6" %');
		var flag = false;
		t.gen(null, null, function(r:String):Void { Assert.areEqual('123 0, 1, 2  e15df n26', r); flag = true; } );
		Assert.isTrue(flag);
	}
	
	
	#if neko
	@Test
	public function dir():Void {
		var d:Dir = Tools.currentDir() + 'tpls';
		var td:TplDir = new TplDir(d, this);
		var flag = false;
		td.gen('index', null, null, function(r:String):Void { Assert.areEqual('hello world', r); flag = true; } );
		Assert.isTrue(flag);
	}
	
	@Test
	public function system():Void {
		var d:Dir = Tools.currentDir() + 'system';
		var s:TplSystem = new TplSystem(d, this);
		//s.gen('index', null, function(r:String) trace(r));
		var first = false;
		var second = false;
		s.gen('index', null, function(r:String):Void {
			Assert.areEqual('hello world :=> * ^world^ *, world, ^world^ <= world => 123, world, ^world^ <= in folder world', r);
			first = true;
		});
		s.gen('index', null, function(r:String):Void {
			Assert.areEqual('hello world :=> * ^world^ *, world, ^world^ <= world => 123, world, ^world^ <= in folder world', r);
			second = true;
		});
	}
	
	#end
	
}

typedef TData = {
	?id: Int, ?username:String
};

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class Ttt extends TplPut<TData, {}>
{
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'f') {
			var r:Array<String> = [];
			for (i in 0...3)
				r.push(@await sub({id: i}, null, Ttt, content));
			return r.join(arg == null ? '' : arg);
		} else
			return @await super.tag(name, content, arg, args, kid);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		if (name == 'username')
			return 'world';
		else if (name == 'id')
			return Std.string(a.id);
		else if (parent == null)
			return arg == null ? name : arg;
		else
			return @await super.shortTag(name, arg, kid);
	}
	
}