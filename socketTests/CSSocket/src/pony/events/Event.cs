
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.events{
	public  class Event : global::haxe.lang.HxObject {
		public    Event(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Event(global::Array args, object target, global::pony.events.Event parent){
			unchecked {
				#line 47 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				global::pony.events.Event.__hx_ctor_pony_events_Event(this, args, target, parent);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_events_Event(global::pony.events.Event __temp_me73, global::Array args, object target, global::pony.events.Event parent){
			unchecked {
				#line 48 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				__temp_me73.target = target;
				if (( args == default(global::Array) )) {
					#line 49 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
					__temp_me73.args = new global::Array<object>(new object[]{});
				}
				 else {
					#line 49 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
					__temp_me73.args = args;
				}
				
				#line 50 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				__temp_me73.parent = parent;
				__temp_me73._stopPropagation = false;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				return new global::pony.events.Event(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				return new global::pony.events.Event(((global::Array) (arr[0]) ), ((object) (arr[1]) ), ((global::pony.events.Event) (arr[2]) ));
			}
			#line default
		}
		
		
		public  global::pony.events.Event parent;
		
		public  global::Array args;
		
		
		
		public  global::pony.events.Event prev;
		
		public  bool _stopPropagation;
		
		public  global::pony.events.Signal signal;
		
		public  object target;
		
		public  object currentListener;
		
		public   void _setListener(object l){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				this.currentListener = l;
			}
			#line default
		}
		
		
		public   void stopPropagation(global::haxe.lang.Null<int> lvl){
			unchecked {
				#line 56 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				int __temp_lvl72 = ( ( ! (lvl.hasValue) ) ? (((int) (-1) )) : (lvl.@value) );
				if (( ( this.parent != default(global::pony.events.Event) ) && (( ( __temp_lvl72 == -1 ) || ( __temp_lvl72 > 0 ) )) )) {
					#line 57 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
					this.parent.stopPropagation(new global::haxe.lang.Null<int>(( __temp_lvl72 - 1 ), true));
				}
				
				#line 58 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				this._stopPropagation = true;
			}
			#line default
		}
		
		
		public   int get_count(){
			unchecked {
				#line 61 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				return ((int) (global::haxe.lang.Runtime.getField_f(this.currentListener, "count", 1248019663, true)) );
			}
			#line default
		}
		
		
		public   int set_count(int v){
			unchecked {
				#line 63 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				return ((int) (global::haxe.lang.Runtime.setField_f(this.currentListener, "count", 1248019663, ((double) (v) ))) );
			}
			#line default
		}
		
		
		public   global::pony.events.Event get_prev(){
			unchecked {
				#line 65 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				return ((global::pony.events.Event) (global::haxe.lang.Runtime.getField(this.currentListener, "prev", 1247723251, true)) );
			}
			#line default
		}
		
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				switch (hash){
					case 209959373:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.currentListener = ((object) (@value) );
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					case 116192081:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.target = ((object) (@value) );
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					case 1248019663:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.set_count(((int) (@value) ));
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					default:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				switch (hash){
					case 209959373:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.currentListener = ((object) (@value) );
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					case 116192081:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.target = ((object) (@value) );
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					case 881208936:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.signal = ((global::pony.events.Signal) (@value) );
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					case 189842539:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this._stopPropagation = global::haxe.lang.Runtime.toBool(@value);
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					case 1247723251:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.prev = ((global::pony.events.Event) (@value) );
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					case 1248019663:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.set_count(((int) (global::haxe.lang.Runtime.toInt(@value)) ));
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					case 1081380189:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.args = ((global::Array) (@value) );
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					case 1836975402:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.parent = ((global::pony.events.Event) (@value) );
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return @value;
					}
					
					
					default:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				switch (hash){
					case 1243183740:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_prev") ), ((int) (1243183740) ))) );
					}
					
					
					case 1901956402:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("set_count") ), ((int) (1901956402) ))) );
					}
					
					
					case 235708710:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_count") ), ((int) (235708710) ))) );
					}
					
					
					case 544309738:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("stopPropagation") ), ((int) (544309738) ))) );
					}
					
					
					case 1318877239:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("_setListener") ), ((int) (1318877239) ))) );
					}
					
					
					case 209959373:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this.currentListener;
					}
					
					
					case 116192081:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this.target;
					}
					
					
					case 881208936:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this.signal;
					}
					
					
					case 189842539:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this._stopPropagation;
					}
					
					
					case 1247723251:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						if (handleProperties) {
							#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
							return this.get_prev();
						}
						 else {
							#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
							return this.prev;
						}
						
					}
					
					
					case 1248019663:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this.get_count();
					}
					
					
					case 1081380189:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this.args;
					}
					
					
					case 1836975402:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this.parent;
					}
					
					
					default:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				switch (hash){
					case 209959373:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return ((double) (global::haxe.lang.Runtime.toDouble(this.currentListener)) );
					}
					
					
					case 116192081:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return ((double) (global::haxe.lang.Runtime.toDouble(this.target)) );
					}
					
					
					case 1248019663:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return ((double) (this.get_count()) );
					}
					
					
					default:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				switch (hash){
					case 1243183740:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this.get_prev();
					}
					
					
					case 1901956402:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this.set_count(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ));
					}
					
					
					case 235708710:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return this.get_count();
					}
					
					
					case 544309738:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this.stopPropagation(global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[0]));
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						break;
					}
					
					
					case 1318877239:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						this._setListener(dynargs[0]);
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						break;
					}
					
					
					default:
					{
						#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				baseArr.push("currentListener");
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				baseArr.push("target");
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				baseArr.push("signal");
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				baseArr.push("_stopPropagation");
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				baseArr.push("prev");
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				baseArr.push("count");
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				baseArr.push("args");
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				baseArr.push("parent");
				#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
				{
					#line 35 "C:\\data\\GitHub\\Pony\\pony\\events\\Event.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}


