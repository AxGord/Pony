
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.net.cs{
	public  class SocketServer : global::pony.net.SocketServerBase {
		public    SocketServer(global::haxe.lang.EmptyObject empty) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
			}
			#line default
		}
		
		
		public    SocketServer(int port, global::haxe.lang.Null<int> maxListeners) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
				#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				global::pony.net.cs.SocketServer.__hx_ctor_pony_net_cs_SocketServer(this, port, maxListeners);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_net_cs_SocketServer(global::pony.net.cs.SocketServer __temp_me112, int port, global::haxe.lang.Null<int> maxListeners){
			unchecked {
				#line 48 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				global::pony.net.SocketServerBase.__hx_ctor_pony_net_SocketServerBase(__temp_me112);
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				int __temp_maxListeners111 = ( ( ! (maxListeners.hasValue) ) ? (((int) (-1) )) : (maxListeners.@value) );
				#line 49 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				__temp_me112.listener = new global::System.Net.Sockets.Socket(((global::System.Net.Sockets.AddressFamily) (global::System.Net.Sockets.AddressFamily.InterNetwork) ), ((global::System.Net.Sockets.SocketType) (global::System.Net.Sockets.SocketType.Stream) ), ((global::System.Net.Sockets.ProtocolType) (global::System.Net.Sockets.ProtocolType.Tcp) ));
				__temp_me112.listener.Bind(((global::System.Net.EndPoint) (new global::System.Net.IPEndPoint(((global::System.Net.IPAddress) (global::System.Net.IPAddress.Any) ), ((int) (port) ))) ));
				__temp_me112.listener.Listen(((int) (-1) ));
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				__temp_me112.waitAccept();
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				return new global::pony.net.cs.SocketServer(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				return new global::pony.net.cs.SocketServer(((int) (global::haxe.lang.Runtime.toInt(arr[0])) ), global::haxe.lang.Null<object>.ofDynamic<int>(arr[1]));
			}
			#line default
		}
		
		
		public  global::System.Net.Sockets.Socket listener;
		
		public virtual   void waitAccept(){
			unchecked {
				#line 57 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				this.listener.BeginAccept(((global::System.AsyncCallback) (acceptCallback) ), ((object) (default(object)) ));
			}
			#line default
		}
		
		
		public virtual   void acceptCallback(global::System.IAsyncResult ar){
			unchecked {
				#line 62 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				try {
					#line 63 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
					this.addClient().initCS(this.listener.EndAccept(((global::System.IAsyncResult) (ar) )));
					this.waitAccept();
				}
				catch (global::System.Exception __temp_catchallException525){
					#line 62 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
					global::haxe.lang.Exceptions.exception = __temp_catchallException525;
					#line 65 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
					object __temp_catchall526 = __temp_catchallException525;
					#line 65 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
					if (( __temp_catchall526 is global::haxe.lang.HaxeException )) {
						#line 65 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						__temp_catchall526 = ((global::haxe.lang.HaxeException) (__temp_catchallException525) ).obj;
					}
					
					#line 65 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
					{
						#line 65 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						object _ = __temp_catchall526;
						#line 65 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						{
						}
						
					}
					
				}
				
				
			}
			#line default
		}
		
		
		public override   void close(){
			unchecked {
				#line 70 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				this.listener.Close();
				this.listener = default(global::System.Net.Sockets.Socket);
				base.close();
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				switch (hash){
					case 942801012:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						this.listener = ((global::System.Net.Sockets.Socket) (@value) );
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						return @value;
					}
					
					
					default:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				switch (hash){
					case 1214453688:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("close") ), ((int) (1214453688) ))) );
					}
					
					
					case 278212845:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("acceptCallback") ), ((int) (278212845) ))) );
					}
					
					
					case 1562126173:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("waitAccept") ), ((int) (1562126173) ))) );
					}
					
					
					case 942801012:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						return this.listener;
					}
					
					
					default:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				switch (hash){
					case 1214453688:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						return global::haxe.lang.Runtime.slowCallField(this, field, dynargs);
					}
					
					
					case 278212845:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						this.acceptCallback(((global::System.IAsyncResult) (dynargs[0]) ));
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						break;
					}
					
					
					case 1562126173:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						this.waitAccept();
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						break;
					}
					
					
					default:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				baseArr.push("listener");
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				{
					#line 43 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}


