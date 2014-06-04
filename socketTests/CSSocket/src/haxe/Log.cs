
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe{
	public  class Log : global::haxe.lang.HxObject {
		static Log() {
			#line 29 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
			global::haxe.Log.trace = ( (( global::haxe.Log_new_29__Fun.__hx_current != default(global::haxe.Log_new_29__Fun) )) ? (global::haxe.Log_new_29__Fun.__hx_current) : (global::haxe.Log_new_29__Fun.__hx_current = ((global::haxe.Log_new_29__Fun) (new global::haxe.Log_new_29__Fun()) )) );
			#line 58 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
			global::haxe.Log.clear = ( (( global::haxe.Log_new_58__Fun.__hx_current != default(global::haxe.Log_new_58__Fun) )) ? (global::haxe.Log_new_58__Fun.__hx_current) : (global::haxe.Log_new_58__Fun.__hx_current = ((global::haxe.Log_new_58__Fun) (new global::haxe.Log_new_58__Fun()) )) );
		}
		public    Log(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Log(){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				global::haxe.Log.__hx_ctor_haxe_Log(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_Log(global::haxe.Log __temp_me27){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public static  global::haxe.lang.Function trace;
		
		public static  global::haxe.lang.Function clear;
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				return new global::haxe.Log(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				return new global::haxe.Log();
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe{
	public  class Log_new_29__Fun : global::haxe.lang.Function {
		public    Log_new_29__Fun() : base(2, 0){
			unchecked {
			}
			#line default
		}
		
		
		public static  global::haxe.Log_new_29__Fun __hx_current;
		
		public override   object __hx_invoke2_o(double __fn_float1, object __fn_dyn1, double __fn_float2, object __fn_dyn2){
			unchecked {
				#line 29 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				object infos = ( (global::haxe.lang.Runtime.eq(__fn_dyn2, global::haxe.lang.Runtime.undefined)) ? (((object) (__fn_float2) )) : (( (global::haxe.lang.Runtime.eq(__fn_dyn2, default(object))) ? (default(object)) : (((object) (__fn_dyn2) )) )) );
				#line 29 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				object v = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((object) (__fn_float1) )) : (((object) (__fn_dyn1) )) );
				#line 46 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				string str = default(string);
				#line 46 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				str = global::haxe.lang.Runtime.concat((( (( ! (global::haxe.lang.Runtime.refEq(infos, default(object))) )) ? (global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.getField(infos, "fileName", 1648581351, true)), ":"), global::haxe.lang.Runtime.toString(((int) (global::haxe.lang.Runtime.getField_f(infos, "lineNumber", 1981972957, true)) ))), ": ")) : ("") )), global::Std.@string(v));
				#line 50 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				System.Console.WriteLine(str);
				#line 29 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				return default(object);
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe{
	public  class Log_new_58__Fun : global::haxe.lang.Function {
		public    Log_new_58__Fun() : base(0, 0){
			unchecked {
			}
			#line default
		}
		
		
		public static  global::haxe.Log_new_58__Fun __hx_current;
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 58 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				{
				}
				
				#line 58 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Log.hx"
				return default(object);
			}
			#line default
		}
		
		
	}
}


