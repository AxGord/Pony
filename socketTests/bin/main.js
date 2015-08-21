(function (console) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	r: null
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		var tmp;
		if(this.r.m != null && n >= 0 && n < this.r.m.length) tmp = this.r.m[n]; else throw new js__$Boot_HaxeError("EReg::matched");
		return tmp;
	}
	,__class__: EReg
};
var HxOverrides = function() { };
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var IntIterator = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIterator.__name__ = ["IntIterator"];
IntIterator.prototype = {
	min: null
	,max: null
	,__class__: IntIterator
};
var Lambda = function() { };
Lambda.__name__ = ["Lambda"];
Lambda.exists = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
};
var List = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,__class__: List
};
var Main = function() { };
Main.__name__ = ["Main"];
Main.main = function() {
	js_Node.require("source-map-support").install();
	haxe_Log.trace("try connect",{ fileName : "Main.hx", lineNumber : 55, className : "Main", methodName : "main"});
	var serv = null;
	var cl = new pony_net_SocketClient(null,13579,100);
	var this1 = cl.log;
	var tmp;
	var l = pony__$Function_Function_$Impl_$.from(haxe_Log.trace,2,false);
	tmp = l;
	var listener = tmp;
	pony_events__$Signal2_Signal2_$Impl_$.add(this1,listener);
	cl.connected.wait(function() {
		haxe_Log.trace("ok",{ fileName : "Main.hx", lineNumber : 66, className : "Main", methodName : "main"});
		if(Main.testCount % 4 != 0) throw new js__$Boot_HaxeError("Wrong test count");
		pony_AsyncTests.init(Main.testCount);
		Main.firstTest();
	});
	haxe_Timer.delay(function() {
		serv = new pony_net_SocketServer(13579);
	},100);
};
Main.firstTest = function() {
	var server = Main.createServer(6001);
	var _g1 = 0;
	var _g = Main.partCount;
	while(_g1 < _g) {
		var i = _g1++;
		var tmp;
		var i1 = [i];
		tmp = (function(i1) {
			return function() {
				return Main.createClient(i1[0]);
			};
		})(i1);
		haxe_Timer.delay(tmp,Main.delay + Main.delay * i);
	}
	pony_AsyncTests.wait(new IntIterator(0,Main.blockCount),function() {
		haxe_Log.trace("Second part",{ fileName : "Main.hx", lineNumber : 93, className : "Main", methodName : "firstTest"});
		server.destroy();
		Main.createServer(6002);
		var _g11 = Main.blockCount;
		var _g2 = Main.blockCount + Main.partCount;
		while(_g11 < _g2) {
			var i2 = _g11++;
			var tmp1;
			var i3 = [i2];
			tmp1 = (function(i3) {
				return function() {
					return Main.createClient(i3[0]);
				};
			})(i3);
			haxe_Timer.delay(tmp1,Main.delay + Main.delay * (i2 - Main.blockCount));
		}
	});
};
Main.createServer = function(aPort) {
	Main.port = aPort;
	var server = new pony_net_SocketServer(aPort);
	var this1 = server.onConnect;
	var tmp;
	var l = pony__$Function_Function_$Impl_$.from(function(cl) {
		var bo = new haxe_io_BytesOutput();
		var s = "hi world";
		bo.writeInt32(s.length);
		bo.writeString(s);
		cl.send(bo);
	},1,false);
	tmp = l;
	var listener = tmp;
	pony_events__$Signal1_Signal1_$Impl_$.add(this1,listener);
	var this2 = server.onData;
	var tmp1;
	var l1 = pony__$Function_Function_$Impl_$.from(function(bi) {
		var i = bi.readInt32();
		var b = pony_Tools.readStr(bi);
		pony_AsyncTests.assertList.push({ a : "hello user", b : b, pos : { fileName : "Main.hx", lineNumber : 116, className : "Main", methodName : "createServer"}});
		pony_AsyncTests.setFlag(Main.partCount + i,{ fileName : "Main.hx", lineNumber : 117, className : "Main", methodName : "createServer"});
	},1,false);
	tmp1 = l1;
	var listener1 = tmp1;
	pony_events__$Signal1_Signal1_$Impl_$.add(this2,listener1);
	return server;
};
Main.createClient = function(i) {
	var client = new pony_net_SocketClient(null,Main.port);
	var this1 = client.onData;
	var tmp;
	var l = pony__$Function_Function_$Impl_$.from(function(data) {
		var s = pony_Tools.readStr(data);
		if(s == null) throw new js__$Boot_HaxeError("wrong data");
		pony_AsyncTests.assertList.push({ a : s, b : "hi world", pos : { fileName : "Main.hx", lineNumber : 129, className : "Main", methodName : "createClient"}});
		var bo = new haxe_io_BytesOutput();
		bo.writeInt32(i);
		bo.writeInt32("hello user".length);
		bo.writeString("hello user");
		client.send(bo);
		pony_AsyncTests.setFlag(i,{ fileName : "Main.hx", lineNumber : 134, className : "Main", methodName : "createClient"});
		client.destroy();
		client = null;
	},1,false);
	tmp = l;
	var listener = tmp;
	pony_events__$Signal1_Signal1_$Impl_$.once(this1,listener);
	return client;
};
Math.__name__ = ["Math"];
var Reflect = function() { };
Reflect.__name__ = ["Reflect"];
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		haxe_CallStack.lastException = e;
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
};
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
};
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
};
var Std = function() { };
Std.__name__ = ["Std"];
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	b: null
	,__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = ["StringTools"];
