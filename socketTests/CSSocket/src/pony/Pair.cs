
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony._Pair{
	public sealed class Pair_Impl_ {
		
		
		
		
		public static   object _new<A, B>(A a, B b){
			unchecked {
				#line 39 "C:\\data\\GitHub\\Pony\\pony\\Pair.hx"
				return new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{97, 98}), new global::Array<object>(new object[]{a, b}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
			}
			#line default
		}
		
		
		public static   A get_a<A, B>(object this1){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\Pair.hx"
				return global::haxe.lang.Runtime.genericCast<A>(global::haxe.lang.Runtime.getField(this1, "a", 97, true));
			}
			#line default
		}
		
		
		public static   B get_b<A, B>(object this1){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\Pair.hx"
				return global::haxe.lang.Runtime.genericCast<B>(global::haxe.lang.Runtime.getField(this1, "b", 98, true));
			}
			#line default
		}
		
		
		public static   A set_a<A, B>(object this1, A v){
			unchecked {
				#line 44 "C:\\data\\GitHub\\Pony\\pony\\Pair.hx"
				return global::haxe.lang.Runtime.genericCast<A>(global::haxe.lang.Runtime.setField(this1, "a", 97, v));
			}
			#line default
		}
		
		
		public static   B set_b<A, B>(object this1, B v){
			unchecked {
				#line 45 "C:\\data\\GitHub\\Pony\\pony\\Pair.hx"
				return global::haxe.lang.Runtime.genericCast<B>(global::haxe.lang.Runtime.setField(this1, "b", 98, v));
			}
			#line default
		}
		
		
		public static   object fromObj<A, B>(object o){
			unchecked {
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\Pair.hx"
				return ((object) (o) );
			}
			#line default
		}
		
		
		public static   object toObj<A, B>(object this1){
			unchecked {
				#line 48 "C:\\data\\GitHub\\Pony\\pony\\Pair.hx"
				return this1;
			}
			#line default
		}
		
		
		public static   object array<T>(global::Array<T> a){
			unchecked {
				#line 50 "C:\\data\\GitHub\\Pony\\pony\\Pair.hx"
				return ((object) (new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{97, 98}), new global::Array<object>(new object[]{a[0], a[1]}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}))) );
			}
			#line default
		}
		
		
	}
}


