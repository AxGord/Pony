package tpl;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.MUnitHelper;

#if neko
import pony.fs.Dir;
import pony.fs.SimplePath;

import pony.magic.Inform;
#end
import pony.magic.Declarator;

#if neko
import pony.tpl.TplDir;
import pony.tpl.TplSystem;
#end

import pony.tpl.WithTplPut;
import pony.tpl.Tpl;
import pony.tpl.TplPut;
import pony.tpl.ITplPut;


/**
 * ...
 * @author AxGord
 */

class TplTest extends MUnitHelper, implements WithTplPut
{
	public var tplPut:Class<Dynamic>;
	
	@Before
	public function setup():Void {
		tplPut = Ttt;
	}
	
	@Test
	public function test():Void {
		var t:Tpl = new Tpl(this, '123 < _ f=", ">%id%</_f>  e% qwe = "15%df% <_n2>weg</_n2>6" %');
		Assert.areEqual('123 0, 1, 2  e15df n26', t.gen());
	}
	
	#if neko
	@Test
	public function dir():Void {
		var d:Dir = new Dir(SimplePath.dir(Inform.file()));
		var td:TplDir = new TplDir(d.dir('tpls'), this);
		Assert.areEqual('hello world', td.gen('index'));
	}
	
	@Test
	public function system():Void {
		var d:Dir = new Dir(SimplePath.dir(Inform.file()));
		var s:TplSystem = new TplSystem(d.dir('system'), this);
		//trace(s.gen('index'));
		Assert.areEqual('hello world :=> * ^world^ *, world, ^world^ <= world => 123, world, ^world^ <= in folder world', s.gen('index'));
		Assert.areEqual('hello world :=> * ^world^ *, world, ^world^ <= world => 123, world, ^world^ <= in folder world', s.gen('index'));
	}
	
	#end
	
	#if (neko || js)
	@AsyncTest
	public function asyncron(factory:AsyncFactory):Void {
		createHandler(factory, 5000, function() {
			var t:Tpl = new Tpl(this, '123 < _ f=", ">%id%</_f>  e% qwe = "15%df% <_n2>weg</_n2>6" %');
			t.genAsync(null, null, eqA('123 0Async, 1Async, 2Async  e15df n26'), failA());
		});
	}
	#end
	
	#if neko
	@AsyncTest
	public function systemAsyncron(factory:AsyncFactory):Void {
		createHandler(factory, 5000, function() {
			var d:Dir = new Dir(SimplePath.dir(Inform.file()));
			var s:TplSystem = new TplSystem(d.dir('system'), this);
			s.genAsync(
				'index',
				null,
				eqA('hello worldAsync :=> * ^worldAsync^ *, worldAsync, ^worldAsync^ <= worldAsync => 123, worldAsync, ^worldAsync^ <= in folder worldAsync'),
				failA()
			);
		});
	}
	#end
	
}

class Ttt extends TplPut<Dynamic, Void>
{
	
	override public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String
	{
		if (name == 'f') {
			var r:Array<String> = [];
			for (i in 0...3)
				r.push(this.sub({id: i}, null, Ttt, content));
			return r.join(arg == null ? '' : arg);
		} else
			return super.tag(name, content, arg, args, kid);
	}
	
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		if (name == 'username')
			return 'world';
		else if (name == 'id')
			return Std.string(data.id);
		else if (parent == null)
			return arg == null ? name : arg;
		else
			return super.shortTag(name, arg, kid);
	}
	
	override public function shortTagAsync(name:String, arg:String, ?kid:ITplPut, ?ok:Dynamic->Void, ?error:Dynamic->Void):Void
	{
		Timer.delay(function() {
			if (name == 'username')
				ok('world'+'Async');
			else if (name == 'id')
				ok(Std.string(data.id)+'Async');
			else if (parent == null)
				ok(arg == null ? name : arg);
			else {
				super_shortTagAsync(name, arg, kid, ok, error);
			}
		}, 3);
	}
	
}