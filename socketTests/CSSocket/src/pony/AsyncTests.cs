
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class AsyncTests : global::haxe.unit.TestCase {
		static AsyncTests() {
			#line 46 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
			global::pony.AsyncTests.assertList = new global::List<object>();
			global::pony.AsyncTests.testCount = 0;
			global::pony.AsyncTests.complite = false;
			global::pony.AsyncTests.dec = "----------";
			global::pony.AsyncTests.waitList = new global::List<object>();
		}
		public    AsyncTests(global::haxe.lang.EmptyObject empty) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
			}
			#line default
		}
		
		
		public    AsyncTests() : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
				#line 30 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestCase.hx"
				global::pony.AsyncTests.__hx_ctor_pony_AsyncTests(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_AsyncTests(global::pony.AsyncTests __temp_me54){
			unchecked {
				#line 30 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestCase.hx"
				global::haxe.unit.TestCase.__hx_ctor_haxe_unit_TestCase(__temp_me54);
			}
			#line default
		}
		
		
		public static  global::haxe.ds.IntMap<bool> isRead;
		
		public static  global::List<object> assertList;
		
		public static  int testCount;
		
		public static  bool complite;
		
		public static  string dec;
		
		public static  global::List<object> waitList;
		
		public static  bool @lock;
		
		public static   void init(int count){
			unchecked {
				#line 56 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				if (( global::pony.AsyncTests.testCount != 0 )) {
					#line 56 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					throw global::haxe.lang.HaxeException.wrap("Second init");
				}
				
				#line 57 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				global::haxe.Log.trace.__hx_invoke2_o(default(double), global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("", global::pony.AsyncTests.dec), " Begin tests ("), global::haxe.lang.Runtime.toString(count)), ") "), global::pony.AsyncTests.dec), default(double), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"init", "pony.AsyncTests", "AsyncTests.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (57) )})));
				global::pony.AsyncTests.testCount = count;
				{
					#line 59 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					global::haxe.ds.IntMap<bool> _g = new global::haxe.ds.IntMap<bool>();
					#line 59 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					{
						#line 59 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						int _g1 = 0;
						#line 59 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						while (( _g1 < count )){
							#line 59 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
							int i = _g1++;
							#line 59 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
							_g.@set(i, false);
						}
						
					}
					
					#line 59 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					global::pony.AsyncTests.isRead = _g;
				}
				
			}
			#line default
		}
		
		
		public static   void @equals<T>(T a, T b, object infos){
			unchecked {
				#line 64 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				global::pony.AsyncTests.assertList.push(new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{97, 98, 5594516}), new global::Array<object>(new object[]{((object) (a) ), ((object) (b) ), infos}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{})));
			}
			#line default
		}
		
		
		public static   void setFlag(int n, object infos){
			unchecked {
				#line 69 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				if (( ( n >= global::pony.AsyncTests.testCount ) || ( n < 0 ) )) {
					#line 69 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					throw global::haxe.lang.HaxeException.wrap("Wrong test number");
				}
				
				#line 70 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				if ((global::pony.AsyncTests.isRead.@get(n)).@value) {
					#line 70 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					throw global::haxe.lang.HaxeException.wrap("Double complite");
				}
				
				#line 71 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				global::haxe.Log.trace.__hx_invoke2_o(default(double), global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("", global::pony.AsyncTests.dec), " Test #"), global::haxe.lang.Runtime.toString(n)), " finished "), global::pony.AsyncTests.dec), default(double), infos);
				{
					#line 72 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					global::pony.AsyncTests.isRead.@set(n, true);
					#line 72 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					bool __temp_expr293 = true;
				}
				
				#line 73 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				if (global::pony.AsyncTests.@lock) {
					#line 73 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					return ;
				}
				
				#line 74 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				global::pony.AsyncTests.@lock = true;
				global::pony.AsyncTests.checkWaitList();
				{
					#line 76 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					object __temp_iterator127 = global::pony.AsyncTests.isRead.iterator();
					#line 76 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator127, "hasNext", 407283053, default(global::Array)))){
						#line 76 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						bool e = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator127, "next", 1224901875, default(global::Array)));
						#line 76 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						if ( ! (e) ) {
							#line 77 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
							global::pony.AsyncTests.@lock = false;
							return ;
						}
						
					}
					
				}
				
				#line 80 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				global::haxe.unit.TestRunner test = new global::haxe.unit.TestRunner();
				test.@add(new global::pony.AsyncTests());
				test.run();
			}
			#line default
		}
		
		
		public static   void finish(object infos){
			unchecked {
				#line 92 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				if ( ! (global::pony.AsyncTests.complite) ) {
					#line 92 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					global::Array<int> __temp_stmt296 = default(global::Array<int>);
					#line 92 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					{
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						global::Array<int> a = new global::Array<int>(new int[]{});
						{
							#line 94 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
							object __temp_iterator128 = global::pony.AsyncTests.isRead.keys();
							#line 94 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
							while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator128, "hasNext", 407283053, default(global::Array)))){
								#line 94 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
								int k = ((int) (global::haxe.lang.Runtime.toInt(global::haxe.lang.Runtime.callField(__temp_iterator128, "next", 1224901875, default(global::Array)))) );
								#line 94 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
								if (( ! (global::pony.AsyncTests.isRead.@get(k).@value) )) {
									#line 94 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
									a.push(k);
								}
								
							}
							
						}
						
						#line 95 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						__temp_stmt296 = a;
					}
					
					#line 92 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					string __temp_stmt295 = global::Std.@string(__temp_stmt296);
					#line 92 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					string __temp_stmt294 = global::haxe.lang.Runtime.concat("Tests not complited: ", __temp_stmt295);
					#line 92 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					throw global::haxe.lang.HaxeException.wrap(__temp_stmt294);
				}
				
				#line 97 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				global::haxe.Log.trace.__hx_invoke2_o(default(double), global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("", global::pony.AsyncTests.dec), " All tests finished "), global::pony.AsyncTests.dec), default(double), infos);
			}
			#line default
		}
		
		
		public static   void wait(global::IntIterator it, global::haxe.lang.Function cb){
			unchecked {
				#line 101 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				if (global::pony.AsyncTests.checkWait(it)) {
					#line 101 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					cb.__hx_invoke0_o();
				}
				 else {
					#line 102 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					global::pony.AsyncTests.waitList.push(new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{22175, 23531}), new global::Array<object>(new object[]{cb, it}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{})));
				}
				
			}
			#line default
		}
		
		
		public static   bool checkWait(global::IntIterator it){
			unchecked {
				#line 106 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				{
					#line 106 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					int _g1 = ((int) (global::haxe.lang.Runtime.getField_f(it, "min", 5443986, false)) );
					#line 106 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					int _g = ((int) (global::haxe.lang.Runtime.getField_f(it, "max", 5442212, false)) );
					#line 106 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					while (( _g1 < _g )){
						#line 106 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						int i = _g1++;
						#line 106 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						if (( ! (global::pony.AsyncTests.isRead.@get(i).@value) )) {
							#line 106 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
							return false;
						}
						
					}
					
				}
				
				#line 107 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				return true;
			}
			#line default
		}
		
		
		public static   void checkWaitList(){
			unchecked {
				#line 111 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				global::List<object> nl = new global::List<object>();
				{
					#line 112 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					object __temp_iterator129 = global::pony.AsyncTests.waitList.iterator();
					#line 112 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator129, "hasNext", 407283053, default(global::Array)))){
						#line 112 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						object e = ((object) (global::haxe.lang.Runtime.callField(__temp_iterator129, "next", 1224901875, default(global::Array))) );
						#line 112 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						if (global::pony.AsyncTests.checkWait(((global::IntIterator) (global::haxe.lang.Runtime.getField(e, "it", 23531, true)) ))) {
							#line 112 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
							global::haxe.lang.Runtime.callField(e, "cb", 22175, default(global::Array));
						}
						 else {
							#line 113 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
							nl.push(e);
						}
						
					}
					
				}
				
				#line 114 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				global::pony.AsyncTests.waitList = nl;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				return new global::pony.AsyncTests(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				return new global::pony.AsyncTests();
			}
			#line default
		}
		
		
		public virtual   void testRun(){
			unchecked {
				#line 87 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				{
					#line 87 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					object __temp_iterator126 = global::pony.AsyncTests.assertList.iterator();
					#line 87 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator126, "hasNext", 407283053, default(global::Array)))){
						#line 87 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						object e = ((object) (global::haxe.lang.Runtime.callField(__temp_iterator126, "next", 1224901875, default(global::Array))) );
						#line 87 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						this.assertEquals<object>(global::haxe.lang.Runtime.getField(e, "a", 97, true), global::haxe.lang.Runtime.getField(e, "b", 98, true), global::haxe.lang.Runtime.getField(e, "pos", 5594516, true));
					}
					
				}
				
				#line 88 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				global::pony.AsyncTests.complite = true;
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				switch (hash){
					case 1036342809:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("testRun") ), ((int) (1036342809) ))) );
					}
					
					
					default:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				switch (hash){
					case 1036342809:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						this.testRun();
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						break;
					}
					
					
					default:
					{
						#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\AsyncTests.hx"
				return default(object);
			}
			#line default
		}
		
		
	}
}


