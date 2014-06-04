
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.unit{
	public  class TestRunner : global::haxe.lang.HxObject {
		static TestRunner() {
			#line 35 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
			global::haxe.unit.TestRunner.print = ( (( global::haxe.unit.TestRunner_new_35__Fun.__hx_current != default(global::haxe.unit.TestRunner_new_35__Fun) )) ? (global::haxe.unit.TestRunner_new_35__Fun.__hx_current) : (global::haxe.unit.TestRunner_new_35__Fun.__hx_current = ((global::haxe.unit.TestRunner_new_35__Fun) (new global::haxe.unit.TestRunner_new_35__Fun()) )) );
		}
		public    TestRunner(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    TestRunner(){
			unchecked {
				#line 96 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				global::haxe.unit.TestRunner.__hx_ctor_haxe_unit_TestRunner(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_unit_TestRunner(global::haxe.unit.TestRunner __temp_me44){
			unchecked {
				#line 97 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				__temp_me44.result = new global::haxe.unit.TestResult();
				__temp_me44.cases = new global::List<object>();
			}
			#line default
		}
		
		
		public static  global::haxe.lang.Function print;
		
		public static   void customTrace(object v, object p){
			unchecked {
				#line 93 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				global::haxe.unit.TestRunner.print.__hx_invoke1_o(default(double), global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.getField(p, "fileName", 1648581351, true)), ":"), global::haxe.lang.Runtime.toString(((int) (global::haxe.lang.Runtime.getField_f(p, "lineNumber", 1981972957, true)) ))), ": "), global::Std.@string(v)), "\n"));
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				return new global::haxe.unit.TestRunner(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				return new global::haxe.unit.TestRunner();
			}
			#line default
		}
		
		
		public  global::haxe.unit.TestResult result;
		
		public  global::List<object> cases;
		
		public virtual   void @add(global::haxe.unit.TestCase c){
			unchecked {
				#line 102 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				this.cases.@add(c);
			}
			#line default
		}
		
		
		public virtual   bool run(){
			unchecked {
				#line 106 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				this.result = new global::haxe.unit.TestResult();
				{
					#line 107 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
					object __temp_iterator125 = this.cases.iterator();
					#line 107 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator125, "hasNext", 407283053, default(global::Array)))){
						#line 107 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						global::haxe.unit.TestCase c = ((global::haxe.unit.TestCase) (global::haxe.lang.Runtime.callField(__temp_iterator125, "next", 1224901875, default(global::Array))) );
						this.runCase(c);
					}
					
				}
				
				#line 110 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				global::haxe.unit.TestRunner.print.__hx_invoke1_o(default(double), this.result.toString());
				return this.result.success;
			}
			#line default
		}
		
		
		public virtual   void runCase(global::haxe.unit.TestCase t){
			unchecked {
				#line 115 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				global::haxe.lang.Function old = global::haxe.Log.trace;
				global::haxe.Log.trace = ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (typeof(global::haxe.unit.TestRunner)) ), ((string) ("customTrace") ), ((int) (727446804) ))) );
				#line 118 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				global::System.Type cl = global::Type.getClass<object>(t);
				global::Array<object> fields = global::Type.getInstanceFields(cl);
				#line 121 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				global::haxe.unit.TestRunner.print.__hx_invoke1_o(default(double), global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("Class: ", global::Type.getClassName(cl)), " "));
				{
					#line 122 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
					int _g = 0;
					#line 122 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
					while (( _g < fields.length )){
						#line 122 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						string f = global::haxe.lang.Runtime.toString(fields[_g]);
						#line 122 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						 ++ _g;
						string fname = f;
						object field = global::Reflect.field(t, f);
						if (( fname.StartsWith("test") && global::Reflect.isFunction(field) )) {
							#line 126 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
							t.currentTest = new global::haxe.unit.TestStatus();
							t.currentTest.classname = global::Type.getClassName(cl);
							t.currentTest.method = fname;
							t.setup();
							#line 131 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
							try {
								#line 132 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
								global::Reflect.callMethod(t, field, new global::Array<object>());
								#line 134 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
								if (t.currentTest.done) {
									#line 135 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
									t.currentTest.success = true;
									global::haxe.unit.TestRunner.print.__hx_invoke1_o(default(double), ".");
								}
								 else {
									#line 138 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
									t.currentTest.success = false;
									t.currentTest.error = "(warning) no assert";
									global::haxe.unit.TestRunner.print.__hx_invoke1_o(default(double), "W");
								}
								
							}
							catch (global::System.Exception __temp_catchallException264){
								#line 131 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
								global::haxe.lang.Exceptions.exception = __temp_catchallException264;
								#line 145 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
								object __temp_catchall265 = __temp_catchallException264;
								#line 145 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
								if (( __temp_catchall265 is global::haxe.lang.HaxeException )) {
									#line 145 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
									__temp_catchall265 = ((global::haxe.lang.HaxeException) (__temp_catchallException264) ).obj;
								}
								
								#line 142 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
								if (( __temp_catchall265 is global::haxe.unit.TestStatus )) {
									#line 142 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
									global::haxe.unit.TestStatus e = ((global::haxe.unit.TestStatus) (__temp_catchall265) );
									#line 142 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
									{
										#line 143 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
										global::haxe.unit.TestRunner.print.__hx_invoke1_o(default(double), "F");
										t.currentTest.backtrace = global::haxe.CallStack.toString(global::haxe.CallStack.exceptionStack());
									}
									
								}
								 else {
									#line 145 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
									object e1 = __temp_catchall265;
									global::haxe.unit.TestRunner.print.__hx_invoke1_o(default(double), "E");
									#line 154 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
									t.currentTest.error = global::haxe.lang.Runtime.concat("exception thrown : ", global::Std.@string(e1));
									#line 156 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
									t.currentTest.backtrace = global::haxe.CallStack.toString(global::haxe.CallStack.exceptionStack());
								}
								
							}
							
							
							#line 158 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
							this.result.@add(t.currentTest);
							t.tearDown();
						}
						
					}
					
				}
				
				#line 163 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				global::haxe.unit.TestRunner.print.__hx_invoke1_o(default(double), "\n");
				global::haxe.Log.trace = old;
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				switch (hash){
					case 1092664259:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						this.cases = ((global::List<object>) (global::List<object>.__hx_cast<object>(((global::List) (@value) ))) );
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return @value;
					}
					
					
					case 142895325:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						this.result = ((global::haxe.unit.TestResult) (@value) );
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return @value;
					}
					
					
					default:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				switch (hash){
					case 1324823451:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("runCase") ), ((int) (1324823451) ))) );
					}
					
					
					case 5695307:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("run") ), ((int) (5695307) ))) );
					}
					
					
					case 4846113:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("add") ), ((int) (4846113) ))) );
					}
					
					
					case 1092664259:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return this.cases;
					}
					
					
					case 142895325:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return this.result;
					}
					
					
					default:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				switch (hash){
					case 1324823451:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						this.runCase(((global::haxe.unit.TestCase) (dynargs[0]) ));
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						break;
					}
					
					
					case 5695307:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return this.run();
					}
					
					
					case 4846113:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						this.@add(((global::haxe.unit.TestCase) (dynargs[0]) ));
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						break;
					}
					
					
					default:
					{
						#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				baseArr.push("cases");
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				baseArr.push("result");
				#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				{
					#line 25 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.unit{
	public  class TestRunner_new_35__Fun : global::haxe.lang.Function {
		public    TestRunner_new_35__Fun() : base(1, 0){
			unchecked {
			}
			#line default
		}
		
		
		public static  global::haxe.unit.TestRunner_new_35__Fun __hx_current;
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 35 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				object v = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((object) (__fn_float1) )) : (((object) (__fn_dyn1) )) );
				#line 83 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				global::System.Console.Write(((object) (v) ));
				#line 83 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestRunner.hx"
				return default(object);
			}
			#line default
		}
		
		
	}
}


