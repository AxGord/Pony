
#pragma warning disable 109, 114, 219, 429, 168, 162
public class EntryPoint__Main{
	public static void Main(){
		global::cs.Boot.init();
		global::Main.main();
	}
}
public  class Main : global::haxe.lang.HxObject {
	static Main() {
		#line 21 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
		global::Main.testCount = 100;
		#line 23 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
		global::Main.delay = 300;
		#line 27 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
		global::Main.port = 16001;
		#line 29 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
		global::Main.partCount = ( global::Main.testCount / 4 );
		global::Main.blockCount = ( global::Main.testCount / 2 );
	}
	public    Main(global::haxe.lang.EmptyObject empty){
		unchecked {
			#line 19 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public    Main(){
		unchecked {
			#line 19 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::Main.__hx_ctor__Main(this);
		}
		#line default
	}
	
	
	public static   void __hx_ctor__Main(global::Main __temp_me9){
		unchecked {
			#line 19 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public static  int testCount;
	
	public static  int delay;
	
	public static  int port;
	
	public static  int partCount;
	
	public static  int blockCount;
	
	public static   void main(){
		unchecked {
			#line 37 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			try {
				#line 39 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				if (( ( global::Main.testCount % 4 ) != 0 )) {
					#line 39 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					throw global::haxe.lang.HaxeException.wrap("Wrong test count");
				}
				
				#line 40 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.AsyncTests.init(global::Main.testCount);
				global::Main.firstTest();
				#line 43 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::Sys.getChar(false);
				global::pony.AsyncTests.finish(new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"main", "Main", "Main.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (44) )})));
			}
			catch (global::System.Exception __temp_catchallException238){
				#line 37 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::haxe.lang.Exceptions.exception = __temp_catchallException238;
				#line 45 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				object __temp_catchall239 = __temp_catchallException238;
				#line 45 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				if (( __temp_catchall239 is global::haxe.lang.HaxeException )) {
					#line 45 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					__temp_catchall239 = ((global::haxe.lang.HaxeException) (__temp_catchallException238) ).obj;
				}
				
				#line 45 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				if (( __temp_catchall239 is string )) {
					#line 45 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					string e = global::haxe.lang.Runtime.toString(__temp_catchall239);
					#line 45 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					{
						#line 45 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						global::haxe.Log.trace.__hx_invoke2_o(default(double), e, default(double), default(object));
						#line 45 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						global::haxe.Log.trace.__hx_invoke2_o(default(double), global::haxe.CallStack.toString(global::haxe.CallStack.exceptionStack()), default(double), default(object));
					}
					
				}
				 else {
					#line 45 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					throw;
				}
				
			}
			
			
		}
		#line default
	}
	
	
	public static   void firstTest(){
		unchecked {
			#line 50 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::Array<object> server = new global::Array<object>(new object[]{global::Main.createServer()});
			#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			{
				#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				int _g1 = 0;
				#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				int _g = global::Main.partCount;
				#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				while (( _g1 < _g )){
					#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					int i = _g1++;
					#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					global::haxe.lang.Function __temp_stmt240 = default(global::haxe.lang.Function);
					#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					{
						#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						global::Array<int> i1 = new global::Array<int>(new int[]{i});
						#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						__temp_stmt240 = new global::Main_firstTest_52__Fun(((global::Array<int>) (i1) ));
					}
					
					#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					global::haxe.Timer.delay(__temp_stmt240, ( global::Main.delay + ( global::Main.delay * i ) ));
				}
				
			}
			
			#line 54 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::pony.AsyncTests.wait(new global::IntIterator(((int) (0) ), ((int) (global::Main.blockCount) )), new global::Main_firstTest_54__Fun(((global::Array<object>) (server) )));
		}
		#line default
	}
	
	
	public static   global::pony.net.SocketServer createServer(){
		unchecked {
			#line 64 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::pony.net.SocketServer server = new global::pony.net.SocketServer(((int) (global::Main.port) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) ));
			#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			{
				#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.events.Signal this1 = server.connect;
				#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				object listener = default(object);
				#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				object __temp_stmt241 = default(object);
				#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				{
					#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					object l = default(object);
					#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					{
						#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						object f = global::pony._Function.Function_Impl_.@from(( (( global::Main_createServer_66__Fun.__hx_current != default(global::Main_createServer_66__Fun) )) ? (global::Main_createServer_66__Fun.__hx_current) : (global::Main_createServer_66__Fun.__hx_current = ((global::Main_createServer_66__Fun) (new global::Main_createServer_66__Fun()) )) ), 1);
						#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						l = global::pony.events._Listener.Listener_Impl_._fromFunction(f, false);
					}
					
					#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					__temp_stmt241 = l;
				}
				
				#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				listener = ((object) (__temp_stmt241) );
				#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.events._Signal1.Signal1_Impl_.@add<object, object>(this1, listener, default(global::haxe.lang.Null<int>));
				#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.events.Signal __temp_expr242 = this1;
			}
			
			#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			{
				#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.events.Signal this2 = server.data;
				#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				object listener1 = default(object);
				#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				object __temp_stmt243 = default(object);
				#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				{
					#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					object l1 = default(object);
					#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					{
						#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						object f1 = global::pony._Function.Function_Impl_.@from(( (( global::Main_createServer_73__Fun.__hx_current != default(global::Main_createServer_73__Fun) )) ? (global::Main_createServer_73__Fun.__hx_current) : (global::Main_createServer_73__Fun.__hx_current = ((global::Main_createServer_73__Fun) (new global::Main_createServer_73__Fun()) )) ), 1);
						#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						l1 = global::pony.events._Listener.Listener_Impl_._fromFunction(f1, false);
					}
					
					#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					__temp_stmt243 = l1;
				}
				
				#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				listener1 = ((object) (__temp_stmt243) );
				#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.events._Signal1.Signal1_Impl_.@add<object, object>(this2, listener1, default(global::haxe.lang.Null<int>));
				#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.events.Signal __temp_expr244 = this2;
			}
			
			#line 79 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return server;
		}
		#line default
	}
	
	
	public static   global::pony.net.SocketClient createClient(int i){
		unchecked {
			#line 82 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::Array<int> i1 = new global::Array<int>(new int[]{i});
			global::Array<object> client = new global::Array<object>(new object[]{new global::pony.net.SocketClient(((string) (default(string)) ), ((int) (global::Main.port) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) ))});
			#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			{
				#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.events.Signal this1 = ((global::pony.net.SocketClient) (client[0]) ).data;
				#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				object listener = default(object);
				#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				object __temp_stmt245 = default(object);
				#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				{
					#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					object l = default(object);
					#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					{
						#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						object f = global::pony._Function.Function_Impl_.@from(new global::Main_createClient_85__Fun(((global::Array<object>) (client) ), ((global::Array<int>) (i1) )), 1);
						#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						l = global::pony.events._Listener.Listener_Impl_._fromFunction(f, false);
					}
					
					#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					__temp_stmt245 = l;
				}
				
				#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				listener = ((object) (__temp_stmt245) );
				#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.events._Signal1.Signal1_Impl_.once<object, object>(this1, listener, default(global::haxe.lang.Null<int>));
				#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.events.Signal __temp_expr246 = this1;
			}
			
			#line 96 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return ((global::pony.net.SocketClient) (client[0]) );
		}
		#line default
	}
	
	
	public static  new object __hx_createEmpty(){
		unchecked {
			#line 19 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return new global::Main(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
		}
		#line default
	}
	
	
	public static  new object __hx_create(global::Array arr){
		unchecked {
			#line 19 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return new global::Main();
		}
		#line default
	}
	
	
}



