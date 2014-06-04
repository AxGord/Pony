
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.net{
	public  class SocketServerBase : global::haxe.lang.HxObject {
		public    SocketServerBase(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    SocketServerBase(){
			unchecked {
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				global::pony.net.SocketServerBase.__hx_ctor_pony_net_SocketServerBase(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_net_SocketServerBase(global::pony.net.SocketServerBase __temp_me110){
			unchecked {
				#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				{
					#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal this1 = default(global::pony.events.Signal);
					#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal __temp_stmt520 = default(global::pony.events.Signal);
					#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal s = new global::pony.events.Signal(((global::pony.net.SocketServer) (__temp_me110) ));
						#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						__temp_stmt520 = s;
					}
					
					#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					this1 = ((global::pony.events.Signal) (__temp_stmt520) );
					#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					__temp_me110.connect = ((global::pony.events.Signal) (this1) );
				}
				
				#line 49 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				{
					#line 49 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal this2 = default(global::pony.events.Signal);
					#line 49 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal __temp_stmt521 = default(global::pony.events.Signal);
					#line 49 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 49 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal s1 = new global::pony.events.Signal(((global::pony.net.SocketServer) (__temp_me110) ));
						#line 49 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						__temp_stmt521 = s1;
					}
					
					#line 49 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					this2 = ((global::pony.events.Signal) (__temp_stmt521) );
					#line 49 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					__temp_me110.message = ((global::pony.events.Signal) (this2) );
				}
				
				#line 50 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				{
					#line 50 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal this3 = default(global::pony.events.Signal);
					#line 50 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal __temp_stmt522 = default(global::pony.events.Signal);
					#line 50 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 50 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal s2 = new global::pony.events.Signal(((global::pony.net.SocketServer) (__temp_me110) ));
						#line 50 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						__temp_stmt522 = s2;
					}
					
					#line 50 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					this3 = ((global::pony.events.Signal) (__temp_stmt522) );
					#line 50 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					__temp_me110.error = ((global::pony.events.Signal) (this3) );
				}
				
				#line 51 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				__temp_me110.disconnect = new global::pony.events.Signal(((object) (default(object)) ));
				{
					#line 52 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal this4 = default(global::pony.events.Signal);
					#line 52 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal __temp_stmt523 = default(global::pony.events.Signal);
					#line 52 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 52 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal s3 = new global::pony.events.Signal(((object) (default(global::pony.net.SocketClient)) ));
						#line 52 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						__temp_stmt523 = s3;
					}
					
					#line 52 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					this4 = ((global::pony.events.Signal) (__temp_stmt523) );
					#line 52 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					__temp_me110.data = ((global::pony.events.Signal) (this4) );
				}
				
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				__temp_me110.closed = new global::pony.events.Signal(((object) (__temp_me110) ));
				__temp_me110.clients = new global::Array<object>(new object[]{});
				object __temp_stmt524 = default(object);
				#line 55 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				{
					#line 55 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					object f = global::pony._Function.Function_Impl_.@from(((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (__temp_me110) ), ((string) ("removeClient") ), ((int) (2038261167) ))) ), 1);
					#line 55 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					__temp_stmt524 = global::pony.events._Listener.Listener_Impl_._fromFunction(f, false);
				}
				
				#line 55 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				__temp_me110.disconnect.@add(__temp_stmt524, default(global::haxe.lang.Null<int>));
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				return new global::pony.net.SocketServerBase(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				return new global::pony.net.SocketServerBase();
			}
			#line default
		}
		
		
		public  global::pony.events.Signal data;
		
		public  global::pony.events.Signal connect;
		
		public  global::pony.events.Signal closed;
		
		public  global::pony.events.Signal disconnect;
		
		public  global::Array<object> clients;
		
		public  global::pony.events.Signal message;
		
		public  global::pony.events.Signal error;
		
		public virtual   global::pony.net.SocketClient addClient(){
			unchecked {
				#line 59 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				global::pony.net.SocketClient cl = ((global::pony.net.SocketClient) (global::Type.createEmptyInstance<object>(typeof(global::pony.net.SocketClient))) );
				cl.init(((global::pony.net.SocketServer) (this) ), this.clients.length);
				this.clients.push(cl);
				return cl;
			}
			#line default
		}
		
		
		public   void removeClient(global::pony.net.SocketClient cl){
			unchecked {
				#line 65 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				this.clients.@remove(cl);
			}
			#line default
		}
		
		
		public virtual   void send(global::haxe.io.BytesOutput data){
			unchecked {
				#line 68 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				global::haxe.io.Bytes bs = data.getBytes();
				{
					#line 69 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					int _g = 0;
					#line 69 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::Array<object> _g1 = this.clients;
					#line 69 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					while (( _g < _g1.length )){
						#line 69 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.net.SocketClient c = ((global::pony.net.SocketClient) (_g1[_g]) );
						#line 69 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						 ++ _g;
						global::haxe.io.BytesOutput b = new global::haxe.io.BytesOutput();
						b.write(bs);
						c.send(b);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   void send2other(global::haxe.io.BytesOutput data, global::pony.net.SocketClient exception){
			unchecked {
				#line 77 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				global::haxe.io.Bytes bs = data.getBytes();
				{
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					int _g = 0;
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::Array<object> _g1 = this.clients;
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					while (( _g < _g1.length )){
						#line 78 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.net.SocketClient c = ((global::pony.net.SocketClient) (_g1[_g]) );
						#line 78 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						 ++ _g;
						if (( c == exception )) {
							#line 79 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							continue;
						}
						
						#line 80 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::haxe.io.BytesOutput b = new global::haxe.io.BytesOutput();
						b.write(bs);
						c.send(b);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   void close(){
			unchecked {
				#line 151 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 88 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal _this = this.closed;
					#line 151 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					_this.dispatchEvent(new global::pony.events.Event(((global::Array) (new global::Array<object>(new object[]{})) ), ((object) (_this.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) )));
					#line 151 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal __temp_expr497 = _this;
				}
				
				#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				{
					#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal this1 = this.data;
					#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( this1.parent != default(global::pony.events.Signal) )) {
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this1.parent.removeSubSignal(this1);
						}
						
						#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							if (( this1.subMap != default(global::pony.Dictionary<object, object>) )) {
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									object __temp_iterator223 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.subMap.vs) ))) );
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator223, "hasNext", 407283053, default(global::Array)))){
										#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator223, "next", 1224901875, default(global::Array))) );
										#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										e.destroy();
									}
									
								}
								
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.Dictionary<object, object> _this1 = this1.subMap;
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this1.ks = new global::Array<object>(new object[]{});
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this1.vs = new global::Array<object>(new object[]{});
								}
								
							}
							
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal __temp_expr498 = this1;
						}
						
						#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							if (( this1.bindMap != default(global::pony.Dictionary<object, object>) )) {
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									object __temp_iterator224 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.bindMap.vs) ))) );
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator224, "hasNext", 407283053, default(global::Array)))){
										#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										global::pony.events.Signal e1 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator224, "next", 1224901875, default(global::Array))) );
										#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										e1.destroy();
									}
									
								}
								
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.Dictionary<object, object> _this2 = this1.bindMap;
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this2.ks = new global::Array<object>(new object[]{});
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this2.vs = new global::Array<object>(new object[]{});
								}
								
							}
							
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal __temp_expr499 = this1;
						}
						
						#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							if (( this1.notMap != default(global::pony.Dictionary<object, object>) )) {
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									object __temp_iterator225 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.notMap.vs) ))) );
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator225, "hasNext", 407283053, default(global::Array)))){
										#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										global::pony.events.Signal e2 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator225, "next", 1224901875, default(global::Array))) );
										#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										e2.destroy();
									}
									
								}
								
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.Dictionary<object, object> _this3 = this1.notMap;
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this3.ks = new global::Array<object>(new object[]{});
									#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this3.vs = new global::Array<object>(new object[]{});
								}
								
							}
							
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal __temp_expr500 = this1;
						}
						
						#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this1.removeAllListeners();
						#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( this1.takeListeners != default(global::pony.events.Signal) )) {
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.events.Signal this2 = this1.takeListeners;
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								this2.destroy();
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_expr501 = this2.target;
							}
							
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this1.takeListeners = default(global::pony.events.Signal);
						}
						
						#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( this1.lostListeners != default(global::pony.events.Signal) )) {
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.events.Signal this3 = this1.lostListeners;
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								this3.destroy();
								#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_expr502 = this3.target;
							}
							
							#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this1.lostListeners = default(global::pony.events.Signal);
						}
						
					}
					
					#line 89 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					object __temp_expr503 = this1.target;
				}
				
				#line 90 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				this.data = default(global::pony.events.Signal);
				{
					#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal this4 = this.connect;
					#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( this4.parent != default(global::pony.events.Signal) )) {
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this4.parent.removeSubSignal(this4);
						}
						
						#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							if (( this4.subMap != default(global::pony.Dictionary<object, object>) )) {
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									object __temp_iterator226 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this4.subMap.vs) ))) );
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator226, "hasNext", 407283053, default(global::Array)))){
										#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										global::pony.events.Signal e3 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator226, "next", 1224901875, default(global::Array))) );
										#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										e3.destroy();
									}
									
								}
								
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.Dictionary<object, object> _this4 = this4.subMap;
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this4.ks = new global::Array<object>(new object[]{});
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this4.vs = new global::Array<object>(new object[]{});
								}
								
							}
							
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal __temp_expr504 = this4;
						}
						
						#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							if (( this4.bindMap != default(global::pony.Dictionary<object, object>) )) {
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									object __temp_iterator227 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this4.bindMap.vs) ))) );
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator227, "hasNext", 407283053, default(global::Array)))){
										#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										global::pony.events.Signal e4 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator227, "next", 1224901875, default(global::Array))) );
										#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										e4.destroy();
									}
									
								}
								
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.Dictionary<object, object> _this5 = this4.bindMap;
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this5.ks = new global::Array<object>(new object[]{});
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this5.vs = new global::Array<object>(new object[]{});
								}
								
							}
							
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal __temp_expr505 = this4;
						}
						
						#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							if (( this4.notMap != default(global::pony.Dictionary<object, object>) )) {
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									object __temp_iterator228 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this4.notMap.vs) ))) );
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator228, "hasNext", 407283053, default(global::Array)))){
										#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										global::pony.events.Signal e5 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator228, "next", 1224901875, default(global::Array))) );
										#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
										e5.destroy();
									}
									
								}
								
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								{
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.Dictionary<object, object> _this6 = this4.notMap;
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this6.ks = new global::Array<object>(new object[]{});
									#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									_this6.vs = new global::Array<object>(new object[]{});
								}
								
							}
							
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal __temp_expr506 = this4;
						}
						
						#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this4.removeAllListeners();
						#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( this4.takeListeners != default(global::pony.events.Signal) )) {
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.events.Signal this5 = this4.takeListeners;
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								this5.destroy();
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_expr507 = this5.target;
							}
							
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this4.takeListeners = default(global::pony.events.Signal);
						}
						
						#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( this4.lostListeners != default(global::pony.events.Signal) )) {
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.events.Signal this6 = this4.lostListeners;
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								this6.destroy();
								#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_expr508 = this6.target;
							}
							
							#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this4.lostListeners = default(global::pony.events.Signal);
						}
						
					}
					
					#line 91 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					object __temp_expr509 = this4.target;
				}
				
				#line 92 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				this.connect = default(global::pony.events.Signal);
				{
					#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal _this7 = this.closed;
					#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					if (( _this7.parent != default(global::pony.events.Signal) )) {
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						_this7.parent.removeSubSignal(_this7);
					}
					
					#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( _this7.subMap != default(global::pony.Dictionary<object, object>) )) {
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_iterator229 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (_this7.subMap.vs) ))) );
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator229, "hasNext", 407283053, default(global::Array)))){
									#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.events.Signal e6 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator229, "next", 1224901875, default(global::Array))) );
									#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									e6.destroy();
								}
								
							}
							
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.Dictionary<object, object> _this8 = _this7.subMap;
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this8.ks = new global::Array<object>(new object[]{});
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this8.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal __temp_expr510 = _this7;
					}
					
					#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( _this7.bindMap != default(global::pony.Dictionary<object, object>) )) {
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_iterator230 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (_this7.bindMap.vs) ))) );
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator230, "hasNext", 407283053, default(global::Array)))){
									#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.events.Signal e7 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator230, "next", 1224901875, default(global::Array))) );
									#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									e7.destroy();
								}
								
							}
							
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.Dictionary<object, object> _this9 = _this7.bindMap;
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this9.ks = new global::Array<object>(new object[]{});
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this9.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal __temp_expr511 = _this7;
					}
					
					#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( _this7.notMap != default(global::pony.Dictionary<object, object>) )) {
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_iterator231 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (_this7.notMap.vs) ))) );
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator231, "hasNext", 407283053, default(global::Array)))){
									#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.events.Signal e8 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator231, "next", 1224901875, default(global::Array))) );
									#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									e8.destroy();
								}
								
							}
							
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.Dictionary<object, object> _this10 = _this7.notMap;
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this10.ks = new global::Array<object>(new object[]{});
								#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this10.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal __temp_expr512 = _this7;
					}
					
					#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					_this7.removeAllListeners();
					#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					if (( _this7.takeListeners != default(global::pony.events.Signal) )) {
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal this7 = _this7.takeListeners;
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this7.destroy();
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							object __temp_expr513 = this7.target;
						}
						
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						_this7.takeListeners = default(global::pony.events.Signal);
					}
					
					#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					if (( _this7.lostListeners != default(global::pony.events.Signal) )) {
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal this8 = _this7.lostListeners;
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this8.destroy();
							#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							object __temp_expr514 = this8.target;
						}
						
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						_this7.lostListeners = default(global::pony.events.Signal);
					}
					
				}
				
				#line 94 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				this.closed = default(global::pony.events.Signal);
				{
					#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					global::pony.events.Signal _this11 = this.disconnect;
					#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					if (( _this11.parent != default(global::pony.events.Signal) )) {
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						_this11.parent.removeSubSignal(_this11);
					}
					
					#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( _this11.subMap != default(global::pony.Dictionary<object, object>) )) {
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_iterator232 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (_this11.subMap.vs) ))) );
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator232, "hasNext", 407283053, default(global::Array)))){
									#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.events.Signal e9 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator232, "next", 1224901875, default(global::Array))) );
									#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									e9.destroy();
								}
								
							}
							
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.Dictionary<object, object> _this12 = _this11.subMap;
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this12.ks = new global::Array<object>(new object[]{});
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this12.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal __temp_expr515 = _this11;
					}
					
					#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( _this11.bindMap != default(global::pony.Dictionary<object, object>) )) {
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_iterator233 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (_this11.bindMap.vs) ))) );
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator233, "hasNext", 407283053, default(global::Array)))){
									#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.events.Signal e10 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator233, "next", 1224901875, default(global::Array))) );
									#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									e10.destroy();
								}
								
							}
							
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.Dictionary<object, object> _this13 = _this11.bindMap;
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this13.ks = new global::Array<object>(new object[]{});
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this13.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal __temp_expr516 = _this11;
					}
					
					#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					{
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						if (( _this11.notMap != default(global::pony.Dictionary<object, object>) )) {
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								object __temp_iterator234 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (_this11.notMap.vs) ))) );
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator234, "hasNext", 407283053, default(global::Array)))){
									#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									global::pony.events.Signal e11 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator234, "next", 1224901875, default(global::Array))) );
									#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
									e11.destroy();
								}
								
							}
							
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							{
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								global::pony.Dictionary<object, object> _this14 = _this11.notMap;
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this14.ks = new global::Array<object>(new object[]{});
								#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
								_this14.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						global::pony.events.Signal __temp_expr517 = _this11;
					}
					
					#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					_this11.removeAllListeners();
					#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					if (( _this11.takeListeners != default(global::pony.events.Signal) )) {
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal this9 = _this11.takeListeners;
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this9.destroy();
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							object __temp_expr518 = this9.target;
						}
						
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						_this11.takeListeners = default(global::pony.events.Signal);
					}
					
					#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					if (( _this11.lostListeners != default(global::pony.events.Signal) )) {
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						{
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							global::pony.events.Signal this10 = _this11.lostListeners;
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							this10.destroy();
							#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
							object __temp_expr519 = this10.target;
						}
						
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						_this11.lostListeners = default(global::pony.events.Signal);
					}
					
				}
				
				#line 96 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				this.disconnect = default(global::pony.events.Signal);
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				switch (hash){
					case 1932118984:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.error = ((global::pony.events.Signal) (@value) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return @value;
					}
					
					
					case 437335495:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.message = ((global::pony.events.Signal) (@value) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return @value;
					}
					
					
					case 2072065992:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.clients = ((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (@value) ))) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return @value;
					}
					
					
					case 1766089820:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.disconnect = ((global::pony.events.Signal) (@value) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return @value;
					}
					
					
					case 240232876:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.closed = ((global::pony.events.Signal) (@value) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return @value;
					}
					
					
					case 360725482:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.connect = ((global::pony.events.Signal) (@value) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return @value;
					}
					
					
					case 1113806378:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.data = ((global::pony.events.Signal) (@value) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return @value;
					}
					
					
					default:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				switch (hash){
					case 1214453688:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("close") ), ((int) (1214453688) ))) );
					}
					
					
					case 554706086:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("send2other") ), ((int) (554706086) ))) );
					}
					
					
					case 1280347464:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("send") ), ((int) (1280347464) ))) );
					}
					
					
					case 2038261167:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeClient") ), ((int) (2038261167) ))) );
					}
					
					
					case 1114898252:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("addClient") ), ((int) (1114898252) ))) );
					}
					
					
					case 1932118984:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return this.error;
					}
					
					
					case 437335495:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return this.message;
					}
					
					
					case 2072065992:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return this.clients;
					}
					
					
					case 1766089820:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return this.disconnect;
					}
					
					
					case 240232876:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return this.closed;
					}
					
					
					case 360725482:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return this.connect;
					}
					
					
					case 1113806378:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return this.data;
					}
					
					
					default:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				switch (hash){
					case 1214453688:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.close();
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						break;
					}
					
					
					case 554706086:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.send2other(((global::haxe.io.BytesOutput) (dynargs[0]) ), ((global::pony.net.SocketClient) (dynargs[1]) ));
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						break;
					}
					
					
					case 1280347464:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.send(((global::haxe.io.BytesOutput) (dynargs[0]) ));
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						break;
					}
					
					
					case 2038261167:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						this.removeClient(((global::pony.net.SocketClient) (dynargs[0]) ));
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						break;
					}
					
					
					case 1114898252:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return this.addClient();
					}
					
					
					default:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				baseArr.push("error");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				baseArr.push("message");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				baseArr.push("clients");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				baseArr.push("disconnect");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				baseArr.push("closed");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				baseArr.push("connect");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				baseArr.push("data");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
				{
					#line 37 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServerBase.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}


