package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.*;
import pony.Tools;

class SignalTest 
{
	
	@Test
	public function shortCuts():Void
	{
		var r:String;
		var e = new Event2();
		var s:Signal2<String, String> = e;
		s.add(function(name:String, end:String) r = 'ok, '+name+end);
		e.dispatch('men', '?');
		Assert.areEqual(r, 'ok, men?');
		e.dispatch('glass', '!');
		Assert.areEqual(r, 'ok, glass!');
		s.clear();
	}
	
	@Test
	public function clearDispath():Void
	{
		var r:String;
		var e = new Event0();
		var s:Signal0 = e;
		s.add(function() r = 'ok');
		e.dispatch();
		Assert.areEqual(r, 'ok');
		s.clear();
	}
	
	@Test
	public function remove():Void {
		
		var c:Int = 0;
		var f:Void->Void = function() c++;
		var e = new Event0();
		var s:Signal0 = e;
		s.add(f);
		e.dispatch();
		e.dispatch();
		s.remove(f);
		e.dispatch();
		Assert.areEqual(c, 2);
	}
	
	@Test
	public function removeAll():Void {
		var c:Int = 0;
		var f = function() c++;
		var e = new Event0();
		var s:Signal0 = e;
		s.add(f);
		e.dispatch();
		e.dispatch();
		s.clear();
		e.dispatch();
		Assert.areEqual(c, 2);
	}
	/*
	@Test
	public function returns():Void {
		var a = true, b = true;
		var e = new Event1();
		var s:Signal1<Bool> = e;
		s.add(function(v:Bool):Bool return v );
		s.add(function():Bool return a = false);
		s.add(function() b = false);
		e.dispatch(true);
		Assert.isFalse(a);
		Assert.isTrue(b);
		e.dispatch(false);
		Assert.isFalse(a);
		Assert.isTrue(b);
	}
	*
	@Test
	public function s1():Void {
		var f:Bool = false;
		var f2:Bool = false;
		var e = new Event1();
		var s:Signal1<Int> = e;
		s.add(function(i:Int) if (i == 3) f = true);
		s.add(function() f2 = true);
		Assert.isTrue(f);
		Assert.isTrue(f2);
	}
	*/
	@Test
	public function s0():Void {
		var f:Bool = false;
		var e = new Event0();
		var s:Signal0 = e;
		s.add(function() f = true);
		e.dispatch();
		Assert.isTrue(f);
	}
	
	@Test
	public function sub():Void {
		var f:Bool = false;
		var e = new Event1();
		var s:Signal1<Int> = e;
		s.sub(3).add(function()f = true);
		e.dispatch(5);
		Assert.isFalse(f);
		e.dispatch(3);
		Assert.isTrue(f);
	}
	
