
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events._Signal1{
	public sealed class Signal1_Impl_ {
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static   global::pony.events.Signal _new<Target, T1>(global::pony.events.Signal s){
			unchecked {
				#line 44 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return s;
			}
			#line default
		}
		
		
		public static   bool get_silent<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 46 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return this1.silent;
			}
			#line default
		}
		
		
		public static   bool set_silent<Target, T1>(global::pony.events.Signal this1, bool b){
			unchecked {
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return this1.silent = b;
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal get_lostListeners<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 49 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return ((global::pony.events.Signal) (this1.lostListeners) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal get_takeListeners<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 50 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return ((global::pony.events.Signal) (this1.takeListeners) );
			}
			#line default
		}
		
		
		public static   bool get_haveListeners<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 51 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return global::haxe.lang.Runtime.toBool( ! ((( this1.listeners.data.length == 0 ))) );
			}
			#line default
		}
		
		
		public static   object get_data<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return this1.data;
			}
			#line default
		}
		
		
		public static   object set_data<Target, T1>(global::pony.events.Signal this1, object d){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return this1.data = d;
			}
			#line default
		}
		
		
		public static   Target get_target<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 55 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   int get_listenersCount<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 56 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return this1.listeners.data.length;
			}
			#line default
		}
		
		
		public static   Target @add<Target, T1>(global::pony.events.Signal this1, object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 58 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				int __temp_priority92 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				this1.@add(((object) (listener) ), new global::haxe.lang.Null<int>(__temp_priority92, true));
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target once<Target, T1>(global::pony.events.Signal this1, object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				int __temp_priority93 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				{
					#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					object listener1 = ((object) (listener) );
					#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					object __temp_stmt432 = default(object);
					#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					{
						#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						object f = global::haxe.lang.Runtime.getField(listener1, "f", 102, true);
						#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						object this2 = default(object);
						#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_getvar202 = f;
							#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							double __temp_ret203 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar202, "used", 1303220797, true)) );
							#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_expr433 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar202, "used", 1303220797, ( __temp_ret203 + 1.0 ))) );
							#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							double __temp_expr434 = __temp_ret203;
						}
						
						#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							bool __temp_odecl430 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "event", 1975830554, true));
							#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							bool __temp_odecl431 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "ignoreReturn", 98429794, true));
							#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							this2 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f, __temp_odecl431, true, default(global::pony.events.Event), __temp_odecl430}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						__temp_stmt432 = this2;
					}
					
					#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					this1.@add(((object) (__temp_stmt432) ), new global::haxe.lang.Null<int>(__temp_priority93, true));
				}
				
				#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target @remove<Target, T1>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 69 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				this1.@remove(((object) (listener) ));
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target changePriority<Target, T1>(global::pony.events.Signal this1, object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 73 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				int __temp_priority94 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				{
					#line 74 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					this1.listeners.changeElement(((object) (listener) ), new global::haxe.lang.Null<int>(__temp_priority94, true));
					#line 74 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal __temp_expr435 = this1;
				}
				
				#line 75 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target dispatch<Target, T1>(global::pony.events.Signal this1, object a){
			unchecked {
				#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					{
						#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						this1.dispatchEvent(new global::pony.events.Event(((global::Array) (new global::Array<T1>(new T1[]{global::haxe.lang.Runtime.genericCast<T1>(a)})) ), ((object) (this1.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) )));
						#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						global::pony.events.Signal __temp_expr436 = this1;
					}
					
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
				}
				
			}
			#line default
		}
		
		
		public static   Target dispatchEvent<Target, T1>(global::pony.events.Signal this1, global::pony.events.Event @event){
			unchecked {
				#line 83 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				this1.dispatchEvent(@event);
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target dispatchArgs<Target, T1>(global::pony.events.Signal this1, global::Array<T1> args){
			unchecked {
				#line 88 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 88 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					this1.dispatchEvent(new global::pony.events.Event(((global::Array) (args) ), ((object) (this1.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) )));
					#line 88 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal __temp_expr437 = this1;
				}
				
				#line 89 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal sub<Target, T1>(global::pony.events.Signal this1, T1 a, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 94 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				int __temp_priority95 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 94 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 94 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal s = this1.subArgs(new global::Array<T1>(new T1[]{a}), new global::haxe.lang.Null<int>(__temp_priority95, true));
					#line 94 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal subArgs<Target, T1>(global::pony.events.Signal this1, global::Array<T1> args, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 96 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				int __temp_priority96 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 96 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 96 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal s = this1.subArgs(args, new global::haxe.lang.Null<int>(__temp_priority96, true));
					#line 96 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
		public static   Target removeSub<Target, T1>(global::pony.events.Signal this1, T1 a){
			unchecked {
				#line 98 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 98 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					this1.removeSubArgs(new global::Array<T1>(new T1[]{a}));
					#line 98 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
				}
				
			}
			#line default
		}
		
		
		public static   Target removeSubArgs<Target, T1>(global::pony.events.Signal this1, global::Array<T1> args){
			unchecked {
				#line 101 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				this1.removeSubArgs(args);
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target removeAllSub<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					if (( this1.subMap != default(global::pony.Dictionary<object, object>) )) {
						#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_iterator204 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.subMap.vs) ))) );
							#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator204, "hasNext", 407283053, default(global::Array)))){
								#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator204, "next", 1224901875, default(global::Array))) );
								#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								e.destroy();
							}
							
						}
						
						#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							global::pony.Dictionary<object, object> _this = this1.subMap;
							#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							_this.ks = new global::Array<object>(new object[]{});
							#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							_this.vs = new global::Array<object>(new object[]{});
						}
						
					}
					
					#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal __temp_expr438 = this1;
				}
				
				#line 107 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target removeAllBind<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					if (( this1.subMap != default(global::pony.Dictionary<object, object>) )) {
						#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_iterator205 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.subMap.vs) ))) );
							#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator205, "hasNext", 407283053, default(global::Array)))){
								#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator205, "next", 1224901875, default(global::Array))) );
								#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								e.destroy();
							}
							
						}
						
						#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							global::pony.Dictionary<object, object> _this = this1.subMap;
							#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							_this.ks = new global::Array<object>(new object[]{});
							#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							_this.vs = new global::Array<object>(new object[]{});
						}
						
					}
					
					#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal __temp_expr439 = this1;
				}
				
				#line 112 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal bind<Target, T1>(global::pony.events.Signal this1, object a, object b, object c, object d, object e, object f, object g){
			unchecked {
				#line 116 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				if (( ! (global::haxe.lang.Runtime.eq(g, default(object))) )) {
					#line 117 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					int priority = 0;
					#line 117 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return this1.bindArgs(new global::Array<object>(new object[]{a, b, c, d, e, f, g}), new global::haxe.lang.Null<int>(priority, true));
				}
				 else {
					#line 118 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					if (( ! (global::haxe.lang.Runtime.eq(f, default(object))) )) {
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						int priority1 = 0;
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						return this1.bindArgs(new global::Array<object>(new object[]{a, b, c, d, e, f}), new global::haxe.lang.Null<int>(priority1, true));
					}
					 else {
						#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						if (( ! (global::haxe.lang.Runtime.eq(e, default(object))) )) {
							#line 121 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							int priority2 = 0;
							#line 121 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							return this1.bindArgs(new global::Array<object>(new object[]{a, b, c, d, e}), new global::haxe.lang.Null<int>(priority2, true));
						}
						 else {
							#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							if (( ! (global::haxe.lang.Runtime.eq(d, default(object))) )) {
								#line 123 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								int priority3 = 0;
								#line 123 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								return this1.bindArgs(new global::Array<object>(new object[]{a, b, c, d}), new global::haxe.lang.Null<int>(priority3, true));
							}
							 else {
								#line 124 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								if (( ! (global::haxe.lang.Runtime.eq(c, default(object))) )) {
									#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
									int priority4 = 0;
									#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
									return this1.bindArgs(new global::Array<object>(new object[]{a, b, c}), new global::haxe.lang.Null<int>(priority4, true));
								}
								 else {
									#line 126 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
									if (( ! (global::haxe.lang.Runtime.eq(b, default(object))) )) {
										#line 127 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
										int priority5 = 0;
										#line 127 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
										return this1.bindArgs(new global::Array<object>(new object[]{a, b}), new global::haxe.lang.Null<int>(priority5, true));
									}
									 else {
										#line 129 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
										int priority6 = 0;
										#line 129 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
										return this1.bindArgs(new global::Array<object>(new object[]{a}), new global::haxe.lang.Null<int>(priority6, true));
									}
									
								}
								
							}
							
						}
						
					}
					
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal bindArgs<Target, T1>(global::pony.events.Signal this1, global::Array args, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 132 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				int __temp_priority97 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 132 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return this1.bindArgs(args, new global::haxe.lang.Null<int>(__temp_priority97, true));
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal bind1<A, Target, T1>(global::pony.events.Signal this1, A a, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 133 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				int __temp_priority98 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 133 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 133 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal s = this1.bindArgs(new global::Array<object>(new object[]{a}), new global::haxe.lang.Null<int>(__temp_priority98, true));
					#line 133 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal and<Target, T1>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 136 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return ((global::pony.events.Signal) (this1.and(s)) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal and0<Target, T1>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 137 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 137 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 137 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal and1<A, Target, T1>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 138 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 138 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 138 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal or<Target, T1>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 140 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 140 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal s1 = this1.or(((global::pony.events.Signal) (s) ));
					#line 140 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (s1) );
				}
				
			}
			#line default
		}
		
		
		public static   Target removeAllListeners<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 143 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				this1.removeAllListeners();
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target sw<Target, T1>(global::pony.events.Signal this1, object l1, object l2){
			unchecked {
				#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					object listener = ((object) (l1) );
					#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					int priority = 0;
					#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					object __temp_stmt444 = default(object);
					#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					{
						#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						object f = global::haxe.lang.Runtime.getField(listener, "f", 102, true);
						#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						object this2 = default(object);
						#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_getvar206 = f;
							#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							double __temp_ret207 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar206, "used", 1303220797, true)) );
							#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_expr445 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar206, "used", 1303220797, ( __temp_ret207 + 1.0 ))) );
							#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							double __temp_expr446 = __temp_ret207;
						}
						
						#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							bool __temp_odecl440 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "event", 1975830554, true));
							#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							bool __temp_odecl441 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "ignoreReturn", 98429794, true));
							#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							this2 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f, __temp_odecl441, true, default(global::pony.events.Event), __temp_odecl440}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						__temp_stmt444 = this2;
					}
					
					#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					this1.@add(((object) (__temp_stmt444) ), new global::haxe.lang.Null<int>(priority, true));
				}
				
				#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					object listener1 = default(object);
					#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					{
						#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						global::haxe.lang.Function __temp_stmt447 = default(global::haxe.lang.Function);
						#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							global::Array<object> f2 = new global::Array<object>(new object[]{((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this1) ), ((string) ("sw") ), ((int) (25764) ))) )});
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							global::Array<object> l11 = new global::Array<object>(new object[]{((object) (l2) )});
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							global::Array<object> l21 = new global::Array<object>(new object[]{((object) (l1) )});
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							__temp_stmt447 = new global::pony.events._Signal1.Signal1_Impl__sw_149__Fun(((global::Array<object>) (l11) ), ((global::Array<object>) (f2) ), ((global::Array<object>) (l21) ));
						}
						
						#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						object f1 = global::pony._Function.Function_Impl_.@from(__temp_stmt447, 0);
						#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						listener1 = global::pony.events._Listener.Listener_Impl_._fromFunction(f1, false);
					}
					
					#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					int priority1 = 0;
					#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					object __temp_stmt448 = default(object);
					#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					{
						#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						object f3 = global::haxe.lang.Runtime.getField(listener1, "f", 102, true);
						#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						object this3 = default(object);
						#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_getvar208 = f3;
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							double __temp_ret209 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar208, "used", 1303220797, true)) );
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_expr449 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar208, "used", 1303220797, ( __temp_ret209 + 1.0 ))) );
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							double __temp_expr450 = __temp_ret209;
						}
						
						#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							bool __temp_odecl442 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "event", 1975830554, true));
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							bool __temp_odecl443 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "ignoreReturn", 98429794, true));
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							this3 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f3, __temp_odecl443, true, default(global::pony.events.Event), __temp_odecl442}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						__temp_stmt448 = this3;
					}
					
					#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					this1.@add(((object) (__temp_stmt448) ), new global::haxe.lang.Null<int>(priority1, true));
				}
				
				#line 150 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target destroy<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					if (( this1.parent != default(global::pony.events.Signal) )) {
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						this1.parent.removeSubSignal(this1);
					}
					
					#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					{
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						if (( this1.subMap != default(global::pony.Dictionary<object, object>) )) {
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							{
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								object __temp_iterator210 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.subMap.vs) ))) );
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator210, "hasNext", 407283053, default(global::Array)))){
									#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
									global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator210, "next", 1224901875, default(global::Array))) );
									#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
									e.destroy();
								}
								
							}
							
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							{
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								global::pony.Dictionary<object, object> _this = this1.subMap;
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								_this.ks = new global::Array<object>(new object[]{});
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								_this.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						global::pony.events.Signal __temp_expr451 = this1;
					}
					
					#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					{
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						if (( this1.bindMap != default(global::pony.Dictionary<object, object>) )) {
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							{
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								object __temp_iterator211 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.bindMap.vs) ))) );
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator211, "hasNext", 407283053, default(global::Array)))){
									#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
									global::pony.events.Signal e1 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator211, "next", 1224901875, default(global::Array))) );
									#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
									e1.destroy();
								}
								
							}
							
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							{
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								global::pony.Dictionary<object, object> _this1 = this1.bindMap;
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								_this1.ks = new global::Array<object>(new object[]{});
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								_this1.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						global::pony.events.Signal __temp_expr452 = this1;
					}
					
					#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					{
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						if (( this1.notMap != default(global::pony.Dictionary<object, object>) )) {
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							{
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								object __temp_iterator212 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this1.notMap.vs) ))) );
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator212, "hasNext", 407283053, default(global::Array)))){
									#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
									global::pony.events.Signal e2 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator212, "next", 1224901875, default(global::Array))) );
									#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
									e2.destroy();
								}
								
							}
							
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							{
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								global::pony.Dictionary<object, object> _this2 = this1.notMap;
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								_this2.ks = new global::Array<object>(new object[]{});
								#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
								_this2.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						global::pony.events.Signal __temp_expr453 = this1;
					}
					
					#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					this1.removeAllListeners();
					#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					if (( this1.takeListeners != default(global::pony.events.Signal) )) {
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							global::pony.events.Signal this2 = this1.takeListeners;
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							this2.destroy();
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_expr454 = this2.target;
						}
						
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						this1.takeListeners = default(global::pony.events.Signal);
					}
					
					#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					if (( this1.lostListeners != default(global::pony.events.Signal) )) {
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						{
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							global::pony.events.Signal this3 = this1.lostListeners;
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							this3.destroy();
							#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
							object __temp_expr455 = this3.target;
						}
						
						#line 154 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
						this1.lostListeners = default(global::pony.events.Signal);
					}
					
				}
				
				#line 155 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   void enableSilent<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 158 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				this1.silent = true;
			}
			#line default
		}
		
		
		public static   void disableSilent<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 159 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				this1.silent = false;
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal @from<A, B>(global::pony.events.Signal s){
			unchecked {
				#line 161 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return ((global::pony.events.Signal) (s) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal to<Target, T1>(global::pony.events.Signal this1){
			unchecked {
				#line 162 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return this1;
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_add<Target, T1>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 167 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				global::pony.events._Signal1.Signal1_Impl_.@add<Target, object>(this1, listener, default(global::haxe.lang.Null<int>));
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_once<Target, T1>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 172 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				global::pony.events._Signal1.Signal1_Impl_.once<Target, object>(this1, listener, default(global::haxe.lang.Null<int>));
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_remove<Target, T1>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 177 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				global::pony.events._Signal1.Signal1_Impl_.@remove<Target, T1>(this1, listener);
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_and0<Target, T1>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 181 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 181 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 181 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_and1<A, Target, T1>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 182 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 182 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 182 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_or<Target, T1>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 184 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 184 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal s1 = this1.or(((global::pony.events.Signal) (s) ));
					#line 184 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (s1) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_bind<A, Target, T1>(global::pony.events.Signal this1, A a){
			unchecked {
				#line 186 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 186 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					int priority = 0;
					#line 186 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal s = this1.bindArgs(new global::Array<object>(new object[]{a}), new global::haxe.lang.Null<int>(priority, true));
					#line 186 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_sub<Target, T1>(global::pony.events.Signal this1, T1 a){
			unchecked {
				#line 187 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				{
					#line 187 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					int priority = 0;
					#line 187 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					global::pony.events.Signal s = this1.subArgs(new global::Array<T1>(new T1[]{a}), new global::haxe.lang.Null<int>(priority, true));
					#line 187 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events._Signal1{
	public  class Signal1_Impl__sw_149__Fun : global::haxe.lang.Function {
		public    Signal1_Impl__sw_149__Fun(global::Array<object> l11, global::Array<object> f2, global::Array<object> l21) : base(0, 0){
			unchecked {
				#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				this.l11 = l11;
				#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				this.f2 = f2;
				#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				this.l21 = l21;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal1.hx"
				return ((global::pony.events.Signal) (((global::haxe.lang.Function) (this.f2[0]) ).__hx_invoke3_o(default(double), this.l11[0], default(double), this.l21[0], default(double), default(object))) );
			}
			#line default
		}
		
		
		public  global::Array<object> l11;
		
		public  global::Array<object> f2;
		
		public  global::Array<object> l21;
		
	}
}


