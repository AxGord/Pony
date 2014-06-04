
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events._Listener0{
	public sealed class Listener0_Impl_ {
		public static   object _new<Target>(object l){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				return l;
			}
			#line default
		}
		
		
		public static   object from0(global::haxe.lang.Function f){
			unchecked {
				#line 36 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				{
					#line 36 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					object l = default(object);
					#line 36 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					{
						#line 36 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
						object f1 = global::pony._Function.Function_Impl_.@from(f, 0);
						#line 36 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
						l = global::pony.events._Listener.Listener_Impl_._fromFunction(f1, false);
					}
					
					#line 36 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					return l;
				}
				
			}
			#line default
		}
		
		
		public static   object fromE(global::haxe.lang.Function f){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				{
					#line 37 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					object l = global::pony.events._Listener.Listener_Impl_._fromFunction(global::pony._Function.Function_Impl_.@from(f, 1), true);
					#line 37 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					return l;
				}
				
			}
			#line default
		}
		
		
		public static   object from0T<T>(global::haxe.lang.Function f){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				{
					#line 38 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					object l = default(object);
					#line 38 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
						object f1 = global::pony._Function.Function_Impl_.@from(f, 1);
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
						l = global::pony.events._Listener.Listener_Impl_._fromFunction(f1, false);
					}
					
					#line 38 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					return l;
				}
				
			}
			#line default
		}
		
		
		public static   object fromTE<T>(global::haxe.lang.Function f){
			unchecked {
				#line 39 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				{
					#line 39 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					object l = default(object);
					#line 39 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					{
						#line 39 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
						object f1 = global::pony._Function.Function_Impl_.@from(f, 2);
						#line 39 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
						l = global::pony.events._Listener.Listener_Impl_._fromFunction(f1, false);
					}
					
					#line 39 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					return l;
				}
				
			}
			#line default
		}
		
		
		public static   object to<Target>(object this1){
			unchecked {
				#line 40 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				return this1;
			}
			#line default
		}
		
		
		public static   object fromSignal0<A>(global::pony.events.Signal s){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				object __temp_stmt345 = default(object);
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				{
					#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					global::haxe.lang.Function __temp_stmt347 = default(global::haxe.lang.Function);
					#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
						global::Array<object> _e = new global::Array<object>(new object[]{s});
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
						__temp_stmt347 = new global::pony.events._Listener0.Listener0_Impl__fromSignal0_42__Fun<A>(((global::Array<object>) (_e) ));
					}
					
					#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					object __temp_stmt346 = global::pony._Function.Function_Impl_.@from(__temp_stmt347, 1);
					#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					object l = global::pony.events._Listener.Listener_Impl_._fromFunction(__temp_stmt346, true);
					#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
					__temp_stmt345 = l;
				}
				
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				return ((object) (__temp_stmt345) );
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events._Listener0{
	public  class Listener0_Impl__fromSignal0_42__Fun<A> : global::haxe.lang.Function {
		public    Listener0_Impl__fromSignal0_42__Fun(global::Array<object> _e) : base(1, 0){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				this._e = _e;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				global::pony.events.Event @event = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.events.Event) (((object) (__fn_float1) )) )) : (((global::pony.events.Event) (__fn_dyn1) )) );
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Listener0.hx"
				return global::pony.events._Signal0.Signal0_Impl_.dispatchEvent<A>(((global::pony.events.Signal) (this._e[0]) ), @event);
			}
			#line default
		}
		
		
		public  global::Array<object> _e;
		
	}
}


