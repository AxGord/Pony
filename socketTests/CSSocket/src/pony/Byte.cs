
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony._Byte{
	public sealed class Byte_Impl_ {
		
		
		
		
		public static   int get_a(int this1){
			unchecked {
				#line 39 "C:\\data\\GitHub\\Pony\\pony\\Byte.hx"
				return ( this1 >> 4 );
			}
			#line default
		}
		
		
		public static   int get_b(int this1){
			unchecked {
				#line 40 "C:\\data\\GitHub\\Pony\\pony\\Byte.hx"
				return ( this1 & 15 );
			}
			#line default
		}
		
		
		public static   int create(int a, int b){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\Byte.hx"
				return ( (( a << 4 )) + b );
			}
			#line default
		}
		
		
		public static   int chechSumWith(int this1, int b){
			unchecked {
				#line 44 "C:\\data\\GitHub\\Pony\\pony\\Byte.hx"
				return ( ( this1 + ((int) (b) ) ) & 255 );
			}
			#line default
		}
		
		
		public static   string toString(int this1){
			unchecked {
				#line 46 "C:\\data\\GitHub\\Pony\\pony\\Byte.hx"
				return global::haxe.lang.Runtime.concat("0x", global::StringTools.hex(this1, default(global::haxe.lang.Null<int>)));
			}
			#line default
		}
		
		
	}
}


