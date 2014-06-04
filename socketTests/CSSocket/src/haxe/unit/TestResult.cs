
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.unit{
	public  class TestResult : global::haxe.lang.HxObject {
		public    TestResult(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    TestResult(){
			unchecked {
				#line 29 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				global::haxe.unit.TestResult.__hx_ctor_haxe_unit_TestResult(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_unit_TestResult(global::haxe.unit.TestResult __temp_me43){
			unchecked {
				#line 30 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				__temp_me43.m_tests = new global::List<object>();
				__temp_me43.success = true;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				return new global::haxe.unit.TestResult(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				return new global::haxe.unit.TestResult();
			}
			#line default
		}
		
		
		public  global::List<object> m_tests;
		
		public  bool success;
		
		public virtual   void @add(global::haxe.unit.TestStatus t){
			unchecked {
				#line 35 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				this.m_tests.@add(t);
				if ( ! (t.success) ) {
					#line 37 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
					this.success = false;
				}
				
			}
			#line default
		}
		
		
		public virtual   string toString(){
			unchecked {
				#line 41 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				global::StringBuf buf = new global::StringBuf();
				int failures = 0;
				{
					#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
					object __temp_iterator124 = this.m_tests.iterator();
					#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator124, "hasNext", 407283053, default(global::Array)))){
						#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						global::haxe.unit.TestStatus test = ((global::haxe.unit.TestStatus) (global::haxe.lang.Runtime.callField(__temp_iterator124, "next", 1224901875, default(global::Array))) );
						if (( test.success == false )) {
							#line 45 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
							buf.b.Append(((object) ("* ") ));
							buf.b.Append(((object) (global::Std.@string(test.classname)) ));
							buf.b.Append(((object) ("::") ));
							buf.b.Append(((object) (global::Std.@string(test.method)) ));
							buf.b.Append(((object) ("()") ));
							buf.b.Append(((object) ("\n") ));
							#line 52 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
							buf.b.Append(((object) ("ERR: ") ));
							if (( ! (global::haxe.lang.Runtime.refEq(test.posInfos, default(object))) )) {
								#line 54 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
								buf.b.Append(((object) (global::Std.@string(global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.getField(test.posInfos, "fileName", 1648581351, true)))) ));
								buf.b.Append(((object) (":") ));
								buf.b.Append(((object) (global::Std.@string(((int) (global::haxe.lang.Runtime.getField_f(test.posInfos, "lineNumber", 1981972957, true)) ))) ));
								buf.b.Append(((object) ("(") ));
								buf.b.Append(((object) (global::Std.@string(global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.getField(test.posInfos, "className", 1547539107, true)))) ));
								buf.b.Append(((object) (".") ));
								buf.b.Append(((object) (global::Std.@string(global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.getField(test.posInfos, "methodName", 302979532, true)))) ));
								buf.b.Append(((object) (") - ") ));
							}
							
							#line 63 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
							buf.b.Append(((object) (global::Std.@string(test.error)) ));
							buf.b.Append(((object) ("\n") ));
							#line 66 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
							if ( ! (string.Equals(test.backtrace, default(string))) ) {
								#line 67 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
								buf.b.Append(((object) (global::Std.@string(test.backtrace)) ));
								buf.b.Append(((object) ("\n") ));
							}
							
							#line 71 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
							buf.b.Append(((object) ("\n") ));
							failures++;
						}
						
					}
					
				}
				
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				buf.b.Append(((object) ("\n") ));
				if (( failures == 0 )) {
					#line 77 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
					buf.b.Append(((object) ("OK ") ));
				}
				 else {
					#line 79 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
					buf.b.Append(((object) ("FAILED ") ));
				}
				
				#line 81 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				buf.b.Append(((object) (global::Std.@string(this.m_tests.length)) ));
				buf.b.Append(((object) (" tests, ") ));
				buf.b.Append(((object) (global::Std.@string(failures)) ));
				buf.b.Append(((object) (" failed, ") ));
				buf.b.Append(((object) (global::Std.@string(( this.m_tests.length - failures ))) ));
				buf.b.Append(((object) (" success") ));
				buf.b.Append(((object) ("\n") ));
				return buf.toString();
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				switch (hash){
					case 944645571:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						this.success = global::haxe.lang.Runtime.toBool(@value);
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return @value;
					}
					
					
					case 1042306895:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						this.m_tests = ((global::List<object>) (global::List<object>.__hx_cast<object>(((global::List) (@value) ))) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return @value;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				switch (hash){
					case 946786476:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("toString") ), ((int) (946786476) ))) );
					}
					
					
					case 4846113:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("add") ), ((int) (4846113) ))) );
					}
					
					
					case 944645571:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return this.success;
					}
					
					
					case 1042306895:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return this.m_tests;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				switch (hash){
					case 946786476:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return this.toString();
					}
					
					
					case 4846113:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						this.@add(((global::haxe.unit.TestStatus) (dynargs[0]) ));
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						break;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				baseArr.push("success");
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				baseArr.push("m_tests");
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
				{
					#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestResult.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
		public override string ToString(){
			return this.toString();
		}
		
		
	}
}


