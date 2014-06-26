
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.net.cs{
	public  class SocketClient : global::pony.net.SocketClientBase {
		public    SocketClient(global::haxe.lang.EmptyObject empty) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
			}
			#line default
		}
		
		
		public    SocketClient(string host, int port, global::haxe.lang.Null<int> reconnect) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				global::pony.net.cs.SocketClient.__hx_ctor_pony_net_cs_SocketClient(this, host, port, reconnect);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_net_cs_SocketClient(global::pony.net.cs.SocketClient __temp_me108, string host, int port, global::haxe.lang.Null<int> reconnect){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\net\\SocketClientBase.hx"
				global::pony.net.SocketClientBase.__hx_ctor_pony_net_SocketClientBase(__temp_me108, host, port, reconnect);
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				return new global::pony.net.cs.SocketClient(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				return new global::pony.net.cs.SocketClient(global::haxe.lang.Runtime.toString(arr[0]), ((int) (global::haxe.lang.Runtime.toInt(arr[1])) ), global::haxe.lang.Null<object>.ofDynamic<int>(arr[2]));
			}
			#line default
		}
		
		
		public  global::System.Net.Sockets.Socket socket;
		
		public  byte[] buffer;
		
		public  bool sendProccess;
		
		public  bool closeAfterSend;
		
		public  int packSize;
		
		public override   void open(){
			unchecked {
				#line 63 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				if ( ! (this.closed) ) {
					#line 63 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					return ;
				}
				
				#line 64 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.socket = new global::System.Net.Sockets.Socket(((global::System.Net.Sockets.AddressFamily) (global::System.Net.Sockets.AddressFamily.InterNetwork) ), ((global::System.Net.Sockets.SocketType) (global::System.Net.Sockets.SocketType.Stream) ), ((global::System.Net.Sockets.ProtocolType) (global::System.Net.Sockets.ProtocolType.Tcp) ));
				this.socket.BeginConnect(((string) (this.host) ), ((int) (this.port) ), ((global::System.AsyncCallback) (this.connectCallback) ), ((object) (default(object)) ));
			}
			#line default
		}
		
		
		public virtual   void connectCallback(global::System.IAsyncResult ar){
			unchecked {
				#line 69 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				try {
					#line 70 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					this.socket.EndConnect(((global::System.IAsyncResult) (ar) ));
					this.initCS(this.socket);
				}
				catch (global::System.Exception __temp_catchallException490){
					#line 69 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					global::haxe.lang.Exceptions.exception = __temp_catchallException490;
					#line 72 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					object __temp_catchall491 = __temp_catchallException490;
					#line 72 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					if (( __temp_catchall491 is global::haxe.lang.HaxeException )) {
						#line 72 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						__temp_catchall491 = ((global::haxe.lang.HaxeException) (__temp_catchallException490) ).obj;
					}
					
					#line 72 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					{
						#line 72 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						object _ = __temp_catchall491;
						global::haxe.Log.trace.__hx_invoke2_o(default(double), "connect error", default(double), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"connectCallback", "pony.net.cs.SocketClient", "SocketClient.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (73) )})));
						this.reconnect();
					}
					
				}
				
				
			}
			#line default
		}
		
		
		public virtual   void initCS(global::System.Net.Sockets.Socket s){
			unchecked {
				#line 79 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.sendProccess = false;
				this.closeAfterSend = false;
				this.socket = s;
				{
					#line 82 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					this.closed = false;
					#line 82 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					if (( this.server != default(global::pony.net.SocketServer) )) {
						#line 82 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						global::pony.events._Signal1.Signal1_Impl_.dispatch<object, object>(this.server.connect, ((object) (this) ));
					}
					
				}
				
				#line 83 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.waitFirstPack();
				global::pony.events._Signal0.Signal0_Impl_.dispatch<object>(this.connect);
			}
			#line default
		}
		
		
		public virtual   void waitFirstPack(){
			unchecked {
				#line 90 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.buffer = new byte[((int) (4) )];
				this.socket.BeginReceive(((byte[]) (this.buffer) ), ((int) (0) ), ((int) (4) ), ((global::System.Net.Sockets.SocketFlags) (global::System.Net.Sockets.SocketFlags.None) ), ((global::System.AsyncCallback) (this.readFirstPack) ), ((object) (default(object)) ));
			}
			#line default
		}
		
		
		public virtual   void readFirstPack(global::System.IAsyncResult ar){
			unchecked {
				#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				if (this.closed) {
					#line 95 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					return ;
				}
				
				#line 96 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				try {
					#line 97 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					int bytesRead = this.socket.EndReceive(((global::System.IAsyncResult) (ar) ));
					if (( bytesRead > 0 )) {
						#line 99 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						if (( bytesRead != 4 )) {
							#line 99 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
							throw global::haxe.lang.HaxeException.wrap("Wrong bytes count");
						}
						
						#line 100 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						global::haxe.io.BytesInput bi = new global::haxe.io.BytesInput(((global::haxe.io.Bytes) (global::haxe.io.Bytes.ofData(((byte[]) (this.buffer) ))) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) ));
						this.packSize = bi.readInt32();
						this.waitSecondPack();
					}
					 else {
						#line 103 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this._close();
					}
					
				}
				catch (global::System.Exception __temp_catchallException492){
					#line 96 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					global::haxe.lang.Exceptions.exception = __temp_catchallException492;
					#line 105 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					object __temp_catchall493 = __temp_catchallException492;
					#line 105 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					if (( __temp_catchall493 is global::haxe.lang.HaxeException )) {
						#line 105 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						__temp_catchall493 = ((global::haxe.lang.HaxeException) (__temp_catchallException492) ).obj;
					}
					
					#line 105 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					{
						#line 105 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						object _ = __temp_catchall493;
						#line 105 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this._close();
					}
					
				}
				
				
			}
			#line default
		}
		
		
		public virtual   void waitSecondPack(){
			unchecked {
				#line 110 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.buffer = new byte[((int) (this.packSize) )];
				this.socket.BeginReceive(((byte[]) (this.buffer) ), ((int) (0) ), ((int) (this.packSize) ), ((global::System.Net.Sockets.SocketFlags) (global::System.Net.Sockets.SocketFlags.None) ), ((global::System.AsyncCallback) (this.readSecondPack) ), ((object) (default(object)) ));
			}
			#line default
		}
		
		
		public virtual   void readSecondPack(global::System.IAsyncResult ar){
			unchecked {
				#line 115 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				if (this.closed) {
					#line 115 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					return ;
				}
				
				#line 116 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				try {
					#line 117 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					int bytesRead = this.socket.EndReceive(((global::System.IAsyncResult) (ar) ));
					if (( bytesRead > 0 )) {
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						if (( bytesRead != this.packSize )) {
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
							throw global::haxe.lang.HaxeException.wrap("Wrong bytes count");
						}
						
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						global::pony.events._Signal1.Signal1_Impl_.dispatch<object, object>(this.data, new global::haxe.io.BytesInput(((global::haxe.io.Bytes) (global::haxe.io.Bytes.ofData(((byte[]) (this.buffer) ))) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) )));
						this.waitFirstPack();
					}
					 else {
						#line 122 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this._close();
					}
					
				}
				catch (global::System.Exception __temp_catchallException494){
					#line 116 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					global::haxe.lang.Exceptions.exception = __temp_catchallException494;
					#line 124 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					object __temp_catchall495 = __temp_catchallException494;
					#line 124 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					if (( __temp_catchall495 is global::haxe.lang.HaxeException )) {
						#line 124 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						__temp_catchall495 = ((global::haxe.lang.HaxeException) (__temp_catchallException494) ).obj;
					}
					
					#line 124 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					{
						#line 124 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						object _ = __temp_catchall495;
						#line 124 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this._close();
					}
					
				}
				
				
			}
			#line default
		}
		
		
		public virtual   void disconnectCallback(global::System.IAsyncResult ar){
			unchecked {
				#line 129 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.socket.EndDisconnect(((global::System.IAsyncResult) (ar) ));
				this.socket.Close();
				#line 151 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 131 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					global::pony.events.Signal _this = this.disconnect;
					#line 151 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					_this.dispatchEvent(new global::pony.events.Event(((global::Array) (new global::Array<object>(new object[]{})) ), ((object) (_this.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) )));
					#line 151 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal __temp_expr496 = _this;
				}
				
			}
			#line default
		}
		
		
		public virtual   void send(global::haxe.io.BytesOutput data){
			unchecked {
				#line 135 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.sendProccess = true;
				data.flush();
				global::haxe.io.Bytes b = data.getBytes();
				this.socket.BeginSend(((byte[]) (b.b) ), ((int) (0) ), ((int) (( b.length + 1 )) ), ((global::System.Net.Sockets.SocketFlags) (global::System.Net.Sockets.SocketFlags.OutOfBand) ), ((global::System.AsyncCallback) (this.sendCallback) ), ((object) (default(object)) ));
			}
			#line default
		}
		
		
		public virtual   void sendCallback(global::System.IAsyncResult ar){
			unchecked {
				#line 142 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.socket.EndSend(((global::System.IAsyncResult) (ar) ));
				this.sendProccess = false;
				if (this.closeAfterSend) {
					#line 144 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					this._close();
				}
				
			}
			#line default
		}
		
		
		public   void close(){
			unchecked {
				#line 148 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				if ( ! (this.sendProccess) ) {
					#line 148 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					this._close();
				}
				 else {
					#line 149 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					this.closeAfterSend = true;
				}
				
			}
			#line default
		}
		
		
		public virtual   void _close(){
			unchecked {
				#line 153 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.closeAfterSend = false;
				if (this.closed) {
					#line 154 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					return ;
				}
				
				#line 155 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				this.closed = true;
				this.socket.Shutdown(((global::System.Net.Sockets.SocketShutdown) (global::System.Net.Sockets.SocketShutdown.Both) ));
				this.socket.BeginDisconnect(global::haxe.lang.Runtime.toBool(true), ((global::System.AsyncCallback) (this.disconnectCallback) ), ((object) (this.socket) ));
			}
			#line default
		}
		
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				switch (hash){
					case 806716474:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.packSize = ((int) (@value) );
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return @value;
					}
					
					
					default:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				switch (hash){
					case 806716474:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.packSize = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return @value;
					}
					
					
					case 1737125548:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.closeAfterSend = global::haxe.lang.Runtime.toBool(@value);
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return @value;
					}
					
					
					case 1868776384:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.sendProccess = global::haxe.lang.Runtime.toBool(@value);
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return @value;
					}
					
					
					case 1351924992:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.buffer = ((byte[]) (@value) );
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return @value;
					}
					
					
					case 642157491:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.socket = ((global::System.Net.Sockets.Socket) (@value) );
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return @value;
					}
					
					
					default:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				switch (hash){
					case 1145724665:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("_close") ), ((int) (1145724665) ))) );
					}
					
					
					case 1214453688:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("close") ), ((int) (1214453688) ))) );
					}
					
					
					case 1069771565:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("sendCallback") ), ((int) (1069771565) ))) );
					}
					
					
					case 1280347464:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("send") ), ((int) (1280347464) ))) );
					}
					
					
					case 1103263297:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("disconnectCallback") ), ((int) (1103263297) ))) );
					}
					
					
					case 1925034851:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("readSecondPack") ), ((int) (1925034851) ))) );
					}
					
					
					case 1157660482:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("waitSecondPack") ), ((int) (1157660482) ))) );
					}
					
					
					case 344902899:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("readFirstPack") ), ((int) (344902899) ))) );
					}
					
					
					case 1978556916:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("waitFirstPack") ), ((int) (1978556916) ))) );
					}
					
					
					case 390879680:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("initCS") ), ((int) (390879680) ))) );
					}
					
					
					case 1645579215:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("connectCallback") ), ((int) (1645579215) ))) );
					}
					
					
					case 1236534218:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("open") ), ((int) (1236534218) ))) );
					}
					
					
					case 806716474:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return this.packSize;
					}
					
					
					case 1737125548:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return this.closeAfterSend;
					}
					
					
					case 1868776384:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return this.sendProccess;
					}
					
					
					case 1351924992:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return this.buffer;
					}
					
					
					case 642157491:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return this.socket;
					}
					
					
					default:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				switch (hash){
					case 806716474:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return ((double) (this.packSize) );
					}
					
					
					default:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				switch (hash){
					case 1236534218:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return global::haxe.lang.Runtime.slowCallField(this, field, dynargs);
					}
					
					
					case 1145724665:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this._close();
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 1214453688:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.close();
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 1069771565:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.sendCallback(((global::System.IAsyncResult) (dynargs[0]) ));
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 1280347464:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.send(((global::haxe.io.BytesOutput) (dynargs[0]) ));
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 1103263297:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.disconnectCallback(((global::System.IAsyncResult) (dynargs[0]) ));
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 1925034851:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.readSecondPack(((global::System.IAsyncResult) (dynargs[0]) ));
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 1157660482:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.waitSecondPack();
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 344902899:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.readFirstPack(((global::System.IAsyncResult) (dynargs[0]) ));
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 1978556916:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.waitFirstPack();
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 390879680:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.initCS(((global::System.Net.Sockets.Socket) (dynargs[0]) ));
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					case 1645579215:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						this.connectCallback(((global::System.IAsyncResult) (dynargs[0]) ));
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						break;
					}
					
					
					default:
					{
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				baseArr.push("packSize");
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				baseArr.push("closeAfterSend");
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				baseArr.push("sendProccess");
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				baseArr.push("buffer");
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				baseArr.push("socket");
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
				{
					#line 53 "C:\\data\\GitHub\\Pony\\pony\\net\\cs\\SocketClient.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}