StringTools.htmlEscape = function(s,quotes) {
	s = s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
	return quotes?s.split("\"").join("&quot;").split("'").join("&#039;"):s;
};
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
};
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var Sys = function() { };
Sys.__name__ = ["Sys"];
Sys.println = function(v) {
	console.log(v);
};
var ValueType = { __ename__ : true, __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] };
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; };
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = function() { };
Type.__name__ = ["Type"];
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
};
Type.getClassName = function(c) {
	var a = c.__name__;
	if(a == null) return null;
	return a.join(".");
};
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
};
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
};
Type["typeof"] = function(v) {
	var _g = typeof(v);
	switch(_g) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = js_Boot.getClass(v);
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
};
var _$UInt_UInt_$Impl_$ = {};
_$UInt_UInt_$Impl_$.__name__ = ["_UInt","UInt_Impl_"];
_$UInt_UInt_$Impl_$.gt = function(a,b) {
	var aNeg = a < 0;
	var bNeg = b < 0;
	return aNeg != bNeg?aNeg:a > b;
};
var haxe_StackItem = { __ename__ : true, __constructs__ : ["CFunction","Module","FilePos","Method","LocalFunction"] };
haxe_StackItem.CFunction = ["CFunction",0];
haxe_StackItem.CFunction.toString = $estr;
haxe_StackItem.CFunction.__enum__ = haxe_StackItem;
haxe_StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.LocalFunction = function(v) { var $x = ["LocalFunction",4,v]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
var haxe_CallStack = function() { };
haxe_CallStack.__name__ = ["haxe","CallStack"];
haxe_CallStack.getStack = function(e) {
	if(e == null) return [];
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = function(error,callsites) {
		var stack = [];
		var _g = 0;
		while(_g < callsites.length) {
			var site = callsites[_g];
			++_g;
			if(haxe_CallStack.wrapCallSite != null) site = haxe_CallStack.wrapCallSite(site);
			var method = null;
			var fullName = site.getFunctionName();
			if(fullName != null) {
				var idx = fullName.lastIndexOf(".");
				if(idx >= 0) {
					var className = HxOverrides.substr(fullName,0,idx);
					var methodName = HxOverrides.substr(fullName,idx + 1,null);
					method = haxe_StackItem.Method(className,methodName);
				}
			}
			stack.push(haxe_StackItem.FilePos(method,site.getFileName(),site.getLineNumber()));
		}
		return stack;
	};
	var a = haxe_CallStack.makeStack(e.stack);
	Error.prepareStackTrace = oldValue;
	return a;
};
haxe_CallStack.callStack = function() {
	try {
		throw new Error();
	} catch( e ) {
		haxe_CallStack.lastException = e;
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		var a = haxe_CallStack.getStack(e);
		a.shift();
		return a;
	}
};
haxe_CallStack.exceptionStack = function() {
	return haxe_CallStack.getStack(haxe_CallStack.lastException);
};
haxe_CallStack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b += "\nCalled from ";
		haxe_CallStack.itemToString(b,s);
	}
	return b.b;
};
haxe_CallStack.itemToString = function(b,s) {
	switch(s[1]) {
	case 0:
		b.b += "a C function";
		break;
	case 1:
		var m = s[2];
		b.b += "module ";
		b.b += m == null?"null":"" + m;
		break;
	case 2:
		var line = s[4];
		var file = s[3];
		var s1 = s[2];
		if(s1 != null) {
			haxe_CallStack.itemToString(b,s1);
			b.b += " (";
		}
		b.b += file == null?"null":"" + file;
		b.b += " line ";
		b.b += line == null?"null":"" + line;
		if(s1 != null) b.b += ")";
		break;
	case 3:
		var meth = s[3];
		var cname = s[2];
		b.b += cname == null?"null":"" + cname;
		b.b += ".";
		b.b += meth == null?"null":"" + meth;
		break;
	case 4:
		var n = s[2];
		b.b += "local function #";
		b.b += n == null?"null":"" + n;
		break;
	}
};
haxe_CallStack.makeStack = function(s) {
	if(s == null) return []; else if(typeof(s) == "string") {
		var stack = s.split("\n");
		if(stack[0] == "Error") stack.shift();
		var m = [];
		var rie10 = new EReg("^   at ([A-Za-z0-9_. ]+) \\(([^)]+):([0-9]+):([0-9]+)\\)$","");
		var _g = 0;
		while(_g < stack.length) {
			var line = stack[_g];
			++_g;
			if(rie10.match(line)) {
				var path = rie10.matched(1).split(".");
				var meth = path.pop();
				var file = rie10.matched(2);
				var line1 = Std.parseInt(rie10.matched(3));
				m.push(haxe_StackItem.FilePos(meth == "Anonymous function"?haxe_StackItem.LocalFunction():meth == "Global code"?null:haxe_StackItem.Method(path.join("."),meth),file,line1));
			} else m.push(haxe_StackItem.Module(StringTools.trim(line)));
		}
		return m;
	} else return s;
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = ["haxe","IMap"];
var haxe_Log = function() { };
haxe_Log.__name__ = ["haxe","Log"];
haxe_Log.trace = function(v,infos) {
	js_Boot.__trace(v,infos);
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.__name__ = ["haxe","Timer"];
haxe_Timer.delay = function(f,time_ms) {
	var t = new haxe_Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe_Timer.prototype = {
	id: null
	,stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe_Timer
};
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__name__ = ["haxe","ds","IntMap"];
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	h: null
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,__class__: haxe_ds_IntMap
};
var haxe_io_Bytes = function(length,b) {
	this.length = length;
	this.b = b;
};
haxe_io_Bytes.__name__ = ["haxe","io","Bytes"];
haxe_io_Bytes.alloc = function(length) {
	return new haxe_io_Bytes(length,new Buffer(length));
};
haxe_io_Bytes.ofString = function(s) {
	var nb = new Buffer(s,"utf8");
	return new haxe_io_Bytes(nb.length,nb);
};
haxe_io_Bytes.ofData = function(b) {
	return new haxe_io_Bytes(b.length,b);
};
haxe_io_Bytes.prototype = {
	length: null
	,b: null
	,getString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		var s = "";
		var b = this.b;
		var fcc = String.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) break;
				s += fcc(c);
			} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c21 = b[i++];
				var c3 = b[i++];
				s += fcc((c & 15) << 18 | (c21 & 127) << 12 | c3 << 6 & 127 | b[i++] & 127);
			}
		}
		return s;
	}
	,toString: function() {
		return this.getString(0,this.length);
	}
	,__class__: haxe_io_Bytes
};
var haxe_io_BytesBuffer = function() {
	this.b = [];
};
haxe_io_BytesBuffer.__name__ = ["haxe","io","BytesBuffer"];
haxe_io_BytesBuffer.prototype = {
	b: null
	,getBytes: function() {
		var nb = new Buffer(this.b);
		var bytes = new haxe_io_Bytes(nb.length,nb);
		this.b = null;
		return bytes;
	}
	,__class__: haxe_io_BytesBuffer
};
var haxe_io_Input = function() { };
haxe_io_Input.__name__ = ["haxe","io","Input"];
haxe_io_Input.prototype = {
	bigEndian: null
	,readByte: function() {
		throw new js__$Boot_HaxeError("Not implemented");
	}
	,readBytes: function(s,pos,len) {
		var k = len;
		var b = s.b;
		if(pos < 0 || len < 0 || pos + len > s.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		while(k > 0) {
			b[pos] = this.readByte();
			pos++;
			k--;
		}
		return len;
	}
	,readFullBytes: function(s,pos,len) {
		while(len > 0) {
			var k = this.readBytes(s,pos,len);
			pos += k;
			len -= k;
		}
	}
	,read: function(nbytes) {
		var s = haxe_io_Bytes.alloc(nbytes);
		var p = 0;
		while(nbytes > 0) {
			var k = this.readBytes(s,p,nbytes);
			if(k == 0) throw new js__$Boot_HaxeError(haxe_io_Error.Blocked);
			p += k;
			nbytes -= k;
		}
		return s;
	}
	,readInt32: function() {
		var ch1 = this.readByte();
		var ch2 = this.readByte();
		var ch3 = this.readByte();
		var ch4 = this.readByte();
		return this.bigEndian?ch4 | ch3 << 8 | ch2 << 16 | ch1 << 24:ch1 | ch2 << 8 | ch3 << 16 | ch4 << 24;
	}
	,readString: function(len) {
		var b = haxe_io_Bytes.alloc(len);
		this.readFullBytes(b,0,len);
		return b.toString();
	}
	,__class__: haxe_io_Input
};
var haxe_io_BytesInput = function(b,pos,len) {
	if(pos == null) pos = 0;
	if(len == null) len = b.length - pos;
	if(pos < 0 || len < 0 || pos + len > b.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
	this.b = b.b;
	this.pos = pos;
	this.len = len;
	this.totlen = len;
};
haxe_io_BytesInput.__name__ = ["haxe","io","BytesInput"];
haxe_io_BytesInput.__super__ = haxe_io_Input;
haxe_io_BytesInput.prototype = $extend(haxe_io_Input.prototype,{
	b: null
	,pos: null
	,len: null
	,totlen: null
	,readByte: function() {
		if(this.len == 0) throw new js__$Boot_HaxeError(new haxe_io_Eof());
		this.len--;
		return this.b[this.pos++];
	}
	,readBytes: function(buf,pos,len) {
		if(pos < 0 || len < 0 || pos + len > buf.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		if(this.len == 0 && len > 0) throw new js__$Boot_HaxeError(new haxe_io_Eof());
		if(this.len < len) len = this.len;
		var b1 = this.b;
		var b2 = buf.b;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			b2[pos + i] = b1[this.pos + i];
		}
		this.pos += len;
		this.len -= len;
		return len;
	}
	,__class__: haxe_io_BytesInput
});
var haxe_io_Output = function() { };
haxe_io_Output.__name__ = ["haxe","io","Output"];
haxe_io_Output.prototype = {
	bigEndian: null
	,writeByte: function(c) {
		throw new js__$Boot_HaxeError("Not implemented");
	}
	,writeBytes: function(s,pos,len) {
		var k = len;
		var b = s.b;
		if(pos < 0 || len < 0 || pos + len > s.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		while(k > 0) {
			this.writeByte(b[pos]);
			pos++;
			k--;
		}
		return len;
	}
	,write: function(s) {
		var l = s.length;
		var p = 0;
		while(l > 0) {
			var k = this.writeBytes(s,p,l);
			if(k == 0) throw new js__$Boot_HaxeError(haxe_io_Error.Blocked);
			p += k;
			l -= k;
		}
	}
	,writeFullBytes: function(s,pos,len) {
		while(len > 0) {
			var k = this.writeBytes(s,pos,len);
			pos += k;
			len -= k;
		}
	}
	,writeInt32: function(x) {
		if(this.bigEndian) {
			this.writeByte(x >>> 24);
			this.writeByte(x >> 16 & 255);
			this.writeByte(x >> 8 & 255);
			this.writeByte(x & 255);
		} else {
			this.writeByte(x & 255);
			this.writeByte(x >> 8 & 255);
			this.writeByte(x >> 16 & 255);
			this.writeByte(x >>> 24);
		}
	}
	,writeString: function(s) {
		var b = haxe_io_Bytes.ofString(s);
		this.writeFullBytes(b,0,b.length);
	}
	,__class__: haxe_io_Output
};
var haxe_io_BytesOutput = function() {
	this.b = new haxe_io_BytesBuffer();
};
haxe_io_BytesOutput.__name__ = ["haxe","io","BytesOutput"];
haxe_io_BytesOutput.__super__ = haxe_io_Output;
haxe_io_BytesOutput.prototype = $extend(haxe_io_Output.prototype,{
	b: null
	,writeByte: function(c) {
		this.b.b.push(c);
	}
	,writeBytes: function(buf,pos,len) {
		var _this = this.b;
		if(pos < 0 || len < 0 || pos + len > buf.length) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
		var b2 = buf.b;
		var _g1 = pos;
		var _g = pos + len;
		while(_g1 < _g) {
			var i = _g1++;
			_this.b.push(b2[i]);
		}
		return len;
	}
	,getBytes: function() {
		return this.b.getBytes();
	}
	,__class__: haxe_io_BytesOutput
});
var haxe_io_Eof = function() {
};
haxe_io_Eof.__name__ = ["haxe","io","Eof"];
haxe_io_Eof.prototype = {
	toString: function() {
		return "Eof";
	}
	,__class__: haxe_io_Eof
};
var haxe_io_Error = { __ename__ : true, __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe_io_Error.Blocked = ["Blocked",0];
haxe_io_Error.Blocked.toString = $estr;
haxe_io_Error.Blocked.__enum__ = haxe_io_Error;
haxe_io_Error.Overflow = ["Overflow",1];
haxe_io_Error.Overflow.toString = $estr;
haxe_io_Error.Overflow.__enum__ = haxe_io_Error;
haxe_io_Error.OutsideBounds = ["OutsideBounds",2];
haxe_io_Error.OutsideBounds.toString = $estr;
haxe_io_Error.OutsideBounds.__enum__ = haxe_io_Error;
haxe_io_Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe_io_Error; $x.toString = $estr; return $x; };
var haxe_unit_TestCase = function() {
};
haxe_unit_TestCase.__name__ = ["haxe","unit","TestCase"];
haxe_unit_TestCase.prototype = {
	currentTest: null
	,setup: function() {
	}
	,tearDown: function() {
	}
	,print: function(v) {
		haxe_unit_TestRunner.print(v);
	}
	,assertTrue: function(b,c) {
		this.currentTest.done = true;
		if(b != true) {
			this.currentTest.success = false;
			this.currentTest.error = "expected true but was false";
			this.currentTest.posInfos = c;
			throw new js__$Boot_HaxeError(this.currentTest);
		}
	}
	,assertFalse: function(b,c) {
		this.currentTest.done = true;
		if(b == true) {
			this.currentTest.success = false;
			this.currentTest.error = "expected false but was true";
			this.currentTest.posInfos = c;
			throw new js__$Boot_HaxeError(this.currentTest);
		}
	}
	,assertEquals: function(expected,actual,c) {
		this.currentTest.done = true;
		if(actual != expected) {
			this.currentTest.success = false;
			this.currentTest.error = "expected '" + Std.string(expected) + "' but was '" + Std.string(actual) + "'";
			this.currentTest.posInfos = c;
			throw new js__$Boot_HaxeError(this.currentTest);
		}
	}
	,__class__: haxe_unit_TestCase
};
var haxe_unit_TestResult = function() {
	this.m_tests = new List();
	this.success = true;
};
haxe_unit_TestResult.__name__ = ["haxe","unit","TestResult"];
haxe_unit_TestResult.prototype = {
	m_tests: null
	,success: null
	,add: function(t) {
		this.m_tests.add(t);
		if(!t.success) this.success = false;
	}
	,toString: function() {
		var buf_b = "";
		var failures = 0;
		var _g_head = this.m_tests.h;
		var _g_val = null;
		while(_g_head != null) {
			var tmp;
			_g_val = _g_head[0];
			_g_head = _g_head[1];
			tmp = _g_val;
			var test = tmp;
			if(test.success == false) {
				buf_b += "* ";
				buf_b += test.classname == null?"null":"" + test.classname;
				buf_b += "::";
				buf_b += test.method == null?"null":"" + test.method;
				buf_b += "()";
				buf_b += "\n";
				buf_b += "ERR: ";
				if(test.posInfos != null) {
					buf_b += Std.string(test.posInfos.fileName);
					buf_b += ":";
					buf_b += Std.string(test.posInfos.lineNumber);
					buf_b += "(";
					buf_b += Std.string(test.posInfos.className);
					buf_b += ".";
					buf_b += Std.string(test.posInfos.methodName);
					buf_b += ") - ";
				}
				buf_b += test.error == null?"null":"" + test.error;
				buf_b += "\n";
				if(test.backtrace != null) {
					buf_b += test.backtrace == null?"null":"" + test.backtrace;
					buf_b += "\n";
				}
				buf_b += "\n";
				failures++;
			}
		}
		buf_b += "\n";
		if(failures == 0) buf_b += "OK "; else buf_b += "FAILED ";
		buf_b += Std.string(this.m_tests.length);
		buf_b += " tests, ";
		buf_b += failures == null?"null":"" + failures;
		buf_b += " failed, ";
		buf_b += Std.string(this.m_tests.length - failures);
		buf_b += " success";
		buf_b += "\n";
		return buf_b;
	}
	,__class__: haxe_unit_TestResult
};
var haxe_unit_TestRunner = function() {
	this.result = new haxe_unit_TestResult();
	this.cases = new List();
};
haxe_unit_TestRunner.__name__ = ["haxe","unit","TestRunner"];
haxe_unit_TestRunner.print = function(v) {
	var msg = js_Boot.__string_rec(v,"");
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) {
		msg = StringTools.htmlEscape(msg).split("\n").join("<br/>");
		d.innerHTML += msg + "<br/>";
	} else if(typeof process != "undefined" && process.stdout != null && process.stdout.write != null) process.stdout.write(msg); else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
haxe_unit_TestRunner.customTrace = function(v,p) {
	haxe_unit_TestRunner.print(p.fileName + ":" + p.lineNumber + ": " + Std.string(v) + "\n");
};
haxe_unit_TestRunner.prototype = {
	result: null
	,cases: null
	,add: function(c) {
		this.cases.add(c);
	}
	,run: function() {
		this.result = new haxe_unit_TestResult();
		var _g_head = this.cases.h;
		var _g_val = null;
		while(_g_head != null) {
			var tmp;
			_g_val = _g_head[0];
			_g_head = _g_head[1];
			tmp = _g_val;
			var c = tmp;
			this.runCase(c);
		}
		haxe_unit_TestRunner.print(this.result.toString());
		return this.result.success;
	}
	,runCase: function(t) {
		var old = haxe_Log.trace;
		haxe_Log.trace = haxe_unit_TestRunner.customTrace;
		var cl = t == null?null:js_Boot.getClass(t);
		var fields = Type.getInstanceFields(cl);
		haxe_unit_TestRunner.print("Class: " + Type.getClassName(cl) + " ");
		var _g = 0;
		while(_g < fields.length) {
			var f = fields[_g];
			++_g;
			var field = Reflect.field(t,f);
			if(StringTools.startsWith(f,"test") && Reflect.isFunction(field)) {
				t.currentTest = new haxe_unit_TestStatus();
				t.currentTest.classname = Type.getClassName(cl);
				t.currentTest.method = f;
				t.setup();
				try {
					var args = [];
					field.apply(t,args);
					if(t.currentTest.done) {
						t.currentTest.success = true;
						haxe_unit_TestRunner.print(".");
					} else {
						t.currentTest.success = false;
						t.currentTest.error = "(warning) no assert";
						haxe_unit_TestRunner.print("W");
					}
				} catch( $e0 ) {
					haxe_CallStack.lastException = $e0;
					if ($e0 instanceof js__$Boot_HaxeError) $e0 = $e0.val;
					if( js_Boot.__instanceof($e0,haxe_unit_TestStatus) ) {
						var e = $e0;
						haxe_unit_TestRunner.print("F");
						t.currentTest.backtrace = haxe_CallStack.toString(haxe_CallStack.exceptionStack());
					} else {
					var e1 = $e0;
					haxe_unit_TestRunner.print("E");
					if(e1.message != null) t.currentTest.error = "exception thrown : " + Std.string(e1) + " [" + Std.string(e1.message) + "]"; else t.currentTest.error = "exception thrown : " + Std.string(e1);
					t.currentTest.backtrace = haxe_CallStack.toString(haxe_CallStack.exceptionStack());
					}
				}
				this.result.add(t.currentTest);
				t.tearDown();
			}
		}
		haxe_unit_TestRunner.print("\n");
		haxe_Log.trace = old;
	}
	,__class__: haxe_unit_TestRunner
};
var haxe_unit_TestStatus = function() {
	this.done = false;
	this.success = false;
};
haxe_unit_TestStatus.__name__ = ["haxe","unit","TestStatus"];
haxe_unit_TestStatus.prototype = {
	done: null
	,success: null
	,error: null
	,method: null
	,classname: null
	,posInfos: null
	,backtrace: null
	,__class__: haxe_unit_TestStatus
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = ["js","_Boot","HaxeError"];
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	val: null
	,__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = ["js","Boot"];
js_Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js_Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js_Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js_Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js_Boot.__unhtml(msg) + "<br/>"; else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			haxe_CallStack.lastException = e;
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return (Function("return typeof " + name + " != \"undefined\" ? " + name + " : null"))();
};
var js_Node = function() { };
js_Node.__name__ = ["js","Node"];
var pony_AsyncTests = function() {
	haxe_unit_TestCase.call(this);
};
pony_AsyncTests.__name__ = ["pony","AsyncTests"];
pony_AsyncTests.init = function(count) {
	if(pony_AsyncTests.testCount != 0) throw new js__$Boot_HaxeError("Second init");
	haxe_Log.trace("" + pony_AsyncTests.dec + " Begin tests (" + count + ") " + pony_AsyncTests.dec,{ fileName : "AsyncTests.hx", lineNumber : 57, className : "pony.AsyncTests", methodName : "init"});
	pony_AsyncTests.testCount = count;
	var tmp;
	var _g = new haxe_ds_IntMap();
	var _g1 = 0;
	while(_g1 < count) {
		var i = _g1++;
		_g.h[i] = false;
	}
	tmp = _g;
	pony_AsyncTests.isRead = tmp;
};
pony_AsyncTests.equals = function(a,b,infos) {
	pony_AsyncTests.assertList.push({ a : a, b : b, pos : infos});
};
pony_AsyncTests.setFlag = function(n,infos) {
	if(n >= pony_AsyncTests.testCount || n < 0) throw new js__$Boot_HaxeError("Wrong test number");
	if(pony_AsyncTests.isRead.h[n]) throw new js__$Boot_HaxeError("Double complite");
	haxe_Log.trace("" + pony_AsyncTests.dec + " Test #" + n + " finished " + pony_AsyncTests.dec,infos);
	pony_AsyncTests.isRead.h[n] = true;
	true;
	if(pony_AsyncTests.lock) return;
	pony_AsyncTests.lock = true;
	pony_AsyncTests.checkWaitList();
	var $it0 = pony_AsyncTests.isRead.iterator();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(!e) {
			pony_AsyncTests.lock = false;
			return;
		}
	}
	var test = new haxe_unit_TestRunner();
	test.add(new pony_AsyncTests());
	test.run();
};
pony_AsyncTests.finish = function(infos) {
	if(!pony_AsyncTests.complite) {
		var tmp;
		var a = [];
		var $it0 = pony_AsyncTests.isRead.keys();
		while( $it0.hasNext() ) {
			var k = $it0.next();
			if(!pony_AsyncTests.isRead.h[k]) a.push(k);
		}
		tmp = a;
		throw new js__$Boot_HaxeError("Tests not complited: " + Std.string(tmp));
	}
	haxe_Log.trace("" + pony_AsyncTests.dec + " All tests finished " + pony_AsyncTests.dec,infos);
};
pony_AsyncTests.wait = function(it,cb) {
	if(pony_AsyncTests.checkWait(it)) cb(); else pony_AsyncTests.waitList.push({ it : it, cb : cb});
};
pony_AsyncTests.checkWait = function(it) {
	var _g1 = Reflect.field(it,"min");
	var _g = Reflect.field(it,"max");
	while(_g1 < _g) {
		var i = _g1++;
		if(!pony_AsyncTests.isRead.h[i]) return false;
	}
	return true;
};
pony_AsyncTests.checkWaitList = function() {
	var nl = new List();
	var _g_head = pony_AsyncTests.waitList.h;
	var _g_val = null;
	while(_g_head != null) {
		var tmp;
		_g_val = _g_head[0];
		_g_head = _g_head[1];
		tmp = _g_val;
		var e = tmp;
		if(pony_AsyncTests.checkWait(e.it)) e.cb(); else nl.push(e);
	}
	pony_AsyncTests.waitList = nl;
};
pony_AsyncTests.__super__ = haxe_unit_TestCase;
pony_AsyncTests.prototype = $extend(haxe_unit_TestCase.prototype,{
	testRun: function() {
		var _g_head = pony_AsyncTests.assertList.h;
		var _g_val = null;
		while(_g_head != null) {
			var tmp;
			_g_val = _g_head[0];
			_g_head = _g_head[1];
			tmp = _g_val;
			var e = tmp;
			this.assertEquals(e.a,e.b,e.pos);
		}
		pony_AsyncTests.complite = true;
	}
	,__class__: pony_AsyncTests
});
var pony_Dictionary = function(maxDepth) {
	if(maxDepth == null) maxDepth = 1;
	this.maxDepth = maxDepth;
	this.ks = [];
	this.vs = [];
};
pony_Dictionary.__name__ = ["pony","Dictionary"];
pony_Dictionary.prototype = {
	ks: null
	,vs: null
	,maxDepth: null
	,set: function(k,v) {
		var i = pony_Tools.superIndexOf(this.ks,k,this.maxDepth);
		if(i != -1) {
			this.vs[i] = v;
			return i;
		} else {
			this.ks.push(k);
			return this.vs.push(v);
		}
	}
	,get: function(k) {
		var i = pony_Tools.superIndexOf(this.ks,k,this.maxDepth);
		if(i == -1) return null; else return this.vs[i];
	}
	,remove: function(k) {
		var i = pony_Tools.superIndexOf(this.ks,k,this.maxDepth);
		if(i != -1) {
			this.ks.splice(i,1);
			this.vs.splice(i,1);
			return true;
		} else return false;
	}
	,__class__: pony_Dictionary
};
var pony__$Function_Function_$Impl_$ = {};
pony__$Function_Function_$Impl_$.__name__ = ["pony","_Function","Function_Impl_"];
pony__$Function_Function_$Impl_$._new = function(f,count,args,ret,event) {
	if(event == null) event = false;
	if(ret == null) ret = true;
	var this1;
	pony__$Function_Function_$Impl_$.counter++;
	if(pony__$Function_Function_$Impl_$.searchFree) while(true) {
		var $it0 = HxOverrides.iter(pony__$Function_Function_$Impl_$.list.vs);
		while( $it0.hasNext() ) {
			var e = $it0.next();
			if(e.id != pony__$Function_Function_$Impl_$.counter) break;
		}
		pony__$Function_Function_$Impl_$.counter++;
	} else if(pony__$Function_Function_$Impl_$.counter == -1) pony__$Function_Function_$Impl_$.searchFree = true;
	this1 = { f : f, count : count, args : args == null?[]:args, id : pony__$Function_Function_$Impl_$.counter, used : 0, event : event, ret : ret};
	return this1;
};
pony__$Function_Function_$Impl_$.from = function(f,argc,ret,event) {
	if(event == null) event = false;
	if(ret == null) ret = true;
	var tmp;
	var _this = pony__$Function_Function_$Impl_$.list;
	var k = f;
	tmp = pony_Tools.superIndexOf(_this.ks,k,_this.maxDepth) != -1;
	if(tmp) return pony__$Function_Function_$Impl_$.list.get(f); else {
		pony__$Function_Function_$Impl_$.unusedCount++;
		var o = pony__$Function_Function_$Impl_$._new(f,argc,null,ret,event);
		pony__$Function_Function_$Impl_$.list.set(f,o);
		return o;
	}
};
var pony_IEvent = function() { };
pony_IEvent.__name__ = ["pony","IEvent"];
var pony_ILogable = function() { };
pony_ILogable.__name__ = ["pony","ILogable"];
var pony_Logable = function() {
	var tmp;
	var tmp2;
	var s = new pony_events_Signal(this);
	tmp2 = s;
	var this1 = tmp2;
	tmp = this1;
	this.log = tmp;
	var tmp1;
	var tmp3;
	var s1 = new pony_events_Signal(this);
	tmp3 = s1;
	var this2 = tmp3;
	tmp1 = this2;
	this.error = tmp1;
};
pony_Logable.__name__ = ["pony","Logable"];
pony_Logable.__interfaces__ = [pony_ILogable];
pony_Logable.prototype = {
	log: null
	,error: null
	,__class__: pony_Logable
};
var pony_Priority = function(data) {
	this["double"] = false;
	this.clear();
	if(data != null) {
		var _g = 0;
		while(_g < data.length) {
			var e = data[_g];
			++_g;
			this.addElement(e);
		}
	}
};
pony_Priority.__name__ = ["pony","Priority"];
pony_Priority.prototype = {
	'double': null
	,data: null
	,hash: null
	,counters: null
	,addElement: function(e,priority) {
		if(priority == null) priority = 0;
		var tmp;
		if(!this["double"]) {
			var tmp1;
			var f = $bind(this,this.compare);
			var a = e;
			tmp1 = function(b) {
				return f(a,b);
			};
			tmp = Lambda.exists(this.data,tmp1);
		} else tmp = false;
		if(tmp) return this;
		var s = this.hash.h.hasOwnProperty(priority)?this.hash.h[priority]:0;
		var c = 0;
		var $it0 = this.hash.keys();
		while( $it0.hasNext() ) {
			var k = $it0.next();
			if(k < priority) c += this.hash.h[k];
		}
		c += s;
		this.data.splice(c,0,e);
		var _g1 = 0;
		var _g = this.counters.length;
		while(_g1 < _g) {
			var k1 = _g1++;
			if(c < this.counters[k1]) this.counters[k1]++;
		}
		this.hash.h[priority] = s + 1;
		return this;
	}
	,iterator: function() {
		var _g = this;
		var n = this.counters.push(0) - 1;
		return { hasNext : function() {
			if(_g.counters.length < n) _g.counters.push(n);
			if(_g.data[_g.counters[n]] != null) return true; else {
				_g.counters.splice(n,1);
				return false;
			}
		}, next : function() {
			return _g.data[_g.counters[n]++];
		}};
	}
	,clear: function() {
		this.hash = new haxe_ds_IntMap();
		this.data = [];
		this.counters = [0];
		return this;
	}
	,compare: function(a,b) {
		return a == b;
	}
	,asort: function(x,y) {
		return x - y;
	}
	,removeElement: function(e) {
		var i = HxOverrides.indexOf(this.data,e,0);
		if(i == -1) return false;
		var _g1 = 0;
		var _g = this.counters.length;
		while(_g1 < _g) {
			var k = _g1++;
			if(i < this.counters[k]) this.counters[k]--;
		}
		HxOverrides.remove(this.data,e);
		var tmp;
		var _g2 = [];
		var $it0 = this.hash.keys();
		while( $it0.hasNext() ) {
			var k1 = $it0.next();
			_g2.push(k1);
		}
		tmp = _g2;
		var a = tmp;
		a.sort($bind(this,this.asort));
		var _g11 = 0;
		while(_g11 < a.length) {
			var k2 = a[_g11];
			++_g11;
			var n = this.hash.h[k2];
			if(i > 0) i -= n; else {
				if(n > 1) this.hash.h[k2] = n - 1; else this.hash.remove(k2);
				break;
			}
		}
		if(this["double"]) this.removeElement(e);
		return true;
	}
	,__class__: pony_Priority
};
var pony_Queue = function(method) {
	this.busy = false;
	this.method = method;
	this.list = new List();
	this.call = Reflect.makeVarArgs($bind(this,this._call));
};
pony_Queue.__name__ = ["pony","Queue"];
pony_Queue.prototype = {
	list: null
	,busy: null
	,call: null
	,method: null
	,_call: function(a) {
		if(!this.busy) {
			this.busy = true;
			this.method.apply(null,a);
		} else this.list.add(a);
	}
	,next: function() {
		if(this.list.length > 0) {
			var args = this.list.pop();
			this.method.apply(null,args);
		} else this.busy = false;
	}
	,__class__: pony_Queue
};
var pony_Tools = function() { };
pony_Tools.__name__ = ["pony","Tools"];
pony_Tools.equal = function(a,b,maxDepth) {
	if(maxDepth == null) maxDepth = 1;
	if(a == b) return true;
	if(maxDepth == 0) return false;
	var type = Type["typeof"](a);
	switch(type[1]) {
	case 1:case 2:case 3:case 0:
		return false;
	case 5:
		try {
			return Reflect.compareMethods(a,b);
		} catch( _ ) {
			haxe_CallStack.lastException = _;
			if (_ instanceof js__$Boot_HaxeError) _ = _.val;
			return false;
		}
		break;
	case 7:
		var t = type[2];
		if(t != Type.getEnum(b)) return false;
		var tmp;
		var e = a;
		tmp = e[1];
		var tmp1;
		var e1 = b;
		tmp1 = e1[1];
		if(tmp != tmp1) return false;
		var tmp2;
		var e2 = a;
		tmp2 = e2.slice(2);
		var a1 = tmp2;
		var tmp3;
		var e3 = b;
		tmp3 = e3.slice(2);
		var b1 = tmp3;
		if(a1.length != b1.length) return false;
		var _g1 = 0;
		var _g = a1.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!pony_Tools.equal(a1[i],b1[i],maxDepth - 1)) return false;
		}
		return true;
	case 4:
		if(js_Boot.__instanceof(a,Class)) return false;
		break;
	case 8:
		break;
	case 6:
		var t1 = type[2];
		if(t1 == Array) {
			if(!((b instanceof Array) && b.__enum__ == null)) return false;
			if(a.length != b.length) return false;
			var _g11 = 0;
			var _g2 = a.length;
			while(_g11 < _g2) {
				var i1 = _g11++;
				if(!pony_Tools.equal(a[i1],b[i1],maxDepth - 1)) return false;
			}
			return true;
		}
		break;
	}
	{
		var _g3 = Type["typeof"](b);
		switch(_g3[1]) {
		case 1:case 2:case 3:case 5:case 7:case 0:
			return false;
		case 4:
			if(js_Boot.__instanceof(b,Class)) return false;
			break;
		case 6:
			var t2 = _g3[2];
			if(t2 == Array) return false;
			break;
		case 8:
			break;
		}
	}
	var fields = Reflect.fields(a);
	if(fields.length == Reflect.fields(b).length) {
		if(fields.length == 0) return true;
		var _g4 = 0;
		while(_g4 < fields.length) {
			var f = fields[_g4];
			++_g4;
			if(!Object.prototype.hasOwnProperty.call(b,f) || !pony_Tools.equal(Reflect.field(a,f),Reflect.field(b,f),maxDepth - 1)) return false;
		}
		return true;
	}
	return false;
};
pony_Tools.superIndexOf = function(it,v,maxDepth) {
	if(maxDepth == null) maxDepth = 1;
	var i = 0;
	if(maxDepth == 0) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			if(e == v) return i;
			i++;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var e1 = $it1.next();
			if(pony_Tools.equal(e1,v,maxDepth)) return i;
			i++;
		}
	}
	return -1;
};
pony_Tools.readStr = function(b) {
	try {
		return b.readString(b.readInt32());
	} catch( _ ) {
		haxe_CallStack.lastException = _;
		if (_ instanceof js__$Boot_HaxeError) _ = _.val;
		return null;
	}
};
var pony_events_Event = function(args,target,parent) {
	this.target = target;
	this.args = args == null?[]:args;
	this.parent = parent;
	this._stopPropagation = false;
};
pony_events_Event.__name__ = ["pony","events","Event"];
pony_events_Event.__interfaces__ = [pony_IEvent];
pony_events_Event.prototype = {
	parent: null
	,args: null
	,_stopPropagation: null
	,signal: null
	,target: null
	,currentListener: null
	,stopPropagation: function(lvl) {
		if(lvl == null) lvl = -1;
		if(this.parent != null && (lvl == -1 || lvl > 0)) this.parent.stopPropagation(lvl - 1);
		this._stopPropagation = true;
	}
	,__class__: pony_events_Event
};
var pony_events__$Listener_Listener_$Impl_$ = {};
pony_events__$Listener_Listener_$Impl_$.__name__ = ["pony","events","_Listener","Listener_Impl_"];
pony_events__$Listener_Listener_$Impl_$.call = function(this1,_event) {
	if(!pony_events__$Listener_Listener_$Impl_$.listeners.h.hasOwnProperty(this1.id)) {
		var v = { count : -1, prev : null, used : 0, active : true};
		pony_events__$Listener_Listener_$Impl_$.listeners.h[this1.id] = v;
	}
	if(!(pony_events__$Listener_Listener_$Impl_$.listeners.h.hasOwnProperty(this1.id)?pony_events__$Listener_Listener_$Impl_$.listeners.h[this1.id].active:true)) return true;
	pony_events__$Listener_Listener_$Impl_$.listeners.h[this1.id].count--;
	var l = pony_events__$Listener_Listener_$Impl_$.listeners.h[this1.id];
	_event.currentListener = l;
	var r = true;
	if(this1.event) {
		if(!this1.ret) {
			var args = [_event];
			if(args == null) args = [];
			var func = this1.f;
			var args1 = this1.args.concat(args);
			func.apply(null,args1);
		} else {
			var tmp;
			var args2 = [_event];
			if(args2 == null) args2 = [];
			var func1 = this1.f;
			var args3 = this1.args.concat(args2);
			tmp = func1.apply(null,args3);
			if(tmp == false) r = false;
		}
	} else {
		var args4 = [];
		var _g = 0;
		var _g1 = _event.args;
		while(_g < _g1.length) {
			var e = _g1[_g];
			++_g;
			args4.push(e);
		}
		args4.push(_event.target);
		args4.push(_event);
		if(!this1.ret) {
			var args5 = args4.slice(0,this1.count);
			if(args5 == null) args5 = [];
			var func2 = this1.f;
			var args6 = this1.args.concat(args5);
			func2.apply(null,args6);
		} else {
			var tmp1;
			var args7 = args4.slice(0,this1.count);
			if(args7 == null) args7 = [];
			var func3 = this1.f;
			var args8 = this1.args.concat(args7);
			tmp1 = func3.apply(null,args8);
			if(tmp1 == false) r = false;
		}
	}
	if(pony_events__$Listener_Listener_$Impl_$.listeners.h[this1.id] != null) pony_events__$Listener_Listener_$Impl_$.listeners.h[this1.id].prev = _event;
	return _event._stopPropagation?false:r;
};
var pony_events_Signal = function(target) {
	this.notMapReady = false;
	this.bindMapReady = false;
	this.subMapReady = false;
	this.readyTakeListeners = false;
	this.readyLostListeners = false;
	this.silent = false;
	this.id = pony_events_Signal.signalsCount++;
	this.target = target;
	this.listeners = new pony_Priority();
	this.lRunCopy = new List();
};
pony_events_Signal.__name__ = ["pony","events","Signal"];
pony_events_Signal.stackFilter = function(s) {
	return s.indexOf("pony.events.") == -1 && s.indexOf("Reflect.") == -1 && s.indexOf("Reflect::") == -1;
};
pony_events_Signal.prototype = {
	id: null
	,silent: null
	,lostListeners: null
	,readyLostListeners: null
	,get_lostListeners: function() {
		if(!this.readyLostListeners) {
			var tmp;
			var tmp1;
			var s = new pony_events_Signal(this);
			tmp1 = s;
			var this1 = tmp1;
			tmp = this1;
			this.lostListeners = tmp;
			this.readyLostListeners = true;
		}
		return this.lostListeners;
	}
	,takeListeners: null
	,readyTakeListeners: null
	,get_takeListeners: function() {
		if(!this.readyTakeListeners) {
			var tmp;
			var tmp1;
			var s = new pony_events_Signal(this);
			tmp1 = s;
			var this1 = tmp1;
			tmp = this1;
			this.takeListeners = tmp;
			this.readyTakeListeners = true;
		}
		return this.takeListeners;
	}
	,target: null
	,listeners: null
	,lRunCopy: null
	,subMap: null
	,subMapReady: null
	,get_subMap: function() {
		if(!this.subMapReady) {
			this.subMap = new pony_Dictionary(5);
			this.subHandlers = new haxe_ds_IntMap();
			this.subMapReady = true;
		}
		return this.subMap;
	}
	,subHandlers: null
	,bindMap: null
	,bindMapReady: null
	,get_bindMap: function() {
		if(!this.bindMapReady) {
			this.bindMap = new pony_Dictionary(5);
			this.bindHandlers = new haxe_ds_IntMap();
			this.bindMapReady = true;
		}
		return this.bindMap;
	}
	,bindHandlers: null
	,notMap: null
	,notMapReady: null
	,notHandlers: null
	,listenersBuffer: null
	,parent: null
	,add: function(listener,priority) {
		if(priority == null) priority = 0;
		if(!pony_events__$Listener_Listener_$Impl_$.listeners.h.hasOwnProperty(listener.id)) {
			var v = { count : -1, prev : null, used : 0, active : true};
			pony_events__$Listener_Listener_$Impl_$.listeners.h[listener.id] = v;
		}
		pony_events__$Listener_Listener_$Impl_$.listeners.h[listener.id].used++;
		var f = this.listeners.data.length == 0;
		this.listeners.addElement(listener,priority);
		if(f && this.readyTakeListeners) pony_events__$Signal0_Signal0_$Impl_$.dispatchEmpty(this.get_takeListeners());
		return this;
	}
	,remove: function(listener,unuse) {
		if(unuse == null) unuse = true;
		if(this.listeners.data.length == 0) return this;
		if(this.listeners.removeElement(listener)) {
			var _g_head = this.lRunCopy.h;
			var _g_val = null;
			while(_g_head != null) {
				var tmp;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				tmp = _g_val;
				var c = tmp;
				c.removeElement(listener);
			}
			if(unuse) {
				if(!pony_events__$Listener_Listener_$Impl_$.listeners.h.hasOwnProperty(listener.id)) {
					var v = { count : -1, prev : null, used : 0, active : true};
					pony_events__$Listener_Listener_$Impl_$.listeners.h[listener.id] = v;
				}
				pony_events__$Listener_Listener_$Impl_$.listeners.h[listener.id].used--;
				if(listener.used == 0) {
					pony_events__$Listener_Listener_$Impl_$.listeners.remove(listener.id);
					listener.used--;
					if(listener.used <= 0) {
						pony__$Function_Function_$Impl_$.list.remove(listener.f);
						pony__$Function_Function_$Impl_$.unusedCount--;
					}
				}
			}
			if(this.listeners.data.length == 0 && this.readyLostListeners) pony_events__$Signal0_Signal0_$Impl_$.dispatchEmpty(this.get_lostListeners());
		}
		return this;
	}
	,dispatchEvent: function(event) {
		if(this.listeners.data.length == 0) return this;
		event.signal = this;
		if(this.silent) return this;
		if(this.listenersBuffer == null) this.listenersBuffer = [];
		while(this.listenersBuffer.length > 0) this.listenersBuffer.pop();
		var _g1 = 0;
		var _g = this.listeners.data.length;
		while(_g1 < _g) {
			var k = _g1++;
			this.listenersBuffer.push(this.listeners.data[k]);
		}
		var i = 0;
		while(i < this.listenersBuffer.length) {
			var l = this.listenersBuffer[i];
			var r = false;
			try {
				r = pony_events__$Listener_Listener_$Impl_$.call(l,event);
			} catch( $e0 ) {
				haxe_CallStack.lastException = $e0;
				if ($e0 instanceof js__$Boot_HaxeError) $e0 = $e0.val;
				if( js_Boot.__instanceof($e0,Error) ) {
					var e = $e0;
					var r1 = "";
					var _g2 = 0;
					var _g11 = e.stack.split("\n");
					while(_g2 < _g11.length) {
						var s = _g11[_g2];
						++_g2;
						s = StringTools.replace(s,__dirname + "\\file:\\","");
						if(pony_events_Signal.stackFilter(s)) r1 += "" + s + "\n";
					}
					Sys.println(r1 + "\n\n\n\n");
					throw e;
				} else {
				var e1 = $e0;
				Sys.println("Listener error: " + Std.string(e1));
				var r2 = "";
				var cs = haxe_CallStack.callStack();
				cs.pop();
				var _g3 = 0;
				var _g12 = haxe_CallStack.toString(haxe_CallStack.exceptionStack().concat(cs)).split("\n");
				while(_g3 < _g12.length) {
					var s1 = _g12[_g3];
					++_g3;
					if(pony_events_Signal.stackFilter(s1)) r2 += "" + s1 + "\n";
				}
				Sys.println(r2 + "\n\n\n\n");
				throw new js__$Boot_HaxeError(e1);
				}
			}
			if((pony_events__$Listener_Listener_$Impl_$.listeners.h.hasOwnProperty(l.id)?pony_events__$Listener_Listener_$Impl_$.listeners.h[l.id].count:-1) == 0) {
				if(!(this.listeners.data.length == 0) && this.listeners.removeElement(l)) {
					HxOverrides.remove(this.listenersBuffer,l);
					if(!pony_events__$Listener_Listener_$Impl_$.listeners.h.hasOwnProperty(l.id)) {
						var v = { count : -1, prev : null, used : 0, active : true};
						pony_events__$Listener_Listener_$Impl_$.listeners.h[l.id] = v;
						v;
					}
					pony_events__$Listener_Listener_$Impl_$.listeners.h[l.id].used--;
					if(l.used == 0) {
						pony_events__$Listener_Listener_$Impl_$.listeners.remove(l.id);
						l.used--;
						if(l.used <= 0) {
							pony__$Function_Function_$Impl_$.list.remove(l.f);
							l = null;
							pony__$Function_Function_$Impl_$.unusedCount--;
						}
					}
					if(this.listeners.data.length == 0 && this.readyLostListeners) pony_events__$Signal0_Signal0_$Impl_$.dispatchEmpty(this.get_lostListeners());
					i--;
				}
			}
			if(!r) break;
			i++;
		}
		return this;
	}
	,dispatchEmpty: function() {
		this.dispatchEvent(new pony_events_Event(null,this.target));
	}
	,removeSubSignal: function(s) {
		var tmp;
		var _this = this.get_subMap();
		tmp = HxOverrides.indexOf(_this.vs,s,0);
		var i = tmp;
		if(i != -1) {
			s.remove(this.subHandlers.h[i]);
			this.subHandlers.remove(i);
			var _this1 = this.get_subMap();
			_this1.ks.splice(i,1);
			_this1.vs.splice(i,1);
		}
		var tmp1;
		var _this2 = this.get_bindMap();
		tmp1 = HxOverrides.indexOf(_this2.vs,s,0);
		var i1 = tmp1;
		if(i1 != -1) {
			s.remove(this.bindHandlers.h[i1]);
			this.bindHandlers.remove(i1);
			var _this3 = this.get_bindMap();
			_this3.ks.splice(i1,1);
			_this3.vs.splice(i1,1);
		}
		var i2 = HxOverrides.indexOf(this.notMap.vs,s,0);
		if(i2 != -1) {
			s.remove(this.notHandlers.h[i2]);
			this.notHandlers.remove(i2);
			var _this4 = this.notMap;
			_this4.ks.splice(i2,1);
			_this4.vs.splice(i2,1);
		}
	}
	,removeAllListeners: function() {
		var f = this.listeners.data.length == 0;
		var $it0 = this.listeners.iterator();
		while( $it0.hasNext() ) {
			var l = $it0.next();
			if(!pony_events__$Listener_Listener_$Impl_$.listeners.h.hasOwnProperty(l.id)) {
				var v = { count : -1, prev : null, used : 0, active : true};
				pony_events__$Listener_Listener_$Impl_$.listeners.h[l.id] = v;
			}
			pony_events__$Listener_Listener_$Impl_$.listeners.h[l.id].used--;
			if(l.used == 0) {
				pony_events__$Listener_Listener_$Impl_$.listeners.remove(l.id);
				l.used--;
				if(l.used <= 0) {
					pony__$Function_Function_$Impl_$.list.remove(l.f);
					l = null;
					pony__$Function_Function_$Impl_$.unusedCount--;
				}
			}
		}
		this.listeners.clear();
		if(!f && this.readyLostListeners) pony_events__$Signal0_Signal0_$Impl_$.dispatch(this.get_lostListeners());
		return this;
	}
	,destroy: function() {
		if(this.parent != null) this.parent.removeSubSignal(this);
		if(this.subMapReady) {
			var tmp;
			var _this = this.get_subMap();
			tmp = HxOverrides.iter(_this.vs);
			while( tmp.hasNext() ) {
				var e = tmp.next();
				e.destroy();
			}
			var _this1 = this.get_subMap();
			_this1.ks = [];
			_this1.vs = [];
			this.subMapReady = false;
			this.subMap = null;
			this.subHandlers = null;
		}
		if(this.bindMapReady) {
			var tmp1;
			var _this2 = this.get_bindMap();
			tmp1 = HxOverrides.iter(_this2.vs);
			while( tmp1.hasNext() ) {
				var e1 = tmp1.next();
				e1.destroy();
			}
			var _this3 = this.get_bindMap();
			_this3.ks = [];
			_this3.vs = [];
		}
		if(this.notMapReady) {
			var $it0 = HxOverrides.iter(this.notMap.vs);
			while( $it0.hasNext() ) {
				var e2 = $it0.next();
				e2.destroy();
			}
			var _this4 = this.notMap;
			_this4.ks = [];
			_this4.vs = [];
		}
		this.removeAllListeners();
		if(this.readyTakeListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this.get_takeListeners());
			this.takeListeners = null;
		}
		if(this.readyLostListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this.get_lostListeners());
			this.lostListeners = null;
		}
	}
	,__class__: pony_events_Signal
};
var pony_events__$Signal0_Signal0_$Impl_$ = {};
pony_events__$Signal0_Signal0_$Impl_$.__name__ = ["pony","events","_Signal0","Signal0_Impl_"];
pony_events__$Signal0_Signal0_$Impl_$.add = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.add(listener,priority);
};
pony_events__$Signal0_Signal0_$Impl_$.dispatch = function(this1) {
	this1.dispatchEmpty();
};
pony_events__$Signal0_Signal0_$Impl_$.dispatchEvent = function(this1,event) {
	this1.dispatchEvent(event);
};
pony_events__$Signal0_Signal0_$Impl_$.dispatchEmpty = function(this1) {
	this1.dispatchEmpty();
};
pony_events__$Signal0_Signal0_$Impl_$.destroy = function(this1) {
	if(this1.parent != null) this1.parent.removeSubSignal(this1);
	if(this1.subMapReady) {
		var tmp;
		var _this = this1.get_subMap();
		tmp = HxOverrides.iter(_this.vs);
		while( tmp.hasNext() ) {
			var e = tmp.next();
			e.destroy();
		}
		var _this1 = this1.get_subMap();
		_this1.ks = [];
		_this1.vs = [];
		this1.subMapReady = false;
		this1.subMap = null;
		this1.subHandlers = null;
	}
	if(this1.bindMapReady) {
		var tmp1;
		var _this2 = this1.get_bindMap();
		tmp1 = HxOverrides.iter(_this2.vs);
		while( tmp1.hasNext() ) {
			var e1 = tmp1.next();
			e1.destroy();
		}
		var _this3 = this1.get_bindMap();
		_this3.ks = [];
		_this3.vs = [];
	}
	if(this1.notMapReady) {
		var $it0 = HxOverrides.iter(this1.notMap.vs);
		while( $it0.hasNext() ) {
			var e2 = $it0.next();
			e2.destroy();
		}
		var _this4 = this1.notMap;
		_this4.ks = [];
		_this4.vs = [];
	}
	this1.removeAllListeners();
	if(this1.readyTakeListeners) {
		pony_events__$Signal0_Signal0_$Impl_$.destroy(this1.get_takeListeners());
		this1.takeListeners = null;
	}
	if(this1.readyLostListeners) {
		pony_events__$Signal0_Signal0_$Impl_$.destroy(this1.get_lostListeners());
		this1.lostListeners = null;
	}
};
var pony_events__$Signal1_Signal1_$Impl_$ = {};
pony_events__$Signal1_Signal1_$Impl_$.__name__ = ["pony","events","_Signal1","Signal1_Impl_"];
pony_events__$Signal1_Signal1_$Impl_$.add = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.add(listener,priority);
};
pony_events__$Signal1_Signal1_$Impl_$.once = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	var listener1 = listener;
	var tmp;
	var this2;
	this2 = pony__$Function_Function_$Impl_$._new(listener1.f,listener1.count,listener1.args,listener1.ret,listener1.event);
	this2.used++;
	if(!pony_events__$Listener_Listener_$Impl_$.listeners.h.hasOwnProperty(this2.id)) {
		var v = { count : 1, prev : null, used : 0, active : true};
		pony_events__$Listener_Listener_$Impl_$.listeners.h[this2.id] = v;
	}
	tmp = this2;
	this1.add(tmp,priority);
};
pony_events__$Signal1_Signal1_$Impl_$.remove = function(this1,listener,unuse) {
	if(unuse == null) unuse = true;
	this1.remove(listener,unuse);
};
pony_events__$Signal1_Signal1_$Impl_$.dispatch = function(this1,a) {
	this1.dispatchEvent(new pony_events_Event([a],this1.target));
};
pony_events__$Signal1_Signal1_$Impl_$.dispatchEvent = function(this1,event) {
	this1.dispatchEvent(event);
};
var pony_events__$Signal2_Signal2_$Impl_$ = {};
pony_events__$Signal2_Signal2_$Impl_$.__name__ = ["pony","events","_Signal2","Signal2_Impl_"];
pony_events__$Signal2_Signal2_$Impl_$.add = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.add(listener,priority);
};
pony_events__$Signal2_Signal2_$Impl_$.dispatch = function(this1,a,b) {
	this1.dispatchEvent(new pony_events_Event([a,b],this1.target));
};
var pony_events_Waiter = function() {
	this.ready = false;
	this.f = new List();
};
pony_events_Waiter.__name__ = ["pony","events","Waiter"];
pony_events_Waiter.prototype = {
	ready: null
	,f: null
	,wait: function(cb) {
		if(this.ready) cb(); else this.f.push(cb);
	}
	,end: function() {
		if(this.ready) throw new js__$Boot_HaxeError("Double ready");
		this.ready = true;
		var _g_head = this.f.h;
		var _g_val = null;
		while(_g_head != null) {
			var tmp;
			_g_val = _g_head[0];
			_g_head = _g_head[1];
			tmp = _g_val;
			var e = tmp;
			e();
		}
		this.f = null;
	}
	,__class__: pony_events_Waiter
};
var pony_net_INet = function() { };
pony_net_INet.__name__ = ["pony","net","INet"];
var pony_net_ISocketClient = function() { };
pony_net_ISocketClient.__name__ = ["pony","net","ISocketClient"];
pony_net_ISocketClient.__interfaces__ = [pony_net_INet];
var pony_net_ISocketServer = function() { };
pony_net_ISocketServer.__name__ = ["pony","net","ISocketServer"];
pony_net_ISocketServer.__interfaces__ = [pony_net_INet];
pony_net_ISocketServer.prototype = {
	onConnect: null
	,onData: null
	,onString: null
	,onDisconnect: null
	,isWithLength: null
	,__class__: pony_net_ISocketServer
};
var pony_net_SocketClientBase = function(host,port,reconnect,aIsWithLength) {
	if(aIsWithLength == null) aIsWithLength = true;
	if(reconnect == null) reconnect = -1;
	this.waitBuf = new haxe_io_BytesOutput();
	this.reconnectDelay = -1;
	var _g = this;
	pony_Logable.call(this);
	this.connected = new pony_events_Waiter();
	if(host == null) host = "127.0.0.1";
	this.host = host;
	this.port = port;
	this.reconnectDelay = reconnect;
	this.connected.wait(function() {
		_g.isAbleToSend = true;
	});
	this.isWithLength = aIsWithLength;
	this._init();
	this.open();
};
pony_net_SocketClientBase.__name__ = ["pony","net","SocketClientBase"];
pony_net_SocketClientBase.__super__ = pony_Logable;
pony_net_SocketClientBase.prototype = $extend(pony_Logable.prototype,{
	server: null
	,onData: null
	,onString: null
	,onDisconnect: null
	,id: null
	,host: null
	,port: null
	,closed: null
	,isAbleToSend: null
	,connected: null
	,isWithLength: null
	,reconnectDelay: null
	,waitNext: null
	,waitBuf: null
	,readString: function(event) {
		var b = event.args[0];
		pony_events__$Signal1_Signal1_$Impl_$.dispatch(this.onString,b.readString(b.totlen));
		if(event.parent != null) event.parent.stopPropagation(-2);
		event._stopPropagation = true;
	}
	,_init: function() {
		var _g = this;
		this.closed = true;
		this.id = -1;
		var tmp;
		var tmp3;
		var s = new pony_events_Signal(this);
		tmp3 = s;
		var this1 = tmp3;
		tmp = this1;
		this.onData = tmp;
		var tmp1;
		var tmp4;
		var s1 = new pony_events_Signal(this);
		tmp4 = s1;
		var this2 = tmp4;
		tmp1 = this2;
		this.onDisconnect = tmp1;
		var tmp2;
		var tmp5;
		var s2 = new pony_events_Signal(null);
		tmp5 = s2;
		var this3 = tmp5;
		tmp2 = this3;
		this.onString = tmp2;
		var this4 = this.onString.get_takeListeners();
		var tmp6;
		var l1 = pony__$Function_Function_$Impl_$.from(function() {
			var tmp7;
			var l = pony__$Function_Function_$Impl_$.from($bind(_g,_g.readString),1,false,true);
			tmp7 = l;
			pony_events__$Signal1_Signal1_$Impl_$.add(_g.onData,tmp7,-1000);
		},0,false);
		tmp6 = l1;
		var listener = tmp6;
		pony_events__$Signal0_Signal0_$Impl_$.add(this4,listener);
		var this5 = this.onString.get_lostListeners();
		var tmp8;
		var l3 = pony__$Function_Function_$Impl_$.from(function() {
			var tmp9;
			var l2 = pony__$Function_Function_$Impl_$.from($bind(_g,_g.readString),1,false,true);
			tmp9 = l2;
			pony_events__$Signal1_Signal1_$Impl_$.remove(_g.onData,tmp9);
		},0,false);
		tmp8 = l3;
		var listener1 = tmp8;
		pony_events__$Signal0_Signal0_$Impl_$.add(this5,listener1);
	}
	,reconnect: function() {
		if(this.reconnectDelay == 0) {
			haxe_Log.trace("Reconnect",{ fileName : "SocketClientBase.hx", lineNumber : 98, className : "pony.net.SocketClientBase", methodName : "reconnect"});
			this.open();
		} else if(this.reconnectDelay > 0) {
			haxe_Log.trace("Reconnect after " + this.reconnectDelay + " ms",{ fileName : "SocketClientBase.hx", lineNumber : 103, className : "pony.net.SocketClientBase", methodName : "reconnect"});
			haxe_Timer.delay($bind(this,this.open),this.reconnectDelay);
		}
	}
	,open: function() {
	}
	,init: function(server,id) {
		this._init();
		this.server = server;
		this.id = id;
		this.waitNext = 0;
		this.waitBuf = new haxe_io_BytesOutput();
		var tmp;
		var tmp2;
		var _e = server.onData;
		tmp2 = function(event) {
			pony_events__$Signal1_Signal1_$Impl_$.dispatchEvent(_e,event);
			return;
		};
		var l = pony__$Function_Function_$Impl_$.from(tmp2,1,false,true);
		tmp = l;
		pony_events__$Signal1_Signal1_$Impl_$.add(this.onData,tmp);
		var tmp1;
		var tmp3;
		var _e1 = server.onDisconnect;
		tmp3 = function(event1) {
			pony_events__$Signal0_Signal0_$Impl_$.dispatchEvent(_e1,event1);
			return;
		};
		var l1 = pony__$Function_Function_$Impl_$.from(tmp3,1,false,true);
		tmp1 = l1;
		pony_events__$Signal0_Signal0_$Impl_$.add(this.onDisconnect,tmp1);
		if(!(server.onString.listeners.data.length == 0)) {
			var this1 = this.onString;
			var tmp4;
			var tmp5;
			var _e2 = server.onString;
			tmp5 = function(event2) {
				pony_events__$Signal1_Signal1_$Impl_$.dispatchEvent(_e2,event2);
				return;
			};
			var l2 = pony__$Function_Function_$Impl_$.from(tmp5,1,false,true);
			tmp4 = l2;
			var listener = tmp4;
			pony_events__$Signal1_Signal1_$Impl_$.add(this1,listener);
		}
	}
	,readLength: function(bi) {
		return bi.readInt32();
	}
	,joinData: function(bi) {
		if(this.server != null) this.isWithLength = this.server.isWithLength;
		if(this.isWithLength) {
			var size = 0;
			var len = 0;
			if(_$UInt_UInt_$Impl_$.gt(this.waitNext,0)) {
				size = this.waitNext;
				len = bi.totlen;
			} else {
				size = this.readLength(bi);
				len = bi.totlen - 4;
			}
			if(_$UInt_UInt_$Impl_$.gt(size,len)) {
				this.waitNext = size - len;
				size = len;
				this.waitBuf.write(bi.read(size));
			} else if(_$UInt_UInt_$Impl_$.gt(this.waitNext,0)) {
				this.waitNext = 0;
				this.waitBuf.write(bi.read(size));
				pony_events__$Signal1_Signal1_$Impl_$.dispatch(this.onData,new haxe_io_BytesInput(this.waitBuf.getBytes()));
				this.waitBuf = new haxe_io_BytesOutput();
			} else {
				this.waitBuf = null;
				pony_events__$Signal1_Signal1_$Impl_$.dispatch(this.onData,new haxe_io_BytesInput(bi.read(size)));
			}
		} else pony_events__$Signal1_Signal1_$Impl_$.dispatch(this.onData,bi);
	}
	,destroy: function() {
		this.closed = true;
		var this1 = this.onData;
		if(this1.parent != null) this1.parent.removeSubSignal(this1);
		if(this1.subMapReady) {
			var tmp;
			var _this = this1.get_subMap();
			tmp = HxOverrides.iter(_this.vs);
			while( tmp.hasNext() ) {
				var e = tmp.next();
				e.destroy();
			}
			var _this1 = this1.get_subMap();
			_this1.ks = [];
			_this1.vs = [];
			this1.subMapReady = false;
			this1.subMap = null;
			this1.subHandlers = null;
		}
		if(this1.bindMapReady) {
			var tmp1;
			var _this2 = this1.get_bindMap();
			tmp1 = HxOverrides.iter(_this2.vs);
			while( tmp1.hasNext() ) {
				var e1 = tmp1.next();
				e1.destroy();
			}
			var _this3 = this1.get_bindMap();
			_this3.ks = [];
			_this3.vs = [];
		}
		if(this1.notMapReady) {
			var $it0 = HxOverrides.iter(this1.notMap.vs);
			while( $it0.hasNext() ) {
				var e2 = $it0.next();
				e2.destroy();
			}
			var _this4 = this1.notMap;
			_this4.ks = [];
			_this4.vs = [];
		}
		this1.removeAllListeners();
		if(this1.readyTakeListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this1.get_takeListeners());
			this1.takeListeners = null;
		}
		if(this1.readyLostListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this1.get_lostListeners());
			this1.lostListeners = null;
		}
		this.onData = null;
		var this2 = this.onString;
		if(this2.parent != null) this2.parent.removeSubSignal(this2);
		if(this2.subMapReady) {
			var tmp2;
			var _this5 = this2.get_subMap();
			tmp2 = HxOverrides.iter(_this5.vs);
			while( tmp2.hasNext() ) {
				var e3 = tmp2.next();
				e3.destroy();
			}
			var _this6 = this2.get_subMap();
			_this6.ks = [];
			_this6.vs = [];
			this2.subMapReady = false;
			this2.subMap = null;
			this2.subHandlers = null;
		}
		if(this2.bindMapReady) {
			var tmp3;
			var _this7 = this2.get_bindMap();
			tmp3 = HxOverrides.iter(_this7.vs);
			while( tmp3.hasNext() ) {
				var e4 = tmp3.next();
				e4.destroy();
			}
			var _this8 = this2.get_bindMap();
			_this8.ks = [];
			_this8.vs = [];
		}
		if(this2.notMapReady) {
			var $it1 = HxOverrides.iter(this2.notMap.vs);
			while( $it1.hasNext() ) {
				var e5 = $it1.next();
				e5.destroy();
			}
			var _this9 = this2.notMap;
			_this9.ks = [];
			_this9.vs = [];
		}
		this2.removeAllListeners();
		if(this2.readyTakeListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this2.get_takeListeners());
			this2.takeListeners = null;
		}
		if(this2.readyLostListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this2.get_lostListeners());
			this2.lostListeners = null;
		}
		this.onString = null;
	}
	,__class__: pony_net_SocketClientBase
});
var pony_net_nodejs_SocketClient = function(host,port,reconnect,aIsWithLength) {
	pony_net_SocketClientBase.call(this,host,port,reconnect,aIsWithLength);
};
pony_net_nodejs_SocketClient.__name__ = ["pony","net","nodejs","SocketClient"];
pony_net_nodejs_SocketClient.__super__ = pony_net_SocketClientBase;
pony_net_nodejs_SocketClient.prototype = $extend(pony_net_SocketClientBase.prototype,{
	socket: null
	,q: null
	,open: function() {
		this.socket = js_Node.require("net").connect(this.port,this.host);
		this.socket.on("connect",$bind(this,this.connectHandler));
		this.nodejsInit(this.socket);
	}
	,nodejsInit: function(s) {
		this.q = new pony_Queue($bind(this,this._send));
		this.socket = s;
		s.on("data",$bind(this,this.dataHandler));
		s.on("end",$bind(this,this.closeHandler));
		s.on("error",$bind(this,this.reconnect));
		this.isAbleToSend = true;
		this.closed = false;
		if(this.server != null) pony_events__$Signal1_Signal1_$Impl_$.dispatch(this.server.onConnect,this);
	}
	,closeHandler: function() {
		pony_events__$Signal0_Signal0_$Impl_$.dispatch(this.onDisconnect);
		var this1 = this.onDisconnect;
		if(this1.parent != null) this1.parent.removeSubSignal(this1);
		if(this1.subMapReady) {
			var tmp;
			var _this = this1.get_subMap();
			tmp = HxOverrides.iter(_this.vs);
			while( tmp.hasNext() ) {
				var e = tmp.next();
				e.destroy();
			}
			var _this1 = this1.get_subMap();
			_this1.ks = [];
			_this1.vs = [];
			this1.subMapReady = false;
			this1.subMap = null;
			this1.subHandlers = null;
		}
		if(this1.bindMapReady) {
			var tmp1;
			var _this2 = this1.get_bindMap();
			tmp1 = HxOverrides.iter(_this2.vs);
			while( tmp1.hasNext() ) {
				var e1 = tmp1.next();
				e1.destroy();
			}
			var _this3 = this1.get_bindMap();
			_this3.ks = [];
			_this3.vs = [];
		}
		if(this1.notMapReady) {
			var $it0 = HxOverrides.iter(this1.notMap.vs);
			while( $it0.hasNext() ) {
				var e2 = $it0.next();
				e2.destroy();
			}
			var _this4 = this1.notMap;
			_this4.ks = [];
			_this4.vs = [];
		}
		this1.removeAllListeners();
		if(this1.readyTakeListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this1.get_takeListeners());
			this1.takeListeners = null;
		}
		if(this1.readyLostListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this1.get_lostListeners());
			this1.lostListeners = null;
		}
		this.onDisconnect = null;
	}
	,connectHandler: function() {
		this.closed = false;
		this.connected.end();
	}
	,send: function(data) {
		this.q.call(data);
	}
	,_send: function(data) {
		var tmp;
		var _this = data.getBytes();
		tmp = _this.b;
		this.socket.write(tmp,null,($_=this.q,$bind($_,$_.next)));
	}
	,dataHandler: function(d) {
		this.joinData(new haxe_io_BytesInput(haxe_io_Bytes.ofData(d)));
	}
	,destroy: function() {
		pony_net_SocketClientBase.prototype.destroy.call(this);
		this.socket.end();
		this.socket = null;
		this.closed = true;
	}
	,__class__: pony_net_nodejs_SocketClient
});
var pony_net_SocketClient = function(host,port,reconnect,aIsWithLength) {
	pony_net_nodejs_SocketClient.call(this,host,port,reconnect,aIsWithLength);
};
pony_net_SocketClient.__name__ = ["pony","net","SocketClient"];
pony_net_SocketClient.__interfaces__ = [pony_net_ISocketClient];
pony_net_SocketClient.__super__ = pony_net_nodejs_SocketClient;
pony_net_SocketClient.prototype = $extend(pony_net_nodejs_SocketClient.prototype,{
	writeLength: function(bo,length) {
		bo.writeInt32(length);
	}
	,send: function(data) {
		var bo = new haxe_io_BytesOutput();
		if(this.isWithLength) this.writeLength(bo,data.b.b.length);
		bo.write(data.getBytes());
		pony_net_nodejs_SocketClient.prototype.send.call(this,bo);
	}
	,__class__: pony_net_SocketClient
});
var pony_net_SocketServerBase = function() {
	this.isWithLength = true;
	this.isAbleToSend = false;
	var _g = this;
	pony_Logable.call(this);
	var tmp;
	var tmp5;
	var s = new pony_events_Signal(this);
	tmp5 = s;
	var this1 = tmp5;
	tmp = this1;
	this.onConnect = tmp;
	var tmp1;
	var s1 = new pony_events_Signal();
	tmp1 = s1;
	this.onDisconnect = tmp1;
	var tmp2;
	var tmp6;
	var s2 = new pony_events_Signal(null);
	tmp6 = s2;
	var this2 = tmp6;
	tmp2 = this2;
	this.onData = tmp2;
	var tmp3;
	var tmp7;
	var s3 = new pony_events_Signal(null);
	tmp7 = s3;
	var this3 = tmp7;
	tmp3 = this3;
	this.onString = tmp3;
	var this4 = this.onString.get_takeListeners();
	var tmp8;
	var l = pony__$Function_Function_$Impl_$.from($bind(this,this.beginString),0,false);
	tmp8 = l;
	var listener = tmp8;
	pony_events__$Signal0_Signal0_$Impl_$.add(this4,listener);
	var this5 = this.onString.get_lostListeners();
	var tmp9;
	var l1 = pony__$Function_Function_$Impl_$.from($bind(this,this.endString),0,false);
	tmp9 = l1;
	var listener1 = tmp9;
	pony_events__$Signal0_Signal0_$Impl_$.add(this5,listener1);
	this.onClose = new pony_events_Signal(this);
	this.clients = [];
	var tmp4;
	var l2 = pony__$Function_Function_$Impl_$.from($bind(this,this.removeClient),1,false);
	tmp4 = l2;
	pony_events__$Signal0_Signal0_$Impl_$.add(this.onDisconnect,tmp4);
	var this6 = this.onConnect;
	var tmp10;
	var l3 = pony__$Function_Function_$Impl_$.from(function() {
		_g.isAbleToSend = true;
	},0,false);
	tmp10 = l3;
	var listener2 = tmp10;
	pony_events__$Signal1_Signal1_$Impl_$.once(this6,listener2);
};
pony_net_SocketServerBase.__name__ = ["pony","net","SocketServerBase"];
pony_net_SocketServerBase.__super__ = pony_Logable;
pony_net_SocketServerBase.prototype = $extend(pony_Logable.prototype,{
	onData: null
	,onString: null
	,onConnect: null
	,onClose: null
	,onDisconnect: null
	,clients: null
	,isAbleToSend: null
	,isWithLength: null
	,beginString: function() {
		var _g = 0;
		var _g1 = this.clients;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			var this1 = c.onString;
			var tmp;
			var tmp1;
			var _e = [this.onString];
			tmp1 = (function(_e) {
				return function(event) {
					pony_events__$Signal1_Signal1_$Impl_$.dispatchEvent(_e[0],event);
					return;
				};
			})(_e);
			var l = pony__$Function_Function_$Impl_$.from(tmp1,1,false,true);
			tmp = l;
			var listener = tmp;
			pony_events__$Signal1_Signal1_$Impl_$.add(this1,listener);
		}
	}
	,endString: function() {
		var _g = 0;
		var _g1 = this.clients;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			var this1 = c.onString;
			var tmp;
			var tmp1;
			var _e = [this.onString];
			tmp1 = (function(_e) {
				return function(event) {
					pony_events__$Signal1_Signal1_$Impl_$.dispatchEvent(_e[0],event);
					return;
				};
			})(_e);
			var l = pony__$Function_Function_$Impl_$.from(tmp1,1,false,true);
			tmp = l;
			var listener = tmp;
			pony_events__$Signal1_Signal1_$Impl_$.remove(this1,listener);
		}
	}
	,addClient: function() {
		var cl = Type.createEmptyInstance(pony_net_SocketClient);
		cl.isWithLength = this.isWithLength;
		cl.init(this,this.clients.length);
		this.clients.push(cl);
		return cl;
	}
	,removeClient: function(cl) {
		HxOverrides.remove(this.clients,cl);
	}
	,destroy: function() {
		var _this = this.onClose;
		_this.dispatchEvent(new pony_events_Event([],_this.target));
		var this1 = this.onData;
		if(this1.parent != null) this1.parent.removeSubSignal(this1);
		if(this1.subMapReady) {
			var tmp;
			var _this1 = this1.get_subMap();
			tmp = HxOverrides.iter(_this1.vs);
			while( tmp.hasNext() ) {
				var e = tmp.next();
				e.destroy();
			}
			var _this2 = this1.get_subMap();
			_this2.ks = [];
			_this2.vs = [];
			this1.subMapReady = false;
			this1.subMap = null;
			this1.subHandlers = null;
		}
		if(this1.bindMapReady) {
			var tmp1;
			var _this3 = this1.get_bindMap();
			tmp1 = HxOverrides.iter(_this3.vs);
			while( tmp1.hasNext() ) {
				var e1 = tmp1.next();
				e1.destroy();
			}
			var _this4 = this1.get_bindMap();
			_this4.ks = [];
			_this4.vs = [];
		}
		if(this1.notMapReady) {
			var $it0 = HxOverrides.iter(this1.notMap.vs);
			while( $it0.hasNext() ) {
				var e2 = $it0.next();
				e2.destroy();
			}
			var _this5 = this1.notMap;
			_this5.ks = [];
			_this5.vs = [];
		}
		this1.removeAllListeners();
		if(this1.readyTakeListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this1.get_takeListeners());
			this1.takeListeners = null;
		}
		if(this1.readyLostListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this1.get_lostListeners());
			this1.lostListeners = null;
		}
		this.onData = null;
		var this2 = this.onString;
		if(this2.parent != null) this2.parent.removeSubSignal(this2);
		if(this2.subMapReady) {
			var tmp2;
			var _this6 = this2.get_subMap();
			tmp2 = HxOverrides.iter(_this6.vs);
			while( tmp2.hasNext() ) {
				var e3 = tmp2.next();
				e3.destroy();
			}
			var _this7 = this2.get_subMap();
			_this7.ks = [];
			_this7.vs = [];
			this2.subMapReady = false;
			this2.subMap = null;
			this2.subHandlers = null;
		}
		if(this2.bindMapReady) {
			var tmp3;
			var _this8 = this2.get_bindMap();
			tmp3 = HxOverrides.iter(_this8.vs);
			while( tmp3.hasNext() ) {
				var e4 = tmp3.next();
				e4.destroy();
			}
			var _this9 = this2.get_bindMap();
			_this9.ks = [];
			_this9.vs = [];
		}
		if(this2.notMapReady) {
			var $it1 = HxOverrides.iter(this2.notMap.vs);
			while( $it1.hasNext() ) {
				var e5 = $it1.next();
				e5.destroy();
			}
			var _this10 = this2.notMap;
			_this10.ks = [];
			_this10.vs = [];
		}
		this2.removeAllListeners();
		if(this2.readyTakeListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this2.get_takeListeners());
			this2.takeListeners = null;
		}
		if(this2.readyLostListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this2.get_lostListeners());
			this2.lostListeners = null;
		}
		this.onString = null;
		var this3 = this.onConnect;
		if(this3.parent != null) this3.parent.removeSubSignal(this3);
		if(this3.subMapReady) {
			var tmp4;
			var _this11 = this3.get_subMap();
			tmp4 = HxOverrides.iter(_this11.vs);
			while( tmp4.hasNext() ) {
				var e6 = tmp4.next();
				e6.destroy();
			}
			var _this12 = this3.get_subMap();
			_this12.ks = [];
			_this12.vs = [];
			this3.subMapReady = false;
			this3.subMap = null;
			this3.subHandlers = null;
		}
		if(this3.bindMapReady) {
			var tmp5;
			var _this13 = this3.get_bindMap();
			tmp5 = HxOverrides.iter(_this13.vs);
			while( tmp5.hasNext() ) {
				var e7 = tmp5.next();
				e7.destroy();
			}
			var _this14 = this3.get_bindMap();
			_this14.ks = [];
			_this14.vs = [];
		}
		if(this3.notMapReady) {
			var $it2 = HxOverrides.iter(this3.notMap.vs);
			while( $it2.hasNext() ) {
				var e8 = $it2.next();
				e8.destroy();
			}
			var _this15 = this3.notMap;
			_this15.ks = [];
			_this15.vs = [];
		}
		this3.removeAllListeners();
		if(this3.readyTakeListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this3.get_takeListeners());
			this3.takeListeners = null;
		}
		if(this3.readyLostListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this3.get_lostListeners());
			this3.lostListeners = null;
		}
		this.onConnect = null;
		var _this16 = this.onClose;
		if(_this16.parent != null) _this16.parent.removeSubSignal(_this16);
		if(_this16.subMapReady) {
			var tmp6;
			var _this17 = _this16.get_subMap();
			tmp6 = HxOverrides.iter(_this17.vs);
			while( tmp6.hasNext() ) {
				var e9 = tmp6.next();
				e9.destroy();
			}
			var _this18 = _this16.get_subMap();
			_this18.ks = [];
			_this18.vs = [];
			_this16.subMapReady = false;
			_this16.subMap = null;
			_this16.subHandlers = null;
		}
		if(_this16.bindMapReady) {
			var tmp7;
			var _this19 = _this16.get_bindMap();
			tmp7 = HxOverrides.iter(_this19.vs);
			while( tmp7.hasNext() ) {
				var e10 = tmp7.next();
				e10.destroy();
			}
			var _this20 = _this16.get_bindMap();
			_this20.ks = [];
			_this20.vs = [];
		}
		if(_this16.notMapReady) {
			var $it3 = HxOverrides.iter(_this16.notMap.vs);
			while( $it3.hasNext() ) {
				var e11 = $it3.next();
				e11.destroy();
			}
			var _this21 = _this16.notMap;
			_this21.ks = [];
			_this21.vs = [];
		}
		_this16.removeAllListeners();
		if(_this16.readyTakeListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(_this16.get_takeListeners());
			_this16.takeListeners = null;
		}
		if(_this16.readyLostListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(_this16.get_lostListeners());
			_this16.lostListeners = null;
		}
		this.onClose = null;
		var this4 = this.onDisconnect;
		if(this4.parent != null) this4.parent.removeSubSignal(this4);
		if(this4.subMapReady) {
			var tmp8;
			var _this22 = this4.get_subMap();
			tmp8 = HxOverrides.iter(_this22.vs);
			while( tmp8.hasNext() ) {
				var e12 = tmp8.next();
				e12.destroy();
			}
			var _this23 = this4.get_subMap();
			_this23.ks = [];
			_this23.vs = [];
			this4.subMapReady = false;
			this4.subMap = null;
			this4.subHandlers = null;
		}
		if(this4.bindMapReady) {
			var tmp9;
			var _this24 = this4.get_bindMap();
			tmp9 = HxOverrides.iter(_this24.vs);
			while( tmp9.hasNext() ) {
				var e13 = tmp9.next();
				e13.destroy();
			}
			var _this25 = this4.get_bindMap();
			_this25.ks = [];
			_this25.vs = [];
		}
		if(this4.notMapReady) {
			var $it4 = HxOverrides.iter(this4.notMap.vs);
			while( $it4.hasNext() ) {
				var e14 = $it4.next();
				e14.destroy();
			}
			var _this26 = this4.notMap;
			_this26.ks = [];
			_this26.vs = [];
		}
		this4.removeAllListeners();
		if(this4.readyTakeListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this4.get_takeListeners());
			this4.takeListeners = null;
		}
		if(this4.readyLostListeners) {
			pony_events__$Signal0_Signal0_$Impl_$.destroy(this4.get_lostListeners());
			this4.lostListeners = null;
		}
		this.onDisconnect = null;
	}
	,__class__: pony_net_SocketServerBase
});
var pony_net_nodejs_SocketServer = function(port) {
	pony_net_SocketServerBase.call(this);
	this.server = js_Node.require("net").createServer(null,null);
	this.server.listen(port,null,$bind(this,this.bound));
	this.server.on("connection",$bind(this,this.connectionHandler));
};
pony_net_nodejs_SocketServer.__name__ = ["pony","net","nodejs","SocketServer"];
pony_net_nodejs_SocketServer.__super__ = pony_net_SocketServerBase;
pony_net_nodejs_SocketServer.prototype = $extend(pony_net_SocketServerBase.prototype,{
	server: null
	,bound: function() {
		var s = "bound " + Std.string(this.server.address());
		pony_events__$Signal2_Signal2_$Impl_$.dispatch(this.log,s,{ fileName : "SocketServer.hx", lineNumber : 48, className : "pony.net.nodejs.SocketServer", methodName : "bound"});
	}
	,connectionHandler: function(c) {
		this.addClient().nodejsInit(c);
	}
	,destroy: function() {
		pony_net_SocketServerBase.prototype.destroy.call(this);
		this.server.close(null);
		this.server = null;
	}
	,__class__: pony_net_nodejs_SocketServer
});
var pony_net_SocketServer = function(port) {
	pony_net_nodejs_SocketServer.call(this,port);
};
pony_net_SocketServer.__name__ = ["pony","net","SocketServer"];
pony_net_SocketServer.__interfaces__ = [pony_net_ISocketServer];
pony_net_SocketServer.__super__ = pony_net_nodejs_SocketServer;
pony_net_SocketServer.prototype = $extend(pony_net_nodejs_SocketServer.prototype,{
	__class__: pony_net_SocketServer
});
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
String.prototype.__class__ = String;
String.__name__ = ["String"];
Array.__name__ = ["Array"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
pony__$Function_Function_$Impl_$.unusedCount = 0;
pony__$Function_Function_$Impl_$.list = new pony_Dictionary(0);
pony__$Function_Function_$Impl_$.counter = -1;
pony__$Function_Function_$Impl_$.searchFree = false;
pony_events__$Listener_Listener_$Impl_$.listeners = new haxe_ds_IntMap();
pony_events_Signal.signalsCount = 0;
Main.testCount = 500;
Main.delay = 1;
Main.port = 16001;
Main.partCount = Main.testCount / 4 | 0;
Main.blockCount = Main.testCount / 2 | 0;
js_Boot.__toStr = {}.toString;
js_Node.require = require;
pony_AsyncTests.assertList = new List();
pony_AsyncTests.testCount = 0;
pony_AsyncTests.complite = false;
pony_AsyncTests.dec = "----------";
pony_AsyncTests.waitList = new List();
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});

//# sourceMappingURL=main.js.map