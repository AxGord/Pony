package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Event;
import pony.events.Signal;
import pony.events.Listener;
import pony.events.Signal0;
import pony.events.Signal1.Signal1;
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
	
}