#pragma warning disable 109, 114, 219, 429, 168, 162
public  class Main_firstTest_52__Fun : global::haxe.lang.Function {
	public    Main_firstTest_52__Fun(global::Array<int> i1) : base(0, 0){
		unchecked {
			#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			this.i1 = i1;
		}
		#line default
	}
	
	
	public override   object __hx_invoke0_o(){
		unchecked {
			#line 52 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return global::Main.createClient(this.i1[0]);
		}
		#line default
	}
	
	
	public  global::Array<int> i1;
	
}



#pragma warning disable 109, 114, 219, 429, 168, 162
public  class Main_firstTest_58__Fun : global::haxe.lang.Function {
	public    Main_firstTest_58__Fun(global::Array<int> i3) : base(0, 0){
		unchecked {
			#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			this.i3 = i3;
		}
		#line default
	}
	
	
	public override   object __hx_invoke0_o(){
		unchecked {
			#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return global::Main.createClient(this.i3[0]);
		}
		#line default
	}
	
	
	public  global::Array<int> i3;
	
}



#pragma warning disable 109, 114, 219, 429, 168, 162
public  class Main_firstTest_54__Fun : global::haxe.lang.Function {
	public    Main_firstTest_54__Fun(global::Array<object> server) : base(0, 0){
		unchecked {
			#line 54 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			this.server = server;
		}
		#line default
	}
	
	
	public override   object __hx_invoke0_o(){
		unchecked {
			#line 55 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::haxe.Log.trace.__hx_invoke2_o(default(double), "Second part", default(double), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"firstTest", "Main", "Main.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (55) )})));
			((global::pony.net.SocketServer) (this.server[0]) ).close();
			global::pony.net.SocketServer server1 = global::Main.createServer();
			{
				#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				int _g11 = global::Main.blockCount;
				#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				int _g2 = ( global::Main.blockCount + global::Main.partCount );
				#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				while (( _g11 < _g2 )){
					#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					int i2 = _g11++;
					#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					global::haxe.lang.Function __temp_stmt247 = default(global::haxe.lang.Function);
					#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					{
						#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						global::Array<int> i3 = new global::Array<int>(new int[]{i2});
						#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
						__temp_stmt247 = new global::Main_firstTest_58__Fun(((global::Array<int>) (i3) ));
					}
					
					#line 58 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
					global::haxe.Timer.delay(__temp_stmt247, ( global::Main.delay + ( global::Main.delay * (( i2 - global::Main.blockCount )) ) ));
				}
				
			}
			
