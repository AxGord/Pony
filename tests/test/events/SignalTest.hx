package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Event;
import pony.events.Signal;
import pony.events.Listener;
import pony.events.Signal0;
import pony.events.Signal1.Signal1;
import pony.events.Signal2.Signal2;
import pony.Function;

class SignalTest 
{
	private var beginListenerUnused:Int;
	private var beginFunctionUnused:Int;
	
	@Before
	public function setup():Void {
		beginListenerUnused = Listener.unusedCount();
		beginFunctionUnused = Function.unusedCount;
	}
	
	@Test
	public function shortCuts():Void
	{
		var r:String;
		var s:Signal = new Signal();
		s.add(function(name:String, end:String) r = 'ok, '+name+end);
		s.dispatch(new Event(['men', '?']));
		Assert.areEqual(r, 'ok, men?');
		s.dispatch('glass', '!');
		Assert.areEqual(r, 'ok, glass!');
		s.removeAllListeners();
	}
	
	@Test
	public function clearDispath():Void
	{
		var r:String;
		var s:Signal = new Signal();
		s.add(function() r = 'ok');
		s.dispatch();
		Assert.areEqual(r, 'ok');
		s.removeAllListeners();
	}
	
	@Test
	public function remove():Void {
		
		var c:Int = 0;
		var f:Void->Void = function() c++;
		var s:Signal = new Signal();
		s.add(f);
		s.dispatch();
		s.dispatch();
		s.remove(f);
		s.dispatch();
		Assert.areEqual(c, 2);
		
		Assert.areEqual(Listener.unusedCount(), beginListenerUnused);
		Assert.areEqual(Function.unusedCount, beginFunctionUnused);
	}
	
	@Test
	public function removeAll():Void {
		var c:Int = 0;
		var f = function() c++;
		var s:Signal = new Signal();
		s.add(f);
		s.dispatch();
		s.dispatch();
		s.removeAllListeners();
		s.dispatch();
		Assert.areEqual(c, 2);
		
		Assert.areEqual(Listener.unusedCount(), beginListenerUnused);
		Assert.areEqual(Function.unusedCount, beginFunctionUnused);
	}
	
	@Test
	public function event():Void {
		var e = new Event(this);
		Assert.areEqual(e.target, this);
	}
	
	@Test
	public function target():Void {
		var t:SignalTest = null;
		var s = new Signal(this);
		s.add(function(tar:SignalTest) t = tar);
		s.dispatch();
		Assert.areEqual(t, this);
	}
	
	@Test
	public function returns():Void {
		var a = true, b=true;
		var s = new Signal(this);
		s.add(function(v:Bool):Bool return v );
		s.add(function():Bool return a = false);
		s.add(function() b = false);
		s.dispatch(true);
		Assert.isFalse(a);
		Assert.isFalse(b);
		s.dispatch(false);
		Assert.isFalse(a);
		Assert.isFalse(b);
	}
	
	@Test
	public function s1():Void {
		var f:Bool = false;
		var f2:Bool = false;
		var s:Signal1<SignalTest, Int> = Signal.create(this);
		s.add(function(i:Int) if (i == 3) f = true);
		s.add(function() f2 = true);
		s.dispatch(3);
		Assert.isTrue(f);
		Assert.isTrue(f2);
	}
	
	@Test
	public function s0():Void {
		var f:Bool = false;
		var s:Signal0<SignalTest> = Signal.create(this);
		s.add(function() f = true);
		s.dispatch();
		Assert.isTrue(f);
	}
	
	@Test
	public function sub():Void {
		var f:Bool = false;
		var s:Signal = new Signal();
		s.sub(3).add(function()f = true);
		s.dispatch(5);
		Assert.isFalse(f);
		s.dispatch(3);
		Assert.isTrue(f);
	}
	
	@Test
	public function sub1():Void {
		var f:Bool = false;
		var s:Signal1<Void, Int> = Signal.createEmpty();
		s.sub(3).add(function() f = true);
		s.dispatch(5);
		Assert.isFalse(f);
		s.dispatch(3);
		Assert.isTrue(f);
	}
	
	@Test
	public function buildListener():Void {
		var c:Int = 0;
		var s1:Signal = new Signal();
		var s2:Signal = new Signal();
		s1.add(function(a:Int, b:Int, d:Int) c = a+b+d);
		s2.add(s1.buildListener(1, 2, 3));
		s2.dispatch();
		Assert.areEqual(c, 6);
	}
	
	@Test
	public function subSilent():Void {
		var f:Bool = true;
		var s:Signal = new Signal();
		s.sub(1).add(function() f = false);
		s.dispatch(3);
		Assert.isTrue(f);
		s.sub(1).silent = true;
		s.dispatch(1);
		Assert.isTrue(f);
		s.sub(1).silent = false;
		s.dispatch(1);
		Assert.isFalse(f);
	}
	
	@Test
	public function listen():Void {
		var f:Bool = false;
		var s1:Signal1<Void, Int> = Signal.createEmpty();
		var s2:Signal1<Void, Int> = Signal.createEmpty();
		s1.listen(s2);
		s1.sub(2).add(function() f = true);
		s2.dispatch(2);
		Assert.isTrue(f);
	}
	
	@Test
	public function sw1():Void {
		var t:String = '';
		var s:Signal1<Void, Int> = Signal.createEmpty();
		s.sw(function() t += 'a', function() t += 'b');
		s.dispatch(1);
		s.dispatch(2);
		s.dispatch(3);
		s.dispatch(4);
		s.dispatch(5);
		Assert.areEqual(t, 'ababa');
	}
	
	@Test
	public function signal2():Void {
		var t:String = '';
		var s:Signal2<SignalTest, String, Int> = Signal.create(this);
		s.add(function(s:String) t+=s);
		s.add(function(s:String, n:Int) t += s + n);
		s.dispatch('v', 8);
		Assert.areEqual(t, 'vv8');
	}
	
}