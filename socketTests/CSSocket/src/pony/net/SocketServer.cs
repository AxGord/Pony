
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.net{
	public  class SocketServer : global::pony.net.cs.SocketServer, global::pony.net.ISocketServer {
		public    SocketServer(global::haxe.lang.EmptyObject empty) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
			}
			#line default
		}
		
		
		public    SocketServer(int port, global::haxe.lang.Null<int> maxListeners) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				global::pony.net.SocketServer.__hx_ctor_pony_net_SocketServer(this, port, maxListeners);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_net_SocketServer(global::pony.net.SocketServer __temp_me113, int port, global::haxe.lang.Null<int> maxListeners){
			unchecked {
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketServer.hx"
				global::pony.net.cs.SocketServer.__hx_ctor_pony_net_cs_SocketServer(__temp_me113, port, maxListeners);
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 36 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServer.hx"
				return new global::pony.net.SocketServer(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 36 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketServer.hx"
				return new global::pony.net.SocketServer(((int) (global::haxe.lang.Runtime.toInt(arr[0])) ), global::haxe.lang.Null<object>.ofDynamic<int>(arr[1]));
			}
			#line default
		}
		
		
	}
}


