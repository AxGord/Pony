
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal : global::haxe.lang.HxObject {
		static Signal() {
			#line 46 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
			global::pony.events.Signal.signalsCount = 0;
		}
		public    Signal(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Signal(object target){
			unchecked {
				#line 71 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Signal.__hx_ctor_pony_events_Signal(this, target);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_events_Signal(global::pony.events.Signal __temp_me85, object target){
			unchecked {
				#line 49 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				__temp_me85.silent = false;
				#line 72 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				__temp_me85.subMap = new global::pony.Dictionary<object, object>(new global::haxe.lang.Null<int>(5, true));
				__temp_me85.subHandlers = new global::haxe.ds.IntMap<object>();
				__temp_me85.bindMap = new global::pony.Dictionary<object, object>(new global::haxe.lang.Null<int>(5, true));
				__temp_me85.bindHandlers = new global::haxe.ds.IntMap<object>();
				__temp_me85.notMap = new global::pony.Dictionary<object, object>(new global::haxe.lang.Null<int>(5, true));
				__temp_me85.notHandlers = new global::haxe.ds.IntMap<object>();
				{
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					__temp_me85.id = global::pony.events.Signal.signalsCount++;
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					__temp_me85.target = target;
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					__temp_me85.listeners = new global::pony.Priority<object>(((global::Array<object>) (default(global::Array<object>)) ));
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					__temp_me85.lRunCopy = new global::List<object>();
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal __temp_expr413 = __temp_me85;
				}
				
				#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal s = default(global::pony.events.Signal);
					#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal _this = ((global::pony.events.Signal) (global::Type.createEmptyInstance<object>(typeof(global::pony.events.Signal))) );
						#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.id = global::pony.events.Signal.signalsCount++;
						#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.target = __temp_me85;
						#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.listeners = new global::pony.Priority<object>(((global::Array<object>) (default(global::Array<object>)) ));
						#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.lRunCopy = new global::List<object>();
						#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s = _this;
					}
					
					#line 79 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					__temp_me85.lostListeners = ((global::pony.events.Signal) (s) );
				}
				
				#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal s1 = default(global::pony.events.Signal);
					#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal _this1 = ((global::pony.events.Signal) (global::Type.createEmptyInstance<object>(typeof(global::pony.events.Signal))) );
						#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this1.id = global::pony.events.Signal.signalsCount++;
						#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this1.target = __temp_me85;
						#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this1.listeners = new global::pony.Priority<object>(((global::Array<object>) (default(global::Array<object>)) ));
						#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this1.lRunCopy = new global::List<object>();
						#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s1 = _this1;
					}
					
					#line 80 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					__temp_me85.takeListeners = ((global::pony.events.Signal) (s1) );
				}
				
			}
			#line default
		}
		
		
		public static  int signalsCount;
		
		public static   global::pony.events.Signal create<A>(A t){
			unchecked {
				#line 489 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 489 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal s = new global::pony.events.Signal(((object) (t) ));
					#line 489 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return s;
				}
				
			}
			#line default
		}
		
		
		public static   global::pony.events.Signal createEmpty(){
			unchecked {
				#line 494 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 494 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal s = new global::pony.events.Signal(((object) (default(object)) ));
					#line 494 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return s;
				}
				
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return new global::pony.events.Signal(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return new global::pony.events.Signal(((object) (arr[0]) ));
			}
			#line default
		}
		
		
		public  int id;
		
		public  bool silent;
		
		public  global::pony.events.Signal lostListeners;
		
		public  global::pony.events.Signal takeListeners;
		
		public  object data;
		
		public  object target;
		
		public  global::pony.Priority<object> listeners;
		
		public  global::List<object> lRunCopy;
		
		public  global::pony.Dictionary<object, object> subMap;
		
		public  global::haxe.ds.IntMap<object> subHandlers;
		
		public  global::pony.Dictionary<object, object> bindMap;
		
		public  global::haxe.ds.IntMap<object> bindHandlers;
		
		public  global::pony.Dictionary<object, object> notMap;
		
		public  global::haxe.ds.IntMap<object> notHandlers;
		
		public  bool haveListeners;
		
		
		
		public  global::pony.events.Signal parent;
		
		public   global::pony.events.Signal init(object target){
			unchecked {
				#line 85 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.id = global::pony.events.Signal.signalsCount++;
				#line 87 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.target = target;
				this.listeners = new global::pony.Priority<object>(((global::Array<object>) (default(global::Array<object>)) ));
				this.lRunCopy = new global::List<object>();
				return this;
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal @add(object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 107 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int __temp_priority77 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				{
					#line 108 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object __temp_getvar162 = listener;
					#line 108 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					double __temp_ret163 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar162, "used", 1303220797, true)) );
					#line 108 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::haxe.lang.Runtime.setField(__temp_getvar162, "used", 1303220797, ( __temp_ret163 + 1.0 ));
					#line 108 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					double __temp_expr358 = __temp_ret163;
				}
				
				#line 109 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				bool f = ( this.listeners.data.length == 0 );
				this.listeners.addElement(listener, new global::haxe.lang.Null<int>(__temp_priority77, true));
				if (( f && ( this.takeListeners != default(global::pony.events.Signal) ) )) {
					#line 111 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events._Signal0.Signal0_Impl_.dispatchEmpty<object>(this.takeListeners);
				}
				
				#line 112 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal @remove(object listener){
			unchecked {
				#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				if (( this.listeners.data.length == 0 )) {
					#line 119 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return this;
				}
				
				#line 120 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				if (this.listeners.removeElement(listener)) {
					#line 121 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 121 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_iterator164 = this.lRunCopy.iterator();
						#line 121 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator164, "hasNext", 407283053, default(global::Array)))){
							#line 121 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.Priority<object> c = ((global::pony.Priority<object>) (global::pony.Priority<object>.__hx_cast<object>(((global::pony.Priority) (global::haxe.lang.Runtime.callField(__temp_iterator164, "next", 1224901875, default(global::Array))) ))) );
							#line 121 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							c.removeElement(listener);
						}
						
					}
					
					#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_getvar165 = listener;
							#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							int __temp_ret166 = ((int) (global::haxe.lang.Runtime.getField_f(__temp_getvar165, "used", 1303220797, true)) );
							#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::haxe.lang.Runtime.setField_f(__temp_getvar165, "used", 1303220797, ((double) (( __temp_ret166 - 1 )) ));
							#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							int __temp_expr359 = __temp_ret166;
						}
						
						#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( ((int) (global::haxe.lang.Runtime.getField_f(listener, "used", 1303220797, true)) ) == 0 )) {
							#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events._Listener.Listener_Impl_.flist.@remove(((int) (global::haxe.lang.Runtime.getField_f(global::haxe.lang.Runtime.getField(listener, "f", 102, true), "id", 23515, true)) ));
							#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								{
									#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									object __temp_getvar167 = global::haxe.lang.Runtime.getField(listener, "f", 102, true);
									#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									int __temp_ret168 = ((int) (global::haxe.lang.Runtime.getField_f(__temp_getvar167, "used", 1303220797, true)) );
									#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::haxe.lang.Runtime.setField_f(__temp_getvar167, "used", 1303220797, ((double) (( __temp_ret168 - 1 )) ));
									#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									int __temp_expr360 = __temp_ret168;
								}
								
								#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								if (( global::haxe.lang.Runtime.compare(((int) (global::haxe.lang.Runtime.getField_f(global::haxe.lang.Runtime.getField(listener, "f", 102, true), "used", 1303220797, true)) ), 0) <= 0 )) {
									#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									if (( global::haxe.lang.Runtime.getField(global::haxe.lang.Runtime.getField(listener, "f", 102, true), "f", 102, true) is global::haxe.lang.Closure )) {
										#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
										global::pony._Function.Function_Impl_.cslist.@remove(global::pony._Function.Function_Impl_.buildCSHash(global::haxe.lang.Runtime.getField(global::haxe.lang.Runtime.getField(listener, "f", 102, true), "f", 102, true)));
									}
									 else {
										#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
										global::pony._Function.Function_Impl_.list.@remove(global::pony._Function.Function_Impl_.buildCSHash(global::haxe.lang.Runtime.getField(global::haxe.lang.Runtime.getField(listener, "f", 102, true), "f", 102, true)));
									}
									
									#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::haxe.lang.Runtime.setField(listener, "f", 102, default(object));
									#line 122 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony._Function.Function_Impl_.unusedCount--;
								}
								
							}
							
						}
						
					}
					
					#line 123 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( ( this.listeners.data.length == 0 ) && ( this.lostListeners != default(global::pony.events.Signal) ) )) {
						#line 123 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events._Signal0.Signal0_Impl_.dispatchEmpty<object>(this.lostListeners);
					}
					
				}
				
				#line 125 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public   global::pony.events.Signal changePriority(object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 133 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int __temp_priority78 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				this.listeners.changeElement(listener, new global::haxe.lang.Null<int>(__temp_priority78, true));
				return this;
			}
			#line default
		}
		
		
		public   global::pony.events.Signal once(object listener, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int __temp_priority79 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				object __temp_stmt363 = default(object);
				#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object f = global::haxe.lang.Runtime.getField(listener, "f", 102, true);
					#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object this1 = default(object);
					#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_getvar169 = f;
						#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						double __temp_ret170 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar169, "used", 1303220797, true)) );
						#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_expr364 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar169, "used", 1303220797, ( __temp_ret170 + 1.0 ))) );
						#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						double __temp_expr365 = __temp_ret170;
					}
					
					#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						bool __temp_odecl361 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "event", 1975830554, true));
						#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						bool __temp_odecl362 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "ignoreReturn", 98429794, true));
						#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this1 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f, __temp_odecl362, true, default(global::pony.events.Event), __temp_odecl361}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
					}
					
					#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					__temp_stmt363 = this1;
				}
				
				#line 139 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this.@add(((object) (__temp_stmt363) ), new global::haxe.lang.Null<int>(__temp_priority79, true));
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal dispatchEvent(global::pony.events.Event @event){
			unchecked {
				#line 159 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				if (( this.listeners.data.length == 0 )) {
					#line 159 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return this;
				}
				
				#line 160 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				@event.signal = this;
				if (this.silent) {
					#line 161 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return this;
				}
				
				#line 162 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.Priority<object> c = new global::pony.Priority<object>(((global::Array<object>) (this.listeners.data.copy()) ));
				this.lRunCopy.@add(c);
				{
					#line 164 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object __temp_iterator171 = c.iterator();
					#line 164 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator171, "hasNext", 407283053, default(global::Array)))){
						#line 164 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object l = ((object) (global::haxe.lang.Runtime.callField(__temp_iterator171, "next", 1224901875, default(global::Array))) );
						bool r = false;
						#line 167 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						try {
							#line 167 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							r = global::pony.events._Listener.Listener_Impl_.call(l, @event);
						}
						catch (global::System.Exception __temp_catchallException368){
							#line 167 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::haxe.lang.Exceptions.exception = __temp_catchallException368;
							#line 198 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_catchall369 = __temp_catchallException368;
							#line 198 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							if (( __temp_catchall369 is global::haxe.lang.HaxeException )) {
								#line 198 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								__temp_catchall369 = ((global::haxe.lang.HaxeException) (__temp_catchallException368) ).obj;
							}
							
							#line 168 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							if (( __temp_catchall369 is string )) {
								#line 168 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								string msg = global::haxe.lang.Runtime.toString(__temp_catchall369);
								#line 168 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								{
									#line 169 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									this.@remove(l);
									this.lRunCopy.@remove(c);
									#line 173 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::haxe.Log.trace.__hx_invoke2_o(default(double), msg, default(double), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"dispatchEvent", "pony.events.Signal", "Signal.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (173) )})));
									global::pony.events._Listener.Listener_Impl_.call(l, @event);
									#line 176 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									throw global::haxe.lang.HaxeException.wrap(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("Listener error (signal: ", global::haxe.lang.Runtime.toString(this.id)), ")"));
								}
								
							}
							 else {
								#line 198 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object e = __temp_catchall369;
								this.@remove(l);
								this.lRunCopy.@remove(c);
								#line 202 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								try {
									#line 202 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::haxe.Log.trace.__hx_invoke2_o(default(double), global::haxe.CallStack.toString(global::haxe.CallStack.exceptionStack()), default(double), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"dispatchEvent", "pony.events.Signal", "Signal.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (202) )})));
								}
								catch (global::System.Exception __temp_catchallException366){
									#line 202 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::haxe.lang.Exceptions.exception = __temp_catchallException366;
									object __temp_catchall367 = __temp_catchallException366;
									#line 203 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									if (( __temp_catchall367 is global::haxe.lang.HaxeException )) {
										#line 203 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
										__temp_catchall367 = ((global::haxe.lang.HaxeException) (__temp_catchallException366) ).obj;
									}
									
									#line 203 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									{
										#line 203 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
										object e1 = __temp_catchall367;
										#line 203 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
										{
										}
										
									}
									
								}
								
								
								#line 204 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								throw global::haxe.lang.HaxeException.wrap(e);
							}
							
						}
						
						
						#line 206 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( ((int) (global::haxe.lang.Runtime.getField_f(l, "count", 1248019663, true)) ) == 0 )) {
							#line 206 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this.@remove(l);
						}
						
						#line 207 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if ( ! (r) ) {
							#line 207 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							break;
						}
						
					}
					
				}
				
				#line 209 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.lRunCopy.@remove(c);
				return this;
			}
			#line default
		}
		
		
		public   global::pony.events.Signal dispatchArgs(global::Array args){
			unchecked {
				#line 214 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.dispatchEvent(new global::pony.events.Event(((global::Array) (args) ), ((object) (this.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) )));
				return this;
			}
			#line default
		}
		
		
		public virtual   void dispatchEmpty(){
			unchecked {
				#line 219 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.dispatchEvent(new global::pony.events.Event(((global::Array) (default(global::Array)) ), ((object) (this.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) )));
			}
			#line default
		}
		
		
		public virtual   void dispatchEmpty1(object _){
			unchecked {
				#line 223 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.dispatchEvent(new global::pony.events.Event(((global::Array) (default(global::Array)) ), ((object) (this.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) )));
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal subArgs(global::Array args, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 234 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int __temp_priority80 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				global::pony.events.Signal s = ((global::pony.events.Signal) (this.subMap.@get(args)) );
				if (( s == default(global::pony.events.Signal) )) {
					#line 237 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					s = new global::pony.events.Signal(((object) (this.target) ));
					s.parent = this;
					global::haxe.lang.Function __temp_stmt371 = default(global::haxe.lang.Function);
					#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::Array<object> f = new global::Array<object>(new object[]{((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("subHandler") ), ((int) (1111449130) ))) )});
						#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::Array<object> a1 = new global::Array<object>(new object[]{args});
						#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						__temp_stmt371 = new global::pony.events.Signal_subArgs_239__Fun(((global::Array<object>) (f) ), ((global::Array<object>) (a1) ));
					}
					
					#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object __temp_stmt370 = global::pony._Function.Function_Impl_.@from(__temp_stmt371, 1);
					#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object l = global::pony.events._Listener.Listener_Impl_._fromFunction(__temp_stmt370, true);
					{
						#line 240 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						int k = this.subMap.@set(args, s);
						#line 240 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.subHandlers.@set(k, l);
						#line 240 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_expr372 = l;
					}
					
					#line 241 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					this.@add(l, new global::haxe.lang.Null<int>(__temp_priority80, true));
				}
				
				#line 243 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return s;
			}
			#line default
		}
		
		
		public virtual   void subHandler(global::Array args, global::pony.events.Event @event){
			unchecked {
				#line 247 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::Array a = ((global::Array) (global::haxe.lang.Runtime.callField(@event.args, "copy", 1103412149, default(global::Array))) );
				{
					#line 248 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					int _g = 0;
					#line 248 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					while (( global::haxe.lang.Runtime.compare(_g, ((int) (global::haxe.lang.Runtime.getField_f(args, "length", 520590566, true)) )) < 0 )){
						#line 248 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object arg = args[_g];
						#line 248 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						 ++ _g;
						#line 248 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( ! (global::haxe.lang.Runtime.eq(((object) (global::haxe.lang.Runtime.callField(a, "shift", 2082663554, default(global::Array))) ), arg)) )) {
							#line 248 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							return ;
						}
						
					}
					
				}
				
				#line 249 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::pony.events.Signal) (this.subMap.@get(args)) ).dispatchEvent(new global::pony.events.Event(((global::Array) (a) ), ((object) (@event.target) ), ((global::pony.events.Event) (@event) )));
			}
			#line default
		}
		
		
		public   global::pony.events.Signal changeSubArgs(global::Array args, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 252 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int __temp_priority81 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				this.removeSubArgs(args);
				return this.subArgs(args, new global::haxe.lang.Null<int>(__temp_priority81, true));
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal removeSubArgs(global::Array args){
			unchecked {
				#line 266 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Signal s = ((global::pony.events.Signal) (this.subMap.@get(args)) );
				if (( s == default(global::pony.events.Signal) )) {
					#line 267 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return this;
				}
				
				#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( s.parent != default(global::pony.events.Signal) )) {
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s.parent.removeSubSignal(s);
					}
					
					#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( s.subMap != default(global::pony.Dictionary<object, object>) )) {
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object __temp_iterator172 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (s.subMap.vs) ))) );
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator172, "hasNext", 407283053, default(global::Array)))){
									#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator172, "next", 1224901875, default(global::Array))) );
									#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									e.destroy();
								}
								
							}
							
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.Dictionary<object, object> _this = s.subMap;
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this.ks = new global::Array<object>(new object[]{});
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal __temp_expr373 = s;
					}
					
					#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( s.bindMap != default(global::pony.Dictionary<object, object>) )) {
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object __temp_iterator173 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (s.bindMap.vs) ))) );
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator173, "hasNext", 407283053, default(global::Array)))){
									#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony.events.Signal e1 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator173, "next", 1224901875, default(global::Array))) );
									#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									e1.destroy();
								}
								
							}
							
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.Dictionary<object, object> _this1 = s.bindMap;
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this1.ks = new global::Array<object>(new object[]{});
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this1.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal __temp_expr374 = s;
					}
					
					#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( s.notMap != default(global::pony.Dictionary<object, object>) )) {
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object __temp_iterator174 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (s.notMap.vs) ))) );
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator174, "hasNext", 407283053, default(global::Array)))){
									#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony.events.Signal e2 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator174, "next", 1224901875, default(global::Array))) );
									#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									e2.destroy();
								}
								
							}
							
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.Dictionary<object, object> _this2 = s.notMap;
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this2.ks = new global::Array<object>(new object[]{});
								#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this2.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal __temp_expr375 = s;
					}
					
					#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					s.removeAllListeners();
					#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( s.takeListeners != default(global::pony.events.Signal) )) {
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events.Signal this1 = s.takeListeners;
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this1.destroy();
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_expr376 = this1.target;
						}
						
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s.takeListeners = default(global::pony.events.Signal);
					}
					
					#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( s.lostListeners != default(global::pony.events.Signal) )) {
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events.Signal this2 = s.lostListeners;
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this2.destroy();
							#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_expr377 = this2.target;
						}
						
						#line 268 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s.lostListeners = default(global::pony.events.Signal);
					}
					
				}
				
				#line 269 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public   global::pony.events.Signal removeAllSub(){
			unchecked {
				#line 273 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				if (( this.subMap != default(global::pony.Dictionary<object, object>) )) {
					#line 274 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 274 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_iterator175 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this.subMap.vs) ))) );
						#line 274 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator175, "hasNext", 407283053, default(global::Array)))){
							#line 274 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator175, "next", 1224901875, default(global::Array))) );
							#line 274 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							e.destroy();
						}
						
					}
					
					#line 275 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 275 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.Dictionary<object, object> _this = this.subMap;
						#line 275 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.ks = new global::Array<object>(new object[]{});
						#line 275 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.vs = new global::Array<object>(new object[]{});
					}
					
				}
				
				#line 277 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public virtual   void removeSubSignal(global::pony.events.Signal s){
			unchecked {
				#line 281 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int i = this.subMap.vs.indexOf(s, default(global::haxe.lang.Null<int>));
				if (( i != -1 )) {
					#line 283 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					s.@remove((this.subHandlers.@get(i)).toDynamic());
					this.subHandlers.@remove(i);
					{
						#line 285 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.Dictionary<object, object> _this = this.subMap;
						#line 285 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.ks.splice(i, 1);
						#line 285 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.vs.splice(i, 1);
					}
					
				}
				
				#line 287 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int i1 = this.bindMap.vs.indexOf(s, default(global::haxe.lang.Null<int>));
				if (( i1 != -1 )) {
					#line 289 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					s.@remove((this.bindHandlers.@get(i1)).toDynamic());
					this.bindHandlers.@remove(i1);
					{
						#line 291 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.Dictionary<object, object> _this1 = this.bindMap;
						#line 291 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this1.ks.splice(i1, 1);
						#line 291 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this1.vs.splice(i1, 1);
					}
					
				}
				
				#line 293 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int i2 = this.notMap.vs.indexOf(s, default(global::haxe.lang.Null<int>));
				if (( i2 != -1 )) {
					#line 295 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					s.@remove((this.notHandlers.@get(i2)).toDynamic());
					this.notHandlers.@remove(i2);
					{
						#line 297 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.Dictionary<object, object> _this2 = this.notMap;
						#line 297 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this2.ks.splice(i2, 1);
						#line 297 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this2.vs.splice(i2, 1);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal bindArgs(global::Array args, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 309 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int __temp_priority82 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				global::pony.events.Signal s = ((global::pony.events.Signal) (this.bindMap.@get(args)) );
				if (( s == default(global::pony.events.Signal) )) {
					#line 312 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					s = new global::pony.events.Signal(((object) (this.target) ));
					s.parent = this;
					global::haxe.lang.Function __temp_stmt379 = default(global::haxe.lang.Function);
					#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::Array<object> f = new global::Array<object>(new object[]{((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("bindHandler") ), ((int) (1111933837) ))) )});
						#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::Array<object> a1 = new global::Array<object>(new object[]{args});
						#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						__temp_stmt379 = new global::pony.events.Signal_bindArgs_314__Fun(((global::Array<object>) (a1) ), ((global::Array<object>) (f) ));
					}
					
					#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object __temp_stmt378 = global::pony._Function.Function_Impl_.@from(__temp_stmt379, 1);
					#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object l = global::pony.events._Listener.Listener_Impl_._fromFunction(__temp_stmt378, true);
					{
						#line 315 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						int k = this.bindMap.@set(args, s);
						#line 315 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.bindHandlers.@set(k, l);
						#line 315 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_expr380 = l;
					}
					
					#line 316 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					this.@add(l, new global::haxe.lang.Null<int>(__temp_priority82, true));
				}
				
				#line 318 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return s;
			}
			#line default
		}
		
		
		public virtual   void bindHandler(global::Array args, global::pony.events.Event @event){
			unchecked {
				#line 322 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::pony.events.Signal) (this.bindMap.@get(args)) ).dispatchEvent(new global::pony.events.Event(((global::Array) (global::haxe.lang.Runtime.callField(args, "concat", 1204816148, new global::Array<object>(new object[]{@event.args}))) ), ((object) (@event.target) ), ((global::pony.events.Event) (@event) )));
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal removeBindArgs(global::Array args){
			unchecked {
				#line 334 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Signal s = ((global::pony.events.Signal) (this.bindMap.@get(args)) );
				if (( s == default(global::pony.events.Signal) )) {
					#line 335 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return this;
				}
				
				#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( s.parent != default(global::pony.events.Signal) )) {
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s.parent.removeSubSignal(s);
					}
					
					#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( s.subMap != default(global::pony.Dictionary<object, object>) )) {
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object __temp_iterator176 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (s.subMap.vs) ))) );
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator176, "hasNext", 407283053, default(global::Array)))){
									#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator176, "next", 1224901875, default(global::Array))) );
									#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									e.destroy();
								}
								
							}
							
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.Dictionary<object, object> _this = s.subMap;
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this.ks = new global::Array<object>(new object[]{});
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal __temp_expr381 = s;
					}
					
					#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( s.bindMap != default(global::pony.Dictionary<object, object>) )) {
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object __temp_iterator177 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (s.bindMap.vs) ))) );
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator177, "hasNext", 407283053, default(global::Array)))){
									#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony.events.Signal e1 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator177, "next", 1224901875, default(global::Array))) );
									#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									e1.destroy();
								}
								
							}
							
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.Dictionary<object, object> _this1 = s.bindMap;
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this1.ks = new global::Array<object>(new object[]{});
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this1.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal __temp_expr382 = s;
					}
					
					#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( s.notMap != default(global::pony.Dictionary<object, object>) )) {
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object __temp_iterator178 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (s.notMap.vs) ))) );
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator178, "hasNext", 407283053, default(global::Array)))){
									#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony.events.Signal e2 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator178, "next", 1224901875, default(global::Array))) );
									#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									e2.destroy();
								}
								
							}
							
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.Dictionary<object, object> _this2 = s.notMap;
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this2.ks = new global::Array<object>(new object[]{});
								#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this2.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal __temp_expr383 = s;
					}
					
					#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					s.removeAllListeners();
					#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( s.takeListeners != default(global::pony.events.Signal) )) {
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events.Signal this1 = s.takeListeners;
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this1.destroy();
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_expr384 = this1.target;
						}
						
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s.takeListeners = default(global::pony.events.Signal);
					}
					
					#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( s.lostListeners != default(global::pony.events.Signal) )) {
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events.Signal this2 = s.lostListeners;
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this2.destroy();
							#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_expr385 = this2.target;
						}
						
						#line 336 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s.lostListeners = default(global::pony.events.Signal);
					}
					
				}
				
				#line 337 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public   global::pony.events.Signal removeAllBind(){
			unchecked {
				#line 341 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				if (( this.bindMap != default(global::pony.Dictionary<object, object>) )) {
					#line 342 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 342 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_iterator179 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this.bindMap.vs) ))) );
						#line 342 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator179, "hasNext", 407283053, default(global::Array)))){
							#line 342 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator179, "next", 1224901875, default(global::Array))) );
							#line 342 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							e.destroy();
						}
						
					}
					
					#line 343 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 343 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.Dictionary<object, object> _this = this.bindMap;
						#line 343 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.ks = new global::Array<object>(new object[]{});
						#line 343 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.vs = new global::Array<object>(new object[]{});
					}
					
				}
				
				#line 345 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal notArgs(global::Array args, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 356 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int __temp_priority83 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				global::pony.events.Signal s = ((global::pony.events.Signal) (this.bindMap.@get(args)) );
				if (( s == default(global::pony.events.Signal) )) {
					#line 359 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					s = new global::pony.events.Signal(((object) (this.target) ));
					s.parent = this;
					global::haxe.lang.Function __temp_stmt387 = default(global::haxe.lang.Function);
					#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::Array<object> f = new global::Array<object>(new object[]{((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("notHandler") ), ((int) (346986231) ))) )});
						#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::Array<object> a1 = new global::Array<object>(new object[]{args});
						#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						__temp_stmt387 = new global::pony.events.Signal_notArgs_361__Fun(((global::Array<object>) (a1) ), ((global::Array<object>) (f) ));
					}
					
					#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object __temp_stmt386 = global::pony._Function.Function_Impl_.@from(__temp_stmt387, 1);
					#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object l = global::pony.events._Listener.Listener_Impl_._fromFunction(__temp_stmt386, true);
					{
						#line 362 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						int k = this.bindMap.@set(args, s);
						#line 362 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.notHandlers.@set(k, l);
						#line 362 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_expr388 = l;
					}
					
					#line 363 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					this.@add(l, new global::haxe.lang.Null<int>(__temp_priority83, true));
				}
				
				#line 365 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return s;
			}
			#line default
		}
		
		
		public virtual   void notHandler(global::Array args, global::pony.events.Event @event){
			unchecked {
				#line 369 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::Array a = ((global::Array) (global::haxe.lang.Runtime.callField(@event.args, "copy", 1103412149, default(global::Array))) );
				{
					#line 370 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					int _g = 0;
					#line 370 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					while (( global::haxe.lang.Runtime.compare(_g, ((int) (global::haxe.lang.Runtime.getField_f(args, "length", 520590566, true)) )) < 0 )){
						#line 370 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object arg = args[_g];
						#line 370 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						 ++ _g;
						#line 370 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (global::haxe.lang.Runtime.eq(((object) (global::haxe.lang.Runtime.callField(a, "shift", 2082663554, default(global::Array))) ), arg)) {
							#line 370 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							return ;
						}
						
					}
					
				}
				
				#line 371 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::pony.events.Signal) (this.subMap.@get(args)) ).dispatchEvent(new global::pony.events.Event(((global::Array) (a) ), ((object) (@event.target) ), ((global::pony.events.Event) (@event) )));
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal removeNotArgs(global::Array args){
			unchecked {
				#line 383 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Signal s = ((global::pony.events.Signal) (this.bindMap.@get(args)) );
				if (( s == default(global::pony.events.Signal) )) {
					#line 384 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return this;
				}
				
				#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( s.parent != default(global::pony.events.Signal) )) {
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s.parent.removeSubSignal(s);
					}
					
					#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( s.subMap != default(global::pony.Dictionary<object, object>) )) {
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object __temp_iterator180 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (s.subMap.vs) ))) );
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator180, "hasNext", 407283053, default(global::Array)))){
									#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator180, "next", 1224901875, default(global::Array))) );
									#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									e.destroy();
								}
								
							}
							
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.Dictionary<object, object> _this = s.subMap;
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this.ks = new global::Array<object>(new object[]{});
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal __temp_expr389 = s;
					}
					
					#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( s.bindMap != default(global::pony.Dictionary<object, object>) )) {
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object __temp_iterator181 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (s.bindMap.vs) ))) );
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator181, "hasNext", 407283053, default(global::Array)))){
									#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony.events.Signal e1 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator181, "next", 1224901875, default(global::Array))) );
									#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									e1.destroy();
								}
								
							}
							
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.Dictionary<object, object> _this1 = s.bindMap;
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this1.ks = new global::Array<object>(new object[]{});
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this1.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal __temp_expr390 = s;
					}
					
					#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( s.notMap != default(global::pony.Dictionary<object, object>) )) {
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								object __temp_iterator182 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (s.notMap.vs) ))) );
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator182, "hasNext", 407283053, default(global::Array)))){
									#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony.events.Signal e2 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator182, "next", 1224901875, default(global::Array))) );
									#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									e2.destroy();
								}
								
							}
							
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.Dictionary<object, object> _this2 = s.notMap;
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this2.ks = new global::Array<object>(new object[]{});
								#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								_this2.vs = new global::Array<object>(new object[]{});
							}
							
						}
						
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal __temp_expr391 = s;
					}
					
					#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					s.removeAllListeners();
					#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( s.takeListeners != default(global::pony.events.Signal) )) {
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events.Signal this1 = s.takeListeners;
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this1.destroy();
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_expr392 = this1.target;
						}
						
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s.takeListeners = default(global::pony.events.Signal);
					}
					
					#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( s.lostListeners != default(global::pony.events.Signal) )) {
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events.Signal this2 = s.lostListeners;
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this2.destroy();
							#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_expr393 = this2.target;
						}
						
						#line 385 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						s.lostListeners = default(global::pony.events.Signal);
					}
					
				}
				
				#line 386 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public   global::pony.events.Signal removeAllNot(){
			unchecked {
				#line 390 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				if (( this.notMap != default(global::pony.Dictionary<object, object>) )) {
					#line 391 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 391 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_iterator183 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this.notMap.vs) ))) );
						#line 391 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator183, "hasNext", 407283053, default(global::Array)))){
							#line 391 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator183, "next", 1224901875, default(global::Array))) );
							#line 391 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							e.destroy();
						}
						
					}
					
					#line 392 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 392 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.Dictionary<object, object> _this = this.notMap;
						#line 392 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.ks = new global::Array<object>(new object[]{});
						#line 392 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						_this.vs = new global::Array<object>(new object[]{});
					}
					
				}
				
				#line 394 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal and(global::pony.events.Signal signal){
			unchecked {
				#line 397 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::Array<object> signal1 = new global::Array<object>(new object[]{signal});
				#line 397 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::Array<object> _g = new global::Array<object>(new object[]{this});
				global::Array<object> ns = new global::Array<object>(new object[]{new global::pony.events.Signal(((object) (default(object)) ))});
				global::Array<bool> lock1 = new global::Array<bool>(new bool[]{false});
				global::Array<bool> lock2 = new global::Array<bool>(new bool[]{false});
				this.@add(global::pony.events._Listener.Listener_Impl_._fromFunction(global::pony._Function.Function_Impl_.@from(new global::pony.events.Signal_and_401__Fun(((global::Array<bool>) (lock2) ), ((global::Array<object>) (signal1) ), ((global::Array<bool>) (lock1) ), ((global::Array<object>) (_g) ), ((global::Array<object>) (ns) )), 1), true), default(global::haxe.lang.Null<int>));
				#line 409 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::pony.events.Signal) (signal1[0]) ).@add(global::pony.events._Listener.Listener_Impl_._fromFunction(global::pony._Function.Function_Impl_.@from(new global::pony.events.Signal_and_409__Fun(((global::Array<bool>) (lock2) ), ((global::Array<bool>) (lock1) ), ((global::Array<object>) (_g) ), ((global::Array<object>) (ns) )), 1), true), default(global::haxe.lang.Null<int>));
				#line 417 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return ((global::pony.events.Signal) (ns[0]) );
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal or(global::pony.events.Signal signal){
			unchecked {
				#line 421 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Signal ns = new global::pony.events.Signal(((object) (default(object)) ));
				this.@add(global::pony.events._Listener.Listener_Impl_._fromFunction(global::pony._Function.Function_Impl_.@from(((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (ns) ), ((string) ("dispatchEvent") ), ((int) (1181009664) ))) ), 1), true), default(global::haxe.lang.Null<int>));
				signal.@add(global::pony.events._Listener.Listener_Impl_._fromFunction(global::pony._Function.Function_Impl_.@from(((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (ns) ), ((string) ("dispatchEvent") ), ((int) (1181009664) ))) ), 1), true), default(global::haxe.lang.Null<int>));
				return ns;
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal removeAllListeners(){
			unchecked {
				#line 431 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				bool f = ( this.listeners.data.length == 0 );
				{
					#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object __temp_iterator188 = this.listeners.iterator();
					#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator188, "hasNext", 407283053, default(global::Array)))){
						#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object l = ((object) (global::haxe.lang.Runtime.callField(__temp_iterator188, "next", 1224901875, default(global::Array))) );
						#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_getvar189 = l;
							#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							int __temp_ret190 = ((int) (global::haxe.lang.Runtime.getField_f(__temp_getvar189, "used", 1303220797, true)) );
							#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::haxe.lang.Runtime.setField_f(__temp_getvar189, "used", 1303220797, ((double) (( __temp_ret190 - 1 )) ));
							#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							int __temp_expr394 = __temp_ret190;
						}
						
						#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (( ((int) (global::haxe.lang.Runtime.getField_f(l, "used", 1303220797, true)) ) == 0 )) {
							#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.events._Listener.Listener_Impl_.flist.@remove(((int) (global::haxe.lang.Runtime.getField_f(global::haxe.lang.Runtime.getField(l, "f", 102, true), "id", 23515, true)) ));
							#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							{
								#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								{
									#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									object __temp_getvar191 = global::haxe.lang.Runtime.getField(l, "f", 102, true);
									#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									int __temp_ret192 = ((int) (global::haxe.lang.Runtime.getField_f(__temp_getvar191, "used", 1303220797, true)) );
									#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::haxe.lang.Runtime.setField_f(__temp_getvar191, "used", 1303220797, ((double) (( __temp_ret192 - 1 )) ));
									#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									int __temp_expr395 = __temp_ret192;
								}
								
								#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								if (( global::haxe.lang.Runtime.compare(((int) (global::haxe.lang.Runtime.getField_f(global::haxe.lang.Runtime.getField(l, "f", 102, true), "used", 1303220797, true)) ), 0) <= 0 )) {
									#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									if (( global::haxe.lang.Runtime.getField(global::haxe.lang.Runtime.getField(l, "f", 102, true), "f", 102, true) is global::haxe.lang.Closure )) {
										#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
										global::pony._Function.Function_Impl_.cslist.@remove(global::pony._Function.Function_Impl_.buildCSHash(global::haxe.lang.Runtime.getField(global::haxe.lang.Runtime.getField(l, "f", 102, true), "f", 102, true)));
									}
									 else {
										#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
										global::pony._Function.Function_Impl_.list.@remove(global::pony._Function.Function_Impl_.buildCSHash(global::haxe.lang.Runtime.getField(global::haxe.lang.Runtime.getField(l, "f", 102, true), "f", 102, true)));
									}
									
									#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::haxe.lang.Runtime.setField(l, "f", 102, default(object));
									#line 432 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
									global::pony._Function.Function_Impl_.unusedCount--;
								}
								
							}
							
						}
						
					}
					
				}
				
				#line 433 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.listeners.clear();
				if ((  ! (f)  && ( this.lostListeners != default(global::pony.events.Signal) ) )) {
					#line 434 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events._Signal0.Signal0_Impl_.dispatch<object>(this.lostListeners);
				}
				
				#line 435 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public   object buildListenerEvent(global::pony.events.Event @event){
			unchecked {
				#line 446 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::Array<object> event1 = new global::Array<object>(new object[]{@event});
				#line 446 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::Array<object> _g = new global::Array<object>(new object[]{this});
				#line 446 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 446 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object f = global::pony._Function.Function_Impl_.@from(new global::pony.events.Signal_buildListenerEvent_446__Fun(((global::Array<object>) (event1) ), ((global::Array<object>) (_g) )), 0);
					#line 446 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return global::pony.events._Listener.Listener_Impl_._fromFunction(f, false);
				}
				
			}
			#line default
		}
		
		
		public   object buildListenerArgs(global::Array args){
			unchecked {
				#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::Array<object> @event = new global::Array<object>(new object[]{new global::pony.events.Event(((global::Array) (args) ), ((object) (this.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) ))});
					#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::Array<object> _g = new global::Array<object>(new object[]{this});
					#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object f = global::pony._Function.Function_Impl_.@from(new global::pony.events.Signal_buildListenerArgs_447__Fun(((global::Array<object>) (@event) ), ((global::Array<object>) (_g) )), 0);
						#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return global::pony.events._Listener.Listener_Impl_._fromFunction(f, false);
					}
					
				}
				
			}
			#line default
		}
		
		
		public   object buildListenerEmpty(){
			unchecked {
				#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::Array<object> @event = new global::Array<object>(new object[]{new global::pony.events.Event(((global::Array) (default(global::Array)) ), ((object) (this.target) ), ((global::pony.events.Event) (default(global::pony.events.Event)) ))});
					#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::Array<object> _g = new global::Array<object>(new object[]{this});
					#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object f = global::pony._Function.Function_Impl_.@from(new global::pony.events.Signal_buildListenerEmpty_448__Fun(((global::Array<object>) (@event) ), ((global::Array<object>) (_g) )), 0);
						#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return global::pony.events._Listener.Listener_Impl_._fromFunction(f, false);
					}
					
				}
				
			}
			#line default
		}
		
		
		public   bool get_haveListeners(){
			unchecked {
				#line 450 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return  ! ((( this.listeners.data.length == 0 ))) ;
			}
			#line default
		}
		
		
		public virtual   global::pony.events.Signal sw(object l1, object l2, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 452 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				int __temp_priority84 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				object __temp_stmt400 = default(object);
				#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object f = global::haxe.lang.Runtime.getField(l1, "f", 102, true);
					#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object this1 = default(object);
					#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_getvar193 = f;
						#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						double __temp_ret194 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar193, "used", 1303220797, true)) );
						#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_expr401 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar193, "used", 1303220797, ( __temp_ret194 + 1.0 ))) );
						#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						double __temp_expr402 = __temp_ret194;
					}
					
					#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						bool __temp_odecl396 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(l1, "event", 1975830554, true));
						#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						bool __temp_odecl397 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(l1, "ignoreReturn", 98429794, true));
						#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this1 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f, __temp_odecl397, true, default(global::pony.events.Event), __temp_odecl396}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
					}
					
					#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					__temp_stmt400 = this1;
				}
				
				#line 453 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.@add(((object) (__temp_stmt400) ), new global::haxe.lang.Null<int>(__temp_priority84, true));
				{
					#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object listener = default(object);
					#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::haxe.lang.Function __temp_stmt403 = default(global::haxe.lang.Function);
						#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::Array<object> f2 = new global::Array<object>(new object[]{((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("sw") ), ((int) (25764) ))) )});
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::Array<object> l11 = new global::Array<object>(new object[]{l2});
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::Array<object> l21 = new global::Array<object>(new object[]{l1});
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::Array<int> a1 = new global::Array<int>(new int[]{__temp_priority84});
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							__temp_stmt403 = new global::pony.events.Signal_sw_454__Fun(((global::Array<object>) (l21) ), ((global::Array<object>) (f2) ), ((global::Array<object>) (l11) ), ((global::Array<int>) (a1) ));
						}
						
						#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object f1 = global::pony._Function.Function_Impl_.@from(__temp_stmt403, 0);
						#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						listener = global::pony.events._Listener.Listener_Impl_._fromFunction(f1, false);
					}
					
					#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object __temp_stmt404 = default(object);
					#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object f3 = global::haxe.lang.Runtime.getField(listener, "f", 102, true);
						#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object this2 = default(object);
						#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_getvar195 = f3;
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							double __temp_ret196 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar195, "used", 1303220797, true)) );
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_expr405 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar195, "used", 1303220797, ( __temp_ret196 + 1.0 ))) );
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							double __temp_expr406 = __temp_ret196;
						}
						
						#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							bool __temp_odecl398 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "event", 1975830554, true));
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							bool __temp_odecl399 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "ignoreReturn", 98429794, true));
							#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this2 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f3, __temp_odecl399, true, default(global::pony.events.Event), __temp_odecl398}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						__temp_stmt404 = this2;
					}
					
					#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					this.@add(((object) (__temp_stmt404) ), new global::haxe.lang.Null<int>(__temp_priority84, true));
				}
				
				#line 455 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this;
			}
			#line default
		}
		
		
		public virtual   void enableSilent(){
			unchecked {
				#line 458 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.silent = true;
			}
			#line default
		}
		
		
		public virtual   void disableSilent(){
			unchecked {
				#line 459 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.silent = false;
			}
			#line default
		}
		
		
		public   int get_listenersCount(){
			unchecked {
				#line 461 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return this.listeners.data.length;
			}
			#line default
		}
		
		
		public   void destroy(){
			unchecked {
				#line 465 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				if (( this.parent != default(global::pony.events.Signal) )) {
					#line 465 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					this.parent.removeSubSignal(this);
				}
				
				#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( this.subMap != default(global::pony.Dictionary<object, object>) )) {
						#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_iterator197 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this.subMap.vs) ))) );
							#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator197, "hasNext", 407283053, default(global::Array)))){
								#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.events.Signal e = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator197, "next", 1224901875, default(global::Array))) );
								#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								e.destroy();
							}
							
						}
						
						#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.Dictionary<object, object> _this = this.subMap;
							#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							_this.ks = new global::Array<object>(new object[]{});
							#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							_this.vs = new global::Array<object>(new object[]{});
						}
						
					}
					
					#line 466 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal __temp_expr407 = this;
				}
				
				#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( this.bindMap != default(global::pony.Dictionary<object, object>) )) {
						#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_iterator198 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this.bindMap.vs) ))) );
							#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator198, "hasNext", 407283053, default(global::Array)))){
								#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.events.Signal e1 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator198, "next", 1224901875, default(global::Array))) );
								#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								e1.destroy();
							}
							
						}
						
						#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.Dictionary<object, object> _this1 = this.bindMap;
							#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							_this1.ks = new global::Array<object>(new object[]{});
							#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							_this1.vs = new global::Array<object>(new object[]{});
						}
						
					}
					
					#line 467 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal __temp_expr408 = this;
				}
				
				#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					if (( this.notMap != default(global::pony.Dictionary<object, object>) )) {
						#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_iterator199 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (this.notMap.vs) ))) );
							#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator199, "hasNext", 407283053, default(global::Array)))){
								#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								global::pony.events.Signal e2 = ((global::pony.events.Signal) (global::haxe.lang.Runtime.callField(__temp_iterator199, "next", 1224901875, default(global::Array))) );
								#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
								e2.destroy();
							}
							
						}
						
						#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							global::pony.Dictionary<object, object> _this2 = this.notMap;
							#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							_this2.ks = new global::Array<object>(new object[]{});
							#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							_this2.vs = new global::Array<object>(new object[]{});
						}
						
					}
					
					#line 468 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					global::pony.events.Signal __temp_expr409 = this;
				}
				
				#line 469 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.removeAllListeners();
				if (( this.takeListeners != default(global::pony.events.Signal) )) {
					#line 471 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 471 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal this1 = this.takeListeners;
						#line 471 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this1.destroy();
						#line 471 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_expr410 = this1.target;
					}
					
					#line 472 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					this.takeListeners = default(global::pony.events.Signal);
				}
				
				#line 474 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				if (( this.lostListeners != default(global::pony.events.Signal) )) {
					#line 475 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 475 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						global::pony.events.Signal this2 = this.lostListeners;
						#line 475 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this2.destroy();
						#line 475 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object __temp_expr411 = this2.target;
					}
					
					#line 476 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					this.lostListeners = default(global::pony.events.Signal);
				}
				
			}
			#line default
		}
		
		
		public   void debug(){
			unchecked {
				#line 480 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::Array<object> _g = new global::Array<object>(new object[]{this});
				#line 482 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				object __temp_stmt412 = default(object);
				#line 482 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 482 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object f = global::pony._Function.Function_Impl_.@from(new global::pony.events.Signal_debug_482__Fun(((global::Array<object>) (_g) )), 0);
					#line 482 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					__temp_stmt412 = global::pony.events._Listener.Listener_Impl_._fromFunction(f, false);
				}
				
				#line 482 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.@add(__temp_stmt412, default(global::haxe.lang.Null<int>));
			}
			#line default
		}
		
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				switch (hash){
					case 116192081:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.target = ((object) (@value) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 1113806378:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.data = ((object) (@value) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 23515:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.id = ((int) (@value) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					default:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				switch (hash){
					case 1836975402:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.parent = ((global::pony.events.Signal) (@value) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 419661303:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.haveListeners = global::haxe.lang.Runtime.toBool(@value);
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 68518300:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.notHandlers = ((global::haxe.ds.IntMap<object>) (global::haxe.ds.IntMap<object>.__hx_cast<object>(((global::haxe.ds.IntMap) (@value) ))) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 832804681:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.notMap = ((global::pony.Dictionary<object, object>) (global::pony.Dictionary<object, object>.__hx_cast<object, object>(((global::pony.Dictionary) (@value) ))) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 1000626246:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.bindHandlers = ((global::haxe.ds.IntMap<object>) (global::haxe.ds.IntMap<object>.__hx_cast<object>(((global::haxe.ds.IntMap) (@value) ))) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 2132295903:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.bindMap = ((global::pony.Dictionary<object, object>) (global::pony.Dictionary<object, object>.__hx_cast<object, object>(((global::pony.Dictionary) (@value) ))) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 892536585:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.subHandlers = ((global::haxe.ds.IntMap<object>) (global::haxe.ds.IntMap<object>.__hx_cast<object>(((global::haxe.ds.IntMap) (@value) ))) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 435030268:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.subMap = ((global::pony.Dictionary<object, object>) (global::pony.Dictionary<object, object>.__hx_cast<object, object>(((global::pony.Dictionary) (@value) ))) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 1033575828:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.lRunCopy = ((global::List<object>) (global::List<object>.__hx_cast<object>(((global::List) (@value) ))) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 1938711935:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.listeners = ((global::pony.Priority<object>) (global::pony.Priority<object>.__hx_cast<object>(((global::pony.Priority) (@value) ))) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 116192081:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.target = ((object) (@value) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 1113806378:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.data = ((object) (@value) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 1417333816:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.takeListeners = ((global::pony.events.Signal) (@value) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 171917051:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.lostListeners = ((global::pony.events.Signal) (@value) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 936212117:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.silent = global::haxe.lang.Runtime.toBool(@value);
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					case 23515:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.id = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return @value;
					}
					
					
					default:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				switch (hash){
					case 1461670483:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("debug") ), ((int) (1461670483) ))) );
					}
					
					
					case 612773114:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("destroy") ), ((int) (612773114) ))) );
					}
					
					
					case 899736473:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_listenersCount") ), ((int) (899736473) ))) );
					}
					
					
					case 753054365:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("disableSilent") ), ((int) (753054365) ))) );
					}
					
					
					case 1650187640:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("enableSilent") ), ((int) (1650187640) ))) );
					}
					
					
					case 25764:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("sw") ), ((int) (25764) ))) );
					}
					
					
					case 527667534:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_haveListeners") ), ((int) (527667534) ))) );
					}
					
					
					case 2067338603:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("buildListenerEmpty") ), ((int) (2067338603) ))) );
					}
					
					
					case 485177407:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("buildListenerArgs") ), ((int) (485177407) ))) );
					}
					
					
					case 19112696:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("buildListenerEvent") ), ((int) (19112696) ))) );
					}
					
					
					case 1214242434:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeAllListeners") ), ((int) (1214242434) ))) );
					}
					
					
					case 24867:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("or") ), ((int) (24867) ))) );
					}
					
					
					case 4848343:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("and") ), ((int) (4848343) ))) );
					}
					
					
					case 783343062:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeAllNot") ), ((int) (783343062) ))) );
					}
					
					
					case 240743468:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeNotArgs") ), ((int) (240743468) ))) );
					}
					
					
					case 346986231:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("notHandler") ), ((int) (346986231) ))) );
					}
					
					
					case 899618832:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("notArgs") ), ((int) (899618832) ))) );
					}
					
					
					case 605952922:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeAllBind") ), ((int) (605952922) ))) );
					}
					
					
					case 2023034398:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeBindArgs") ), ((int) (2023034398) ))) );
					}
					
					
					case 1111933837:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("bindHandler") ), ((int) (1111933837) ))) );
					}
					
					
					case 775868858:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("bindArgs") ), ((int) (775868858) ))) );
					}
					
					
					case 2079393572:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeSubSignal") ), ((int) (2079393572) ))) );
					}
					
					
					case 783593027:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeAllSub") ), ((int) (783593027) ))) );
					}
					
					
					case 1731362585:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeSubArgs") ), ((int) (1731362585) ))) );
					}
					
					
					case 1867302765:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("changeSubArgs") ), ((int) (1867302765) ))) );
					}
					
					
					case 1111449130:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("subHandler") ), ((int) (1111449130) ))) );
					}
					
					
					case 242754301:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("subArgs") ), ((int) (242754301) ))) );
					}
					
					
					case 712510302:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("dispatchEmpty1") ), ((int) (712510302) ))) );
					}
					
					
					case 1081751923:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("dispatchEmpty") ), ((int) (1081751923) ))) );
					}
					
					
					case 1530424631:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("dispatchArgs") ), ((int) (1530424631) ))) );
					}
					
					
					case 1181009664:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("dispatchEvent") ), ((int) (1181009664) ))) );
					}
					
					
					case 1236434305:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("once") ), ((int) (1236434305) ))) );
					}
					
					
					case 343521524:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("changePriority") ), ((int) (343521524) ))) );
					}
					
					
					case 76061764:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("remove") ), ((int) (76061764) ))) );
					}
					
					
					case 4846113:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("add") ), ((int) (4846113) ))) );
					}
					
					
					case 1169898256:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("init") ), ((int) (1169898256) ))) );
					}
					
					
					case 1836975402:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.parent;
					}
					
					
					case 436667088:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.get_listenersCount();
					}
					
					
					case 419661303:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						if (handleProperties) {
							#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							return this.get_haveListeners();
						}
						 else {
							#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							return this.haveListeners;
						}
						
					}
					
					
					case 68518300:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.notHandlers;
					}
					
					
					case 832804681:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.notMap;
					}
					
					
					case 1000626246:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.bindHandlers;
					}
					
					
					case 2132295903:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.bindMap;
					}
					
					
					case 892536585:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.subHandlers;
					}
					
					
					case 435030268:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.subMap;
					}
					
					
					case 1033575828:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.lRunCopy;
					}
					
					
					case 1938711935:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.listeners;
					}
					
					
					case 116192081:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.target;
					}
					
					
					case 1113806378:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.data;
					}
					
					
					case 1417333816:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.takeListeners;
					}
					
					
					case 171917051:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.lostListeners;
					}
					
					
					case 936212117:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.silent;
					}
					
					
					case 23515:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.id;
					}
					
					
					default:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				switch (hash){
					case 436667088:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((double) (this.get_listenersCount()) );
					}
					
					
					case 116192081:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((double) (global::haxe.lang.Runtime.toDouble(this.target)) );
					}
					
					
					case 1113806378:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((double) (global::haxe.lang.Runtime.toDouble(this.data)) );
					}
					
					
					case 23515:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return ((double) (this.id) );
					}
					
					
					default:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				switch (hash){
					case 1461670483:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.debug();
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 612773114:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.destroy();
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 899736473:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.get_listenersCount();
					}
					
					
					case 753054365:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.disableSilent();
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 1650187640:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.enableSilent();
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 25764:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.sw(dynargs[0], dynargs[1], global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[2]));
					}
					
					
					case 527667534:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.get_haveListeners();
					}
					
					
					case 2067338603:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.buildListenerEmpty();
					}
					
					
					case 485177407:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.buildListenerArgs(((global::Array) (dynargs[0]) ));
					}
					
					
					case 19112696:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.buildListenerEvent(((global::pony.events.Event) (dynargs[0]) ));
					}
					
					
					case 1214242434:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.removeAllListeners();
					}
					
					
					case 24867:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.or(((global::pony.events.Signal) (dynargs[0]) ));
					}
					
					
					case 4848343:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.and(((global::pony.events.Signal) (dynargs[0]) ));
					}
					
					
					case 783343062:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.removeAllNot();
					}
					
					
					case 240743468:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.removeNotArgs(((global::Array) (dynargs[0]) ));
					}
					
					
					case 346986231:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.notHandler(((global::Array) (dynargs[0]) ), ((global::pony.events.Event) (dynargs[1]) ));
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 899618832:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.notArgs(((global::Array) (dynargs[0]) ), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 605952922:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.removeAllBind();
					}
					
					
					case 2023034398:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.removeBindArgs(((global::Array) (dynargs[0]) ));
					}
					
					
					case 1111933837:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.bindHandler(((global::Array) (dynargs[0]) ), ((global::pony.events.Event) (dynargs[1]) ));
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 775868858:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.bindArgs(((global::Array) (dynargs[0]) ), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 2079393572:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.removeSubSignal(((global::pony.events.Signal) (dynargs[0]) ));
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 783593027:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.removeAllSub();
					}
					
					
					case 1731362585:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.removeSubArgs(((global::Array) (dynargs[0]) ));
					}
					
					
					case 1867302765:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.changeSubArgs(((global::Array) (dynargs[0]) ), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 1111449130:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.subHandler(((global::Array) (dynargs[0]) ), ((global::pony.events.Event) (dynargs[1]) ));
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 242754301:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.subArgs(((global::Array) (dynargs[0]) ), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 712510302:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.dispatchEmpty1(dynargs[0]);
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 1081751923:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						this.dispatchEmpty();
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						break;
					}
					
					
					case 1530424631:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.dispatchArgs(((global::Array) (dynargs[0]) ));
					}
					
					
					case 1181009664:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.dispatchEvent(((global::pony.events.Event) (dynargs[0]) ));
					}
					
					
					case 1236434305:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.once(dynargs[0], global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 343521524:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.changePriority(dynargs[0], global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 76061764:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.@remove(dynargs[0]);
					}
					
					
					case 4846113:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.@add(dynargs[0], global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 1169898256:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return this.init(dynargs[0]);
					}
					
					
					default:
					{
						#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("parent");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("listenersCount");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("haveListeners");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("notHandlers");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("notMap");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("bindHandlers");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("bindMap");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("subHandlers");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("subMap");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("lRunCopy");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("listeners");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("target");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("data");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("takeListeners");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("lostListeners");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("silent");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				baseArr.push("id");
				#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				{
					#line 42 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_subArgs_239__Fun : global::haxe.lang.Function {
		public    Signal_subArgs_239__Fun(global::Array<object> f, global::Array<object> a1) : base(1, 0){
			unchecked {
				#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.f = f;
				#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.a1 = a1;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Event a2 = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.events.Event) (((object) (__fn_float1) )) )) : (((global::pony.events.Event) (__fn_dyn1) )) );
				#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::haxe.lang.Function) (this.f[0]) ).__hx_invoke2_o(default(double), ((global::Array) (this.a1[0]) ), default(double), a2);
				#line 239 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<object> f;
		
		public  global::Array<object> a1;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_bindArgs_314__Fun : global::haxe.lang.Function {
		public    Signal_bindArgs_314__Fun(global::Array<object> a1, global::Array<object> f) : base(1, 0){
			unchecked {
				#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.a1 = a1;
				#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.f = f;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Event a2 = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.events.Event) (((object) (__fn_float1) )) )) : (((global::pony.events.Event) (__fn_dyn1) )) );
				#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::haxe.lang.Function) (this.f[0]) ).__hx_invoke2_o(default(double), ((global::Array) (this.a1[0]) ), default(double), a2);
				#line 314 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<object> a1;
		
		public  global::Array<object> f;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_notArgs_361__Fun : global::haxe.lang.Function {
		public    Signal_notArgs_361__Fun(global::Array<object> a1, global::Array<object> f) : base(1, 0){
			unchecked {
				#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.a1 = a1;
				#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.f = f;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Event a2 = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.events.Event) (((object) (__fn_float1) )) )) : (((global::pony.events.Event) (__fn_dyn1) )) );
				#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::haxe.lang.Function) (this.f[0]) ).__hx_invoke2_o(default(double), ((global::Array) (this.a1[0]) ), default(double), a2);
				#line 361 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<object> a1;
		
		public  global::Array<object> f;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_and_404__Fun : global::haxe.lang.Function {
		public    Signal_and_404__Fun(global::Array<bool> lock2, global::Array<object> e11, global::Array<object> _g, global::Array<object> ns) : base(1, 0){
			unchecked {
				#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.lock2 = lock2;
				#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.e11 = e11;
				#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this._g = _g;
				#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.ns = ns;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Event e2 = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.events.Event) (((object) (__fn_float1) )) )) : (((global::pony.events.Event) (__fn_dyn1) )) );
				this.lock2[0] = false;
				((global::pony.events.Signal) (this.ns[0]) ).dispatchEvent(new global::pony.events.Event(((global::Array) (global::haxe.lang.Runtime.callField(((global::pony.events.Event) (this.e11[0]) ).args, "concat", 1204816148, new global::Array<object>(new object[]{e2.args}))) ), ((object) (((global::pony.events.Signal) (this._g[0]) ).target) ), ((global::pony.events.Event) (this.e11[0]) )));
				#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<bool> lock2;
		
		public  global::Array<object> e11;
		
		public  global::Array<object> _g;
		
		public  global::Array<object> ns;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_and_401__Fun : global::haxe.lang.Function {
		public    Signal_and_401__Fun(global::Array<bool> lock2, global::Array<object> signal1, global::Array<bool> lock1, global::Array<object> _g, global::Array<object> ns) : base(1, 0){
			unchecked {
				#line 401 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.lock2 = lock2;
				#line 401 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.signal1 = signal1;
				#line 401 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.lock1 = lock1;
				#line 401 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this._g = _g;
				#line 401 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.ns = ns;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 401 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Event e1 = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.events.Event) (((object) (__fn_float1) )) )) : (((global::pony.events.Event) (__fn_dyn1) )) );
				#line 401 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::Array<object> e11 = new global::Array<object>(new object[]{e1});
				if (this.lock1[0]) {
					#line 402 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return default(object);
				}
				
				#line 403 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.lock2[0] = true;
				{
					#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object listener = global::pony.events._Listener.Listener_Impl_._fromFunction(global::pony._Function.Function_Impl_.@from(new global::pony.events.Signal_and_404__Fun(((global::Array<bool>) (this.lock2) ), ((global::Array<object>) (e11) ), ((global::Array<object>) (this._g) ), ((global::Array<object>) (this.ns) )), 1), true);
					#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					int priority = 0;
					#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object __temp_stmt416 = default(object);
					#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object f = global::haxe.lang.Runtime.getField(listener, "f", 102, true);
						#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object this1 = default(object);
						#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_getvar184 = f;
							#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							double __temp_ret185 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar184, "used", 1303220797, true)) );
							#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_expr417 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar184, "used", 1303220797, ( __temp_ret185 + 1.0 ))) );
							#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							double __temp_expr418 = __temp_ret185;
						}
						
						#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							bool __temp_odecl414 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "event", 1975830554, true));
							#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							bool __temp_odecl415 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener, "ignoreReturn", 98429794, true));
							#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this1 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f, __temp_odecl415, true, default(global::pony.events.Event), __temp_odecl414}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						__temp_stmt416 = this1;
					}
					
					#line 404 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					((global::pony.events.Signal) (this.signal1[0]) ).@add(((object) (__temp_stmt416) ), new global::haxe.lang.Null<int>(priority, true));
				}
				
				#line 401 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<bool> lock2;
		
		public  global::Array<object> signal1;
		
		public  global::Array<bool> lock1;
		
		public  global::Array<object> _g;
		
		public  global::Array<object> ns;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_and_412__Fun : global::haxe.lang.Function {
		public    Signal_and_412__Fun(global::Array<bool> lock1, global::Array<object> _g, global::Array<object> e22, global::Array<object> ns) : base(1, 0){
			unchecked {
				#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.lock1 = lock1;
				#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this._g = _g;
				#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.e22 = e22;
				#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.ns = ns;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Event e12 = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.events.Event) (((object) (__fn_float1) )) )) : (((global::pony.events.Event) (__fn_dyn1) )) );
				this.lock1[0] = false;
				((global::pony.events.Signal) (this.ns[0]) ).dispatchEvent(new global::pony.events.Event(((global::Array) (global::haxe.lang.Runtime.callField(e12.args, "concat", 1204816148, new global::Array<object>(new object[]{((global::pony.events.Event) (this.e22[0]) ).args}))) ), ((object) (((global::pony.events.Signal) (this._g[0]) ).target) ), ((global::pony.events.Event) (e12) )));
				#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<bool> lock1;
		
		public  global::Array<object> _g;
		
		public  global::Array<object> e22;
		
		public  global::Array<object> ns;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_and_409__Fun : global::haxe.lang.Function {
		public    Signal_and_409__Fun(global::Array<bool> lock2, global::Array<bool> lock1, global::Array<object> _g, global::Array<object> ns) : base(1, 0){
			unchecked {
				#line 409 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.lock2 = lock2;
				#line 409 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.lock1 = lock1;
				#line 409 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this._g = _g;
				#line 409 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.ns = ns;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 409 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::pony.events.Event e21 = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((global::pony.events.Event) (((object) (__fn_float1) )) )) : (((global::pony.events.Event) (__fn_dyn1) )) );
				#line 409 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::Array<object> e22 = new global::Array<object>(new object[]{e21});
				if (this.lock2[0]) {
					#line 410 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					return default(object);
				}
				
				#line 411 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.lock1[0] = true;
				{
					#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object listener1 = global::pony.events._Listener.Listener_Impl_._fromFunction(global::pony._Function.Function_Impl_.@from(new global::pony.events.Signal_and_412__Fun(((global::Array<bool>) (this.lock1) ), ((global::Array<object>) (this._g) ), ((global::Array<object>) (e22) ), ((global::Array<object>) (this.ns) )), 1), true);
					#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					int priority1 = 0;
					#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					object __temp_stmt421 = default(object);
					#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					{
						#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object f1 = global::haxe.lang.Runtime.getField(listener1, "f", 102, true);
						#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						object this2 = default(object);
						#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_getvar186 = f1;
							#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							double __temp_ret187 = ((double) (global::haxe.lang.Runtime.getField_f(__temp_getvar186, "used", 1303220797, true)) );
							#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							object __temp_expr422 = ((object) (global::haxe.lang.Runtime.setField(__temp_getvar186, "used", 1303220797, ( __temp_ret187 + 1.0 ))) );
							#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							double __temp_expr423 = __temp_ret187;
						}
						
						#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						{
							#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							bool __temp_odecl419 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "event", 1975830554, true));
							#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							bool __temp_odecl420 = global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.getField(listener1, "ignoreReturn", 98429794, true));
							#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
							this2 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 98429794, 373703110, 1247723251, 1975830554}), new global::Array<object>(new object[]{f1, __temp_odecl420, true, default(global::pony.events.Event), __temp_odecl419}), new global::Array<int>(new int[]{1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (1) ), ((double) (0) )}));
						}
						
						#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
						__temp_stmt421 = this2;
					}
					
					#line 412 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
					((global::pony.events.Signal) (this._g[0]) ).@add(((object) (__temp_stmt421) ), new global::haxe.lang.Null<int>(priority1, true));
				}
				
				#line 409 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<bool> lock2;
		
		public  global::Array<bool> lock1;
		
		public  global::Array<object> _g;
		
		public  global::Array<object> ns;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_buildListenerEvent_446__Fun : global::haxe.lang.Function {
		public    Signal_buildListenerEvent_446__Fun(global::Array<object> event1, global::Array<object> _g) : base(0, 0){
			unchecked {
				#line 446 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.event1 = event1;
				#line 446 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this._g = _g;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 446 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::pony.events.Signal) (this._g[0]) ).dispatchEvent(((global::pony.events.Event) (this.event1[0]) ));
				#line 446 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<object> event1;
		
		public  global::Array<object> _g;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_buildListenerArgs_447__Fun : global::haxe.lang.Function {
		public    Signal_buildListenerArgs_447__Fun(global::Array<object> @event, global::Array<object> _g) : base(0, 0){
			unchecked {
				#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.@event = @event;
				#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this._g = _g;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::pony.events.Signal) (this._g[0]) ).dispatchEvent(((global::pony.events.Event) (this.@event[0]) ));
				#line 447 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<object> @event;
		
		public  global::Array<object> _g;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_buildListenerEmpty_448__Fun : global::haxe.lang.Function {
		public    Signal_buildListenerEmpty_448__Fun(global::Array<object> @event, global::Array<object> _g) : base(0, 0){
			unchecked {
				#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.@event = @event;
				#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this._g = _g;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				((global::pony.events.Signal) (this._g[0]) ).dispatchEvent(((global::pony.events.Event) (this.@event[0]) ));
				#line 448 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<object> @event;
		
		public  global::Array<object> _g;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_sw_454__Fun : global::haxe.lang.Function {
		public    Signal_sw_454__Fun(global::Array<object> l21, global::Array<object> f2, global::Array<object> l11, global::Array<int> a1) : base(0, 0){
			unchecked {
				#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.l21 = l21;
				#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.f2 = f2;
				#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.l11 = l11;
				#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this.a1 = a1;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 454 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return ((global::pony.events.Signal) (((global::haxe.lang.Function) (this.f2[0]) ).__hx_invoke3_o(default(double), this.l11[0], default(double), this.l21[0], ((double) (this.a1[0]) ), global::haxe.lang.Runtime.undefined)) );
			}
			#line default
		}
		
		
		public  global::Array<object> l21;
		
		public  global::Array<object> f2;
		
		public  global::Array<object> l11;
		
		public  global::Array<int> a1;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Signal_debug_482__Fun : global::haxe.lang.Function {
		public    Signal_debug_482__Fun(global::Array<object> _g) : base(0, 0){
			unchecked {
				#line 482 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				this._g = _g;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 482 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				global::haxe.Log.trace.__hx_invoke2_o(default(double), global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("dispatch(", global::haxe.lang.Runtime.toString(((global::pony.events.Signal) (this._g[0]) ).id)), ")"), default(double), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"debug", "pony.events.Signal", "Signal.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (482) )})));
				#line 482 "C:\\data\\GitHub\\Pony\\pony\\events\\Signal.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<object> _g;
		
	}
}