	@Test
	public function sub1():Void {
		var f:Bool = false;
		var e = new Event2();
		var s:Signal2<Int,Int> = e;
		s.sub1(3).add(function() f = true);
		e.dispatch(5,4);
		Assert.isFalse(f);
		e.dispatch(3,4);
		Assert.isTrue(f);
	}
	/*
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
		s2.add(s1);
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
	
	@Test
	public function signal2subs():Void {
		var r = '';
		var s:Signal2<Void, Int, String> = Signal.createEmpty();
		s.sub1(1).add(function(c:String) r += c);
		s.sub2(1, 'd').add(function() r += '-');
		s.sub(2, 'e').add(function() r += '-');
		s.sub(2).add(function(c:String) r += c);
		s.dispatch(1, 'd');
		s.dispatch(2, 'e');
		Assert.areEqual(r, 'd--e');
	}
	
	@Test
	public function typedTarget():Void {
		var t:SignalTest = null;
		var s:Signal0<SignalTest> = Signal.create(this);
		s.add(function(tar:SignalTest, e:Event) t = tar);
		s.dispatch();
		Assert.areEqual(t, this);
	}
	
	@Test
	public function and():Void {
		var flags = [for(_ in 0...3) false];
		var f2 = false;
		var f3 = false;
		var s1 = new Signal();
		var s2 = new Signal();
		var s3 = s1.and(s2);
		s1.add(function() flags[0] = true);
		s2.add(function() flags[1] = true);
		s3.add(function() flags[2] = true);
		Assert.isTrue(Tools.equal(flags, [false, false, false]));
		s2.dispatch();
		Assert.isTrue(Tools.equal(flags, [false, true, false]));
		s1.dispatch();
		Assert.isTrue(Tools.equal(flags, [true, true, true]));
	}
	
	@Test
	public function shortSyntax():Void {
		var s:Signal0<Void> = Signal.createEmpty();
		var a = false;
		var f = function() a = true;
		s << f;
		Assert.isFalse(a);
		s.dispatch();
		Assert.isTrue(a);
		a = false;
		s >> f;
		s.dispatch();
		Assert.isFalse(a);
	}
	
	@Test
	public function shortSyntaxAnd():Void {
		var s1:Signal0<Void> = Signal.createEmpty();
		var s2:Signal0<Void> = Signal.createEmpty();
		var v = false;
		(s2 & s1) << function() v = true;
		s1.dispatch();
		Assert.isFalse(v);
		s2.dispatch();
		Assert.isTrue(v);
	}
	
	@Test
	public function arrows():Void {
		var s1:Signal1<Void, Int> = Signal.createEmpty();
		var s2:Signal1<Void, Int> = Signal.createEmpty();
		var fsum = 0;
		function f(v:Int) {
			s2.dispatch(v * 2);
			fsum += v * 2;
		}
		s2.takeListeners << function() s1 << f;
		s2.lostListeners << function() s1 >> f;
		var sum = 0;
		s1.dispatch(3);
		function l(v:Int) sum += v;
		s2 << l;
		s1.dispatch(1);
		s2 >> l;
		s1.dispatch(4);
		s2 < l;
		s1.dispatch(7);
		s1.dispatch(9);
		Assert.areEqual(fsum, sum);
		Assert.areEqual(sum, 16);
	}
	
	@Test
	public function toFunction():Void {
		var s:Signal1<Void, Int> = Signal.createEmpty();
		var f = false;
		s < function(v:Int) if (v == 3) f = true;
		var fun:Int->Void = s;
		fun(3);
		Assert.isTrue(f);
	}

	@Test
	public function join():Void {
		var s1:Signal = new Signal();
		var s2:Signal = new Signal();
		s1.join(s2);
		var a = false;
		var b = false;
		s1.add(function() a = true);
		s2.add(function() b = true);
		s1.dispatch();
		Assert.isTrue(a);
		Assert.isTrue(b);
		a = b = false;
		s2.dispatch();
		Assert.isTrue(a);
		Assert.isTrue(b);
	}
	
	@Test
	public function typed0Join():Void {
		var s1:Signal0<Void> = Signal.createEmpty();
		var s2:Signal0<Void> = Signal.createEmpty();
		s1.join(s2);
		var a = false;
		var b = false;
		s1.add(function() a = true);
		s2.add(function() b = true);
		s1.dispatch();
		Assert.isTrue(a);
		Assert.isTrue(b);
		a = b = false;
		s2.dispatch();
		Assert.isTrue(a);
		Assert.isTrue(b);
	}
	
	@Test
	public function typed0bJoin():Void {
		var s1:Signal0<Void> = Signal.createEmpty();
		var s2:Signal0<Void> = Signal.createEmpty();
		var a = false;
		var b = false;
		s2.add(function() b = true);
		s1.join(s2);
		s1.add(function() a = true);
		s1.dispatch();
		Assert.isTrue(a);
		Assert.isTrue(b);
		a = b = false;
		s2.dispatch();
		Assert.isTrue(a);
		Assert.isTrue(b);
	}
	
	@Test
	public function typed0brJoin():Void {
		var s1:Signal0<Void> = Signal.createEmpty();
		var s2:Signal0<Void> = Signal.createEmpty();
		var a = false;
		var b = false;
		s1.add(function() a = true);
		s1.join(s2);
		s2.add(function() b = true);
		s1.dispatch();
		Assert.isTrue(a);
		Assert.isTrue(b);
		a = b = false;
		s2.dispatch();
		Assert.isTrue(a);
		Assert.isTrue(b);
	}
	*/
}