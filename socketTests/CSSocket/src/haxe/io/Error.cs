
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.io{
	public  class Error : global::haxe.lang.Enum {
		static Error() {
			#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Error.hx"
			global::haxe.io.Error.constructs = new global::Array<object>(new object[]{"Blocked", "Overflow", "OutsideBounds", "Custom"});
			#line 29 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Error.hx"
			global::haxe.io.Error.Blocked = new global::haxe.io.Error(((int) (0) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
			#line 31 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Error.hx"
			global::haxe.io.Error.Overflow = new global::haxe.io.Error(((int) (1) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
			#line 33 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Error.hx"
			global::haxe.io.Error.OutsideBounds = new global::haxe.io.Error(((int) (2) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
		}
		public    Error(global::haxe.lang.EmptyObject empty) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
			}
			#line default
		}
		
		
		public    Error(int index, global::Array<object> @params) : base(index, @params){
			unchecked {
			}
			#line default
		}
		
		
		public static  global::Array<object> constructs;
		
		public static  global::haxe.io.Error Blocked;
		
		public static  global::haxe.io.Error Overflow;
		
		public static  global::haxe.io.Error OutsideBounds;
		
		public static   global::haxe.io.Error Custom(object e){
			unchecked {
				#line 35 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Error.hx"
				return new global::haxe.io.Error(((int) (3) ), ((global::Array<object>) (new global::Array<object>(new object[]{e})) ));
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Error.hx"
				return new global::haxe.io.Error(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Error.hx"
				return new global::haxe.io.Error(((int) (global::haxe.lang.Runtime.toInt(arr[0])) ), ((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (arr[1]) ))) ));
			}
			#line default
		}
		
		
	}
}


