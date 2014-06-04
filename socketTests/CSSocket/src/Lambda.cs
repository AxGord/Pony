
#pragma warning disable 109, 114, 219, 429, 168, 162
public  class Lambda : global::haxe.lang.HxObject {
	public    Lambda(global::haxe.lang.EmptyObject empty){
		unchecked {
			#line 35 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public    Lambda(){
		unchecked {
			#line 35 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
			global::Lambda.__hx_ctor__Lambda(this);
		}
		#line default
	}
	
	
	public static   void __hx_ctor__Lambda(global::Lambda __temp_me7){
		unchecked {
			#line 35 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public static   bool exists<A>(object it, global::haxe.lang.Function f){
		unchecked {
			#line 116 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
			{
				#line 116 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
				object __temp_iterator117 = ((object) (global::haxe.lang.Runtime.callField(it, "iterator", 328878574, default(global::Array))) );
				#line 116 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
				while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator117, "hasNext", 407283053, default(global::Array)))){
					#line 116 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
					A x = global::haxe.lang.Runtime.genericCast<A>(global::haxe.lang.Runtime.callField(__temp_iterator117, "next", 1224901875, default(global::Array)));
					if (global::haxe.lang.Runtime.toBool(f.__hx_invoke1_o(default(double), x))) {
						#line 118 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
						return true;
					}
					
				}
				
			}
			
			#line 119 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
			return false;
		}
		#line default
	}
	
	
	public static   int indexOf<T>(object it, T v){
		unchecked {
			#line 218 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
			int i = 0;
			{
				#line 219 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
				object __temp_iterator118 = ((object) (global::haxe.lang.Runtime.callField(it, "iterator", 328878574, default(global::Array))) );
				#line 219 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
				while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator118, "hasNext", 407283053, default(global::Array)))){
					#line 219 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
					T v2 = global::haxe.lang.Runtime.genericCast<T>(global::haxe.lang.Runtime.callField(__temp_iterator118, "next", 1224901875, default(global::Array)));
					if (global::haxe.lang.Runtime.eq(v, v2)) {
						#line 221 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
						return i;
					}
					
					#line 222 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
					i++;
				}
				
			}
			
			#line 224 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
			return -1;
		}
		#line default
	}
	
	
	public static  new object __hx_createEmpty(){
		unchecked {
			#line 35 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
			return new global::Lambda(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
		}
		#line default
	}
	
	
	public static  new object __hx_create(global::Array arr){
		unchecked {
			#line 35 "C:\\HaxeToolkit\\haxe\\std\\Lambda.hx"
			return new global::Lambda();
		}
		#line default
	}
	
	
}


