
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events._Signal2{
	public sealed class Signal2_Impl_ {
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static   global::pony.events.Signal _new<Target, T1, T2>(global::pony.events.Signal s){
			unchecked {
				#line 45 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return s;
			}
			#line default
		}
		
		
		public static   bool get_silent<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return this1.silent;
			}
			#line default
		}
		
		
		public static   bool set_silent<Target, T1, T2>(global::pony.events.Signal this1, bool b){
			unchecked {
				#line 48 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return this1.silent = b;
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal get_lostListeners<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 50 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return ((global::pony.events.Signal) (this1.lostListeners) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal get_takeListeners<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 51 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return ((global::pony.events.Signal) (this1.takeListeners) );
			}
			#line default
		}
		
		
		public static   bool get_haveListeners<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 52 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return global::haxe.lang.Runtime.toBool( ! ((( this1.listeners.data.length == 0 ))) );
			}
			#line default
		}
		
		
		public static   object get_data<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return this1.data;
			}
			#line default
		}
		
		
		public static   object set_data<Target, T1, T2>(global::pony.events.Signal this1, object d){
			unchecked {
				#line 55 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return this1.data = d;
			}
			#line default
		}
		
		
		public static   Target get_target<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 56 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   int get_listenersCount<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 57 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return this1.listeners.data.length;
			}
			#line default
		}
		
		
		public static   Target @add<Target, T1, T2>(global::pony.events.Signal this1, object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 59 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				int __temp_priority99 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				this1.@add(((object) (listener) ), new global::haxe.lang.Null<int>(__temp_priority99, true));
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target once<Target, T1, T2>(global::pony.events.Signal this1, object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				int __temp_priority100 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				{
					#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					object listener1 = ((object) (listener) );
					#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					object __temp_stmt457 = default(object);
					#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					{
						#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						object f = global::haxe.lang.Runtime.getField(listener1, "f", 102, true);
						#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						object this2 = default(object);
						#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							object __temp_getvar213 = f;
							#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							double __temp_ret214 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar213, "used", 1303220797, true)) );
							#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							object __temp_expr458 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar213, "used", 1303220797, ( __temp_ret214 + 1.0 ))) );
							#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							double __temp_expr459 = __temp_ret214;
						}
						
						#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							bool __temp_odecl455 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "event", 1975830554, true));
							#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							bool __temp_odecl456 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "ignoreReturn", 98429794, true));
							#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							this2 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f, __temp_odecl456, true, default(global::pony.events.Event), __temp_odecl455}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						__temp_stmt457 = this2;
					}
					
					#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					this1.@add(((object) (__temp_stmt457) ), new global::haxe.lang.Null<int>(__temp_priority100, true));
				}
				
				#line 66 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target @remove<Target, T1, T2>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 70 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				this1.@remove(((object) (listener) ));
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target changePriority<Target, T1, T2>(global::pony.events.Signal this1, object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 74 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				int __temp_priority101 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				{
					#line 75 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					this1.listeners.changeElement(((object) (listener) ), new global::haxe.lang.Null<int>(__temp_priority101, true));
					#line 75 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					global::pony.events.Signal __temp_expr460 = this1;
				}
				
				#line 76 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target dispatch<Target, T1, T2>(global::pony.events.Signal this1, object a, object b){
			unchecked {
				#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					{
						#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						this1.dispatchEvent(new global::pony.events.Event(((global::Array) (new global::Array<object>(new object[]{a, b})) ), ((object) (this1.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) )));
						#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						global::pony.events.Signal __temp_expr461 = this1;
					}
					
					#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
				}
				
			}
			#line default
		}
		
		
		public static   Target dispatchEvent<Target, T1, T2>(global::pony.events.Signal this1, global::pony.events.Event @event){
			unchecked {
				#line 85 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				this1.dispatchEvent(@event);
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target dispatchArgs<Target, T1, T2>(global::pony.events.Signal this1, global::Array args){
			unchecked {
				#line 90 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 90 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					this1.dispatchEvent(new global::pony.events.Event(((global::Array) (args) ), ((object) (this1.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) )));
					#line 90 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					global::pony.events.Signal __temp_expr462 = this1;
				}
				
				#line 91 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal sub<Target, T1, T2>(global::pony.events.Signal this1, T1 a, T2 b, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 94 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				int __temp_priority102 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 94 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return this1.subArgs(( (global::haxe.lang.Runtime.eq(b, default(T2))) ? (new global::Array<object>(new object[]{a})) : (new global::Array<object>(new object[]{a, b})) ), new global::haxe.lang.Null<int>(__temp_priority102, true));
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal sub1<Target, T1, T2>(global::pony.events.Signal this1, T1 a, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 96 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				int __temp_priority103 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 96 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 96 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					global::pony.events.Signal s = this1.subArgs(new global::Array<object>(new object[]{a}), new global::haxe.lang.Null<int>(__temp_priority103, true));
					#line 96 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal sub2<Target, T1, T2>(global::pony.events.Signal this1, T1 a, T2 b, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 97 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				int __temp_priority104 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 97 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 97 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					global::pony.events.Signal s = this1.subArgs(new global::Array<object>(new object[]{a, b}), new global::haxe.lang.Null<int>(__temp_priority104, true));
					#line 97 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal subArgs<Target, T1, T2>(global::pony.events.Signal this1, global::Array args, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 99 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				int __temp_priority105 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 99 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return this1.subArgs(args, new global::haxe.lang.Null<int>(__temp_priority105, true));
			}
			#line default
		}
		
		
		public static   Target removeSub<Target, T1, T2>(global::pony.events.Signal this1, T1 a, T2 b){
			unchecked {
				#line 101 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 101 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					this1.removeSubArgs(( (global::haxe.lang.Runtime.eq(b, default(T2))) ? (new global::Array<object>(new object[]{a})) : (new global::Array<object>(new object[]{a, b})) ));
					#line 101 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
				}
				
			}
			#line default
		}
		
		
		public static   Target removeSubArgs<Target, T1, T2>(global::pony.events.Signal this1, global::Array args){
			unchecked {
				#line 104 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				this1.removeSubArgs(args);
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target removeAllSub<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					if (( this1.subMap != default(global::pony.Dictionary<object, object>) )) {
						#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							object __temp_iterator215 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.subMap.vs) ))) );
							#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator215, "hasNext", 407283053, default(global::Array)))){
								#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator215, "next", 1224901875, default(global::Array))) );
								#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								e.destroy();
							}
							
						}
						
						#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							global::pony.Dictionary<object, object> _this = this1.subMap;
							#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							_this.ks = new global::Array<object>(new object[]{});
							#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							_this.vs = new global::Array<object>(new object[]{});
						}
						
					}
					
					#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					global::pony.events.Signal __temp_expr463 = this1;
				}
				
				#line 110 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target removeAllListeners<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 114 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				this1.removeAllListeners();
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target sw<Target, T1, T2>(global::pony.events.Signal this1, object l1, object l2){
			unchecked {
				#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					object listener = ((object) (l1) );
					#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					int priority = 0;
					#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					object __temp_stmt468 = default(object);
					#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					{
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						object f = global::haxe.lang.Runtime.getField(listener, "f", 102, true);
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						object this2 = default(object);
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							object __temp_getvar216 = f;
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							double __temp_ret217 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar216, "used", 1303220797, true)) );
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							object __temp_expr469 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar216, "used", 1303220797, ( __temp_ret217 + 1.0 ))) );
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							double __temp_expr470 = __temp_ret217;
						}
						
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							bool __temp_odecl464 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "event", 1975830554, true));
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							bool __temp_odecl465 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "ignoreReturn", 98429794, true));
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							this2 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f, __temp_odecl465, true, default(global::pony.events.Event), __temp_odecl464}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						__temp_stmt468 = this2;
					}
					
					#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					this1.@add(((object) (__temp_stmt468) ), new global::haxe.lang.Null<int>(priority, true));
				}
				
				#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					object listener1 = default(object);
					#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					{
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						global::haxe.lang.Function __temp_stmt471 = default(global::haxe.lang.Function);
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							global::Array<object> f2 = new global::Array<object>(new object[]{((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this1) ), ((string) ("sw") ), ((int) (25764) ))) )});
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							global::Array<object> l11 = new global::Array<object>(new object[]{((object) (l2) )});
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							global::Array<object> l21 = new global::Array<object>(new object[]{((object) (l1) )});
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							__temp_stmt471 = new global::pony.events._Signal2.Signal2_Impl__sw_120__Fun(((global::Array<object>) (l11) ), ((global::Array<object>) (f2) ), ((global::Array<object>) (l21) ));
						}
						
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						object f1 = global::pony._Function.Function_Impl_.@from(__temp_stmt471, 0);
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						listener1 = global::pony.events._Listener.Listener_Impl_._fromFunction(f1, false);
					}
					
					#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					int priority1 = 0;
					#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					object __temp_stmt472 = default(object);
					#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					{
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						object f3 = global::haxe.lang.Runtime.getField(listener1, "f", 102, true);
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						object this3 = default(object);
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							object __temp_getvar218 = f3;
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							double __temp_ret219 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar218, "used", 1303220797, true)) );
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							object __temp_expr473 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar218, "used", 1303220797, ( __temp_ret219 + 1.0 ))) );
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							double __temp_expr474 = __temp_ret219;
						}
						
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							bool __temp_odecl466 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "event", 1975830554, true));
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							bool __temp_odecl467 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "ignoreReturn", 98429794, true));
							#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							this3 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f3, __temp_odecl467, true, default(global::pony.events.Event), __temp_odecl466}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						__temp_stmt472 = this3;
					}
					
					#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					this1.@add(((object) (__temp_stmt472) ), new global::haxe.lang.Null<int>(priority1, true));
				}
				
				#line 121 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target destroy<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					if (( this1.parent != default(global::pony.events.Signal) )) {
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						this1.parent.removeSubSignal(this1);
					}
					
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					{
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						if (( this1.subMap != default(global::pony.Dictionary<object, object>) )) {
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							{
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								object __temp_iterator220 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.subMap.vs) ))) );
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator220, "hasNext", 407283053, default(global::Array)))){
									#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
									global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator220, "next", 1224901875, default(global::Array))) );
									#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
									e.destroy();
								}
								
							}
							
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							{
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								global::pony.Dictionary<object, object> _this = this1.subMap;
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								_this.ks = new global::Array<object>(new object[]{});
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								_this.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						global::pony.events.Signal __temp_expr475 = this1;
					}
					
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					{
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						if (( this1.bindMap != default(global::pony.Dictionary<object, object>) )) {
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							{
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								object __temp_iterator221 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.bindMap.vs) ))) );
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator221, "hasNext", 407283053, default(global::Array)))){
									#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
									global::pony.events.Signal e1 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator221, "next", 1224901875, default(global::Array))) );
									#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
									e1.destroy();
								}
								
							}
							
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							{
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								global::pony.Dictionary<object, object> _this1 = this1.bindMap;
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								_this1.ks = new global::Array<object>(new object[]{});
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								_this1.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						global::pony.events.Signal __temp_expr476 = this1;
					}
					
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					{
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						if (( this1.notMap != default(global::pony.Dictionary<object, object>) )) {
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							{
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								object __temp_iterator222 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.notMap.vs) ))) );
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator222, "hasNext", 407283053, default(global::Array)))){
									#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
									global::pony.events.Signal e2 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator222, "next", 1224901875, default(global::Array))) );
									#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
									e2.destroy();
								}
								
							}
							
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							{
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								global::pony.Dictionary<object, object> _this2 = this1.notMap;
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								_this2.ks = new global::Array<object>(new object[]{});
								#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
								_this2.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						global::pony.events.Signal __temp_expr477 = this1;
					}
					
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					this1.removeAllListeners();
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					if (( this1.takeListeners != default(global::pony.events.Signal) )) {
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							global::pony.events.Signal this2 = this1.takeListeners;
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							this2.destroy();
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							object __temp_expr478 = this2.target;
						}
						
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						this1.takeListeners = default(global::pony.events.Signal);
					}
					
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					if (( this1.lostListeners != default(global::pony.events.Signal) )) {
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						{
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							global::pony.events.Signal this3 = this1.lostListeners;
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							this3.destroy();
							#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
							object __temp_expr479 = this3.target;
						}
						
						#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
						this1.lostListeners = default(global::pony.events.Signal);
					}
					
				}
				
				#line 126 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   void enableSilent<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 129 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				this1.silent = true;
			}
			#line default
		}
		
		
		public static   void disableSilent<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 130 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				this1.silent = false;
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal @from<A, B, C>(global::pony.events.Signal s){
			unchecked {
				#line 132 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return ((global::pony.events.Signal) (s) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal to<Target, T1, T2>(global::pony.events.Signal this1){
			unchecked {
				#line 133 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return this1;
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_add<Target, T1, T2>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 138 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				global::pony.events._Signal2.Signal2_Impl_.@add<Target, object, object>(this1, listener, default(global::haxe.lang.Null<int>));
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_once<Target, T1, T2>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 143 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				global::pony.events._Signal2.Signal2_Impl_.once<Target, object, object>(this1, listener, default(global::haxe.lang.Null<int>));
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_remove<Target, T1, T2>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				global::pony.events._Signal2.Signal2_Impl_.@remove<Target, T1, T2>(this1, listener);
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_sub<Target, T1, T2>(global::pony.events.Signal this1, T1 a){
			unchecked {
				#line 152 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				{
					#line 152 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					int priority = 0;
					#line 152 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					global::pony.events.Signal s = this1.subArgs(new global::Array<object>(new object[]{a}), new global::haxe.lang.Null<int>(priority, true));
					#line 152 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events._Signal2{
	public  class Signal2_Impl__sw_120__Fun : global::haxe.lang.Function {
		public    Signal2_Impl__sw_120__Fun(global::Array<object> l11, global::Array<object> f2, global::Array<object> l21) : base(0, 0){
			unchecked {
				#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				this.l11 = l11;
				#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				this.f2 = f2;
				#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				this.l21 = l21;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal2.hx"
				return ((global::pony.events.Signal) (((global::haxe.lang.Function) (this.f2[0]) ).__hx_invoke3_o(default(double), this.l11[0], default(double), this.l21[0], default(double), default(object))) );
			}
			#line default
		}
		
		
		public  global::Array<object> l11;
		
		public  global::Array<object> f2;
		
		public  global::Array<object> l21;
		
	}
}


