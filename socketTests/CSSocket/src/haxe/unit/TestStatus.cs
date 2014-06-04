
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.unit{
	public  class TestStatus : global::haxe.lang.HxObject {
		public    TestStatus(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    TestStatus(){
			unchecked {
				#line 36 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				global::haxe.unit.TestStatus.__hx_ctor_haxe_unit_TestStatus(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_unit_TestStatus(global::haxe.unit.TestStatus __temp_me45){
			unchecked {
				#line 37 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				__temp_me45.done = false;
				__temp_me45.success = false;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				return new global::haxe.unit.TestStatus(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				return new global::haxe.unit.TestStatus();
			}
			#line default
		}
		
		
		public  bool done;
		
		public  bool success;
		
		public  string error;
		
		public  string method;
		
		public  string classname;
		
		public  object posInfos;
		
		public  string backtrace;
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				switch (hash){
					case 1512997393:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						this.posInfos = ((object) (@value) );
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return @value;
					}
					
					
					default:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				switch (hash){
					case 1604552446:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						this.backtrace = global::haxe.lang.Runtime.toString(@value);
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return @value;
					}
					
					
					case 1512997393:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						this.posInfos = ((object) (@value) );
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return @value;
					}
					
					
					case 1902405251:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						this.classname = global::haxe.lang.Runtime.toString(@value);
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return @value;
					}
					
					
					case 156956385:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						this.method = global::haxe.lang.Runtime.toString(@value);
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return @value;
					}
					
					
					case 1932118984:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						this.error = global::haxe.lang.Runtime.toString(@value);
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return @value;
					}
					
					
					case 944645571:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						this.success = global::haxe.lang.Runtime.toBool(@value);
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return @value;
					}
					
					
					case 1114501250:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						this.done = global::haxe.lang.Runtime.toBool(@value);
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return @value;
					}
					
					
					default:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				switch (hash){
					case 1604552446:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return this.backtrace;
					}
					
					
					case 1512997393:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return this.posInfos;
					}
					
					
					case 1902405251:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return this.classname;
					}
					
					
					case 156956385:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return this.method;
					}
					
					
					case 1932118984:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return this.error;
					}
					
					
					case 944645571:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return this.success;
					}
					
					
					case 1114501250:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return this.done;
					}
					
					
					default:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				switch (hash){
					case 1512997393:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return ((double) (global::haxe.lang.Runtime.toDouble(this.posInfos)) );
					}
					
					
					default:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				baseArr.push("backtrace");
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				baseArr.push("posInfos");
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				baseArr.push("classname");
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				baseArr.push("method");
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				baseArr.push("error");
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				baseArr.push("success");
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				baseArr.push("done");
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
				{
					#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\unit\\TestStatus.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}


