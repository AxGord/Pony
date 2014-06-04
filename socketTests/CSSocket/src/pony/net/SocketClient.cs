
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.net{
	public  class SocketClient : global::pony.net.cs.SocketClient, global::pony.net.ISocketClient {
		public    SocketClient(global::haxe.lang.EmptyObject empty) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
			}
			#line default
		}
		
		
		public    SocketClient(string host, int port, global::haxe.lang.Null<int> reconnect) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				global::pony.net.SocketClient.__hx_ctor_pony_net_SocketClient(this, host, port, reconnect);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_net_SocketClient(global::pony.net.SocketClient __temp_me109, string host, int port, global::haxe.lang.Null<int> reconnect){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				global::pony.net.cs.SocketClient.__hx_ctor_pony_net_cs_SocketClient(__temp_me109, host, port, reconnect);
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
				return new global::pony.net.SocketClient(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
				return new global::pony.net.SocketClient(global::haxe.lang.Runtime.toString(arr[0]), ((int) (global::haxe.lang.Runtime.toInt(arr[1])) ), global::haxe.lang.Null<object>.ofDynamic<int>(arr[2]));
			}
			#line default
		}
		
		
		public override   void send(global::haxe.io.BytesOutput data){
			unchecked {
				#line 46 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
				global::haxe.io.BytesOutput bo = new global::haxe.io.BytesOutput();
				int __temp_stmt496 = default(int);
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
				{
					#line 47 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
					long x = ( data.b.b as global::System.IO.Stream ).Length;
					#line 47 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
					__temp_stmt496 = ((int) (x) );
				}
				
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
				bo.writeInt32(__temp_stmt496);
				bo.write(data.getBytes());
				base.send(bo);
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
				switch (hash){
					case 1280347464:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("send") ), ((int) (1280347464) ))) );
					}
					
					
					default:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClient.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
	}
}