			#line 54 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return default(object);
		}
		#line default
	}
	
	
	public  global::Array<object> server;
	
}



#pragma warning disable 109, 114, 219, 429, 168, 162
public  class Main_createServer_66__Fun : global::haxe.lang.Function {
	public    Main_createServer_66__Fun() : base(1, 0){
		unchecked {
		}
		#line default
	}
	
	
	public static  global::Main_createServer_66__Fun __hx_current;
	
	public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
		unchecked {
			#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::pony.net.SocketClient cl = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.net.SocketClient) (((object) (__fn_float1) )) )) : (((global::pony.net.SocketClient) (__fn_dyn1) )) );
			global::haxe.io.BytesOutput bo = new global::haxe.io.BytesOutput();
			{
				#line 68 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				bo.writeInt32("hi world".Length);
				#line 68 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				bo.writeString("hi world");
			}
			
			#line 70 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			cl.send(bo);
			#line 66 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return default(object);
		}
		#line default
	}
	
	
}



#pragma warning disable 109, 114, 219, 429, 168, 162
public  class Main_createServer_73__Fun : global::haxe.lang.Function {
	public    Main_createServer_73__Fun() : base(1, 0){
		unchecked {
		}
		#line default
	}
	
	
	public static  global::Main_createServer_73__Fun __hx_current;
	
	public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
		unchecked {
			#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::haxe.io.BytesInput bi = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::haxe.io.BytesInput) (((object) (__fn_float1) )) )) : (((global::haxe.io.BytesInput) (__fn_dyn1) )) );
			int i = bi.readInt32();
			{
				#line 75 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				string b = global::pony.Tools.readStr(bi);
				#line 75 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				global::pony.AsyncTests.assertList.push(new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{97, 98, 5594516}), new global::Array<object>(new object[]{((object) ("hello user") ), ((object) (b) ), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"createServer", "Main", "Main.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (75) )}))}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{})));
			}
			
			#line 76 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::pony.AsyncTests.setFlag(( global::Main.partCount + i ), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"createServer", "Main", "Main.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (76) )})));
			#line 73 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return default(object);
		}
		#line default
	}
	
	
}



#pragma warning disable 109, 114, 219, 429, 168, 162
public  class Main_createClient_85__Fun : global::haxe.lang.Function {
	public    Main_createClient_85__Fun(global::Array<object> client, global::Array<int> i1) : base(1, 0){
		unchecked {
			#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			this.client = client;
			#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			this.i1 = i1;
		}
		#line default
	}
	
	
	public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
		unchecked {
			#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			global::haxe.io.BytesInput data = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::haxe.io.BytesInput) (((object) (__fn_float1) )) )) : (((global::haxe.io.BytesInput) (__fn_dyn1) )) );
			string s = global::pony.Tools.readStr(data);
			global::pony.AsyncTests.assertList.push(new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{97, 98, 5594516}), new global::Array<object>(new object[]{((object) (s) ), ((object) ("hi world") ), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"createClient", "Main", "Main.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (87) )}))}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{})));
			global::haxe.io.BytesOutput bo = new global::haxe.io.BytesOutput();
			bo.writeInt32(this.i1[0]);
			{
				#line 90 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				bo.writeInt32("hello user".Length);
				#line 90 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				bo.writeString("hello user");
			}
			
			#line 91 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			((global::pony.net.SocketClient) (this.client[0]) ).send(bo);
			global::pony.AsyncTests.setFlag(this.i1[0], new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"createClient", "Main", "Main.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (92) )})));
			if ( ! (((global::pony.net.SocketClient) (this.client[0]) ).sendProccess) ) {
				#line 93 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				((global::pony.net.SocketClient) (this.client[0]) )._close();
			}
			 else {
				#line 93 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
				((global::pony.net.SocketClient) (this.client[0]) ).closeAfterSend = true;
			}
			
			#line 85 "C:\\data\\GitHub\\Pony\\socketTests\\src\\Main.hx"
			return default(object);
		}
		#line default
	}
	
	
	public  global::Array<object> client;
	
	public  global::Array<int> i1;
	
}


