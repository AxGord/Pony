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