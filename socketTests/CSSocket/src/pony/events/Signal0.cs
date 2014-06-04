
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events._Signal0{
	public sealed class Signal0_Impl_ {
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static   global::pony.events.Signal _new<Target>(global::pony.events.Signal s){
			unchecked {
				#line 43 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return s;
			}
			#line default
		}
		
		
		public static   bool get_silent<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 45 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return this1.silent;
			}
			#line default
		}
		
		
		public static   bool set_silent<Target>(global::pony.events.Signal this1, bool b){
			unchecked {
				#line 46 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return this1.silent = b;
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal get_lostListeners<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 48 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return ((global::pony.events.Signal) (this1.lostListeners) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal get_takeListeners<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 49 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return ((global::pony.events.Signal) (this1.takeListeners) );
			}
			#line default
		}
		
		
		public static   bool get_haveListeners<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 50 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return global::haxe.lang.Runtime.toBool( ! ((( this1.listeners.data.length == 0 ))) );
			}
			#line default
		}
		
		
		public static   object get_data<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 52 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return this1.data;
			}
			#line default
		}
		
		
		public static   object set_data<Target>(global::pony.events.Signal this1, object d){
			unchecked {
				#line 53 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return this1.data = d;
			}
			#line default
		}
		
		
		public static   Target get_target<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   int get_listenersCount<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 55 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return this1.listeners.data.length;
			}
			#line default
		}
		
		
		public static   Target @add<Target>(global::pony.events.Signal this1, object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 57 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				int __temp_priority86 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				this1.@add(((object) (listener) ), new global::haxe.lang.Null<int>(__temp_priority86, true));
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target once<Target>(global::pony.events.Signal this1, object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 62 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				int __temp_priority87 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				{
					#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					object listener1 = ((object) (listener) );
					#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					object __temp_stmt425 = default(object);
					#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					{
						#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
						object f = global::haxe.lang.Runtime.getField(listener1, "f", 102, true);
						#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
						object this2 = default(object);
						#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
						{
							#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							object __temp_getvar200 = f;
							#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							double __temp_ret201 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar200, "used", 1303220797, true)) );
							#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							object __temp_expr426 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar200, "used", 1303220797, ( __temp_ret201 + 1.0 ))) );
							#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							double __temp_expr427 = __temp_ret201;
						}
						
						#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
						{
							#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							bool __temp_odecl423 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "event", 1975830554, true));
							#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							bool __temp_odecl424 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "ignoreReturn", 98429794, true));
							#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							this2 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f, __temp_odecl424, true, default(global::pony.events.Event), __temp_odecl423}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
						__temp_stmt425 = this2;
					}
					
					#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					this1.@add(((object) (__temp_stmt425) ), new global::haxe.lang.Null<int>(__temp_priority87, true));
				}
				
				#line 64 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target @remove<Target>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 68 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.@remove(((object) (listener) ));
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target changePriority<Target>(global::pony.events.Signal this1, object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 73 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				int __temp_priority88 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				{
					#line 74 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					this1.listeners.changeElement(((object) (listener) ), new global::haxe.lang.Null<int>(__temp_priority88, true));
					#line 74 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal __temp_expr428 = this1;
				}
				
				#line 75 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target dispatch<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.dispatchEmpty();
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target dispatchEvent<Target>(global::pony.events.Signal this1, global::pony.events.Event @event){
			unchecked {
				#line 84 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.dispatchEvent(@event);
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target dispatchArgs<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 89 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.dispatchEmpty();
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   void dispatchEmpty<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 93 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.dispatchEmpty();
			}
			#line default
		}
		
		
		public static   void dispatchEmpty1<Target>(global::pony.events.Signal this1, object _){
			unchecked {
				#line 95 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.dispatchEmpty();
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal bind<Target>(global::pony.events.Signal this1, object a, object b, object c, object d, object e, object f, object g){
			unchecked {
				#line 98 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				if (( ! (global::haxe.lang.Runtime.eq(g, default(object))) )) {
					#line 99 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					int priority = 0;
					#line 99 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return this1.bindArgs(new global::Array<object>(new object[]{a, b, c, d, e, f, g}), new global::haxe.lang.Null<int>(priority, true));
				}
				 else {
					#line 100 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					if (( ! (global::haxe.lang.Runtime.eq(f, default(object))) )) {
						#line 101 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
						int priority1 = 0;
						#line 101 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
						return this1.bindArgs(new global::Array<object>(new object[]{a, b, c, d, e, f}), new global::haxe.lang.Null<int>(priority1, true));
					}
					 else {
						#line 102 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
						if (( ! (global::haxe.lang.Runtime.eq(e, default(object))) )) {
							#line 103 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							int priority2 = 0;
							#line 103 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							return this1.bindArgs(new global::Array<object>(new object[]{a, b, c, d, e}), new global::haxe.lang.Null<int>(priority2, true));
						}
						 else {
							#line 104 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
							if (( ! (global::haxe.lang.Runtime.eq(d, default(object))) )) {
								#line 105 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
								int priority3 = 0;
								#line 105 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
								return this1.bindArgs(new global::Array<object>(new object[]{a, b, c, d}), new global::haxe.lang.Null<int>(priority3, true));
							}
							 else {
								#line 106 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
								if (( ! (global::haxe.lang.Runtime.eq(c, default(object))) )) {
									#line 107 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
									int priority4 = 0;
									#line 107 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
									return this1.bindArgs(new global::Array<object>(new object[]{a, b, c}), new global::haxe.lang.Null<int>(priority4, true));
								}
								 else {
									#line 108 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
									if (( ! (global::haxe.lang.Runtime.eq(b, default(object))) )) {
										#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
										int priority5 = 0;
										#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
										return this1.bindArgs(new global::Array<object>(new object[]{a, b}), new global::haxe.lang.Null<int>(priority5, true));
									}
									 else {
										#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
										int priority6 = 0;
										#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
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
		
		
		public static   global::pony.events.Signal bindArgs<Target>(global::pony.events.Signal this1, global::Array args, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 114 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				int __temp_priority89 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 114 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return this1.bindArgs(args, new global::haxe.lang.Null<int>(__temp_priority89, true));
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal bind1<A, Target>(global::pony.events.Signal this1, A a, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 115 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				int __temp_priority90 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 115 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 115 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal s = this1.bindArgs(new global::Array<object>(new object[]{a}), new global::haxe.lang.Null<int>(__temp_priority90, true));
					#line 115 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal bind2<A, B, Target>(global::pony.events.Signal this1, A a, B b, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 116 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				int __temp_priority91 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 116 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 116 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal s = this1.bindArgs(new global::Array<object>(new object[]{a, b}), new global::haxe.lang.Null<int>(__temp_priority91, true));
					#line 116 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
		public static   Target removeBindArgs<Target>(global::pony.events.Signal this1, global::Array args){
			unchecked {
				#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.removeBindArgs(args);
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal and<Target>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 123 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return ((global::pony.events.Signal) (this1.and(s)) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal and0<Target>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 124 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 124 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 124 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal and1<A, Target>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal and2<A, B, Target>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 126 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 126 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 126 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal or<Target>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 128 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 128 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal s1 = this1.or(((global::pony.events.Signal) (s) ));
					#line 128 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (s1) );
				}
				
			}
			#line default
		}
		
		
		public static   Target removeAllListeners<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 131 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.removeAllListeners();
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   Target sw<Target>(global::pony.events.Signal this1, object l1, object l2){
			unchecked {
				#line 136 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.sw(((object) (l1) ), ((object) (l2) ), default(global::haxe.lang.Null<int>));
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   void enableSilent<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 140 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.silent = true;
			}
			#line default
		}
		
		
		public static   void disableSilent<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 141 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.silent = false;
			}
			#line default
		}
		
		
		public static   Target destroy<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 144 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				this1.destroy();
				return global::haxe.lang.Runtime.genericCast<Target>(this1.target);
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal @from<A>(global::pony.events.Signal s){
			unchecked {
				#line 148 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return ((global::pony.events.Signal) (s) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal toDynamic<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 149 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return this1;
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal toTar<Target>(global::pony.events.Signal this1){
			unchecked {
				#line 150 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_add<Target>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 155 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				global::pony.events._Signal0.Signal0_Impl_.@add<Target>(this1, listener, default(global::haxe.lang.Null<int>));
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_once<Target>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 160 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				global::pony.events._Signal0.Signal0_Impl_.once<Target>(this1, listener, default(global::haxe.lang.Null<int>));
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_remove<Target>(global::pony.events.Signal this1, object listener){
			unchecked {
				#line 165 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				global::pony.events._Signal0.Signal0_Impl_.@remove<Target>(this1, listener);
				return ((global::pony.events.Signal) (this1) );
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_and0<Target>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 169 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 169 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 169 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_and1<A, Target>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 170 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 170 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 170 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_and2<A, B, Target>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 171 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 171 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal this2 = ((global::pony.events.Signal) (this1.and(((global::pony.events.Signal) (s) ))) );
					#line 171 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (this2) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_or<Target>(global::pony.events.Signal this1, global::pony.events.Signal s){
			unchecked {
				#line 173 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 173 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal s1 = this1.or(((global::pony.events.Signal) (s) ));
					#line 173 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (s1) );
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal op_bind1<A, Target>(global::pony.events.Signal this1, A a){
			unchecked {
				#line 175 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
				{
					#line 175 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					int priority = 0;
					#line 175 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					global::pony.events.Signal s = this1.bindArgs(new global::Array<object>(new object[]{a}), new global::haxe.lang.Null<int>(priority, true));
					#line 175 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal0.hx"
					return ((global::pony.events.Signal) (s) );
				}
				
			}
			#line default
		}
		
		
	}
}


