
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.net{
	public  class SocketClientBase : global::haxe.lang.HxObject {
		public    SocketClientBase(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    SocketClientBase(string host, int port, global::haxe.lang.Null<int> reconnect){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				global::pony.net.SocketClientBase.__hx_ctor_pony_net_SocketClientBase(this, host, port, reconnect);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_net_SocketClientBase(global::pony.net.SocketClientBase __temp_me107, string host, int port, global::haxe.lang.Null<int> reconnect){
			unchecked {
				#line 52 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				__temp_me107.reconnectDelay = -1;
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				int __temp_reconnect106 = ( ( ! (reconnect.hasValue) ) ? (((int) (-1) )) : (reconnect.@value) );
				#line 56 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				if (string.Equals(host, default(string))) {
					#line 56 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					host = "127.0.0.1";
				}
				
				#line 57 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				__temp_me107.host = host;
				__temp_me107.port = port;
				__temp_me107.reconnectDelay = __temp_reconnect106;
				{
					#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					__temp_me107.closed = true;
					#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					__temp_me107.id = -1;
					#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					{
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal this1 = default(global::pony.events.Signal);
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal __temp_stmt487 = default(global::pony.events.Signal);
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						{
							#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
							global::pony.events.Signal s = new global::pony.events.Signal(((global::pony.net.SocketClient) (__temp_me107) ));
							#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
							__temp_stmt487 = s;
						}
						
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this1 = ((global::pony.events.Signal) (__temp_stmt487) );
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						__temp_me107.connect = ((global::pony.events.Signal) (this1) );
					}
					
					#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					{
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal this2 = default(global::pony.events.Signal);
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal __temp_stmt488 = default(global::pony.events.Signal);
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						{
							#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
							global::pony.events.Signal s1 = new global::pony.events.Signal(((global::pony.net.SocketClient) (__temp_me107) ));
							#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
							__temp_stmt488 = s1;
						}
						
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this2 = ((global::pony.events.Signal) (__temp_stmt488) );
						#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						__temp_me107.data = ((global::pony.events.Signal) (this2) );
					}
					
					#line 60 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					__temp_me107.disconnect = new global::pony.events.Signal(((object) (__temp_me107) ));
				}
				
				#line 61 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				__temp_me107.open();
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				return new global::pony.net.SocketClientBase(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				return new global::pony.net.SocketClientBase(global::haxe.lang.Runtime.toString(arr[0]), ((int) (global::haxe.lang.Runtime.toInt(arr[1])) ), global::haxe.lang.Null<object>.ofDynamic<int>(arr[2]));
			}
			#line default
		}
		
		
		public  global::pony.net.SocketServer server;
		
		public  global::pony.events.Signal connect;
		
		public  global::pony.events.Signal data;
		
		public  global::pony.events.Signal disconnect;
		
		public  int id;
		
		public  string host;
		
		public  int port;
		
		public  bool closed;
		
		public  int reconnectDelay;
		
		public   void _init(){
			unchecked {
				#line 65 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				this.closed = true;
				this.id = -1;
				{
					#line 67 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					global::pony.events.Signal this1 = default(global::pony.events.Signal);
					#line 67 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					global::pony.events.Signal __temp_stmt480 = default(global::pony.events.Signal);
					#line 67 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					{
						#line 67 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal s = new global::pony.events.Signal(((global::pony.net.SocketClient) (this) ));
						#line 67 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						__temp_stmt480 = s;
					}
					
					#line 67 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					this1 = ((global::pony.events.Signal) (__temp_stmt480) );
					#line 67 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					this.connect = ((global::pony.events.Signal) (this1) );
				}
				
				#line 68 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				{
					#line 68 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					global::pony.events.Signal this2 = default(global::pony.events.Signal);
					#line 68 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					global::pony.events.Signal __temp_stmt481 = default(global::pony.events.Signal);
					#line 68 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					{
						#line 68 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal s1 = new global::pony.events.Signal(((global::pony.net.SocketClient) (this) ));
						#line 68 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						__temp_stmt481 = s1;
					}
					
					#line 68 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					this2 = ((global::pony.events.Signal) (__temp_stmt481) );
					#line 68 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					this.data = ((global::pony.events.Signal) (this2) );
				}
				
				#line 69 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				this.disconnect = new global::pony.events.Signal(((object) (this) ));
			}
			#line default
		}
		
		
		public virtual   void reconnect(){
			unchecked {
				#line 73 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				if (( this.reconnectDelay == 0 )) {
					#line 74 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					global::haxe.Log.trace.__hx_invoke2_o(default(double), "Reconnect", default(double), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"reconnect", "pony.net.SocketClientBase", "SocketClientBase.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (74) )})));
					this.open();
				}
				 else {
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					if (( this.reconnectDelay > 0 )) {
						#line 79 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::haxe.Log.trace.__hx_invoke2_o(default(double), global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("Reconnect after ", global::haxe.lang.Runtime.toString(this.reconnectDelay)), " ms"), default(double), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"reconnect", "pony.net.SocketClientBase", "SocketClientBase.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (79) )})));
						global::haxe.Timer.delay(((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("open") ), ((int) (1236534218) ))) ), this.reconnectDelay);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   void open(){
			unchecked {
				#line 85 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public   void endInit(){
			unchecked {
				#line 88 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				this.closed = false;
				if (( this.server != default(global::pony.net.SocketServer) )) {
					#line 90 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					global::pony.events._Signal1.Signal1_Impl_.dispatch<object, object>(this.server.connect, ((object) (this) ));
				}
				
			}
			#line default
		}
		
		
		public virtual   void init(global::pony.net.SocketServer server, int id){
			unchecked {
				#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				{
					#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					this.closed = true;
					#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					this.id = -1;
					#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					{
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal this1 = default(global::pony.events.Signal);
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal __temp_stmt482 = default(global::pony.events.Signal);
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						{
							#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
							global::pony.events.Signal s = new global::pony.events.Signal(((global::pony.net.SocketClient) (this) ));
							#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
							__temp_stmt482 = s;
						}
						
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this1 = ((global::pony.events.Signal) (__temp_stmt482) );
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.connect = ((global::pony.events.Signal) (this1) );
					}
					
					#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					{
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal this2 = default(global::pony.events.Signal);
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::pony.events.Signal __temp_stmt483 = default(global::pony.events.Signal);
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						{
							#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
							global::pony.events.Signal s1 = new global::pony.events.Signal(((global::pony.net.SocketClient) (this) ));
							#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
							__temp_stmt483 = s1;
						}
						
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this2 = ((global::pony.events.Signal) (__temp_stmt483) );
						#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.data = ((global::pony.events.Signal) (this2) );
					}
					
					#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					this.disconnect = new global::pony.events.Signal(((object) (this) ));
				}
				
				#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				this.server = server;
				this.id = id;
				object __temp_stmt484 = default(object);
				#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				{
					#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					global::haxe.lang.Function __temp_stmt486 = default(global::haxe.lang.Function);
					#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					{
						#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						global::Array<object> _e = new global::Array<object>(new object[]{server.data});
						#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						__temp_stmt486 = new global::pony.net.SocketClientBase_init_97__Fun(((global::Array<object>) (_e) ));
					}
					
					#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					object __temp_stmt485 = global::pony._Function.Function_Impl_.@from(__temp_stmt486, 1);
					#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					object l = global::pony.events._Listener.Listener_Impl_._fromFunction(__temp_stmt485, true);
					#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					__temp_stmt484 = l;
				}
				
				#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				global::pony.events._Signal1.Signal1_Impl_.@add<object, object>(this.data, ((object) (__temp_stmt484) ), default(global::haxe.lang.Null<int>));
				this.disconnect.@add(global::pony.events._Listener.Listener_Impl_._fromFunction(global::pony._Function.Function_Impl_.@from(((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (server.disconnect) ), ((string) ("dispatchEvent") ), ((int) (1181009664) ))) ), 1), true), default(global::haxe.lang.Null<int>));
			}
			#line default
		}
		
		
		public   void send2other(global::haxe.io.BytesOutput data){
			unchecked {
				#line 101 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				this.server.send2other(data, ((global::pony.net.SocketClient) (this) ));
			}
			#line default
		}
		
		
		public virtual   void joinData(global::haxe.io.BytesInput bi){
			unchecked {
				#line 104 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				global::pony.events._Signal1.Signal1_Impl_.dispatch<object, object>(this.data, new global::haxe.io.BytesInput(((global::haxe.io.Bytes) (bi.read(bi.readInt32())) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) )));
			}
			#line default
		}
		
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				switch (hash){
					case 952188780:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.reconnectDelay = ((int) (@value) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 1247576961:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.port = ((int) (@value) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 23515:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.id = ((int) (@value) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					default:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				switch (hash){
					case 952188780:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.reconnectDelay = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 240232876:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.closed = global::haxe.lang.Runtime.toBool(@value);
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 1247576961:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.port = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 1158860648:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.host = global::haxe.lang.Runtime.toString(@value);
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 23515:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.id = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 1766089820:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.disconnect = ((global::pony.events.Signal) (@value) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 1113806378:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.data = ((global::pony.events.Signal) (@value) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 360725482:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.connect = ((global::pony.events.Signal) (@value) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					case 1849117379:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.server = ((global::pony.net.SocketServer) (@value) );
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return @value;
					}
					
					
					default:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				switch (hash){
					case 897250100:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("joinData") ), ((int) (897250100) ))) );
					}
					
					
					case 554706086:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("send2other") ), ((int) (554706086) ))) );
					}
					
					
					case 1169898256:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("init") ), ((int) (1169898256) ))) );
					}
					
					
					case 668988555:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("endInit") ), ((int) (668988555) ))) );
					}
					
					
					case 1236534218:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("open") ), ((int) (1236534218) ))) );
					}
					
					
					case 367527063:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("reconnect") ), ((int) (367527063) ))) );
					}
					
					
					case 2026657519:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("_init") ), ((int) (2026657519) ))) );
					}
					
					
					case 952188780:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return this.reconnectDelay;
					}
					
					
					case 240232876:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return this.closed;
					}
					
					
					case 1247576961:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return this.port;
					}
					
					
					case 1158860648:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return this.host;
					}
					
					
					case 23515:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return this.id;
					}
					
					
					case 1766089820:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return this.disconnect;
					}
					
					
					case 1113806378:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return this.data;
					}
					
					
					case 360725482:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return this.connect;
					}
					
					
					case 1849117379:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return this.server;
					}
					
					
					default:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				switch (hash){
					case 952188780:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((double) (this.reconnectDelay) );
					}
					
					
					case 1247576961:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((double) (this.port) );
					}
					
					
					case 23515:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return ((double) (this.id) );
					}
					
					
					default:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				switch (hash){
					case 897250100:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.joinData(((global::haxe.io.BytesInput) (dynargs[0]) ));
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						break;
					}
					
					
					case 554706086:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.send2other(((global::haxe.io.BytesOutput) (dynargs[0]) ));
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						break;
					}
					
					
					case 1169898256:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.init(((global::pony.net.SocketServer) (dynargs[0]) ), ((int) (global::haxe.lang.Runtime.toInt(dynargs[1])) ));
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						break;
					}
					
					
					case 668988555:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.endInit();
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						break;
					}
					
					
					case 1236534218:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.open();
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						break;
					}
					
					
					case 367527063:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this.reconnect();
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						break;
					}
					
					
					case 2026657519:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						this._init();
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						break;
					}
					
					
					default:
					{
						#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				baseArr.push("reconnectDelay");
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				baseArr.push("closed");
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				baseArr.push("port");
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				baseArr.push("host");
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				baseArr.push("id");
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				baseArr.push("disconnect");
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				baseArr.push("data");
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				baseArr.push("connect");
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				baseArr.push("server");
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				{
					#line 41 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.net{
	public  class SocketClientBase_init_97__Fun : global::haxe.lang.Function {
		public    SocketClientBase_init_97__Fun(global::Array<object> _e) : base(1, 0){
			unchecked {
				#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				this._e = _e;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				global::pony.events.Event @event = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.events.Event) (((object) (__fn_float1) )) )) : (((global::pony.events.Event) (__fn_dyn1) )) );
				#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				return ((global::pony.net.SocketClient) (global::pony.events._Signal1.Signal1_Impl_.dispatchEvent<object, object>(((global::pony.events.Signal) (this._e[0]) ), @event)) );
			}
			#line default
		}
		
		
		public  global::Array<object> _e;
		
	}
}


