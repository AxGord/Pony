
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony._KeyValue{
	public sealed class KeyValue_Impl_ {
		
		
		
		
		public static   object _new<Key, Value>(object p){
			unchecked {
				#line 39 "C:\\data\\GitHub\\Pony\\pony\\KeyValue.hx"
				return p;
			}
			#line default
		}
		
		
		public static   Key get_key<Key, Value>(object this1){
			unchecked {
				#line 40 "C:\\data\\GitHub\\Pony\\pony\\KeyValue.hx"
				return global::haxe.lang.Runtime.genericCast<Key>(global::haxe.lang.Runtime.getField(this1, "a", 97, true));
			}
			#line default
		}
		
		
		public static   Value get_value<Key, Value>(object this1){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\KeyValue.hx"
				return global::haxe.lang.Runtime.genericCast<Value>(global::haxe.lang.Runtime.getField(this1, "b", 98, true));
			}
			#line default
		}
		
		
		public static   object fromPair<A, B>(object p){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\KeyValue.hx"
				return ((object) (p) );
			}
			#line default
		}
		
		
		public static   object toPair<Key, Value>(object this1){
			unchecked {
				#line 44 "C:\\data\\GitHub\\Pony\\pony\\KeyValue.hx"
				return this1;
			}
			#line default
		}
		
		
	}
}


