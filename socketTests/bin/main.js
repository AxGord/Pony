(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
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
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
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
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,__class__: List
};
var Main = function() { };
Main.__name__ = ["Main"];
Main.main = function() {
	js.Node.require("source-map-support").install();
	if(Main.testCount % 4 != 0) throw "Wrong test count";
	pony.AsyncTests.init(Main.testCount);
	Main.firstTest();
};
Main.firstTest = function() {
	var server = Main.createServer(6001);
	var _g1 = 0;
	var _g = Main.partCount;
	while(_g1 < _g) {
		var i = _g1++;
		haxe.Timer.delay((function(f,i1) {
			return function() {
				return f(i1);
			};
		})(Main.createClient,i),Main.delay + Main.delay * i);
	}
	pony.AsyncTests.wait(new IntIterator(0,Main.blockCount),function() {
		haxe.Log.trace("Second part",{ fileName : "Main.hx", lineNumber : 73, className : "Main", methodName : "firstTest"});
		var server1 = Main.createServer(6002);
		var _g11 = Main.blockCount;
		var _g2 = Main.blockCount + Main.partCount;
		while(_g11 < _g2) {
			var i2 = _g11++;
			haxe.Timer.delay((function(f1,i3) {
				return function() {
					return f1(i3);
				};
			})(Main.createClient,i2),Main.delay + Main.delay * (i2 - Main.blockCount));
		}
	});
};
Main.createServer = function(aPort) {
	Main.port = aPort;
	var server = new pony.net.SocketServer(aPort);
	var this1 = server.onConnect;
	var listener;
	var l;
	var f = pony._Function.Function_Impl_.from(function(cl) {
		var bo = new haxe.io.BytesOutput();
		var s = "hi world";
		bo.writeInt32(s.length);
		bo.writeString(s);
		haxe.Log.trace(bo.b.b.length,{ fileName : "Main.hx", lineNumber : 90, className : "Main", methodName : "createServer"});
		cl.send(bo);
	},1,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f);
	listener = l;
	pony.events._Signal1.Signal1_Impl_.add(this1,listener);
	this1;
	var this2 = server.onData;
	var listener1;
	var l1;
	var f1 = pony._Function.Function_Impl_.from(function(bi) {
		var i = bi.readInt32();
		pony.AsyncTests.equals("hello user",pony.Tools.readStr(bi),{ fileName : "Main.hx", lineNumber : 96, className : "Main", methodName : "createServer"});
		pony.AsyncTests.setFlag(Main.partCount + i,{ fileName : "Main.hx", lineNumber : 97, className : "Main", methodName : "createServer"});
	},1,false);
	l1 = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	listener1 = l1;
	pony.events._Signal1.Signal1_Impl_.add(this2,listener1);
	this2;
	return server;
};
Main.createClient = function(i) {
	var client = new pony.net.SocketClient(null,Main.port);
	var this1 = client.onData;
	var listener;
	var l;
	var f = pony._Function.Function_Impl_.from(function(data) {
		var s = pony.Tools.readStr(data);
		if(s == null) throw "wrong data";
		pony.AsyncTests.assertList.push({ a : s, b : "hi world", pos : { fileName : "Main.hx", lineNumber : 109, className : "Main", methodName : "createClient"}});
		var bo = new haxe.io.BytesOutput();
		bo.writeInt32(i);
		bo.writeInt32("hello user".length);
		bo.writeString("hello user");
		client.send(bo);
		pony.AsyncTests.setFlag(i,{ fileName : "Main.hx", lineNumber : 114, className : "Main", methodName : "createClient"});
	},1,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f);
	listener = l;
	pony.events._Signal1.Signal1_Impl_.once(this1,listener);
	this1;
	return client;
};
var IMap = function() { };
IMap.__name__ = ["IMap"];
Math.__name__ = ["Math"];
var Reflect = function() { };
Reflect.__name__ = ["Reflect"];
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
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
Reflect.compare = function(a,b) {
	if(a == b) return 0; else if(a > b) return 1; else return -1;
};
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
};
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && v.__enum__ == null || t == "function" && (v.__name__ || v.__ename__) != null;
};
Reflect.isEnumValue = function(v) {
	return v != null && v.__enum__ != null;
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
	return js.Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
Std.parseFloat = function(x) {
	return parseFloat(x);
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	b: null
	,add: function(x) {
		this.b += Std.string(x);
	}
	,addSub: function(s,pos,len) {
		if(len == null) this.b += HxOverrides.substr(s,pos,null); else this.b += HxOverrides.substr(s,pos,len);
	}
	,__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = ["StringTools"];
StringTools.htmlEscape = function(s,quotes) {
	s = s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
	if(quotes) return s.split("\"").join("&quot;").split("'").join("&#039;"); else return s;
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
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
};
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
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
Type.getClass = function(o) {
	if(o == null) return null;
	return js.Boot.getClass(o);
};
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
		var c = js.Boot.getClass(v);
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
Type.enumParameters = function(e) {
	return e.slice(2);
};
Type.enumIndex = function(e) {
	return e[1];
};
var XmlType = { __ename__ : true, __constructs__ : [] };
var Xml = function() {
};
Xml.__name__ = ["Xml"];
Xml.parse = function(str) {
	return haxe.xml.Parser.parse(str);
};
Xml.createElement = function(name) {
	var r = new Xml();
	r.nodeType = Xml.Element;
	r._children = new Array();
	r._attributes = new haxe.ds.StringMap();
	r.set_nodeName(name);
	return r;
};
Xml.createPCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.PCData;
	r.set_nodeValue(data);
	return r;
};
Xml.createCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.CData;
	r.set_nodeValue(data);
	return r;
};
Xml.createComment = function(data) {
	var r = new Xml();
	r.nodeType = Xml.Comment;
	r.set_nodeValue(data);
	return r;
};
Xml.createDocType = function(data) {
	var r = new Xml();
	r.nodeType = Xml.DocType;
	r.set_nodeValue(data);
	return r;
};
Xml.createProcessingInstruction = function(data) {
	var r = new Xml();
	r.nodeType = Xml.ProcessingInstruction;
	r.set_nodeValue(data);
	return r;
};
Xml.createDocument = function() {
	var r = new Xml();
	r.nodeType = Xml.Document;
	r._children = new Array();
	return r;
};
Xml.prototype = {
	nodeType: null
	,_nodeName: null
	,_nodeValue: null
	,_attributes: null
	,_children: null
	,_parent: null
	,get_nodeName: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName;
	}
	,set_nodeName: function(n) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName = n;
	}
	,set_nodeValue: function(v) {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue = v;
	}
	,get: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.get(att);
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.set(att,value);
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.exists(att);
	}
	,addChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) HxOverrides.remove(x._parent._children,x);
		x._parent = this;
		this._children.push(x);
	}
	,__class__: Xml
};
var haxe = {};
haxe.StackItem = { __ename__ : true, __constructs__ : ["CFunction","Module","FilePos","Method","LocalFunction"] };
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; };
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; };
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; };
haxe.StackItem.LocalFunction = function(v) { var $x = ["LocalFunction",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; };
haxe.CallStack = function() { };
haxe.CallStack.__name__ = ["haxe","CallStack"];
haxe.CallStack.exceptionStack = function() {
	return [];
};
haxe.CallStack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b += "\nCalled from ";
		haxe.CallStack.itemToString(b,s);
	}
	return b.b;
};
haxe.CallStack.itemToString = function(b,s) {
	switch(s[1]) {
	case 0:
		b.b += "a C function";
		break;
	case 1:
		var m = s[2];
		b.b += "module ";
		if(m == null) b.b += "null"; else b.b += "" + m;
		break;
	case 2:
		var line = s[4];
		var file = s[3];
		var s1 = s[2];
		if(s1 != null) {
			haxe.CallStack.itemToString(b,s1);
			b.b += " (";
		}
		if(file == null) b.b += "null"; else b.b += "" + file;
		b.b += " line ";
		if(line == null) b.b += "null"; else b.b += "" + line;
		if(s1 != null) b.b += ")";
		break;
	case 3:
		var meth = s[3];
		var cname = s[2];
		if(cname == null) b.b += "null"; else b.b += "" + cname;
		b.b += ".";
		if(meth == null) b.b += "null"; else b.b += "" + meth;
		break;
	case 4:
		var n = s[2];
		b.b += "local function #";
		if(n == null) b.b += "null"; else b.b += "" + n;
		break;
	}
};
haxe.Log = function() { };
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe.Timer.prototype = {
	id: null
	,stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe.Timer
};
haxe.ds = {};
haxe.ds.BalancedTree = function() {
};
haxe.ds.BalancedTree.__name__ = ["haxe","ds","BalancedTree"];
haxe.ds.BalancedTree.prototype = {
	root: null
	,set: function(key,value) {
		this.root = this.setLoop(key,value,this.root);
	}
	,get: function(key) {
		var node = this.root;
		while(node != null) {
			var c = this.compare(key,node.key);
			if(c == 0) return node.value;
			if(c < 0) node = node.left; else node = node.right;
		}
		return null;
	}
	,keys: function() {
		var ret = [];
		this.keysLoop(this.root,ret);
		return HxOverrides.iter(ret);
	}
	,setLoop: function(k,v,node) {
		if(node == null) return new haxe.ds.TreeNode(null,k,v,null);
		var c = this.compare(k,node.key);
		if(c == 0) return new haxe.ds.TreeNode(node.left,k,v,node.right,node == null?0:node._height); else if(c < 0) {
			var nl = this.setLoop(k,v,node.left);
			return this.balance(nl,node.key,node.value,node.right);
		} else {
			var nr = this.setLoop(k,v,node.right);
			return this.balance(node.left,node.key,node.value,nr);
		}
	}
	,keysLoop: function(node,acc) {
		if(node != null) {
			this.keysLoop(node.left,acc);
			acc.push(node.key);
			this.keysLoop(node.right,acc);
		}
	}
	,balance: function(l,k,v,r) {
		var hl;
		if(l == null) hl = 0; else hl = l._height;
		var hr;
		if(r == null) hr = 0; else hr = r._height;
		if(hl > hr + 2) {
			if((function($this) {
				var $r;
				var _this = l.left;
				$r = _this == null?0:_this._height;
				return $r;
			}(this)) >= (function($this) {
				var $r;
				var _this1 = l.right;
				$r = _this1 == null?0:_this1._height;
				return $r;
			}(this))) return new haxe.ds.TreeNode(l.left,l.key,l.value,new haxe.ds.TreeNode(l.right,k,v,r)); else return new haxe.ds.TreeNode(new haxe.ds.TreeNode(l.left,l.key,l.value,l.right.left),l.right.key,l.right.value,new haxe.ds.TreeNode(l.right.right,k,v,r));
		} else if(hr > hl + 2) {
			if((function($this) {
				var $r;
				var _this2 = r.right;
				$r = _this2 == null?0:_this2._height;
				return $r;
			}(this)) > (function($this) {
				var $r;
				var _this3 = r.left;
				$r = _this3 == null?0:_this3._height;
				return $r;
			}(this))) return new haxe.ds.TreeNode(new haxe.ds.TreeNode(l,k,v,r.left),r.key,r.value,r.right); else return new haxe.ds.TreeNode(new haxe.ds.TreeNode(l,k,v,r.left.left),r.left.key,r.left.value,new haxe.ds.TreeNode(r.left.right,r.key,r.value,r.right));
		} else return new haxe.ds.TreeNode(l,k,v,r,(hl > hr?hl:hr) + 1);
	}
	,compare: function(k1,k2) {
		return Reflect.compare(k1,k2);
	}
	,__class__: haxe.ds.BalancedTree
};
haxe.ds.TreeNode = function(l,k,v,r,h) {
	if(h == null) h = -1;
	this.left = l;
	this.key = k;
	this.value = v;
	this.right = r;
	if(h == -1) this._height = ((function($this) {
		var $r;
		var _this = $this.left;
		$r = _this == null?0:_this._height;
		return $r;
	}(this)) > (function($this) {
		var $r;
		var _this1 = $this.right;
		$r = _this1 == null?0:_this1._height;
		return $r;
	}(this))?(function($this) {
		var $r;
		var _this2 = $this.left;
		$r = _this2 == null?0:_this2._height;
		return $r;
	}(this)):(function($this) {
		var $r;
		var _this3 = $this.right;
		$r = _this3 == null?0:_this3._height;
		return $r;
	}(this))) + 1; else this._height = h;
};
haxe.ds.TreeNode.__name__ = ["haxe","ds","TreeNode"];
haxe.ds.TreeNode.prototype = {
	left: null
	,right: null
	,key: null
	,value: null
	,_height: null
	,__class__: haxe.ds.TreeNode
};
haxe.ds.EnumValueMap = function() {
	haxe.ds.BalancedTree.call(this);
};
haxe.ds.EnumValueMap.__name__ = ["haxe","ds","EnumValueMap"];
haxe.ds.EnumValueMap.__interfaces__ = [IMap];
haxe.ds.EnumValueMap.__super__ = haxe.ds.BalancedTree;
haxe.ds.EnumValueMap.prototype = $extend(haxe.ds.BalancedTree.prototype,{
	compare: function(k1,k2) {
		var d = k1[1] - k2[1];
		if(d != 0) return d;
		var p1 = k1.slice(2);
		var p2 = k2.slice(2);
		if(p1.length == 0 && p2.length == 0) return 0;
		return this.compareArgs(p1,p2);
	}
	,compareArgs: function(a1,a2) {
		var ld = a1.length - a2.length;
		if(ld != 0) return ld;
		var _g1 = 0;
		var _g = a1.length;
		while(_g1 < _g) {
			var i = _g1++;
			var d = this.compareArg(a1[i],a2[i]);
			if(d != 0) return d;
		}
		return 0;
	}
	,compareArg: function(v1,v2) {
		if(Reflect.isEnumValue(v1) && Reflect.isEnumValue(v2)) return this.compare(v1,v2); else if((v1 instanceof Array) && v1.__enum__ == null && ((v2 instanceof Array) && v2.__enum__ == null)) return this.compareArgs(v1,v2); else return Reflect.compare(v1,v2);
	}
	,__class__: haxe.ds.EnumValueMap
});
haxe.ds.IntMap = function() {
	this.h = { };
};
haxe.ds.IntMap.__name__ = ["haxe","ds","IntMap"];
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	h: null
	,set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
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
	,__class__: haxe.ds.IntMap
};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = ["haxe","ds","StringMap"];
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	h: null
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,__class__: haxe.ds.StringMap
};
haxe.io = {};
haxe.io.Bytes = function(length,b) {
	this.length = length;
	this.b = b;
};
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.alloc = function(length) {
	return new haxe.io.Bytes(length,new Buffer(length));
};
haxe.io.Bytes.ofString = function(s) {
	var nb = new Buffer(s,"utf8");
	return new haxe.io.Bytes(nb.length,nb);
};
haxe.io.Bytes.ofData = function(b) {
	return new haxe.io.Bytes(b.length,b);
};
haxe.io.Bytes.prototype = {
	length: null
	,b: null
	,get: function(pos) {
		return this.b[pos];
	}
	,set: function(pos,v) {
		this.b[pos] = v;
	}
	,blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io.Error.OutsideBounds;
		src.b.copy(this.b,pos,srcpos,srcpos + len);
	}
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		var nb = new Buffer(len);
		var slice = this.b.slice(pos,pos + len);
		slice.copy(nb,0,0,len);
		return new haxe.io.Bytes(len,nb);
	}
	,compare: function(other) {
		var b1 = this.b;
		var b2 = other.b;
		var len;
		if(this.length < other.length) len = this.length; else len = other.length;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			if(b1[i] != b2[i]) return b1[i] - b2[i];
		}
		return this.length - other.length;
	}
	,readString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
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
		return this.readString(0,this.length);
	}
	,toHex: function() {
		var s = new StringBuf();
		var chars = [];
		var str = "0123456789abcdef";
		var _g1 = 0;
		var _g = str.length;
		while(_g1 < _g) {
			var i = _g1++;
			chars.push(HxOverrides.cca(str,i));
		}
		var _g11 = 0;
		var _g2 = this.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			var c = this.b[i1];
			s.b += String.fromCharCode(chars[c >> 4]);
			s.b += String.fromCharCode(chars[c & 15]);
		}
		return s.b;
	}
	,getData: function() {
		return this.b;
	}
	,__class__: haxe.io.Bytes
};
haxe.io.BytesBuffer = function() {
	this.b = new Array();
};
haxe.io.BytesBuffer.__name__ = ["haxe","io","BytesBuffer"];
haxe.io.BytesBuffer.prototype = {
	b: null
	,get_length: function() {
		return this.b.length;
	}
	,addByte: function($byte) {
		this.b.push($byte);
	}
	,add: function(src) {
		var b1 = this.b;
		var b2 = src.b;
		var _g1 = 0;
		var _g = src.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.b.push(b2[i]);
		}
	}
	,addBytes: function(src,pos,len) {
		if(pos < 0 || len < 0 || pos + len > src.length) throw haxe.io.Error.OutsideBounds;
		var b1 = this.b;
		var b2 = src.b;
		var _g1 = pos;
		var _g = pos + len;
		while(_g1 < _g) {
			var i = _g1++;
			this.b.push(b2[i]);
		}
	}
	,getBytes: function() {
		var nb = new Buffer(this.b);
		var bytes = new haxe.io.Bytes(nb.length,nb);
		this.b = null;
		return bytes;
	}
	,__class__: haxe.io.BytesBuffer
};
haxe.io.Input = function() { };
haxe.io.Input.__name__ = ["haxe","io","Input"];
haxe.io.Input.prototype = {
	bigEndian: null
	,readByte: function() {
		throw "Not implemented";
	}
	,readBytes: function(s,pos,len) {
		var k = len;
		var b = s.b;
		if(pos < 0 || len < 0 || pos + len > s.length) throw haxe.io.Error.OutsideBounds;
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
		var s = haxe.io.Bytes.alloc(nbytes);
		var p = 0;
		while(nbytes > 0) {
			var k = this.readBytes(s,p,nbytes);
			if(k == 0) throw haxe.io.Error.Blocked;
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
		if(this.bigEndian) return ch4 | ch3 << 8 | ch2 << 16 | ch1 << 24; else return ch1 | ch2 << 8 | ch3 << 16 | ch4 << 24;
	}
	,readString: function(len) {
		var b = haxe.io.Bytes.alloc(len);
		this.readFullBytes(b,0,len);
		return b.toString();
	}
	,__class__: haxe.io.Input
};
haxe.io.BytesInput = function(b,pos,len) {
	if(pos == null) pos = 0;
	if(len == null) len = b.length - pos;
	if(pos < 0 || len < 0 || pos + len > b.length) throw haxe.io.Error.OutsideBounds;
	this.b = b.b;
	this.pos = pos;
	this.len = len;
	this.totlen = len;
};
haxe.io.BytesInput.__name__ = ["haxe","io","BytesInput"];
haxe.io.BytesInput.__super__ = haxe.io.Input;
haxe.io.BytesInput.prototype = $extend(haxe.io.Input.prototype,{
	b: null
	,pos: null
	,len: null
	,totlen: null
	,readByte: function() {
		if(this.len == 0) throw new haxe.io.Eof();
		this.len--;
		return this.b[this.pos++];
	}
	,readBytes: function(buf,pos,len) {
		if(pos < 0 || len < 0 || pos + len > buf.length) throw haxe.io.Error.OutsideBounds;
		if(this.len == 0 && len > 0) throw new haxe.io.Eof();
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
	,__class__: haxe.io.BytesInput
});
haxe.io.Output = function() { };
haxe.io.Output.__name__ = ["haxe","io","Output"];
haxe.io.Output.prototype = {
	bigEndian: null
	,writeByte: function(c) {
		throw "Not implemented";
	}
	,writeBytes: function(s,pos,len) {
		var k = len;
		var b = s.b;
		if(pos < 0 || len < 0 || pos + len > s.length) throw haxe.io.Error.OutsideBounds;
		while(k > 0) {
			this.writeByte(b[pos]);
			pos++;
			k--;
		}
		return len;
	}
	,close: function() {
	}
	,write: function(s) {
		var l = s.length;
		var p = 0;
		while(l > 0) {
			var k = this.writeBytes(s,p,l);
			if(k == 0) throw haxe.io.Error.Blocked;
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
		var b = haxe.io.Bytes.ofString(s);
		this.writeFullBytes(b,0,b.length);
	}
	,__class__: haxe.io.Output
};
haxe.io.BytesOutput = function() {
	this.b = new haxe.io.BytesBuffer();
};
haxe.io.BytesOutput.__name__ = ["haxe","io","BytesOutput"];
haxe.io.BytesOutput.__super__ = haxe.io.Output;
haxe.io.BytesOutput.prototype = $extend(haxe.io.Output.prototype,{
	b: null
	,writeByte: function(c) {
		this.b.b.push(c);
	}
	,writeBytes: function(buf,pos,len) {
		this.b.addBytes(buf,pos,len);
		return len;
	}
	,getBytes: function() {
		return this.b.getBytes();
	}
	,__class__: haxe.io.BytesOutput
});
haxe.io.Eof = function() {
};
haxe.io.Eof.__name__ = ["haxe","io","Eof"];
haxe.io.Eof.prototype = {
	toString: function() {
		return "Eof";
	}
	,__class__: haxe.io.Eof
};
haxe.io.Error = { __ename__ : true, __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; };
haxe.unit = {};
haxe.unit.TestCase = function() {
};
haxe.unit.TestCase.__name__ = ["haxe","unit","TestCase"];
haxe.unit.TestCase.prototype = {
	currentTest: null
	,setup: function() {
	}
	,tearDown: function() {
	}
	,print: function(v) {
		haxe.unit.TestRunner.print(v);
	}
	,assertTrue: function(b,c) {
		this.currentTest.done = true;
		if(b == false) {
			this.currentTest.success = false;
			this.currentTest.error = "expected true but was false";
			this.currentTest.posInfos = c;
			throw this.currentTest;
		}
	}
	,assertFalse: function(b,c) {
		this.currentTest.done = true;
		if(b == true) {
			this.currentTest.success = false;
			this.currentTest.error = "expected false but was true";
			this.currentTest.posInfos = c;
			throw this.currentTest;
		}
	}
	,assertEquals: function(expected,actual,c) {
		this.currentTest.done = true;
		if(actual != expected) {
			this.currentTest.success = false;
			this.currentTest.error = "expected '" + Std.string(expected) + "' but was '" + Std.string(actual) + "'";
			this.currentTest.posInfos = c;
			throw this.currentTest;
		}
	}
	,__class__: haxe.unit.TestCase
};
haxe.unit.TestResult = function() {
	this.m_tests = new List();
	this.success = true;
};
haxe.unit.TestResult.__name__ = ["haxe","unit","TestResult"];
haxe.unit.TestResult.prototype = {
	m_tests: null
	,success: null
	,add: function(t) {
		this.m_tests.add(t);
		if(!t.success) this.success = false;
	}
	,toString: function() {
		var buf = new StringBuf();
		var failures = 0;
		var $it0 = this.m_tests.iterator();
		while( $it0.hasNext() ) {
			var test = $it0.next();
			if(test.success == false) {
				buf.b += "* ";
				if(test.classname == null) buf.b += "null"; else buf.b += "" + test.classname;
				buf.b += "::";
				if(test.method == null) buf.b += "null"; else buf.b += "" + test.method;
				buf.b += "()";
				buf.b += "\n";
				buf.b += "ERR: ";
				if(test.posInfos != null) {
					buf.b += Std.string(test.posInfos.fileName);
					buf.b += ":";
					buf.b += Std.string(test.posInfos.lineNumber);
					buf.b += "(";
					buf.b += Std.string(test.posInfos.className);
					buf.b += ".";
					buf.b += Std.string(test.posInfos.methodName);
					buf.b += ") - ";
				}
				if(test.error == null) buf.b += "null"; else buf.b += "" + test.error;
				buf.b += "\n";
				if(test.backtrace != null) {
					if(test.backtrace == null) buf.b += "null"; else buf.b += "" + test.backtrace;
					buf.b += "\n";
				}
				buf.b += "\n";
				failures++;
			}
		}
		buf.b += "\n";
		if(failures == 0) buf.b += "OK "; else buf.b += "FAILED ";
		buf.b += Std.string(this.m_tests.length);
		buf.b += " tests, ";
		if(failures == null) buf.b += "null"; else buf.b += "" + failures;
		buf.b += " failed, ";
		buf.b += Std.string(this.m_tests.length - failures);
		buf.b += " success";
		buf.b += "\n";
		return buf.b;
	}
	,__class__: haxe.unit.TestResult
};
haxe.unit.TestRunner = function() {
	this.result = new haxe.unit.TestResult();
	this.cases = new List();
};
haxe.unit.TestRunner.__name__ = ["haxe","unit","TestRunner"];
haxe.unit.TestRunner.print = function(v) {
	var msg = js.Boot.__string_rec(v,"");
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) {
		msg = StringTools.htmlEscape(msg).split("\n").join("<br/>");
		d.innerHTML += msg + "<br/>";
	} else if(typeof process != "undefined" && process.stdout != null && process.stdout.write != null) process.stdout.write(msg); else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
haxe.unit.TestRunner.customTrace = function(v,p) {
	haxe.unit.TestRunner.print(p.fileName + ":" + p.lineNumber + ": " + Std.string(v) + "\n");
};
haxe.unit.TestRunner.prototype = {
	result: null
	,cases: null
	,add: function(c) {
		this.cases.add(c);
	}
	,run: function() {
		this.result = new haxe.unit.TestResult();
		var $it0 = this.cases.iterator();
		while( $it0.hasNext() ) {
			var c = $it0.next();
			this.runCase(c);
		}
		haxe.unit.TestRunner.print(this.result.toString());
		return this.result.success;
	}
	,runCase: function(t) {
		var old = haxe.Log.trace;
		haxe.Log.trace = haxe.unit.TestRunner.customTrace;
		var cl = Type.getClass(t);
		var fields = Type.getInstanceFields(cl);
		haxe.unit.TestRunner.print("Class: " + Type.getClassName(cl) + " ");
		var _g = 0;
		while(_g < fields.length) {
			var f = fields[_g];
			++_g;
			var fname = f;
			var field = Reflect.field(t,f);
			if(StringTools.startsWith(fname,"test") && Reflect.isFunction(field)) {
				t.currentTest = new haxe.unit.TestStatus();
				t.currentTest.classname = Type.getClassName(cl);
				t.currentTest.method = fname;
				t.setup();
				try {
					Reflect.callMethod(t,field,new Array());
					if(t.currentTest.done) {
						t.currentTest.success = true;
						haxe.unit.TestRunner.print(".");
					} else {
						t.currentTest.success = false;
						t.currentTest.error = "(warning) no assert";
						haxe.unit.TestRunner.print("W");
					}
				} catch( $e0 ) {
					if( js.Boot.__instanceof($e0,haxe.unit.TestStatus) ) {
						var e = $e0;
						haxe.unit.TestRunner.print("F");
						t.currentTest.backtrace = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
					} else {
					var e1 = $e0;
					haxe.unit.TestRunner.print("E");
					if(e1.message != null) t.currentTest.error = "exception thrown : " + Std.string(e1) + " [" + Std.string(e1.message) + "]"; else t.currentTest.error = "exception thrown : " + Std.string(e1);
					t.currentTest.backtrace = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
					}
				}
				this.result.add(t.currentTest);
				t.tearDown();
			}
		}
		haxe.unit.TestRunner.print("\n");
		haxe.Log.trace = old;
	}
	,__class__: haxe.unit.TestRunner
};
haxe.unit.TestStatus = function() {
	this.done = false;
	this.success = false;
};
haxe.unit.TestStatus.__name__ = ["haxe","unit","TestStatus"];
haxe.unit.TestStatus.prototype = {
	done: null
	,success: null
	,error: null
	,method: null
	,classname: null
	,posInfos: null
	,backtrace: null
	,__class__: haxe.unit.TestStatus
};
haxe.xml = {};
haxe.xml._Fast = {};
haxe.xml._Fast.NodeAccess = function(x) {
	this.__x = x;
};
haxe.xml._Fast.NodeAccess.__name__ = ["haxe","xml","_Fast","NodeAccess"];
haxe.xml._Fast.NodeAccess.prototype = {
	__x: null
	,__class__: haxe.xml._Fast.NodeAccess
};
haxe.xml._Fast.AttribAccess = function(x) {
	this.__x = x;
};
haxe.xml._Fast.AttribAccess.__name__ = ["haxe","xml","_Fast","AttribAccess"];
haxe.xml._Fast.AttribAccess.prototype = {
	__x: null
	,resolve: function(name) {
		if(this.__x.nodeType == Xml.Document) throw "Cannot access document attribute " + name;
		var v = this.__x.get(name);
		if(v == null) throw this.__x.get_nodeName() + " is missing attribute " + name;
		return v;
	}
	,__class__: haxe.xml._Fast.AttribAccess
};
haxe.xml._Fast.HasAttribAccess = function(x) {
	this.__x = x;
};
haxe.xml._Fast.HasAttribAccess.__name__ = ["haxe","xml","_Fast","HasAttribAccess"];
haxe.xml._Fast.HasAttribAccess.prototype = {
	__x: null
	,resolve: function(name) {
		if(this.__x.nodeType == Xml.Document) throw "Cannot access document attribute " + name;
		return this.__x.exists(name);
	}
	,__class__: haxe.xml._Fast.HasAttribAccess
};
haxe.xml._Fast.HasNodeAccess = function(x) {
	this.__x = x;
};
haxe.xml._Fast.HasNodeAccess.__name__ = ["haxe","xml","_Fast","HasNodeAccess"];
haxe.xml._Fast.HasNodeAccess.prototype = {
	__x: null
	,__class__: haxe.xml._Fast.HasNodeAccess
};
haxe.xml._Fast.NodeListAccess = function(x) {
	this.__x = x;
};
haxe.xml._Fast.NodeListAccess.__name__ = ["haxe","xml","_Fast","NodeListAccess"];
haxe.xml._Fast.NodeListAccess.prototype = {
	__x: null
	,__class__: haxe.xml._Fast.NodeListAccess
};
haxe.xml.Fast = function(x) {
	if(x.nodeType != Xml.Document && x.nodeType != Xml.Element) throw "Invalid nodeType " + Std.string(x.nodeType);
	this.x = x;
	this.node = new haxe.xml._Fast.NodeAccess(x);
	this.nodes = new haxe.xml._Fast.NodeListAccess(x);
	this.att = new haxe.xml._Fast.AttribAccess(x);
	this.has = new haxe.xml._Fast.HasAttribAccess(x);
	this.hasNode = new haxe.xml._Fast.HasNodeAccess(x);
};
haxe.xml.Fast.__name__ = ["haxe","xml","Fast"];
haxe.xml.Fast.prototype = {
	x: null
	,node: null
	,nodes: null
	,att: null
	,has: null
	,hasNode: null
	,__class__: haxe.xml.Fast
};
haxe.xml.Parser = function() { };
haxe.xml.Parser.__name__ = ["haxe","xml","Parser"];
haxe.xml.Parser.parse = function(str) {
	var doc = Xml.createDocument();
	haxe.xml.Parser.doParse(str,0,doc);
	return doc;
};
haxe.xml.Parser.doParse = function(str,p,parent) {
	if(p == null) p = 0;
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var c = str.charCodeAt(p);
	var buf = new StringBuf();
	while(!(c != c)) {
		switch(state) {
		case 0:
			switch(c) {
			case 10:case 13:case 9:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			switch(c) {
			case 60:
				state = 0;
				next = 2;
				break;
			default:
				start = p;
				state = 13;
				continue;
			}
			break;
		case 13:
			if(c == 60) {
				var child = Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start));
				buf = new StringBuf();
				parent.addChild(child);
				nsubs++;
				state = 0;
				next = 2;
			} else if(c == 38) {
				buf.addSub(str,start,p - start);
				state = 18;
				next = 13;
				start = p + 1;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child1 = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child1);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") throw "Expected <![CDATA[";
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") throw "Expected <!DOCTYPE";
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) throw "Expected <!--"; else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 63:
				state = 14;
				start = p;
				break;
			case 47:
				if(parent == null) throw "Expected node name";
				start = p + 1;
				state = 0;
				next = 10;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) throw "Expected node name";
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				nsubs++;
				break;
			case 62:
				state = 9;
				nsubs++;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				var tmp;
				if(start == p) throw "Expected attribute name";
				tmp = HxOverrides.substr(str,start,p - start);
				aname = tmp;
				if(xml.exists(aname)) throw "Duplicate attribute";
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			switch(c) {
			case 61:
				state = 0;
				next = 7;
				break;
			default:
				throw "Expected =";
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				state = 8;
				start = p;
				break;
			default:
				throw "Expected \"";
			}
			break;
		case 8:
			if(c == str.charCodeAt(start)) {
				var val = HxOverrides.substr(str,start + 1,p - start - 1);
				xml.set(aname,val);
				state = 0;
				next = 4;
			}
			break;
		case 9:
			p = haxe.xml.Parser.doParse(str,p,xml);
			start = p;
			state = 1;
			break;
		case 11:
			switch(c) {
			case 62:
				state = 1;
				break;
			default:
				throw "Expected >";
			}
			break;
		case 12:
			switch(c) {
			case 62:
				if(nsubs == 0) parent.addChild(Xml.createPCData(""));
				return p;
			default:
				throw "Expected >";
			}
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) throw "Expected node name";
				var v = HxOverrides.substr(str,start,p - start);
				if(v != parent.get_nodeName()) throw "Expected </" + parent.get_nodeName() + ">";
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				parent.addChild(Xml.createComment(HxOverrides.substr(str,start,p - start)));
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) nbrackets++; else if(c == 93) nbrackets--; else if(c == 62 && nbrackets == 0) {
				parent.addChild(Xml.createDocType(HxOverrides.substr(str,start,p - start)));
				state = 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				p++;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				parent.addChild(Xml.createProcessingInstruction(str1));
				state = 1;
			}
			break;
		case 18:
			if(c == 59) {
				var s = HxOverrides.substr(str,start,p - start);
				if(s.charCodeAt(0) == 35) {
					var i;
					if(s.charCodeAt(1) == 120) i = Std.parseInt("0" + HxOverrides.substr(s,1,s.length - 1)); else i = Std.parseInt(HxOverrides.substr(s,1,s.length - 1));
					buf.add(String.fromCharCode(i));
				} else if(!haxe.xml.Parser.escapes.exists(s)) buf.b += Std.string("&" + s + ";"); else buf.add(haxe.xml.Parser.escapes.get(s));
				start = p + 1;
				state = next;
			}
			break;
		}
		c = StringTools.fastCodeAt(str,++p);
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(p != start || nsubs == 0) parent.addChild(Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start)));
		return p;
	}
	throw "Unexpected end";
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js.Boot.__trace = function(v,i) {
	var msg;
	if(i != null) msg = i.fileName + ":" + i.lineNumber + ": "; else msg = "";
	msg += js.Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js.Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
js.Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js.Boot.__nativeClassName(o);
		if(name != null) return js.Boot.__resolveNativeClass(name);
		return null;
	}
};
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js.Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) str2 += ", \n";
		str2 += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
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
				if(js.Boot.__interfLoop(js.Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js.Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js.Boot.__nativeClassName = function(o) {
	var name = js.Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js.Boot.__isNativeObj = function(o) {
	return js.Boot.__nativeClassName(o) != null;
};
js.Boot.__resolveNativeClass = function(name) {
	if(typeof window != "undefined") return window[name]; else return global[name];
};
js.NodeC = function() { };
js.NodeC.__name__ = ["js","NodeC"];
js.Node = function() { };
js.Node.__name__ = ["js","Node"];
js.Node.get_assert = function() {
	return js.Node.require("assert");
};
js.Node.get_child_process = function() {
	return js.Node.require("child_process");
};
js.Node.get_cluster = function() {
	return js.Node.require("cluster");
};
js.Node.get_crypto = function() {
	return js.Node.require("crypto");
};
js.Node.get_dgram = function() {
	return js.Node.require("dgram");
};
js.Node.get_dns = function() {
	return js.Node.require("dns");
};
js.Node.get_fs = function() {
	return js.Node.require("fs");
};
js.Node.get_http = function() {
	return js.Node.require("http");
};
js.Node.get_https = function() {
	return js.Node.require("https");
};
js.Node.get_net = function() {
	return js.Node.require("net");
};
js.Node.get_os = function() {
	return js.Node.require("os");
};
js.Node.get_path = function() {
	return js.Node.require("path");
};
js.Node.get_querystring = function() {
	return js.Node.require("querystring");
};
js.Node.get_repl = function() {
	return js.Node.require("repl");
};
js.Node.get_tls = function() {
	return js.Node.require("tls");
};
js.Node.get_url = function() {
	return js.Node.require("url");
};
js.Node.get_util = function() {
	return js.Node.require("util");
};
js.Node.get_vm = function() {
	return js.Node.require("vm");
};
js.Node.get_zlib = function() {
	return js.Node.require("zlib");
};
js.Node.get___filename = function() {
	return __filename;
};
js.Node.get___dirname = function() {
	return __dirname;
};
js.Node.get_json = function() {
	return JSON;
};
js.Node.newSocket = function(options) {
	return new js.Node.net.Socket(options);
};
var pony = {};
pony.AsyncTests = function() {
	haxe.unit.TestCase.call(this);
};
pony.AsyncTests.__name__ = ["pony","AsyncTests"];
pony.AsyncTests.init = function(count) {
	if(pony.AsyncTests.testCount != 0) throw "Second init";
	haxe.Log.trace("" + pony.AsyncTests.dec + " Begin tests (" + count + ") " + pony.AsyncTests.dec,{ fileName : "AsyncTests.hx", lineNumber : 57, className : "pony.AsyncTests", methodName : "init"});
	pony.AsyncTests.testCount = count;
	var _g = new haxe.ds.IntMap();
	var _g1 = 0;
	while(_g1 < count) {
		var i = _g1++;
		_g.set(i,false);
	}
	pony.AsyncTests.isRead = _g;
};
pony.AsyncTests.equals = function(a,b,infos) {
	pony.AsyncTests.assertList.push({ a : a, b : b, pos : infos});
};
pony.AsyncTests.setFlag = function(n,infos) {
	if(n >= pony.AsyncTests.testCount || n < 0) throw "Wrong test number";
	if(pony.AsyncTests.isRead.get(n)) throw "Double complite";
	haxe.Log.trace("" + pony.AsyncTests.dec + " Test #" + n + " finished " + pony.AsyncTests.dec,infos);
	pony.AsyncTests.isRead.set(n,true);
	true;
	if(pony.AsyncTests.lock) return;
	pony.AsyncTests.lock = true;
	pony.AsyncTests.checkWaitList();
	var $it0 = pony.AsyncTests.isRead.iterator();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(!e) {
			pony.AsyncTests.lock = false;
			return;
		}
	}
	var test = new haxe.unit.TestRunner();
	test.add(new pony.AsyncTests());
	test.run();
};
pony.AsyncTests.finish = function(infos) {
	if(!pony.AsyncTests.complite) throw "Tests not complited: " + Std.string((function($this) {
		var $r;
		var a = [];
		var $it0 = pony.AsyncTests.isRead.keys();
		while( $it0.hasNext() ) {
			var k = $it0.next();
			if(!pony.AsyncTests.isRead.get(k)) a.push(k);
		}
		$r = a;
		return $r;
	}(this)));
	haxe.Log.trace("" + pony.AsyncTests.dec + " All tests finished " + pony.AsyncTests.dec,infos);
};
pony.AsyncTests.wait = function(it,cb) {
	if(pony.AsyncTests.checkWait(it)) cb(); else pony.AsyncTests.waitList.push({ it : it, cb : cb});
};
pony.AsyncTests.checkWait = function(it) {
	var _g1 = Reflect.field(it,"min");
	var _g = Reflect.field(it,"max");
	while(_g1 < _g) {
		var i = _g1++;
		if(!pony.AsyncTests.isRead.get(i)) return false;
	}
	return true;
};
pony.AsyncTests.checkWaitList = function() {
	var nl = new List();
	var $it0 = pony.AsyncTests.waitList.iterator();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(pony.AsyncTests.checkWait(e.it)) e.cb(); else nl.push(e);
	}
	pony.AsyncTests.waitList = nl;
};
pony.AsyncTests.__super__ = haxe.unit.TestCase;
pony.AsyncTests.prototype = $extend(haxe.unit.TestCase.prototype,{
	testRun: function() {
		var $it0 = pony.AsyncTests.assertList.iterator();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			this.assertEquals(e.a,e.b,e.pos);
		}
		pony.AsyncTests.complite = true;
	}
	,__class__: pony.AsyncTests
});
pony._Byte = {};
pony._Byte.Byte_Impl_ = function() { };
pony._Byte.Byte_Impl_.__name__ = ["pony","_Byte","Byte_Impl_"];
pony._Byte.Byte_Impl_.get_a = function(this1) {
	return this1 >> 4;
};
pony._Byte.Byte_Impl_.get_b = function(this1) {
	return this1 & 15;
};
pony._Byte.Byte_Impl_.create = function(a,b) {
	return (a << 4) + b;
};
pony._Byte.Byte_Impl_.chechSumWith = function(this1,b) {
	return this1 + b & 255;
};
pony._Byte.Byte_Impl_.toString = function(this1) {
	return "0x" + StringTools.hex(this1);
};
pony.Dictionary = function(maxDepth) {
	if(maxDepth == null) maxDepth = 1;
	this.maxDepth = maxDepth;
	this.ks = [];
	this.vs = [];
};
pony.Dictionary.__name__ = ["pony","Dictionary"];
pony.Dictionary.prototype = {
	ks: null
	,vs: null
	,count: null
	,maxDepth: null
	,getIndex: function(k) {
		return pony.Tools.superIndexOf(this.ks,k,this.maxDepth);
	}
	,set: function(k,v) {
		var i = pony.Tools.superIndexOf(this.ks,k,this.maxDepth);
		if(i != -1) {
			this.vs[i] = v;
			return i;
		} else {
			this.ks.push(k);
			return this.vs.push(v);
		}
	}
	,get: function(k) {
		var i = pony.Tools.superIndexOf(this.ks,k,this.maxDepth);
		if(i == -1) return null; else return this.vs[i];
	}
	,exists: function(k) {
		return pony.Tools.superIndexOf(this.ks,k,this.maxDepth) != -1;
	}
	,remove: function(k) {
		var i = pony.Tools.superIndexOf(this.ks,k,this.maxDepth);
		if(i != -1) {
			this.ks.splice(i,1);
			this.vs.splice(i,1);
			return true;
		} else return false;
	}
	,removeIndex: function(i) {
		this.ks.splice(i,1);
		this.vs.splice(i,1);
	}
	,clear: function() {
		this.ks = [];
		this.vs = [];
	}
	,iterator: function() {
		return HxOverrides.iter(this.vs);
	}
	,keys: function() {
		return HxOverrides.iter(this.ks);
	}
	,toString: function() {
		var a = [];
		var $it0 = HxOverrides.iter(this.ks);
		while( $it0.hasNext() ) {
			var k = $it0.next();
			a.push(Std.string(k) + ": " + Std.string(this.get(k)));
		}
		return "[" + a.join(", ") + "]";
	}
	,removeValue: function(v) {
		var i = HxOverrides.indexOf(this.vs,v,0);
		if(i != -1) {
			this.ks.splice(i,1);
			this.vs.splice(i,1);
		}
	}
	,getKey: function(v) {
		var i = HxOverrides.indexOf(this.vs,v,0);
		if(i == -1) return null;
		return this.ks[i];
	}
	,getValueIndex: function(v) {
		return HxOverrides.indexOf(this.vs,v,0);
	}
	,get_count: function() {
		return this.ks.length;
	}
	,__class__: pony.Dictionary
};
pony._Function = {};
pony._Function.Function_Impl_ = function() { };
pony._Function.Function_Impl_.__name__ = ["pony","_Function","Function_Impl_"];
pony._Function.Function_Impl_._new = function(f,count,args,ret,event) {
	if(event == null) event = false;
	if(ret == null) ret = true;
	var this1;
	pony._Function.Function_Impl_.counter++;
	if(pony._Function.Function_Impl_.searchFree) while(true) {
		var $it0 = HxOverrides.iter(pony._Function.Function_Impl_.list.vs);
		while( $it0.hasNext() ) {
			var e = $it0.next();
			if(e.id != pony._Function.Function_Impl_.counter) break;
		}
		pony._Function.Function_Impl_.counter++;
	} else if(pony._Function.Function_Impl_.counter == -1) pony._Function.Function_Impl_.searchFree = true;
	this1 = { f : f, count : count, args : args == null?[]:args, id : pony._Function.Function_Impl_.counter, used : 0, event : event, ret : ret};
	return this1;
};
pony._Function.Function_Impl_.from = function(f,argc,ret,event) {
	if(event == null) event = false;
	if(ret == null) ret = true;
	if(pony._Function.Function_Impl_.list.exists(f)) return pony._Function.Function_Impl_.list.get(f); else {
		pony._Function.Function_Impl_.unusedCount++;
		var o = pony._Function.Function_Impl_._new(f,argc,null,ret,event);
		pony._Function.Function_Impl_.list.set(f,o);
		return o;
	}
};
pony._Function.Function_Impl_.fromEventR = function(f) {
	return pony._Function.Function_Impl_.from(f,1,true,true);
};
pony._Function.Function_Impl_.fromEvent = function(f) {
	return pony._Function.Function_Impl_.from(f,1,false,true);
};
pony._Function.Function_Impl_.from0r = function(f) {
	return pony._Function.Function_Impl_.from(f,0);
};
pony._Function.Function_Impl_.from1r = function(f) {
	return pony._Function.Function_Impl_.from(f,1);
};
pony._Function.Function_Impl_.from2r = function(f) {
	return pony._Function.Function_Impl_.from(f,2);
};
pony._Function.Function_Impl_.from3r = function(f) {
	return pony._Function.Function_Impl_.from(f,3);
};
pony._Function.Function_Impl_.from4r = function(f) {
	return pony._Function.Function_Impl_.from(f,4);
};
pony._Function.Function_Impl_.from5r = function(f) {
	return pony._Function.Function_Impl_.from(f,5);
};
pony._Function.Function_Impl_.from6r = function(f) {
	return pony._Function.Function_Impl_.from(f,6);
};
pony._Function.Function_Impl_.from7r = function(f) {
	return pony._Function.Function_Impl_.from(f,7);
};
pony._Function.Function_Impl_.from0 = function(f) {
	return pony._Function.Function_Impl_.from(f,0,false);
};
pony._Function.Function_Impl_.from1 = function(f) {
	return pony._Function.Function_Impl_.from(f,1,false);
};
pony._Function.Function_Impl_.from2 = function(f) {
	return pony._Function.Function_Impl_.from(f,2,false);
};
pony._Function.Function_Impl_.from3 = function(f) {
	return pony._Function.Function_Impl_.from(f,3,false);
};
pony._Function.Function_Impl_.from4 = function(f) {
	return pony._Function.Function_Impl_.from(f,4,false);
};
pony._Function.Function_Impl_.from5 = function(f) {
	return pony._Function.Function_Impl_.from(f,5,false);
};
pony._Function.Function_Impl_.from6 = function(f) {
	return pony._Function.Function_Impl_.from(f,6,false);
};
pony._Function.Function_Impl_.from7 = function(f) {
	return pony._Function.Function_Impl_.from(f,7,false);
};
pony._Function.Function_Impl_.call = function(this1,args) {
	if(args == null) args = [];
	return Reflect.callMethod(null,this1.f,this1.args.concat(args));
};
pony._Function.Function_Impl_.get_id = function(this1) {
	return this1.id;
};
pony._Function.Function_Impl_.get_count = function(this1) {
	return this1.count;
};
pony._Function.Function_Impl_._setArgs = function(this1,args) {
	this1.count -= args.length;
	this1.args = this1.args.concat(args);
};
pony._Function.Function_Impl_._use = function(this1) {
	this1.used++;
};
pony._Function.Function_Impl_.unuse = function(this1) {
	this1.used--;
	if(this1.used <= 0) {
		pony._Function.Function_Impl_.list.remove(this1.f);
		this1 = null;
		pony._Function.Function_Impl_.unusedCount--;
	}
};
pony._Function.Function_Impl_.get_used = function(this1) {
	return this1.used;
};
pony._Function.Function_Impl_.get_event = function(this1) {
	return this1.event;
};
pony._Function.Function_Impl_.get_ret = function(this1) {
	return this1.ret;
};
pony.IEvent = function() { };
pony.IEvent.__name__ = ["pony","IEvent"];
pony.ILogable = function() { };
pony.ILogable.__name__ = ["pony","ILogable"];
pony.ILogable.prototype = {
	log: null
	,error: null
	,_log: null
	,_error: null
	,__class__: pony.ILogable
};
pony._KeyValue = {};
pony._KeyValue.KeyValue_Impl_ = function() { };
pony._KeyValue.KeyValue_Impl_.__name__ = ["pony","_KeyValue","KeyValue_Impl_"];
pony._KeyValue.KeyValue_Impl_._new = function(p) {
	return p;
};
pony._KeyValue.KeyValue_Impl_.get_key = function(this1) {
	return this1.a;
};
pony._KeyValue.KeyValue_Impl_.get_value = function(this1) {
	return this1.b;
};
pony._KeyValue.KeyValue_Impl_.fromPair = function(p) {
	return p;
};
pony._KeyValue.KeyValue_Impl_.toPair = function(this1) {
	return this1;
};
pony.Logable = function() {
	var this1 = pony.events.Signal.create(this);
	this.log = this1;
	var this2 = pony.events.Signal.create(this);
	this.error = this2;
};
pony.Logable.__name__ = ["pony","Logable"];
pony.Logable.__interfaces__ = [pony.ILogable];
pony.Logable.prototype = {
	log: null
	,error: null
	,_error: function(s,p) {
		pony.events._Signal2.Signal2_Impl_.dispatch(this.error,s,p);
	}
	,_log: function(s,p) {
		pony.events._Signal2.Signal2_Impl_.dispatch(this.log,s,p);
	}
	,__class__: pony.Logable
};
pony._Pair = {};
pony._Pair.Pair_Impl_ = function() { };
pony._Pair.Pair_Impl_.__name__ = ["pony","_Pair","Pair_Impl_"];
pony._Pair.Pair_Impl_._new = function(a,b) {
	return { a : a, b : b};
};
pony._Pair.Pair_Impl_.get_a = function(this1) {
	return this1.a;
};
pony._Pair.Pair_Impl_.get_b = function(this1) {
	return this1.b;
};
pony._Pair.Pair_Impl_.set_a = function(this1,v) {
	return this1.a = v;
};
pony._Pair.Pair_Impl_.set_b = function(this1,v) {
	return this1.b = v;
};
pony._Pair.Pair_Impl_.fromObj = function(o) {
	return o;
};
pony._Pair.Pair_Impl_.toObj = function(this1) {
	return this1;
};
pony._Pair.Pair_Impl_.array = function(a) {
	return { a : a[0], b : a[1]};
};
pony.Priority = function(data) {
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
pony.Priority.__name__ = ["pony","Priority"];
pony.Priority.createIds = function(a) {
	var i = 0;
	return new pony.Priority((function($this) {
		var $r;
		var _g = [];
		{
			var _g1 = 0;
			while(_g1 < a.length) {
				var e = a[_g1];
				++_g1;
				_g.push({ id : i++, name : e});
			}
		}
		$r = _g;
		return $r;
	}(this)));
};
pony.Priority.prototype = {
	'double': null
	,data: null
	,hash: null
	,counters: null
	,addElement: function(e,priority) {
		if(priority == null) priority = 0;
		if(!this["double"] && this.existsElement(e)) return this;
		var s;
		if(this.hash.exists(priority)) s = this.hash.get(priority); else s = 0;
		var c = 0;
		var $it0 = this.hash.keys();
		while( $it0.hasNext() ) {
			var k = $it0.next();
			if(k < priority) c += this.hash.get(k);
		}
		c += s;
		this.data.splice(c,0,e);
		var _g1 = 0;
		var _g = this.counters.length;
		while(_g1 < _g) {
			var k1 = _g1++;
			if(c < this.counters[k1]) this.counters[k1]++;
		}
		this.hash.set(priority,s + 1);
		return this;
	}
	,addArray: function(a,priority) {
		if(priority == null) priority = 0;
		var _g = 0;
		while(_g < a.length) {
			var e = a[_g];
			++_g;
			this.addElement(e,priority);
		}
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
		this.hash = new haxe.ds.IntMap();
		this.data = new Array();
		this.counters = [0];
		return this;
	}
	,destroy: function() {
		this.hash = null;
		this.data = null;
		this.counters = null;
	}
	,existsElement: function(element) {
		return Lambda.exists(this.data,function(e) {
			return e == element;
		});
	}
	,existsFunction: function(f) {
		return Lambda.exists(this.data,f);
	}
	,existsArray: function(a) {
		var _g = 0;
		while(_g < a.length) {
			var e = a[_g];
			++_g;
			if(this.existsElement(e)) return true;
		}
		return false;
	}
	,search: function(f) {
		var s = null;
		Lambda.exists(this.data,function(e) {
			if(f(e)) {
				s = e;
				return true;
			} else return false;
		});
		return s;
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
		var a = [];
		var $it0 = this.hash.keys();
		while( $it0.hasNext() ) {
			var k1 = $it0.next();
			a.push(k1);
		}
		a.sort(function(x,y) {
			return x - y;
		});
		var _g2 = 0;
		while(_g2 < a.length) {
			var k2 = a[_g2];
			++_g2;
			if(i > 0) i -= this.hash.get(k2); else {
				var value = this.hash.get(k2) - 1;
				this.hash.set(k2,value);
				break;
			}
		}
		if(this["double"]) this.removeElement(e);
		return true;
	}
	,removeFunction: function(f) {
		var e = this.search(f);
		if(e != null) return this.removeElement(e); else return false;
	}
	,removeArray: function(a) {
		var f = true;
		var _g = 0;
		while(_g < a.length) {
			var e = a[_g];
			++_g;
			if(!this.removeElement(e)) f = false;
		}
		return f;
	}
	,repriority: function(priority) {
		if(priority == null) priority = 0;
		this.hash = new haxe.ds.IntMap();
		this.hash.set(priority,this.data.length);
	}
	,changeElement: function(e,priority) {
		if(priority == null) priority = 0;
		if(this.removeElement(e)) this.addElement(e,priority); else throw "Element not exists";
		return this;
	}
	,changeFunction: function(f,priority) {
		if(priority == null) priority = 0;
		var e = this.search(f);
		return this.changeElement(e,priority);
	}
	,changeArray: function(a,priority) {
		if(priority == null) priority = 0;
		var _g = 0;
		while(_g < a.length) {
			var e = a[_g];
			++_g;
			this.changeElement(e,priority);
		}
		return this;
	}
	,toString: function() {
		return this.data.toString();
	}
	,join: function(sep) {
		return this.data.join(sep);
	}
	,get_first: function() {
		return this.data[0];
	}
	,get_last: function() {
		return this.data[this.data.length - 1];
	}
	,get_length: function() {
		return this.data.length;
	}
	,get_empty: function() {
		return this.data.length == 0;
	}
	,loop: function() {
		if(this.counters[0] >= this.data.length) {
			this.counters[0] = 0;
			if(this.data.length == 0) return null;
		}
		return this.data[this.counters[0]++];
	}
	,resetLoop: function() {
		this.counters[0] = 0;
		return this;
	}
	,reloop: function(e) {
		while(this.loop() != e) null;
	}
	,get_current: function() {
		if(this.counters[0] > this.data.length) return this.data[0]; else if(this.counters[0] < 1) return this.data[this.data.length - 1]; else return this.data[this.counters[0] - 1];
	}
	,backLoop: function() {
		if(this.data.length == 0) {
			this.counters[0] = 0;
			return null;
		}
		this.counters[0]--;
		if(this.counters[0] < 1) this.counters[0] = this.data.length;
		return this.data[this.counters[0] - 1];
	}
	,get_min: function() {
		var n = null;
		var $it0 = this.hash.keys();
		while( $it0.hasNext() ) {
			var k = $it0.next();
			if(n == null || k < n) n = k;
		}
		return n;
	}
	,get_max: function() {
		var n = null;
		var $it0 = this.hash.keys();
		while( $it0.hasNext() ) {
			var k = $it0.next();
			if(n == null || k > n) n = k;
		}
		return n;
	}
	,addElementToBegin: function(e) {
		this.addElement(e,this.get_min() - 1);
	}
	,addElementToEnd: function(e) {
		this.addElement(e,this.get_max() + 1);
	}
	,__class__: pony.Priority
};
pony.Queue = function(method) {
	this.busy = false;
	this.method = method;
	this.list = new List();
	this.call = Reflect.makeVarArgs($bind(this,this._call));
};
pony.Queue.__name__ = ["pony","Queue"];
pony.Queue.prototype = {
	list: null
	,busy: null
	,call: null
	,method: null
	,_call: function(a) {
		if(!this.busy) {
			this.method.apply(null,a);
			this.busy = true;
		} else this.list.add(a);
	}
	,next: function() {
		if(this.list.length > 0) Reflect.callMethod(null,this.method,this.list.pop()); else this.busy = false;
	}
	,__class__: pony.Queue
};
pony.Tools = function() { };
pony.Tools.__name__ = ["pony","Tools"];
pony.Tools.nore = function(v) {
	return v == null || v.length == 0;
};
pony.Tools.or = function(v1,v2) {
	if(v1 == null) return v2; else return v1;
};
pony.Tools.equal = function(a,b,maxDepth) {
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
			return false;
		}
		break;
	case 7:
		var t = type[2];
		if(t != Type.getEnum(b)) return false;
		if(Type.enumIndex(a) != Type.enumIndex(b)) return false;
		var a1 = Type.enumParameters(a);
		var b1 = Type.enumParameters(b);
		if(a1.length != b1.length) return false;
		var _g1 = 0;
		var _g = a1.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!pony.Tools.equal(a1[i],b1[i],maxDepth - 1)) return false;
		}
		return true;
	case 4:
		if(js.Boot.__instanceof(a,Class)) return false;
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
				if(!pony.Tools.equal(a[i1],b[i1],maxDepth - 1)) return false;
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
			if(js.Boot.__instanceof(b,Class)) return false;
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
			if(!Object.prototype.hasOwnProperty.call(b,f) || !pony.Tools.equal(Reflect.field(a,f),Reflect.field(b,f),maxDepth - 1)) return false;
		}
		return true;
	}
	return false;
};
pony.Tools.superIndexOf = function(it,v,maxDepth) {
	if(maxDepth == null) maxDepth = 1;
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(pony.Tools.equal(e,v,maxDepth)) return i;
		i++;
	}
	return -1;
};
pony.Tools.superMultyIndexOf = function(it,av,maxDepth) {
	if(maxDepth == null) maxDepth = 1;
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		var _g = 0;
		while(_g < av.length) {
			var v = av[_g];
			++_g;
			if(pony.Tools.equal(e,v,maxDepth)) return i;
		}
		i++;
	}
	return -1;
};
pony.Tools.multyIndexOf = function(it,av) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		var _g = 0;
		while(_g < av.length) {
			var v = av[_g];
			++_g;
			if(e == v) return i;
		}
		i++;
	}
	return -1;
};
pony.Tools.cut = function(inp) {
	var out = new haxe.io.BytesOutput();
	var cntNull = 0;
	var flagNull = true;
	var cur = -99;
	while(true) {
		try {
			cur = inp.readByte();
		} catch( _ ) {
			break;
		}
		if(cur == 0) {
			if(!flagNull) flagNull = true;
			cntNull++;
		} else {
			if(flagNull) while(cntNull-- > 0) out.writeByte(0);
			flagNull = false;
			out.writeByte(cur);
		}
	}
	out.close();
	return new haxe.io.BytesInput(out.getBytes());
};
pony.Tools.exists = function(a,e) {
	return Lambda.indexOf(a,e) != -1;
};
pony.Tools.bytesIterator = function(b) {
	var i = 0;
	return { hasNext : function() {
		return i < b.length;
	}, next : function() {
		return b.get(i++);
	}};
};
pony.Tools.bytesInputIterator = function(b) {
	var i = 0;
	return { hasNext : function() {
		return b.pos < b.totlen;
	}, next : function() {
		return b.readByte();
	}};
};
pony.Tools.setFields = function(a,b) {
	var _g = 0;
	var _g1 = Reflect.fields(b);
	while(_g < _g1.length) {
		var p = _g1[_g];
		++_g;
		var d = Reflect.field(b,p);
		if(Reflect.isObject(d) && !(typeof(d) == "string")) pony.Tools.setFields(Reflect.field(a,p),d); else a[p] = d;
	}
};
pony.Tools.copyFields = function(a,b) {
	var _g = 0;
	var _g1 = Reflect.fields(b);
	while(_g < _g1.length) {
		var p = _g1[_g];
		++_g;
		Reflect.setField(a,p,Reflect.field(b,p));
	}
};
pony.Tools.parsePrefixObjects = function(a,delimiter) {
	if(delimiter == null) delimiter = "_";
	var result = { };
	var _g = 0;
	var _g1 = Reflect.fields(a);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		var d = f.split(delimiter);
		var obj = result;
		var _g3 = 0;
		var _g2 = d.length - 1;
		while(_g3 < _g2) {
			var i = _g3++;
			if(Object.prototype.hasOwnProperty.call(obj,d[i])) obj = Reflect.field(obj,d[i]); else {
				var newObj = { };
				obj[d[i]] = newObj;
				obj = newObj;
			}
		}
		Reflect.setField(obj,d.pop(),Reflect.field(a,f));
	}
	return result;
};
pony.Tools.convertObject = function(a,fun) {
	var result = { };
	var _g = 0;
	var _g1 = Reflect.fields(a);
	while(_g < _g1.length) {
		var p = _g1[_g];
		++_g;
		var d = Reflect.field(a,p);
		if(Reflect.isObject(d) && !(typeof(d) == "string")) Reflect.setField(result,p,pony.Tools.convertObject(d,fun)); else Reflect.setField(result,p,fun(d));
	}
	return result;
};
pony.Tools.traceThrow = function(e) {
	haxe.Log.trace(e,null);
	haxe.Log.trace(haxe.CallStack.toString(haxe.CallStack.exceptionStack()),null);
};
pony.Tools.writeStr = function(b,s) {
	b.writeInt32(s.length);
	b.writeString(s);
};
pony.Tools.readStr = function(b) {
	try {
		return b.readString(b.readInt32());
	} catch( _ ) {
		return null;
	}
};
pony.Tools.reverse = function(map) {
	var _g = new haxe.ds.EnumValueMap();
	var $it0 = map.keys();
	while( $it0.hasNext() ) {
		var k = $it0.next();
		var key = map.get(k);
		_g.set(key,k);
	}
	return _g;
};
pony.Tools.min = function(it) {
	return Reflect.field(it,"min");
};
pony.Tools.max = function(it) {
	return Reflect.field(it,"max");
};
pony.Tools.copy = function(it) {
	return new IntIterator(Reflect.field(it,"min"),Reflect.field(it,"max"));
};
pony.Tools.nullFunction0 = function() {
	return;
};
pony.Tools.nullFunction1 = function(_) {
	return;
};
pony.Tools.nullFunction2 = function(_,_1) {
	return;
};
pony.Tools.nullFunction3 = function(_,_1,_2) {
	return;
};
pony.Tools.nullFunction4 = function(_,_1,_2,_3) {
	return;
};
pony.Tools.nullFunction5 = function(_,_1,_2,_3,_4) {
	return;
};
pony.Tools.errorFunction = function(e) {
	throw e;
};
pony.ArrayTools = function() { };
pony.ArrayTools.__name__ = ["pony","ArrayTools"];
pony.ArrayTools.exists = function(a,e) {
	return HxOverrides.indexOf(a,e,0) != -1;
};
pony.ArrayTools.thereIs = function(a,b) {
	var $it0 = $iterator(a)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(pony.Tools.equal(e,b)) return true;
	}
	return false;
};
pony.ArrayTools.kv = function(a) {
	var i = 0;
	var it = $iterator(a)();
	return { hasNext : $bind(it,it.hasNext), next : function() {
		var p;
		var b = it.next();
		p = { a : i, b : b};
		i++;
		return p;
	}};
};
pony.ArrayTools.toBytes = function(a) {
	var b = new haxe.io.BytesOutput();
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		b.writeByte(e);
	}
	return b;
};
pony.ArrayTools.randomize = function(a) {
	a.sort(pony.ArrayTools.randomizeSort);
	return a;
};
pony.ArrayTools.randomizeSort = function(_,_1) {
	if(Math.random() > 0.5) return 1; else return -1;
};
pony.ArrayTools.last = function(a) {
	return a[a.length - 1];
};
pony.ArrayTools.swap = function(array,a,b) {
	if(a > b) return pony.ArrayTools.swap(array,b,a); else if(a == b) return array;
	var v1 = array[a];
	var v2 = array[b];
	var p1;
	if(a == 0) p1 = []; else p1 = array.slice(0,a);
	var p2 = array.slice(a + 1,b);
	var p3 = array.slice(b + 1);
	p1.push(v2);
	p2.push(v1);
	return p1.concat(p2).concat(p3);
};
pony.ArrayTools["delete"] = function(array,index) {
	var na = [];
	var _g1 = 0;
	var _g = array.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(i != index) na.push(array[i]);
	}
	return na;
};
pony.FloatTools = function() { };
pony.FloatTools.__name__ = ["pony","FloatTools"];
pony.FloatTools._toFixed = function(v,n,begin,d,beginS,endS) {
	if(endS == null) endS = "0";
	if(beginS == null) beginS = "0";
	if(d == null) d = ".";
	if(begin == null) begin = 0;
	if(begin != 0) {
		var s = pony.FloatTools._toFixed(v,n,0,d,beginS,endS);
		var a = s.split(d);
		var d1 = begin - a[0].length;
		return pony.text.TextTools.repeat(beginS,d1) + s;
	}
	if(n == 0) return Std.string(v | 0);
	var p = Math.pow(10,n);
	v = Math.floor(v * p) / p;
	var s1;
	if(v == null) s1 = "null"; else s1 = "" + v;
	var a1 = s1.split(".");
	if(a1.length <= 1) return s1 + d + pony.text.TextTools.repeat(endS,n); else return a1[0] + d + a1[1] + pony.text.TextTools.repeat(endS,n - a1[1].length);
};
pony.XMLTools = function() { };
pony.XMLTools.__name__ = ["pony","XMLTools"];
pony.XMLTools.isTrue = function(x,name) {
	return x.has.resolve(name) && pony.text.TextTools.isTrue(x.att.resolve(name));
};
pony.XMLTools.fast = function(text) {
	return new haxe.xml.Fast(Xml.parse(text));
};
pony.events = {};
pony.events.Event = function(args,target,parent) {
	this.target = target;
	if(args == null) this.args = []; else this.args = args;
	this.parent = parent;
	this._stopPropagation = false;
};
pony.events.Event.__name__ = ["pony","events","Event"];
pony.events.Event.__interfaces__ = [pony.IEvent];
pony.events.Event.prototype = {
	parent: null
	,args: null
	,prev: null
	,_stopPropagation: null
	,signal: null
	,target: null
	,currentListener: null
	,_setListener: function(l) {
		this.currentListener = l;
	}
	,stopPropagation: function(lvl) {
		if(lvl == null) lvl = -1;
		if(this.parent != null && (lvl == -1 || lvl > 0)) this.parent.stopPropagation(lvl - 1);
		this._stopPropagation = true;
	}
	,get_count: function() {
		return this.currentListener.count;
	}
	,set_count: function(v) {
		return this.currentListener.count = v;
	}
	,get_prev: function() {
		return this.currentListener.prev;
	}
	,__class__: pony.events.Event
};
pony.events._Listener = {};
pony.events._Listener.Listener_Impl_ = function() { };
pony.events._Listener.Listener_Impl_.__name__ = ["pony","events","_Listener","Listener_Impl_"];
pony.events._Listener.Listener_Impl_._new = function(f,count) {
	if(count == null) count = -1;
	var this1;
	f.used++;
	this1 = { f : f, count : count, event : f.event, prev : null, used : 0, active : true, ignoreReturn : !f.ret};
	return this1;
};
pony.events._Listener.Listener_Impl_.fromFunction = function(f) {
	return pony.events._Listener.Listener_Impl_._fromFunction(f);
};
pony.events._Listener.Listener_Impl_.fromSignal = function(s) {
	var f = pony._Function.Function_Impl_.from($bind(s,s.dispatchEvent),1,true,true);
	return pony.events._Listener.Listener_Impl_._fromFunction(f);
};
pony.events._Listener.Listener_Impl_._fromFunction = function(f) {
	if(pony.events._Listener.Listener_Impl_.flist.exists(f.id)) return pony.events._Listener.Listener_Impl_.flist.get(f.id); else {
		var o;
		var this1;
		f.used++;
		this1 = { f : f, count : -1, event : f.event, prev : null, used : 0, active : true, ignoreReturn : !f.ret};
		o = this1;
		pony.events._Listener.Listener_Impl_.flist.set(f.id,o);
		return o;
	}
};
pony.events._Listener.Listener_Impl_.get_count = function(this1) {
	return this1.count;
};
pony.events._Listener.Listener_Impl_.call = function(this1,event) {
	if(!this1.active) return true;
	this1.count--;
	event.currentListener = this1;
	var r = true;
	if(this1.event) {
		if(this1.ignoreReturn) {
			var this2 = this1.f;
			var args = [event];
			if(args == null) args = [];
			Reflect.callMethod(null,this2.f,this2.args.concat(args));
		} else if((function($this) {
			var $r;
			var this3 = this1.f;
			var args1 = [event];
			if(args1 == null) args1 = [];
			$r = Reflect.callMethod(null,this3.f,this3.args.concat(args1));
			return $r;
		}(this)) == false) r = false;
	} else {
		var args2 = [];
		var _g = 0;
		var _g1 = event.args;
		while(_g < _g1.length) {
			var e = _g1[_g];
			++_g;
			args2.push(e);
		}
		args2.push(event.target);
		args2.push(event);
		if(this1.ignoreReturn) {
			var this4 = this1.f;
			var args3 = args2.slice(0,this1.f.count);
			if(args3 == null) args3 = [];
			Reflect.callMethod(null,this4.f,this4.args.concat(args3));
		} else if((function($this) {
			var $r;
			var this5 = this1.f;
			var args4 = args2.slice(0,this1.f.count);
			if(args4 == null) args4 = [];
			$r = Reflect.callMethod(null,this5.f,this5.args.concat(args4));
			return $r;
		}(this)) == false) r = false;
	}
	this1.prev = event;
	if(event._stopPropagation) return false; else return r;
};
pony.events._Listener.Listener_Impl_.setCount = function(this1,count) {
	var f = this1.f;
	var this2;
	f.used++;
	this2 = { f : f, count : count, event : f.event, prev : null, used : 0, active : true, ignoreReturn : !f.ret};
	return this2;
};
pony.events._Listener.Listener_Impl_._use = function(this1) {
	this1.used++;
};
pony.events._Listener.Listener_Impl_.unuse = function(this1) {
	this1.used--;
	if(this1.used == 0) {
		pony.events._Listener.Listener_Impl_.flist.remove(this1.f.id);
		this1.f.used--;
		if(this1.f.used <= 0) {
			pony._Function.Function_Impl_.list.remove(this1.f.f);
			this1.f = null;
			pony._Function.Function_Impl_.unusedCount--;
		}
	}
};
pony.events._Listener.Listener_Impl_.get_used = function(this1) {
	return this1.used;
};
pony.events._Listener.Listener_Impl_.unusedCount = function() {
	var c = 0;
	var $it0 = pony.events._Listener.Listener_Impl_.flist.iterator();
	while( $it0.hasNext() ) {
		var l = $it0.next();
		if(l.used <= 0) c++;
	}
	return c;
};
pony.events._Listener.Listener_Impl_.get_active = function(this1) {
	return this1.active;
};
pony.events._Listener.Listener_Impl_.set_active = function(this1,b) {
	return this1.active = b;
};
pony.events._Listener0 = {};
pony.events._Listener0.Listener0_Impl_ = function() { };
pony.events._Listener0.Listener0_Impl_.__name__ = ["pony","events","_Listener0","Listener0_Impl_"];
pony.events._Listener0.Listener0_Impl_._new = function(l) {
	return l;
};
pony.events._Listener0.Listener0_Impl_.from0 = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,0,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener0.Listener0_Impl_.fromE = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,1,false,true);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener0.Listener0_Impl_.from0T = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,1,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener0.Listener0_Impl_.fromTE = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,2,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener0.Listener0_Impl_.to = function(this1) {
	return this1;
};
pony.events._Listener0.Listener0_Impl_.fromSignal0 = function(s) {
	var f = (function(_e) {
		return function(event) {
			return pony.events._Signal0.Signal0_Impl_.dispatchEvent(_e,event);
		};
	})(s);
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,1,false,true);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener1 = {};
pony.events._Listener1.Listener1_Impl_ = function() { };
pony.events._Listener1.Listener1_Impl_.__name__ = ["pony","events","_Listener1","Listener1_Impl_"];
pony.events._Listener1.Listener1_Impl_._new = function(l) {
	return l;
};
pony.events._Listener1.Listener1_Impl_.from0 = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,0,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener1.Listener1_Impl_.fromE = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,1,false,true);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener1.Listener1_Impl_.from1 = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,1,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener1.Listener1_Impl_.from1T = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,2,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener1.Listener1_Impl_.from1TE = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,3,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener1.Listener1_Impl_.to = function(this1) {
	return this1;
};
pony.events._Listener1.Listener1_Impl_.fromSignal0 = function(s) {
	var l;
	var f;
	var f1 = (function(_e) {
		return function(event) {
			return pony.events._Signal0.Signal0_Impl_.dispatchEvent(_e,event);
		};
	})(s);
	f = pony._Function.Function_Impl_.from(f1,1,true,true);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f);
	return l;
};
pony.events._Listener1.Listener1_Impl_.fromSignal1 = function(s) {
	var l;
	var f;
	var f1 = (function(_e) {
		return function(event) {
			return pony.events._Signal1.Signal1_Impl_.dispatchEvent(_e,event);
		};
	})(s);
	f = pony._Function.Function_Impl_.from(f1,1,true,true);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f);
	return l;
};
pony.events._Listener2 = {};
pony.events._Listener2.Listener2_Impl_ = function() { };
pony.events._Listener2.Listener2_Impl_.__name__ = ["pony","events","_Listener2","Listener2_Impl_"];
pony.events._Listener2.Listener2_Impl_._new = function(l) {
	return l;
};
pony.events._Listener2.Listener2_Impl_.from0 = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,0,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener2.Listener2_Impl_.fromE = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,1,false,true);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener2.Listener2_Impl_.from1 = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,1,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener2.Listener2_Impl_.from1E = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,2,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener2.Listener2_Impl_.from2 = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,2,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener2.Listener2_Impl_.from2T = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,3,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener2.Listener2_Impl_.from2TE = function(f) {
	var l;
	var f1 = pony._Function.Function_Impl_.from(f,4,false);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
	return l;
};
pony.events._Listener2.Listener2_Impl_.to = function(this1) {
	return this1;
};
pony.events._Listener2.Listener2_Impl_.fromSignal0 = function(s) {
	var l;
	var f;
	var f1 = (function(_e) {
		return function(event) {
			return pony.events._Signal0.Signal0_Impl_.dispatchEvent(_e,event);
		};
	})(s);
	f = pony._Function.Function_Impl_.from(f1,1,true,true);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f);
	return l;
};
pony.events._Listener2.Listener2_Impl_.fromSignal1 = function(s) {
	var l;
	var f;
	var f1 = (function(_e) {
		return function(event) {
			return pony.events._Signal1.Signal1_Impl_.dispatchEvent(_e,event);
		};
	})(s);
	f = pony._Function.Function_Impl_.from(f1,1,true,true);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f);
	return l;
};
pony.events._Listener2.Listener2_Impl_.fromSignal2 = function(s) {
	var l;
	var f;
	var f1 = (function(_e) {
		return function(event) {
			return pony.events._Signal2.Signal2_Impl_.dispatchEvent(_e,event);
		};
	})(s);
	f = pony._Function.Function_Impl_.from(f1,1,true,true);
	l = pony.events._Listener.Listener_Impl_._fromFunction(f);
	return l;
};
pony.events.Signal = function(target) {
	this.silent = false;
	this.subMap = new pony.Dictionary(5);
	this.subHandlers = new haxe.ds.IntMap();
	this.bindMap = new pony.Dictionary(5);
	this.bindHandlers = new haxe.ds.IntMap();
	this.notMap = new pony.Dictionary(5);
	this.notHandlers = new haxe.ds.IntMap();
	this.id = pony.events.Signal.signalsCount++;
	this.target = target;
	this.listeners = new pony.Priority();
	this.lRunCopy = new List();
	this;
	var s = Type.createEmptyInstance(pony.events.Signal).init(this);
	this.lostListeners = s;
	var s1 = Type.createEmptyInstance(pony.events.Signal).init(this);
	this.takeListeners = s1;
};
pony.events.Signal.__name__ = ["pony","events","Signal"];
pony.events.Signal.create = function(t) {
	var s = new pony.events.Signal(t);
	return s;
};
pony.events.Signal.createEmpty = function() {
	var s = new pony.events.Signal();
	return s;
};
pony.events.Signal.prototype = {
	id: null
	,silent: null
	,lostListeners: null
	,takeListeners: null
	,data: null
	,target: null
	,listeners: null
	,lRunCopy: null
	,subMap: null
	,subHandlers: null
	,bindMap: null
	,bindHandlers: null
	,notMap: null
	,notHandlers: null
	,haveListeners: null
	,parent: null
	,init: function(target) {
		this.id = pony.events.Signal.signalsCount++;
		this.target = target;
		this.listeners = new pony.Priority();
		this.lRunCopy = new List();
		return this;
	}
	,add: function(listener,priority) {
		if(priority == null) priority = 0;
		listener.used++;
		var f = this.listeners.data.length == 0;
		this.listeners.addElement(listener,priority);
		if(f && this.takeListeners != null) pony.events._Signal0.Signal0_Impl_.dispatchEmpty(this.takeListeners);
		return this;
	}
	,remove: function(listener) {
		if(this.listeners.data.length == 0) return this;
		if(this.listeners.removeElement(listener)) {
			var $it0 = this.lRunCopy.iterator();
			while( $it0.hasNext() ) {
				var c = $it0.next();
				c.removeElement(listener);
			}
			listener.used--;
			if(listener.used == 0) {
				pony.events._Listener.Listener_Impl_.flist.remove(listener.f.id);
				listener.f.used--;
				if(listener.f.used <= 0) {
					pony._Function.Function_Impl_.list.remove(listener.f.f);
					listener.f = null;
					pony._Function.Function_Impl_.unusedCount--;
				}
			}
			if(this.listeners.data.length == 0 && this.lostListeners != null) pony.events._Signal0.Signal0_Impl_.dispatchEmpty(this.lostListeners);
		}
		return this;
	}
	,changePriority: function(listener,priority) {
		if(priority == null) priority = 0;
		this.listeners.changeElement(listener,priority);
		return this;
	}
	,once: function(listener,priority) {
		if(priority == null) priority = 0;
		return this.add((function($this) {
			var $r;
			var f = listener.f;
			var this1;
			f.used++;
			this1 = { f : f, count : 1, event : f.event, prev : null, used : 0, active : true, ignoreReturn : !f.ret};
			$r = this1;
			return $r;
		}(this)),priority);
	}
	,dispatchEvent: function(event) {
		if(this.listeners.data.length == 0) return this;
		event.signal = this;
		if(this.silent) return this;
		var c = new pony.Priority(this.listeners.data.slice());
		this.lRunCopy.add(c);
		var $it0 = c.iterator();
		while( $it0.hasNext() ) {
			var l = $it0.next();
			var r = false;
			try {
				r = pony.events._Listener.Listener_Impl_.call(l,event);
			} catch( $e1 ) {
				if( js.Boot.__instanceof($e1,String) ) {
					var msg = $e1;
					this.remove(l);
					this.lRunCopy.remove(c);
					throw msg;
				} else {
				var e = $e1;
				this.remove(l);
				this.lRunCopy.remove(c);
				try {
					haxe.Log.trace(haxe.CallStack.toString(haxe.CallStack.exceptionStack()),{ fileName : "Signal.hx", lineNumber : 202, className : "pony.events.Signal", methodName : "dispatchEvent"});
				} catch( e1 ) {
				}
				throw e;
				}
			}
			if(l.count == 0) this.remove(l);
			if(!r) break;
		}
		this.lRunCopy.remove(c);
		return this;
	}
	,dispatchArgs: function(args) {
		this.dispatchEvent(new pony.events.Event(args,this.target));
		return this;
	}
	,dispatchEmpty: function() {
		this.dispatchEvent(new pony.events.Event(null,this.target));
	}
	,dispatchEmpty1: function(_) {
		this.dispatchEvent(new pony.events.Event(null,this.target));
	}
	,subArgs: function(args,priority) {
		if(priority == null) priority = 0;
		var s = this.subMap.get(args);
		if(s == null) {
			s = new pony.events.Signal(this.target);
			s.parent = this;
			var l;
			var f;
			var f1 = (function(f2,a1) {
				return function(a2) {
					f2(a1,a2);
				};
			})($bind(this,this.subHandler),args);
			f = pony._Function.Function_Impl_.from(f1,1,false,true);
			l = pony.events._Listener.Listener_Impl_._fromFunction(f);
			var k = this.subMap.set(args,s);
			this.subHandlers.set(k,l);
			l;
			this.add(l,priority);
		}
		return s;
	}
	,subHandler: function(args,event) {
		var a = event.args.slice();
		var _g = 0;
		while(_g < args.length) {
			var arg = args[_g];
			++_g;
			if(a.shift() != arg) return;
		}
		this.subMap.get(args).dispatchEvent(new pony.events.Event(a,event.target,event));
	}
	,changeSubArgs: function(args,priority) {
		if(priority == null) priority = 0;
		this.removeSubArgs(args);
		return this.subArgs(args,priority);
	}
	,removeSubArgs: function(args) {
		var s = this.subMap.get(args);
		if(s == null) return this;
		s.destroy();
		return this;
	}
	,removeAllSub: function() {
		if(this.subMap != null) {
			var $it0 = HxOverrides.iter(this.subMap.vs);
			while( $it0.hasNext() ) {
				var e = $it0.next();
				e.destroy();
			}
			this.subMap.clear();
		}
		return this;
	}
	,removeSubSignal: function(s) {
		var i = HxOverrides.indexOf(this.subMap.vs,s,0);
		if(i != -1) {
			s.remove(this.subHandlers.get(i));
			this.subHandlers.remove(i);
			this.subMap.removeIndex(i);
		}
		var i1 = HxOverrides.indexOf(this.bindMap.vs,s,0);
		if(i1 != -1) {
			s.remove(this.bindHandlers.get(i1));
			this.bindHandlers.remove(i1);
			this.bindMap.removeIndex(i1);
		}
		var i2 = HxOverrides.indexOf(this.notMap.vs,s,0);
		if(i2 != -1) {
			s.remove(this.notHandlers.get(i2));
			this.notHandlers.remove(i2);
			this.notMap.removeIndex(i2);
		}
	}
	,bindArgs: function(args,priority) {
		if(priority == null) priority = 0;
		var s = this.bindMap.get(args);
		if(s == null) {
			s = new pony.events.Signal(this.target);
			s.parent = this;
			var l;
			var f;
			var f1 = (function(f2,a1) {
				return function(a2) {
					f2(a1,a2);
				};
			})($bind(this,this.bindHandler),args);
			f = pony._Function.Function_Impl_.from(f1,1,false,true);
			l = pony.events._Listener.Listener_Impl_._fromFunction(f);
			var k = this.bindMap.set(args,s);
			this.bindHandlers.set(k,l);
			l;
			this.add(l,priority);
		}
		return s;
	}
	,bindHandler: function(args,event) {
		this.bindMap.get(args).dispatchEvent(new pony.events.Event(args.concat(event.args),event.target,event));
	}
	,removeBindArgs: function(args) {
		var s = this.bindMap.get(args);
		if(s == null) return this;
		s.destroy();
		return this;
	}
	,removeAllBind: function() {
		if(this.bindMap != null) {
			var $it0 = HxOverrides.iter(this.bindMap.vs);
			while( $it0.hasNext() ) {
				var e = $it0.next();
				e.destroy();
			}
			this.bindMap.clear();
		}
		return this;
	}
	,notArgs: function(args,priority) {
		if(priority == null) priority = 0;
		var s = this.bindMap.get(args);
		if(s == null) {
			s = new pony.events.Signal(this.target);
			s.parent = this;
			var l;
			var f;
			var f1 = (function(f2,a1) {
				return function(a2) {
					f2(a1,a2);
				};
			})($bind(this,this.notHandler),args);
			f = pony._Function.Function_Impl_.from(f1,1,false,true);
			l = pony.events._Listener.Listener_Impl_._fromFunction(f);
			var k = this.notMap.set(args,s);
			this.notHandlers.set(k,l);
			l;
			this.add(l,priority);
		}
		return s;
	}
	,notHandler: function(args,event) {
		var a = event.args.slice();
		var _g = 0;
		while(_g < args.length) {
			var arg = args[_g];
			++_g;
			if(a.shift() == arg) return;
		}
		this.notMap.get(args).dispatchEvent(new pony.events.Event(a,event.target,event));
	}
	,removeNotArgs: function(args) {
		var s = this.bindMap.get(args);
		if(s == null) return this;
		s.destroy();
		return this;
	}
	,removeAllNot: function() {
		if(this.notMap != null) {
			var $it0 = HxOverrides.iter(this.notMap.vs);
			while( $it0.hasNext() ) {
				var e = $it0.next();
				e.destroy();
			}
			this.notMap.clear();
		}
		return this;
	}
	,and: function(signal) {
		var _g = this;
		var ns = new pony.events.Signal();
		var lock1 = false;
		var lock2 = false;
		this.add((function($this) {
			var $r;
			var f = pony._Function.Function_Impl_.from(function(e1) {
				if(lock1) return;
				lock2 = true;
				signal.once((function($this) {
					var $r;
					var f1 = pony._Function.Function_Impl_.from(function(e2) {
						lock2 = false;
						ns.dispatchEvent(new pony.events.Event(e1.args.concat(e2.args),_g.target,e1));
					},1,false,true);
					$r = pony.events._Listener.Listener_Impl_._fromFunction(f1);
					return $r;
				}(this)),null);
			},1,false,true);
			$r = pony.events._Listener.Listener_Impl_._fromFunction(f);
			return $r;
		}(this)));
		signal.add((function($this) {
			var $r;
			var f2 = pony._Function.Function_Impl_.from(function(e21) {
				if(lock2) return;
				lock1 = true;
				_g.once((function($this) {
					var $r;
					var f3 = pony._Function.Function_Impl_.from(function(e11) {
						lock1 = false;
						ns.dispatchEvent(new pony.events.Event(e11.args.concat(e21.args),_g.target,e11));
					},1,false,true);
					$r = pony.events._Listener.Listener_Impl_._fromFunction(f3);
					return $r;
				}(this)),null);
			},1,false,true);
			$r = pony.events._Listener.Listener_Impl_._fromFunction(f2);
			return $r;
		}(this)));
		return ns;
	}
	,or: function(signal) {
		var ns = new pony.events.Signal();
		this.add((function($this) {
			var $r;
			var f = pony._Function.Function_Impl_.from($bind(ns,ns.dispatchEvent),1,true,true);
			$r = pony.events._Listener.Listener_Impl_._fromFunction(f);
			return $r;
		}(this)));
		signal.add((function($this) {
			var $r;
			var f1 = pony._Function.Function_Impl_.from($bind(ns,ns.dispatchEvent),1,true,true);
			$r = pony.events._Listener.Listener_Impl_._fromFunction(f1);
			return $r;
		}(this)));
		return ns;
	}
	,removeAllListeners: function() {
		var f = this.listeners.data.length == 0;
		var $it0 = this.listeners.iterator();
		while( $it0.hasNext() ) {
			var l = $it0.next();
			l.used--;
			if(l.used == 0) {
				pony.events._Listener.Listener_Impl_.flist.remove(l.f.id);
				l.f.used--;
				if(l.f.used <= 0) {
					pony._Function.Function_Impl_.list.remove(l.f.f);
					l.f = null;
					pony._Function.Function_Impl_.unusedCount--;
				}
			}
		}
		this.listeners.clear();
		if(!f && this.lostListeners != null) pony.events._Signal0.Signal0_Impl_.dispatch(this.lostListeners);
		return this;
	}
	,buildListenerEvent: function(event) {
		var _g = this;
		var f = pony._Function.Function_Impl_.from(function() {
			_g.dispatchEvent(event);
		},0,false);
		return pony.events._Listener.Listener_Impl_._fromFunction(f);
	}
	,buildListenerArgs: function(args) {
		return this.buildListenerEvent(new pony.events.Event(args,this.target));
	}
	,buildListenerEmpty: function() {
		return this.buildListenerEvent(new pony.events.Event(null,this.target));
	}
	,get_haveListeners: function() {
		return !(this.listeners.data.length == 0);
	}
	,sw: function(l1,l2,priority) {
		if(priority == null) priority = 0;
		this.once(l1,priority);
		this.once((function($this) {
			var $r;
			var f;
			{
				var f1 = (function(f2,l11,l21,a1) {
					return function() {
						return f2(l11,l21,a1);
					};
				})($bind($this,$this.sw),l2,l1,priority);
				f = pony._Function.Function_Impl_.from(f1,0);
			}
			$r = pony.events._Listener.Listener_Impl_._fromFunction(f);
			return $r;
		}(this)),priority);
		return this;
	}
	,enableSilent: function() {
		this.silent = true;
	}
	,disableSilent: function() {
		this.silent = false;
	}
	,get_listenersCount: function() {
		return this.listeners.data.length;
	}
	,destroy: function() {
		if(this.parent != null) this.parent.removeSubSignal(this);
		if(this.subMap != null) {
			var $it0 = HxOverrides.iter(this.subMap.vs);
			while( $it0.hasNext() ) {
				var e = $it0.next();
				e.destroy();
			}
			this.subMap.clear();
		}
		this;
		if(this.bindMap != null) {
			var $it1 = HxOverrides.iter(this.bindMap.vs);
			while( $it1.hasNext() ) {
				var e1 = $it1.next();
				e1.destroy();
			}
			this.bindMap.clear();
		}
		this;
		if(this.notMap != null) {
			var $it2 = HxOverrides.iter(this.notMap.vs);
			while( $it2.hasNext() ) {
				var e2 = $it2.next();
				e2.destroy();
			}
			this.notMap.clear();
		}
		this;
		this.removeAllListeners();
		if(this.takeListeners != null) {
			var this1 = this.takeListeners;
			this1.destroy();
			this1.target;
			this.takeListeners = null;
		}
		if(this.lostListeners != null) {
			var this2 = this.lostListeners;
			this2.destroy();
			this2.target;
			this.lostListeners = null;
		}
	}
	,debug: function() {
		var _g = this;
		this.add((function($this) {
			var $r;
			var f = pony._Function.Function_Impl_.from(function() {
				haxe.Log.trace("dispatch(" + _g.id + ")",{ fileName : "Signal.hx", lineNumber : 482, className : "pony.events.Signal", methodName : "debug"});
			},0,false);
			$r = pony.events._Listener.Listener_Impl_._fromFunction(f);
			return $r;
		}(this)));
	}
	,__class__: pony.events.Signal
};
pony.events._Signal0 = {};
pony.events._Signal0.Signal0_Impl_ = function() { };
pony.events._Signal0.Signal0_Impl_.__name__ = ["pony","events","_Signal0","Signal0_Impl_"];
pony.events._Signal0.Signal0_Impl_._new = function(s) {
	return s;
};
pony.events._Signal0.Signal0_Impl_.get_silent = function(this1) {
	return this1.silent;
};
pony.events._Signal0.Signal0_Impl_.set_silent = function(this1,b) {
	return this1.silent = b;
};
pony.events._Signal0.Signal0_Impl_.get_lostListeners = function(this1) {
	return this1.lostListeners;
};
pony.events._Signal0.Signal0_Impl_.get_takeListeners = function(this1) {
	return this1.takeListeners;
};
pony.events._Signal0.Signal0_Impl_.get_haveListeners = function(this1) {
	return !(this1.listeners.data.length == 0);
};
pony.events._Signal0.Signal0_Impl_.get_data = function(this1) {
	return this1.data;
};
pony.events._Signal0.Signal0_Impl_.set_data = function(this1,d) {
	return this1.data = d;
};
pony.events._Signal0.Signal0_Impl_.get_target = function(this1) {
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.get_listenersCount = function(this1) {
	return this1.listeners.data.length;
};
pony.events._Signal0.Signal0_Impl_.add = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.add(listener,priority);
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.once = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.once(listener,priority);
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.remove = function(this1,listener) {
	this1.remove(listener);
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.changePriority = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.listeners.changeElement(listener,priority);
	this1;
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.dispatch = function(this1) {
	this1.dispatchEmpty();
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.dispatchEvent = function(this1,event) {
	this1.dispatchEvent(event);
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.dispatchArgs = function(this1) {
	this1.dispatchEmpty();
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.dispatchEmpty = function(this1) {
	this1.dispatchEmpty();
};
pony.events._Signal0.Signal0_Impl_.dispatchEmpty1 = function(this1,_) {
	this1.dispatchEmpty();
};
pony.events._Signal0.Signal0_Impl_.bind = function(this1,a,b,c,d,e,f,g) {
	if(g != null) return this1.bindArgs([a,b,c,d,e,f,g],0); else if(f != null) return this1.bindArgs([a,b,c,d,e,f],0); else if(e != null) return this1.bindArgs([a,b,c,d,e],0); else if(d != null) return this1.bindArgs([a,b,c,d],0); else if(c != null) return this1.bindArgs([a,b,c],0); else if(b != null) return this1.bindArgs([a,b],0); else return this1.bindArgs([a],0);
};
pony.events._Signal0.Signal0_Impl_.bindArgs = function(this1,args,priority) {
	if(priority == null) priority = 0;
	return this1.bindArgs(args,priority);
};
pony.events._Signal0.Signal0_Impl_.bind1 = function(this1,a,priority) {
	if(priority == null) priority = 0;
	var s = this1.bindArgs([a],priority);
	return s;
};
pony.events._Signal0.Signal0_Impl_.bind2 = function(this1,a,b,priority) {
	if(priority == null) priority = 0;
	var s = this1.bindArgs([a,b],priority);
	return s;
};
pony.events._Signal0.Signal0_Impl_.removeBindArgs = function(this1,args) {
	this1.removeBindArgs(args);
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.and = function(this1,s) {
	return this1.and(s);
};
pony.events._Signal0.Signal0_Impl_.and0 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal0.Signal0_Impl_.and1 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal0.Signal0_Impl_.and2 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal0.Signal0_Impl_.or = function(this1,s) {
	var s1 = this1.or(s);
	return s1;
};
pony.events._Signal0.Signal0_Impl_.removeAllListeners = function(this1) {
	this1.removeAllListeners();
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.sw = function(this1,l1,l2) {
	this1.sw(l1,l2);
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.enableSilent = function(this1) {
	this1.silent = true;
};
pony.events._Signal0.Signal0_Impl_.disableSilent = function(this1) {
	this1.silent = false;
};
pony.events._Signal0.Signal0_Impl_.destroy = function(this1) {
	this1.destroy();
	return this1.target;
};
pony.events._Signal0.Signal0_Impl_.from = function(s) {
	return s;
};
pony.events._Signal0.Signal0_Impl_.toDynamic = function(this1) {
	return this1;
};
pony.events._Signal0.Signal0_Impl_.toTar = function(this1) {
	return this1;
};
pony.events._Signal0.Signal0_Impl_.toFunction = function(this1) {
	return (function(_e) {
		return function() {
			return pony.events._Signal0.Signal0_Impl_.dispatch(_e);
		};
	})(this1);
};
pony.events._Signal0.Signal0_Impl_.toFunction2 = function(this1) {
	return (function(_e) {
		return function(event) {
			return pony.events._Signal0.Signal0_Impl_.dispatchEvent(_e,event);
		};
	})(this1);
};
pony.events._Signal0.Signal0_Impl_.debug = function(this1) {
	this1.debug();
};
pony.events._Signal0.Signal0_Impl_.op_add = function(this1,listener) {
	pony.events._Signal0.Signal0_Impl_.add(this1,listener);
	return this1;
};
pony.events._Signal0.Signal0_Impl_.op_once = function(this1,listener) {
	pony.events._Signal0.Signal0_Impl_.once(this1,listener);
	return this1;
};
pony.events._Signal0.Signal0_Impl_.op_remove = function(this1,listener) {
	pony.events._Signal0.Signal0_Impl_.remove(this1,listener);
	return this1;
};
pony.events._Signal0.Signal0_Impl_.op_and0 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal0.Signal0_Impl_.op_and1 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal0.Signal0_Impl_.op_and2 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal0.Signal0_Impl_.op_or = function(this1,s) {
	var s1 = this1.or(s);
	return s1;
};
pony.events._Signal0.Signal0_Impl_.op_bind1 = function(this1,a) {
	var s = this1.bindArgs([a],0);
	return s;
};
pony.events._Signal1 = {};
pony.events._Signal1.Signal1_Impl_ = function() { };
pony.events._Signal1.Signal1_Impl_.__name__ = ["pony","events","_Signal1","Signal1_Impl_"];
pony.events._Signal1.Signal1_Impl_._new = function(s) {
	return s;
};
pony.events._Signal1.Signal1_Impl_.get_silent = function(this1) {
	return this1.silent;
};
pony.events._Signal1.Signal1_Impl_.set_silent = function(this1,b) {
	return this1.silent = b;
};
pony.events._Signal1.Signal1_Impl_.get_lostListeners = function(this1) {
	return this1.lostListeners;
};
pony.events._Signal1.Signal1_Impl_.get_takeListeners = function(this1) {
	return this1.takeListeners;
};
pony.events._Signal1.Signal1_Impl_.get_haveListeners = function(this1) {
	return !(this1.listeners.data.length == 0);
};
pony.events._Signal1.Signal1_Impl_.get_data = function(this1) {
	return this1.data;
};
pony.events._Signal1.Signal1_Impl_.set_data = function(this1,d) {
	return this1.data = d;
};
pony.events._Signal1.Signal1_Impl_.get_target = function(this1) {
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.get_listenersCount = function(this1) {
	return this1.listeners.data.length;
};
pony.events._Signal1.Signal1_Impl_.add = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.add(listener,priority);
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.once = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.once(listener,priority);
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.remove = function(this1,listener) {
	this1.remove(listener);
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.changePriority = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.listeners.changeElement(listener,priority);
	this1;
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.dispatch = function(this1,a) {
	this1.dispatchEvent(new pony.events.Event([a],this1.target));
	this1;
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.dispatchEvent = function(this1,event) {
	this1.dispatchEvent(event);
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.dispatchArgs = function(this1,args) {
	this1.dispatchEvent(new pony.events.Event(args,this1.target));
	this1;
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.sub = function(this1,a,priority) {
	if(priority == null) priority = 0;
	var s = this1.subArgs([a],priority);
	return s;
};
pony.events._Signal1.Signal1_Impl_.subArgs = function(this1,args,priority) {
	if(priority == null) priority = 0;
	var s = this1.subArgs(args,priority);
	return s;
};
pony.events._Signal1.Signal1_Impl_.removeSub = function(this1,a) {
	this1.removeSubArgs([a]);
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.removeSubArgs = function(this1,args) {
	this1.removeSubArgs(args);
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.removeAllSub = function(this1) {
	if(this1.subMap != null) {
		var $it0 = HxOverrides.iter(this1.subMap.vs);
		while( $it0.hasNext() ) {
			var e = $it0.next();
			e.destroy();
		}
		this1.subMap.clear();
	}
	this1;
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.removeAllBind = function(this1) {
	if(this1.subMap != null) {
		var $it0 = HxOverrides.iter(this1.subMap.vs);
		while( $it0.hasNext() ) {
			var e = $it0.next();
			e.destroy();
		}
		this1.subMap.clear();
	}
	this1;
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.not = function(this1,v,priority) {
	if(priority == null) priority = 0;
	var s = this1.notArgs([v],priority);
	return s;
};
pony.events._Signal1.Signal1_Impl_.bind = function(this1,a,b,c,d,e,f,g) {
	if(g != null) return this1.bindArgs([a,b,c,d,e,f,g],0); else if(f != null) return this1.bindArgs([a,b,c,d,e,f],0); else if(e != null) return this1.bindArgs([a,b,c,d,e],0); else if(d != null) return this1.bindArgs([a,b,c,d],0); else if(c != null) return this1.bindArgs([a,b,c],0); else if(b != null) return this1.bindArgs([a,b],0); else return this1.bindArgs([a],0);
};
pony.events._Signal1.Signal1_Impl_.bindArgs = function(this1,args,priority) {
	if(priority == null) priority = 0;
	return this1.bindArgs(args,priority);
};
pony.events._Signal1.Signal1_Impl_.bind1 = function(this1,a,priority) {
	if(priority == null) priority = 0;
	var s = this1.bindArgs([a],priority);
	return s;
};
pony.events._Signal1.Signal1_Impl_.and = function(this1,s) {
	return this1.and(s);
};
pony.events._Signal1.Signal1_Impl_.and0 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal1.Signal1_Impl_.and1 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal1.Signal1_Impl_.or = function(this1,s) {
	var s1 = this1.or(s);
	return s1;
};
pony.events._Signal1.Signal1_Impl_.removeAllListeners = function(this1) {
	this1.removeAllListeners();
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.sw = function(this1,l1,l2) {
	this1.once(l1,null);
	this1.once((function($this) {
		var $r;
		var f;
		{
			var f1 = (function(f2,l11,l21) {
				return function() {
					return f2(l11,l21);
				};
			})($bind(this1,this1.sw),l2,l1);
			f = pony._Function.Function_Impl_.from(f1,0);
		}
		$r = pony.events._Listener.Listener_Impl_._fromFunction(f);
		return $r;
	}(this)),null);
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.destroy = function(this1) {
	this1.destroy();
	return this1.target;
};
pony.events._Signal1.Signal1_Impl_.enableSilent = function(this1) {
	this1.silent = true;
};
pony.events._Signal1.Signal1_Impl_.disableSilent = function(this1) {
	this1.silent = false;
};
pony.events._Signal1.Signal1_Impl_.from = function(s) {
	return s;
};
pony.events._Signal1.Signal1_Impl_.to = function(this1) {
	return this1;
};
pony.events._Signal1.Signal1_Impl_.toListener = function(this1) {
	var f = pony._Function.Function_Impl_.from($bind(this1,this1.dispatchEvent),1,true,true);
	return pony.events._Listener.Listener_Impl_._fromFunction(f);
};
pony.events._Signal1.Signal1_Impl_.toFunction = function(this1) {
	return (function(_e) {
		return function(a) {
			return pony.events._Signal1.Signal1_Impl_.dispatch(_e,a);
		};
	})(this1);
};
pony.events._Signal1.Signal1_Impl_.toFunction2 = function(this1) {
	return (function(_e) {
		return function(event) {
			return pony.events._Signal1.Signal1_Impl_.dispatchEvent(_e,event);
		};
	})(this1);
};
pony.events._Signal1.Signal1_Impl_.debug = function(this1) {
	this1.debug();
};
pony.events._Signal1.Signal1_Impl_.op_add = function(this1,listener) {
	pony.events._Signal1.Signal1_Impl_.add(this1,listener);
	return this1;
};
pony.events._Signal1.Signal1_Impl_.op_once = function(this1,listener) {
	pony.events._Signal1.Signal1_Impl_.once(this1,listener);
	return this1;
};
pony.events._Signal1.Signal1_Impl_.op_remove = function(this1,listener) {
	pony.events._Signal1.Signal1_Impl_.remove(this1,listener);
	return this1;
};
pony.events._Signal1.Signal1_Impl_.op_and0 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal1.Signal1_Impl_.op_and1 = function(this1,s) {
	var this2 = this1.and(s);
	return this2;
};
pony.events._Signal1.Signal1_Impl_.op_or = function(this1,s) {
	var s1 = this1.or(s);
	return s1;
};
pony.events._Signal1.Signal1_Impl_.op_bind = function(this1,a) {
	var s = this1.bindArgs([a],0);
	return s;
};
pony.events._Signal1.Signal1_Impl_.op_sub = function(this1,a) {
	var s = this1.subArgs([a],0);
	return s;
};
pony.events._Signal1.Signal1_Impl_.op_not = function(this1,a) {
	var s = this1.notArgs([a],0);
	return s;
};
pony.events._Signal2 = {};
pony.events._Signal2.Signal2_Impl_ = function() { };
pony.events._Signal2.Signal2_Impl_.__name__ = ["pony","events","_Signal2","Signal2_Impl_"];
pony.events._Signal2.Signal2_Impl_._new = function(s) {
	return s;
};
pony.events._Signal2.Signal2_Impl_.get_silent = function(this1) {
	return this1.silent;
};
pony.events._Signal2.Signal2_Impl_.set_silent = function(this1,b) {
	return this1.silent = b;
};
pony.events._Signal2.Signal2_Impl_.get_lostListeners = function(this1) {
	return this1.lostListeners;
};
pony.events._Signal2.Signal2_Impl_.get_takeListeners = function(this1) {
	return this1.takeListeners;
};
pony.events._Signal2.Signal2_Impl_.get_haveListeners = function(this1) {
	return !(this1.listeners.data.length == 0);
};
pony.events._Signal2.Signal2_Impl_.get_data = function(this1) {
	return this1.data;
};
pony.events._Signal2.Signal2_Impl_.set_data = function(this1,d) {
	return this1.data = d;
};
pony.events._Signal2.Signal2_Impl_.get_target = function(this1) {
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.get_listenersCount = function(this1) {
	return this1.listeners.data.length;
};
pony.events._Signal2.Signal2_Impl_.add = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.add(listener,priority);
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.once = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.once(listener,priority);
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.remove = function(this1,listener) {
	this1.remove(listener);
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.changePriority = function(this1,listener,priority) {
	if(priority == null) priority = 0;
	this1.listeners.changeElement(listener,priority);
	this1;
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.dispatch = function(this1,a,b) {
	this1.dispatchEvent(new pony.events.Event([a,b],this1.target));
	this1;
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.dispatchEvent = function(this1,event) {
	this1.dispatchEvent(event);
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.dispatchArgs = function(this1,args) {
	this1.dispatchEvent(new pony.events.Event(args,this1.target));
	this1;
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.sub = function(this1,a,b,priority) {
	if(priority == null) priority = 0;
	return this1.subArgs(b == null?[a]:[a,b],priority);
};
pony.events._Signal2.Signal2_Impl_.sub1 = function(this1,a,priority) {
	if(priority == null) priority = 0;
	var s = this1.subArgs([a],priority);
	return s;
};
pony.events._Signal2.Signal2_Impl_.sub2 = function(this1,a,b,priority) {
	if(priority == null) priority = 0;
	var s = this1.subArgs([a,b],priority);
	return s;
};
pony.events._Signal2.Signal2_Impl_.subArgs = function(this1,args,priority) {
	if(priority == null) priority = 0;
	return this1.subArgs(args,priority);
};
pony.events._Signal2.Signal2_Impl_.removeSub = function(this1,a,b) {
	this1.removeSubArgs(b == null?[a]:[a,b]);
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.removeSubArgs = function(this1,args) {
	this1.removeSubArgs(args);
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.removeAllSub = function(this1) {
	if(this1.subMap != null) {
		var $it0 = HxOverrides.iter(this1.subMap.vs);
		while( $it0.hasNext() ) {
			var e = $it0.next();
			e.destroy();
		}
		this1.subMap.clear();
	}
	this1;
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.not1 = function(this1,v,priority) {
	if(priority == null) priority = 0;
	var s = this1.notArgs([v],priority);
	return s;
};
pony.events._Signal2.Signal2_Impl_.not2 = function(this1,v1,v2,priority) {
	if(priority == null) priority = 0;
	var s = this1.notArgs([v1,v2],priority);
	return s;
};
pony.events._Signal2.Signal2_Impl_.removeAllListeners = function(this1) {
	this1.removeAllListeners();
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.sw = function(this1,l1,l2) {
	this1.once(l1,null);
	this1.once((function($this) {
		var $r;
		var f;
		{
			var f1 = (function(f2,l11,l21) {
				return function() {
					return f2(l11,l21);
				};
			})($bind(this1,this1.sw),l2,l1);
			f = pony._Function.Function_Impl_.from(f1,0);
		}
		$r = pony.events._Listener.Listener_Impl_._fromFunction(f);
		return $r;
	}(this)),null);
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.destroy = function(this1) {
	this1.destroy();
	return this1.target;
};
pony.events._Signal2.Signal2_Impl_.enableSilent = function(this1) {
	this1.silent = true;
};
pony.events._Signal2.Signal2_Impl_.disableSilent = function(this1) {
	this1.silent = false;
};
pony.events._Signal2.Signal2_Impl_.from = function(s) {
	return s;
};
pony.events._Signal2.Signal2_Impl_.to = function(this1) {
	return this1;
};
pony.events._Signal2.Signal2_Impl_.toFunction = function(this1) {
	return (function(_e) {
		return function(a,b) {
			return pony.events._Signal2.Signal2_Impl_.dispatch(_e,a,b);
		};
	})(this1);
};
pony.events._Signal2.Signal2_Impl_.toFunction2 = function(this1) {
	return (function(_e) {
		return function(event) {
			return pony.events._Signal2.Signal2_Impl_.dispatchEvent(_e,event);
		};
	})(this1);
};
pony.events._Signal2.Signal2_Impl_.debug = function(this1) {
	this1.debug();
};
pony.events._Signal2.Signal2_Impl_.op_add = function(this1,listener) {
	pony.events._Signal2.Signal2_Impl_.add(this1,listener);
	return this1;
};
pony.events._Signal2.Signal2_Impl_.op_once = function(this1,listener) {
	pony.events._Signal2.Signal2_Impl_.once(this1,listener);
	return this1;
};
pony.events._Signal2.Signal2_Impl_.op_remove = function(this1,listener) {
	pony.events._Signal2.Signal2_Impl_.remove(this1,listener);
	return this1;
};
pony.events._Signal2.Signal2_Impl_.op_sub = function(this1,a) {
	var s = this1.subArgs([a],0);
	return s;
};
pony.events._Signal2.Signal2_Impl_.op_not = function(this1,a) {
	var s = this1.notArgs([a],0);
	return s;
};
pony.events._SignalTar = {};
pony.events._SignalTar.SignalTar_Impl_ = function() { };
pony.events._SignalTar.SignalTar_Impl_.__name__ = ["pony","events","_SignalTar","SignalTar_Impl_"];
pony.events._SignalTar.SignalTar_Impl_._new = function(s) {
	return s;
};
pony.events._SignalTar.SignalTar_Impl_.to0 = function(this1) {
	return this1;
};
pony.events._SignalTar.SignalTar_Impl_.to1 = function(this1) {
	return this1;
};
pony.events._SignalTar.SignalTar_Impl_.to2 = function(this1) {
	return this1;
};
pony.events._SignalTar.SignalTar_Impl_.tod0 = function(this1) {
	return this1;
};
pony.events._SignalTar.SignalTar_Impl_.tod1 = function(this1) {
	return this1;
};
pony.events._SignalTar.SignalTar_Impl_.tod2 = function(this1) {
	return this1;
};
pony.events.Waiter = function() {
	this.ready = false;
	this.f = new List();
};
pony.events.Waiter.__name__ = ["pony","events","Waiter"];
pony.events.Waiter.prototype = {
	ready: null
	,f: null
	,wait: function(cb) {
		if(this.ready) cb(); else this.f.push(cb);
	}
	,end: function() {
		if(this.ready) throw "Double ready";
		this.ready = true;
		var $it0 = this.f.iterator();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			e();
		}
		this.f = null;
	}
	,__class__: pony.events.Waiter
};
pony.net = {};
pony.net.INet = function() { };
pony.net.INet.__name__ = ["pony","net","INet"];
pony.net.INet.prototype = {
	onData: null
	,isAbleToSend: null
	,isWithLength: null
	,onDisconnect: null
	,send: null
	,destroy: null
	,__class__: pony.net.INet
};
pony.net.ISocketClient = function() { };
pony.net.ISocketClient.__name__ = ["pony","net","ISocketClient"];
pony.net.ISocketClient.__interfaces__ = [pony.net.INet];
pony.net.ISocketClient.prototype = {
	server: null
	,onData: null
	,onDisconnect: null
	,id: null
	,host: null
	,port: null
	,closed: null
	,connected: null
	,isAbleToSend: null
	,isWithLength: null
	,send: null
	,destroy: null
	,open: null
	,reconnect: null
	,send2other: null
	,__class__: pony.net.ISocketClient
};
pony.net.ISocketServer = function() { };
pony.net.ISocketServer.__name__ = ["pony","net","ISocketServer"];
pony.net.ISocketServer.__interfaces__ = [pony.net.INet];
pony.net.ISocketServer.prototype = {
	onData: null
	,onClose: null
	,onDisconnect: null
	,clients: null
	,isAbleToSend: null
	,isWithLength: null
	,send: null
	,destroy: null
	,__class__: pony.net.ISocketServer
};
pony.net.SocketClientBase = function(host,port,reconnect,aIsWithLength) {
	if(aIsWithLength == null) aIsWithLength = true;
	if(reconnect == null) reconnect = -1;
	this.reconnectDelay = -1;
	pony.Logable.call(this);
	this.connected = new pony.events.Waiter();
	if(host == null) host = "127.0.0.1";
	this.host = host;
	this.port = port;
	this.reconnectDelay = reconnect;
	var this1 = pony.events.Signal.create(null);
	this.onConnect = this1;
	this.isWithLength = aIsWithLength;
	this._init();
	this.open();
};
pony.net.SocketClientBase.__name__ = ["pony","net","SocketClientBase"];
pony.net.SocketClientBase.__super__ = pony.Logable;
pony.net.SocketClientBase.prototype = $extend(pony.Logable.prototype,{
	server: null
	,onConnect: null
	,onData: null
	,onDisconnect: null
	,id: null
	,host: null
	,port: null
	,closed: null
	,isAbleToSend: null
	,connected: null
	,isWithLength: null
	,reconnectDelay: null
	,_init: function() {
		this.closed = true;
		this.id = -1;
		var this1 = pony.events.Signal.create(this);
		this.onData = this1;
		this.onDisconnect = new pony.events.Signal(this);
	}
	,reconnect: function() {
		if(this.reconnectDelay == 0) {
			haxe.Log.trace("Reconnect",{ fileName : "SocketClientBase.hx", lineNumber : 83, className : "pony.net.SocketClientBase", methodName : "reconnect"});
			this.open();
		}
	}
	,open: function() {
	}
	,endInit: function() {
		this.closed = false;
		if(this.server != null) pony.events._Signal1.Signal1_Impl_.dispatch(this.server.onConnect,this);
	}
	,init: function(server,id) {
		this._init();
		this.server = server;
		this.id = id;
		pony.events._Signal1.Signal1_Impl_.add(this.onData,(function($this) {
			var $r;
			var f = (function(_e) {
				return function(event) {
					return pony.events._Signal1.Signal1_Impl_.dispatchEvent(_e,event);
				};
			})(server.onData);
			var l;
			{
				var f1 = pony._Function.Function_Impl_.from(f,1,false,true);
				l = pony.events._Listener.Listener_Impl_._fromFunction(f1);
			}
			$r = l;
			return $r;
		}(this)));
		this.onDisconnect.add((function($this) {
			var $r;
			var f2 = pony._Function.Function_Impl_.from(($_=server.onDisconnect,$bind($_,$_.dispatchEvent)),1,true,true);
			$r = pony.events._Listener.Listener_Impl_._fromFunction(f2);
			return $r;
		}(this)));
	}
	,send2other: function(data) {
		this.server.send2other(data,this);
	}
	,joinData: function(bi) {
		if(this.server != null) this.isWithLength = this.server.isWithLength;
		if(this.isWithLength) {
			var size = bi.readInt32();
			haxe.Log.trace(size,{ fileName : "SocketClientBase.hx", lineNumber : 117, className : "pony.net.SocketClientBase", methodName : "joinData"});
			pony.events._Signal1.Signal1_Impl_.dispatch(this.onData,new haxe.io.BytesInput(bi.read(size)));
		} else {
			haxe.Log.trace(this.isWithLength,{ fileName : "SocketClientBase.hx", lineNumber : 122, className : "pony.net.SocketClientBase", methodName : "joinData"});
			pony.events._Signal1.Signal1_Impl_.dispatch(this.onData,bi);
		}
	}
	,destroy: function() {
		this.closed = true;
		var this1 = this.onConnect;
		this1.destroy();
		this1.target;
		this.onConnect = null;
		var this2 = this.onData;
		this2.destroy();
		this2.target;
		this.onData = null;
	}
	,__class__: pony.net.SocketClientBase
});
pony.net.nodejs = {};
pony.net.nodejs.SocketClient = function(host,port,reconnect,aIsWithLength) {
	pony.net.SocketClientBase.call(this,host,port,reconnect,aIsWithLength);
};
pony.net.nodejs.SocketClient.__name__ = ["pony","net","nodejs","SocketClient"];
pony.net.nodejs.SocketClient.__super__ = pony.net.SocketClientBase;
pony.net.nodejs.SocketClient.prototype = $extend(pony.net.SocketClientBase.prototype,{
	socket: null
	,q: null
	,open: function() {
		this.socket = js.Node.require("net").connect(this.port,this.host);
		this.socket.on("connect",$bind(this,this.connectHandler));
		this.nodejsInit(this.socket);
	}
	,nodejsInit: function(s) {
		this.q = new pony.Queue($bind(this,this._send));
		this.socket = s;
		s.on("data",$bind(this,this.dataHandler));
		s.on("end",$bind(this,this.closeHandler));
		s.on("error",$bind(this,this.reconnect));
		this.closed = false;
		if(this.server != null) pony.events._Signal1.Signal1_Impl_.dispatch(this.server.onConnect,this);
	}
	,closeHandler: function() {
		this.onDisconnect.dispatchArgs([]);
		this.onDisconnect.destroy();
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
		this.socket.write(data.getBytes().getData(),null,($_=this.q,$bind($_,$_.next)));
	}
	,dataHandler: function(d) {
		this.joinData(new haxe.io.BytesInput(haxe.io.Bytes.ofData(d)));
	}
	,destroy: function() {
		pony.net.SocketClientBase.prototype.destroy.call(this);
		this.socket.end();
		this.socket = null;
		this.closed = true;
	}
	,__class__: pony.net.nodejs.SocketClient
});
pony.net.SocketClient = function(host,port,reconnect,aIsWithLength) {
	pony.net.nodejs.SocketClient.call(this,host,port,reconnect,aIsWithLength);
};
pony.net.SocketClient.__name__ = ["pony","net","SocketClient"];
pony.net.SocketClient.__interfaces__ = [pony.net.ISocketClient];
pony.net.SocketClient.__super__ = pony.net.nodejs.SocketClient;
pony.net.SocketClient.prototype = $extend(pony.net.nodejs.SocketClient.prototype,{
	send: function(data) {
		var bo = new haxe.io.BytesOutput();
		if(this.isWithLength) bo.writeInt32(data.b.b.length);
		bo.write(data.getBytes());
		pony.net.nodejs.SocketClient.prototype.send.call(this,bo);
	}
	,__class__: pony.net.SocketClient
});
pony.net.SocketServerBase = function() {
	this.isWithLength = true;
	this.isAbleToSend = false;
	pony.Logable.call(this);
	var this1 = pony.events.Signal.create(this);
	this.onConnect = this1;
	var this2 = pony.events.Signal.create(this);
	this.onMessage = this2;
	var this3 = pony.events.Signal.create(this);
	this.onError = this3;
	this.onDisconnect = new pony.events.Signal();
	var this4 = pony.events.Signal.create(null);
	this.onData = this4;
	this.onClose = new pony.events.Signal(this);
	this.clients = [];
	this.onDisconnect.add((function($this) {
		var $r;
		var f = pony._Function.Function_Impl_.from($bind($this,$this.removeClient),1,false);
		$r = pony.events._Listener.Listener_Impl_._fromFunction(f);
		return $r;
	}(this)));
};
pony.net.SocketServerBase.__name__ = ["pony","net","SocketServerBase"];
pony.net.SocketServerBase.__super__ = pony.Logable;
pony.net.SocketServerBase.prototype = $extend(pony.Logable.prototype,{
	onData: null
	,onConnect: null
	,onClose: null
	,onDisconnect: null
	,clients: null
	,onMessage: null
	,onError: null
	,isAbleToSend: null
	,isWithLength: null
	,addClient: function() {
		var cl = Type.createEmptyInstance(pony.net.SocketClient);
		cl.isWithLength = this.isWithLength;
		cl.init(this,this.clients.length);
		this.clients.push(cl);
		return cl;
	}
	,removeClient: function(cl) {
		HxOverrides.remove(this.clients,cl);
	}
	,send: function(data) {
		var bs = data.getBytes();
		var _g = 0;
		var _g1 = this.clients;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			var b = new haxe.io.BytesOutput();
			b.write(bs);
			c.send(b);
		}
	}
	,send2other: function(data,exception) {
		var bs = data.getBytes();
		var _g = 0;
		var _g1 = this.clients;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			if(c == exception) continue;
			var b = new haxe.io.BytesOutput();
			b.write(bs);
			c.send(b);
		}
	}
	,destroy: function() {
		this.onClose.dispatchArgs([]);
		var this1 = this.onData;
		this1.destroy();
		this1.target;
		this.onData = null;
		var this2 = this.onConnect;
		this2.destroy();
		this2.target;
		this.onConnect = null;
		this.onClose.destroy();
		this.onClose = null;
		this.onDisconnect.destroy();
		this.onDisconnect = null;
	}
	,__class__: pony.net.SocketServerBase
});
pony.net.nodejs.SocketServer = function(port) {
	pony.net.SocketServerBase.call(this);
	this.server = js.Node.require("net").createServer(null,null);
	this.server.listen(port,null,$bind(this,this.bound));
	this.server.on("connection",$bind(this,this.connectionHandler));
};
pony.net.nodejs.SocketServer.__name__ = ["pony","net","nodejs","SocketServer"];
pony.net.nodejs.SocketServer.__super__ = pony.net.SocketServerBase;
pony.net.nodejs.SocketServer.prototype = $extend(pony.net.SocketServerBase.prototype,{
	server: null
	,bound: function() {
		pony.events._Signal1.Signal1_Impl_.dispatch(this.onMessage,"bound " + Std.string(this.server.address()));
	}
	,connectionHandler: function(c) {
		this.addClient().nodejsInit(c);
	}
	,destroy: function() {
		pony.net.SocketServerBase.prototype.destroy.call(this);
		this.server.close(null);
		this.server = null;
	}
	,__class__: pony.net.nodejs.SocketServer
});
pony.net.SocketServer = function(port) {
	pony.net.nodejs.SocketServer.call(this,port);
};
pony.net.SocketServer.__name__ = ["pony","net","SocketServer"];
pony.net.SocketServer.__interfaces__ = [pony.net.ISocketServer];
pony.net.SocketServer.__super__ = pony.net.nodejs.SocketServer;
pony.net.SocketServer.prototype = $extend(pony.net.nodejs.SocketServer.prototype,{
	__class__: pony.net.SocketServer
});
pony.text = {};
pony.text.TextTools = function() { };
pony.text.TextTools.__name__ = ["pony","text","TextTools"];
pony.text.TextTools.exists = function(s,ch) {
	return s.indexOf(ch) != -1;
};
pony.text.TextTools.repeat = function(s,count) {
	var r = "";
	while(count-- > 0) r += s;
	return r;
};
pony.text.TextTools.isTrue = function(s) {
	return StringTools.trim(s.toLowerCase()) == "true";
};
pony.text.TextTools.explode = function(s,delimiters) {
	var r = [s];
	var _g = 0;
	while(_g < delimiters.length) {
		var d = delimiters[_g];
		++_g;
		var sr = [];
		var _g1 = 0;
		while(_g1 < r.length) {
			var e = r[_g1];
			++_g1;
			var _g2 = 0;
			var _g3 = e.split(d);
			while(_g2 < _g3.length) {
				var se = _g3[_g2];
				++_g2;
				if(se != "") sr.push(se);
			}
		}
		r = sr;
	}
	return r;
};
pony.text.TextTools.parsePercent = function(s) {
	if(s.indexOf("%") != -1) return Std.parseFloat(HxOverrides.substr(s,0,s.length - 1)) / 100; else return Std.parseFloat(s);
};
pony.text.TextTools.last = function(s) {
	return s.charAt(s.length - 1);
};
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
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
Xml.Element = "element";
Xml.PCData = "pcdata";
Xml.CData = "cdata";
Xml.Comment = "comment";
Xml.DocType = "doctype";
Xml.ProcessingInstruction = "processingInstruction";
Xml.Document = "document";
js.Node.setTimeout = setTimeout;
js.Node.clearTimeout = clearTimeout;
js.Node.setInterval = setInterval;
js.Node.clearInterval = clearInterval;
js.Node.global = global;
js.Node.process = process;
js.Node.require = require;
js.Node.console = console;
js.Node.module = module;
js.Node.stringify = JSON.stringify;
js.Node.parse = JSON.parse;
var version = HxOverrides.substr(js.Node.process.version,1,null).split(".").map(Std.parseInt);
if(version[0] > 0 || version[1] >= 9) {
	js.Node.setImmediate = setImmediate;
	js.Node.clearImmediate = clearImmediate;
}
pony._Function.Function_Impl_.unusedCount = 0;
pony._Function.Function_Impl_.list = new pony.Dictionary(1);
pony._Function.Function_Impl_.counter = -1;
pony._Function.Function_Impl_.searchFree = false;
pony.events._Listener.Listener_Impl_.flist = new haxe.ds.IntMap();
pony.events.Signal.signalsCount = 0;
Main.testCount = 20000;
Main.delay = 1;
Main.port = 16001;
Main.partCount = Main.testCount / 4 | 0;
Main.blockCount = Main.testCount / 2 | 0;
haxe.xml.Parser.escapes = (function($this) {
	var $r;
	var h = new haxe.ds.StringMap();
	h.set("lt","<");
	h.set("gt",">");
	h.set("amp","&");
	h.set("quot","\"");
	h.set("apos","'");
	h.set("nbsp",String.fromCharCode(160));
	$r = h;
	return $r;
}(this));
js.Boot.__toStr = {}.toString;
js.NodeC.UTF8 = "utf8";
js.NodeC.ASCII = "ascii";
js.NodeC.BINARY = "binary";
js.NodeC.BASE64 = "base64";
js.NodeC.HEX = "hex";
js.NodeC.EVENT_EVENTEMITTER_NEWLISTENER = "newListener";
js.NodeC.EVENT_EVENTEMITTER_ERROR = "error";
js.NodeC.EVENT_STREAM_DATA = "data";
js.NodeC.EVENT_STREAM_END = "end";
js.NodeC.EVENT_STREAM_ERROR = "error";
js.NodeC.EVENT_STREAM_CLOSE = "close";
js.NodeC.EVENT_STREAM_DRAIN = "drain";
js.NodeC.EVENT_STREAM_CONNECT = "connect";
js.NodeC.EVENT_STREAM_SECURE = "secure";
js.NodeC.EVENT_STREAM_TIMEOUT = "timeout";
js.NodeC.EVENT_STREAM_PIPE = "pipe";
js.NodeC.EVENT_PROCESS_EXIT = "exit";
js.NodeC.EVENT_PROCESS_UNCAUGHTEXCEPTION = "uncaughtException";
js.NodeC.EVENT_PROCESS_SIGINT = "SIGINT";
js.NodeC.EVENT_PROCESS_SIGUSR1 = "SIGUSR1";
js.NodeC.EVENT_CHILDPROCESS_EXIT = "exit";
js.NodeC.EVENT_HTTPSERVER_REQUEST = "request";
js.NodeC.EVENT_HTTPSERVER_CONNECTION = "connection";
js.NodeC.EVENT_HTTPSERVER_CLOSE = "close";
js.NodeC.EVENT_HTTPSERVER_UPGRADE = "upgrade";
js.NodeC.EVENT_HTTPSERVER_CLIENTERROR = "clientError";
js.NodeC.EVENT_HTTPSERVERREQUEST_DATA = "data";
js.NodeC.EVENT_HTTPSERVERREQUEST_END = "end";
js.NodeC.EVENT_CLIENTREQUEST_RESPONSE = "response";
js.NodeC.EVENT_CLIENTRESPONSE_DATA = "data";
js.NodeC.EVENT_CLIENTRESPONSE_END = "end";
js.NodeC.EVENT_NETSERVER_CONNECTION = "connection";
js.NodeC.EVENT_NETSERVER_CLOSE = "close";
js.NodeC.FILE_READ = "r";
js.NodeC.FILE_READ_APPEND = "r+";
js.NodeC.FILE_WRITE = "w";
js.NodeC.FILE_WRITE_APPEND = "a+";
js.NodeC.FILE_READWRITE = "a";
js.NodeC.FILE_READWRITE_APPEND = "a+";
pony.AsyncTests.assertList = new List();
pony.AsyncTests.testCount = 0;
pony.AsyncTests.complite = false;
pony.AsyncTests.dec = "----------";
pony.AsyncTests.waitList = new List();
Main.main();
})();

//# sourceMappingURL=main.js.map