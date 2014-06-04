
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Priority<T> : global::haxe.lang.HxObject, global::pony.Priority {
		public    Priority(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Priority(global::Array<T> data){
			unchecked {
				#line 85 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				global::pony.Priority<object>.__hx_ctor_pony_Priority<T>(this, data);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_Priority<T_c>(global::pony.Priority<T_c> __temp_me63, global::Array<T_c> data){
			unchecked {
				#line 73 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				__temp_me63.@double = false;
				#line 86 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				__temp_me63.clear();
				if (( data != default(global::Array<T_c>) )) {
					#line 88 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g = 0;
					#line 88 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (( _g < data.length )){
						#line 88 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						T_c e = data[_g];
						#line 88 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						 ++ _g;
						#line 88 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						__temp_me63.addElement(e, default(global::haxe.lang.Null<int>));
					}
					
				}
				
			}
			#line default
		}
		
		
		public static   object __hx_cast<T_c_c>(global::pony.Priority me){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return ( (( me != default(global::pony.Priority) )) ? (me.pony_Priority_cast<T_c_c>()) : (default(global::pony.Priority)) );
			}
			#line default
		}
		
		
		public static   global::pony.Priority<object> createIds(global::Array<object> a){
			unchecked {
				#line 350 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int i = 0;
				global::Array<object> __temp_stmt313 = default(global::Array<object>);
				#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				{
					#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					global::Array<object> _g = new global::Array<object>(new object[]{});
					#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					{
						#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						int _g1 = 0;
						#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						while (( _g1 < a.length )){
							#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							string e = global::haxe.lang.Runtime.toString(a[_g1]);
							#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							 ++ _g1;
							#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							object __temp_stmt314 = default(object);
							#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							{
								#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
								int __temp_odecl312 = i++;
								#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
								__temp_stmt314 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{1224700491}), new global::Array<object>(new object[]{e}), new global::Array<int>(new int[]{23515}), new global::Array<double>(new double[]{((double) (__temp_odecl312) )}));
							}
							
							#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							_g.push(__temp_stmt314);
						}
						
					}
					
					#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					__temp_stmt313 = _g;
				}
				
				#line 351 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return new global::pony.Priority<object>(((global::Array<object>) (__temp_stmt313) ));
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return new global::pony.Priority<object>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return new global::pony.Priority<object>(((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (arr[0]) ))) ));
			}
			#line default
		}
		
		
		public virtual   object pony_Priority_cast<T_c>(){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (global::haxe.lang.Runtime.eq(typeof(T), typeof(T_c))) {
					#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					return this;
				}
				
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				global::pony.Priority<T_c> new_me = new global::pony.Priority<T_c>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				{
					#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					object __temp_iterator138 = global::Reflect.fields(this).iterator();
					#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator138, "hasNext", 407283053, default(global::Array)))){
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						string field = global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.callField(__temp_iterator138, "next", 1224901875, default(global::Array)));
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						switch (field){
							default:
							{
								#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
								global::Reflect.setField(new_me, field, ((object) (global::Reflect.field(this, field)) ));
								#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
								break;
							}
							
						}
						
					}
					
				}
				
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return new_me;
			}
			#line default
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public  bool @double;
		
		
		
		public  global::Array<T> data;
		
		public  global::haxe.ds.IntMap<int> hash;
		
		public  global::Array<int> counters;
		
		public virtual   global::pony.Priority<T> addElement(T e, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 99 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int __temp_priority57 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				bool __temp_boolv304 =  ! (this.@double) ;
				#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				bool __temp_boolv303 = false;
				#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (__temp_boolv304) {
					#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					{
						#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						global::Array<T> element = new global::Array<T>(new T[]{e});
						#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						__temp_boolv303 = global::Lambda.exists<T>(this.data, new global::pony.Priority_addElement_100__Fun<T>(((global::Array<T>) (element) )));
					}
					
				}
				
				#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				bool __temp_stmt302 = ( __temp_boolv304 && __temp_boolv303 );
				#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (__temp_stmt302) {
					#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					return this;
				}
				
				#line 101 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int s = default(int);
				#line 101 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (this.hash.exists(__temp_priority57)) {
					#line 101 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					s = this.hash.@get(__temp_priority57).@value;
				}
				 else {
					#line 101 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					s = 0;
				}
				
				#line 102 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int c = 0;
				{
					#line 103 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					object __temp_iterator139 = this.hash.keys();
					#line 103 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator139, "hasNext", 407283053, default(global::Array)))){
						#line 103 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						int k = ((int) (global::haxe.lang.Runtime.toInt(global::haxe.lang.Runtime.callField(__temp_iterator139, "next", 1224901875, default(global::Array)))) );
						if (( k < __temp_priority57 )) {
							#line 104 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							c += this.hash.@get(k).@value;
						}
						
					}
					
				}
				
				#line 105 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				c += s;
				this.data.insert(c, e);
				{
					#line 107 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g1 = 0;
					#line 107 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g = this.counters.length;
					#line 107 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (( _g1 < _g )){
						#line 107 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						int k1 = _g1++;
						if (( c < this.counters[k1] )) {
							#line 108 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							this.counters[k1]++;
						}
						
					}
					
				}
				
				#line 109 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.hash.@set(__temp_priority57, ( s + 1 ));
				return this;
			}
			#line default
		}
		
		
		public   global::pony.Priority<T> addArray(global::Array<T> a, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 118 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int __temp_priority58 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				{
					#line 119 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g = 0;
					#line 119 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (( _g < a.length )){
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						T e = a[_g];
						#line 119 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						 ++ _g;
						this.addElement(e, new global::haxe.lang.Null<int>(__temp_priority58, true));
					}
					
				}
				
				#line 121 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this;
			}
			#line default
		}
		
		
		public virtual   object iterator(){
			unchecked {
				#line 133 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				global::Array<object> _g = new global::Array<object>(new object[]{this});
				global::Array<int> n = new global::Array<int>(new int[]{( this.counters.push(0) - 1 )});
				{
					#line 136 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					global::haxe.lang.Function __temp_odecl305 = new global::pony.Priority_iterator_136__Fun<T>(((global::Array<object>) (_g) ), ((global::Array<int>) (n) ));
					#line 145 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					global::haxe.lang.Function __temp_odecl306 = new global::pony.Priority_iterator_145__Fun<T>(((global::Array<object>) (_g) ), ((global::Array<int>) (n) ));
					#line 135 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					return new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{407283053, 1224901875}), new global::Array<object>(new object[]{__temp_odecl305, __temp_odecl306}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
				}
				
			}
			#line default
		}
		
		
		public virtual   global::pony.Priority<T> clear(){
			unchecked {
				#line 153 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.hash = new global::haxe.ds.IntMap<int>();
				this.data = new global::Array<T>();
				this.counters = new global::Array<int>(new int[]{0});
				return this;
			}
			#line default
		}
		
		
		public virtual   void destroy(){
			unchecked {
				#line 160 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.hash = default(global::haxe.ds.IntMap<int>);
				this.data = default(global::Array<T>);
				this.counters = default(global::Array<int>);
			}
			#line default
		}
		
		
		public   bool existsElement(T element){
			unchecked {
				#line 165 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				global::Array<T> element1 = new global::Array<T>(new T[]{element});
				return global::Lambda.exists<T>(this.data, new global::pony.Priority_existsElement_166__Fun<T>(((global::Array<T>) (element1) )));
			}
			#line default
		}
		
		
		public   bool existsFunction(global::haxe.lang.Function f){
			unchecked {
				#line 168 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return global::Lambda.exists<T>(this.data, f);
			}
			#line default
		}
		
		
		public virtual   bool existsArray(global::Array<T> a){
			unchecked {
				#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				{
					#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g = 0;
					#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (( _g < a.length )){
						#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						T e = a[_g];
						#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						 ++ _g;
						#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						bool __temp_stmt307 = default(bool);
						#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						{
							#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							global::Array<T> element = new global::Array<T>(new T[]{e});
							#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							__temp_stmt307 = global::Lambda.exists<T>(this.data, new global::pony.Priority_existsArray_171__Fun<T>(((global::Array<T>) (element) )));
						}
						
						#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						if (__temp_stmt307) {
							#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							return true;
						}
						
					}
					
				}
				
				#line 172 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return false;
			}
			#line default
		}
		
		
		public virtual   T search(global::haxe.lang.Function f){
			unchecked {
				#line 178 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				global::Array<object> f1 = new global::Array<object>(new object[]{f});
				global::Array<T> s = new global::Array<T>(new T[]{default(T)});
				global::Lambda.exists<T>(this.data, new global::pony.Priority_search_180__Fun<T>(((global::Array<T>) (s) ), ((global::Array<object>) (f1) )));
				#line 187 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return s[0];
			}
			#line default
		}
		
		
		public virtual   bool removeElement(T e){
			unchecked {
				#line 194 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int i = this.data.indexOf(e, default(global::haxe.lang.Null<int>));
				if (( i == -1 )) {
					#line 195 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					return false;
				}
				
				#line 196 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				{
					#line 196 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g1 = 0;
					#line 196 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g = this.counters.length;
					#line 196 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (( _g1 < _g )){
						#line 196 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						int k = _g1++;
						if (( i < this.counters[k] )) {
							#line 197 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							this.counters[k]--;
						}
						
					}
					
				}
				
				#line 198 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.data.@remove(e);
				global::Array<int> a = new global::Array<int>(new int[]{});
				{
					#line 200 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					object __temp_iterator140 = this.hash.keys();
					#line 200 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator140, "hasNext", 407283053, default(global::Array)))){
						#line 200 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						int k1 = ((int) (global::haxe.lang.Runtime.toInt(global::haxe.lang.Runtime.callField(__temp_iterator140, "next", 1224901875, default(global::Array)))) );
						a.push(k1);
					}
					
				}
				
				#line 202 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				a.sort(( (( global::pony.Priority_removeElement_202__Fun.__hx_current != default(global::pony.Priority_removeElement_202__Fun) )) ? (global::pony.Priority_removeElement_202__Fun.__hx_current) : (global::pony.Priority_removeElement_202__Fun.__hx_current = ((global::pony.Priority_removeElement_202__Fun) (new global::pony.Priority_removeElement_202__Fun()) )) ));
				{
					#line 203 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g2 = 0;
					#line 203 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (( _g2 < a.length )){
						#line 203 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						int k2 = a[_g2];
						#line 203 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						 ++ _g2;
						if (( i > 0 )) {
							#line 205 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							i -= this.hash.@get(k2).@value;
						}
						 else {
							#line 207 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							{
								#line 207 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
								int @value = ( this.hash.@get(k2).@value - 1 );
								#line 207 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
								this.hash.@set(k2, @value);
							}
							
							#line 208 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							break;
						}
						
					}
					
				}
				
				#line 211 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (this.@double) {
					#line 211 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					this.removeElement(e);
				}
				
				#line 212 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return true;
			}
			#line default
		}
		
		
		public virtual   bool removeFunction(global::haxe.lang.Function f){
			unchecked {
				#line 216 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				T e = this.search(f);
				if (( ! (global::haxe.lang.Runtime.eq(e, default(T))) )) {
					#line 217 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					return this.removeElement(e);
				}
				 else {
					#line 218 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					return false;
				}
				
			}
			#line default
		}
		
		
		public virtual   bool removeArray(global::Array<T> a){
			unchecked {
				#line 222 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				bool f = true;
				{
					#line 223 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g = 0;
					#line 223 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (( _g < a.length )){
						#line 223 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						T e = a[_g];
						#line 223 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						 ++ _g;
						#line 223 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						if ( ! (this.removeElement(e)) ) {
							#line 223 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							f = false;
						}
						
					}
					
				}
				
				#line 224 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return f;
			}
			#line default
		}
		
		
		public virtual   void repriority(global::haxe.lang.Null<int> priority){
			unchecked {
				#line 231 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int __temp_priority59 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				this.hash = new global::haxe.ds.IntMap<int>();
				this.hash.@set(__temp_priority59, this.data.length);
			}
			#line default
		}
		
		
		public virtual   global::pony.Priority<T> changeElement(T e, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 236 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int __temp_priority60 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				if (this.removeElement(e)) {
					#line 237 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					this.addElement(e, new global::haxe.lang.Null<int>(__temp_priority60, true));
				}
				 else {
					#line 238 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					throw global::haxe.lang.HaxeException.wrap("Element not exists");
				}
				
				#line 239 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this;
			}
			#line default
		}
		
		
		public virtual   global::pony.Priority<T> changeFunction(global::haxe.lang.Function f, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 242 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int __temp_priority61 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				T e = this.search(f);
				return this.changeElement(e, new global::haxe.lang.Null<int>(__temp_priority61, true));
			}
			#line default
		}
		
		
		public virtual   global::pony.Priority<T> changeArray(global::Array<T> a, global::haxe.lang.Null<int> priority){
			unchecked {
				#line 247 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int __temp_priority62 = ( ( ! (priority.hasValue) ) ? (((int) (0) )) : (priority.@value) );
				{
					#line 248 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					int _g = 0;
					#line 248 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (( _g < a.length )){
						#line 248 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						T e = a[_g];
						#line 248 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						 ++ _g;
						#line 248 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.changeElement(e, new global::haxe.lang.Null<int>(__temp_priority62, true));
					}
					
				}
				
				#line 249 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this;
			}
			#line default
		}
		
		
		public   string toString(){
			unchecked {
				#line 252 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this.data.toString();
			}
			#line default
		}
		
		
		public   string @join(string sep){
			unchecked {
				#line 254 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this.data.@join(sep);
			}
			#line default
		}
		
		
		public   T get_first(){
			unchecked {
				#line 256 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this.data[0];
			}
			#line default
		}
		
		
		public   T get_last(){
			unchecked {
				#line 258 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this.data[( this.data.length - 1 )];
			}
			#line default
		}
		
		
		public   int get_length(){
			unchecked {
				#line 260 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this.data.length;
			}
			#line default
		}
		
		
		public   bool get_empty(){
			unchecked {
				#line 265 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return ( this.data.length == 0 );
			}
			#line default
		}
		
		
		public virtual   T loop(){
			unchecked {
				#line 272 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (( this.counters[0] >= this.data.length )) {
					#line 273 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					this.counters[0] = 0;
					if (( this.data.length == 0 )) {
						#line 274 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return default(T);
					}
					
				}
				
				#line 276 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this.data[this.counters[0]++];
			}
			#line default
		}
		
		
		public   global::pony.Priority<T> resetLoop(){
			unchecked {
				#line 283 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.counters[0] = 0;
				return this;
			}
			#line default
		}
		
		
		public   void reloop(T e){
			unchecked {
				#line 292 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				while (( ! (global::haxe.lang.Runtime.eq(this.loop(), e)) )){
					#line 292 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					object __temp_expr308 = default(object);
				}
				
			}
			#line default
		}
		
		
		public   T get_current(){
			unchecked {
				#line 298 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (( this.counters[0] > this.data.length )) {
					#line 298 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					return this.data[0];
				}
				 else {
					#line 298 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					if (( this.counters[0] < 1 )) {
						#line 298 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.data[( this.data.length - 1 )];
					}
					 else {
						#line 298 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.data[( this.counters[0] - 1 )];
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   T backLoop(){
			unchecked {
				#line 306 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (( this.data.length == 0 )) {
					#line 307 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					this.counters[0] = 0;
					return default(T);
				}
				
				#line 310 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.counters[0]--;
				if (( this.counters[0] < 1 )) {
					#line 311 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					this.counters[0] = this.data.length;
				}
				
				#line 312 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return this.data[( this.counters[0] - 1 )];
			}
			#line default
		}
		
		
		public virtual   int get_min(){
			unchecked {
				#line 319 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				global::haxe.lang.Null<int> n = default(global::haxe.lang.Null<int>);
				{
					#line 320 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					object __temp_iterator141 = this.hash.keys();
					#line 320 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator141, "hasNext", 407283053, default(global::Array)))){
						#line 320 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						int k = ((int) (global::haxe.lang.Runtime.toInt(global::haxe.lang.Runtime.callField(__temp_iterator141, "next", 1224901875, default(global::Array)))) );
						if ((  ! (n.hasValue)  || ( k < n.@value ) )) {
							#line 322 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							n = new global::haxe.lang.Null<int>(k, true);
						}
						
					}
					
				}
				
				#line 323 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return n.@value;
			}
			#line default
		}
		
		
		public virtual   int get_max(){
			unchecked {
				#line 330 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				global::haxe.lang.Null<int> n = default(global::haxe.lang.Null<int>);
				{
					#line 331 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					object __temp_iterator142 = this.hash.keys();
					#line 331 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator142, "hasNext", 407283053, default(global::Array)))){
						#line 331 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						int k = ((int) (global::haxe.lang.Runtime.toInt(global::haxe.lang.Runtime.callField(__temp_iterator142, "next", 1224901875, default(global::Array)))) );
						if ((  ! (n.hasValue)  || ( k > n.@value ) )) {
							#line 333 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
							n = new global::haxe.lang.Null<int>(k, true);
						}
						
					}
					
				}
				
				#line 334 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return n.@value;
			}
			#line default
		}
		
		
		public   void addElementToBegin(T e){
			unchecked {
				#line 341 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.addElement(e, new global::haxe.lang.Null<int>(( this.get_min() - 1 ), true));
			}
			#line default
		}
		
		
		public   void addElementToEnd(T e){
			unchecked {
				#line 347 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.addElement(e, new global::haxe.lang.Null<int>(( this.get_max() + 1 ), true));
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				switch (hash){
					case 287272439:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.counters = ((global::Array<int>) (global::Array<object>.__hx_cast<int>(((global::Array) (@value) ))) );
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return @value;
					}
					
					
					case 1158164430:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.hash = ((global::haxe.ds.IntMap<int>) (global::haxe.ds.IntMap<object>.__hx_cast<int>(((global::haxe.ds.IntMap) (@value) ))) );
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return @value;
					}
					
					
					case 1113806378:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.data = ((global::Array<T>) (global::Array<object>.__hx_cast<T>(((global::Array) (@value) ))) );
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return @value;
					}
					
					
					case 852175633:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.@double = global::haxe.lang.Runtime.toBool(@value);
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return @value;
					}
					
					
					default:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				switch (hash){
					case 2056779909:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("addElementToEnd") ), ((int) (2056779909) ))) );
					}
					
					
					case 180804947:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("addElementToBegin") ), ((int) (180804947) ))) );
					}
					
					
					case 650629947:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_max") ), ((int) (650629947) ))) );
					}
					
					
					case 650631721:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_min") ), ((int) (650631721) ))) );
					}
					
					
					case 179784747:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("backLoop") ), ((int) (179784747) ))) );
					}
					
					
					case 1373502544:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_current") ), ((int) (1373502544) ))) );
					}
					
					
					case 64970647:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("reloop") ), ((int) (64970647) ))) );
					}
					
					
					case 228831187:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("resetLoop") ), ((int) (228831187) ))) );
					}
					
					
					case 1203218020:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("loop") ), ((int) (1203218020) ))) );
					}
					
					
					case 864261860:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_empty") ), ((int) (864261860) ))) );
					}
					
					
					case 261031087:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_length") ), ((int) (261031087) ))) );
					}
					
					
					case 1197983199:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_last") ), ((int) (1197983199) ))) );
					}
					
					
					case 1145492615:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_first") ), ((int) (1145492615) ))) );
					}
					
					
					case 1181037546:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("join") ), ((int) (1181037546) ))) );
					}
					
					
					case 946786476:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("toString") ), ((int) (946786476) ))) );
					}
					
					
					case 1263867401:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("changeArray") ), ((int) (1263867401) ))) );
					}
					
					
					case 1838016680:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("changeFunction") ), ((int) (1838016680) ))) );
					}
					
					
					case 1730761516:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("changeElement") ), ((int) (1730761516) ))) );
					}
					
					
					case 363219479:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("repriority") ), ((int) (363219479) ))) );
					}
					
					
					case 600001205:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeArray") ), ((int) (600001205) ))) );
					}
					
					
					case 1588127612:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeFunction") ), ((int) (1588127612) ))) );
					}
					
					
					case 1594821336:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeElement") ), ((int) (1594821336) ))) );
					}
					
					
					case 1660395368:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("search") ), ((int) (1660395368) ))) );
					}
					
					
					case 1020723741:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("existsArray") ), ((int) (1020723741) ))) );
					}
					
					
					case 775930132:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("existsFunction") ), ((int) (775930132) ))) );
					}
					
					
					case 772631616:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("existsElement") ), ((int) (772631616) ))) );
					}
					
					
					case 612773114:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("destroy") ), ((int) (612773114) ))) );
					}
					
					
					case 1213952397:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("clear") ), ((int) (1213952397) ))) );
					}
					
					
					case 328878574:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("iterator") ), ((int) (328878574) ))) );
					}
					
					
					case 518820792:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("addArray") ), ((int) (518820792) ))) );
					}
					
					
					case 1843321499:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("addElement") ), ((int) (1843321499) ))) );
					}
					
					
					case 287272439:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.counters;
					}
					
					
					case 1158164430:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.hash;
					}
					
					
					case 1113806378:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.data;
					}
					
					
					case 1273207865:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_current();
					}
					
					
					case 852175633:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.@double;
					}
					
					
					case 1876572813:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_empty();
					}
					
					
					case 1202522710:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_last();
					}
					
					
					case 10319920:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_first();
					}
					
					
					case 5442212:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_max();
					}
					
					
					case 5443986:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_min();
					}
					
					
					case 520590566:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_length();
					}
					
					
					default:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				switch (hash){
					case 1273207865:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						T __temp_stmt309 = default(T);
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((double) (global::haxe.lang.Runtime.toDouble(((object) (this.get_current()) ))) );
					}
					
					
					case 1202522710:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						T __temp_stmt310 = default(T);
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((double) (global::haxe.lang.Runtime.toDouble(((object) (this.get_last()) ))) );
					}
					
					
					case 10319920:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						T __temp_stmt311 = default(T);
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((double) (global::haxe.lang.Runtime.toDouble(((object) (this.get_first()) ))) );
					}
					
					
					case 5442212:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((double) (this.get_max()) );
					}
					
					
					case 5443986:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((double) (this.get_min()) );
					}
					
					
					case 520590566:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return ((double) (this.get_length()) );
					}
					
					
					default:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				switch (hash){
					case 2056779909:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.addElementToEnd(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]));
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						break;
					}
					
					
					case 180804947:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.addElementToBegin(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]));
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						break;
					}
					
					
					case 650629947:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_max();
					}
					
					
					case 650631721:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_min();
					}
					
					
					case 179784747:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.backLoop();
					}
					
					
					case 1373502544:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_current();
					}
					
					
					case 64970647:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.reloop(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]));
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						break;
					}
					
					
					case 228831187:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.resetLoop();
					}
					
					
					case 1203218020:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.loop();
					}
					
					
					case 864261860:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_empty();
					}
					
					
					case 261031087:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_length();
					}
					
					
					case 1197983199:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_last();
					}
					
					
					case 1145492615:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.get_first();
					}
					
					
					case 1181037546:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.@join(global::haxe.lang.Runtime.toString(dynargs[0]));
					}
					
					
					case 946786476:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.toString();
					}
					
					
					case 1263867401:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.changeArray(((global::Array<T>) (global::Array<object>.__hx_cast<T>(((global::Array) (dynargs[0]) ))) ), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 1838016680:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.changeFunction(((global::haxe.lang.Function) (dynargs[0]) ), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 1730761516:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.changeElement(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 363219479:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.repriority(global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[0]));
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						break;
					}
					
					
					case 600001205:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.removeArray(((global::Array<T>) (global::Array<object>.__hx_cast<T>(((global::Array) (dynargs[0]) ))) ));
					}
					
					
					case 1588127612:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.removeFunction(((global::haxe.lang.Function) (dynargs[0]) ));
					}
					
					
					case 1594821336:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.removeElement(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]));
					}
					
					
					case 1660395368:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.search(((global::haxe.lang.Function) (dynargs[0]) ));
					}
					
					
					case 1020723741:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.existsArray(((global::Array<T>) (global::Array<object>.__hx_cast<T>(((global::Array) (dynargs[0]) ))) ));
					}
					
					
					case 775930132:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.existsFunction(((global::haxe.lang.Function) (dynargs[0]) ));
					}
					
					
					case 772631616:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.existsElement(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]));
					}
					
					
					case 612773114:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						this.destroy();
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						break;
					}
					
					
					case 1213952397:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.clear();
					}
					
					
					case 328878574:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.iterator();
					}
					
					
					case 518820792:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.addArray(((global::Array<T>) (global::Array<object>.__hx_cast<T>(((global::Array) (dynargs[0]) ))) ), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					case 1843321499:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return this.addElement(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
					}
					
					
					default:
					{
						#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("counters");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("hash");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("data");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("current");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("double");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("empty");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("last");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("first");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("max");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("min");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				baseArr.push("length");
				#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				{
					#line 38 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
		public override string ToString(){
			return this.toString();
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Priority_addElement_100__Fun<T> : global::haxe.lang.Function {
		public    Priority_addElement_100__Fun(global::Array<T> element) : base(1, 0){
			unchecked {
				#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.element = element;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				T e1 = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (global::haxe.lang.Runtime.genericCast<T>(((object) (__fn_float1) ))) : (global::haxe.lang.Runtime.genericCast<T>(__fn_dyn1)) );
				#line 100 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return global::haxe.lang.Runtime.eq(e1, this.element[0]);
			}
			#line default
		}
		
		
		public  global::Array<T> element;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Priority_iterator_136__Fun<T> : global::haxe.lang.Function {
		public    Priority_iterator_136__Fun(global::Array<object> _g, global::Array<int> n) : base(0, 0){
			unchecked {
				#line 136 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this._g = _g;
				#line 136 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.n = n;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 137 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (( ((global::pony.Priority<T>) (global::pony.Priority<object>.__hx_cast<T>(((global::pony.Priority) (this._g[0]) ))) ).counters.length < this.n[0] )) {
					#line 137 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					((global::pony.Priority<T>) (global::pony.Priority<object>.__hx_cast<T>(((global::pony.Priority) (this._g[0]) ))) ).counters.push(this.n[0]);
				}
				
				#line 138 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				if (( ! (global::haxe.lang.Runtime.eq(((global::pony.Priority<T>) (global::pony.Priority<object>.__hx_cast<T>(((global::pony.Priority) (this._g[0]) ))) ).data[((global::pony.Priority<T>) (global::pony.Priority<object>.__hx_cast<T>(((global::pony.Priority) (this._g[0]) ))) ).counters[this.n[0]]], default(T))) )) {
					#line 139 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					return true;
				}
				 else {
					#line 141 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					((global::pony.Priority<T>) (global::pony.Priority<object>.__hx_cast<T>(((global::pony.Priority) (this._g[0]) ))) ).counters.splice(this.n[0], 1);
					return false;
				}
				
			}
			#line default
		}
		
		
		public  global::Array<object> _g;
		
		public  global::Array<int> n;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Priority_iterator_145__Fun<T> : global::haxe.lang.Function {
		public    Priority_iterator_145__Fun(global::Array<object> _g, global::Array<int> n) : base(0, 0){
			unchecked {
				#line 145 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this._g = _g;
				#line 145 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.n = n;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 145 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return ((global::pony.Priority<T>) (global::pony.Priority<object>.__hx_cast<T>(((global::pony.Priority) (this._g[0]) ))) ).data[((global::pony.Priority<T>) (global::pony.Priority<object>.__hx_cast<T>(((global::pony.Priority) (this._g[0]) ))) ).counters[this.n[0]]++];
			}
			#line default
		}
		
		
		public  global::Array<object> _g;
		
		public  global::Array<int> n;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Priority_existsElement_166__Fun<T> : global::haxe.lang.Function {
		public    Priority_existsElement_166__Fun(global::Array<T> element1) : base(1, 0){
			unchecked {
				#line 166 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.element1 = element1;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 166 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				T e = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (global::haxe.lang.Runtime.genericCast<T>(((object) (__fn_float1) ))) : (global::haxe.lang.Runtime.genericCast<T>(__fn_dyn1)) );
				#line 166 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return global::haxe.lang.Runtime.eq(e, this.element1[0]);
			}
			#line default
		}
		
		
		public  global::Array<T> element1;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Priority_existsArray_171__Fun<T> : global::haxe.lang.Function {
		public    Priority_existsArray_171__Fun(global::Array<T> element) : base(1, 0){
			unchecked {
				#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.element = element;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				T e1 = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (global::haxe.lang.Runtime.genericCast<T>(((object) (__fn_float1) ))) : (global::haxe.lang.Runtime.genericCast<T>(__fn_dyn1)) );
				#line 171 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return global::haxe.lang.Runtime.eq(e1, this.element[0]);
			}
			#line default
		}
		
		
		public  global::Array<T> element;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Priority_search_180__Fun<T> : global::haxe.lang.Function {
		public    Priority_search_180__Fun(global::Array<T> s, global::Array<object> f1) : base(1, 0){
			unchecked {
				#line 181 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.s = s;
				#line 181 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				this.f1 = f1;
			}
			#line default
		}
		
		
		public override   object __hx_invoke1_o(double __fn_float1, object __fn_dyn1){
			unchecked {
				#line 180 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				T e = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (global::haxe.lang.Runtime.genericCast<T>(((object) (__fn_float1) ))) : (global::haxe.lang.Runtime.genericCast<T>(__fn_dyn1)) );
				if (global::haxe.lang.Runtime.toBool(((global::haxe.lang.Function) (this.f1[0]) ).__hx_invoke1_o(default(double), e))) {
					#line 182 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					this.s[0] = e;
					return true;
				}
				 else {
					#line 185 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
					return false;
				}
				
			}
			#line default
		}
		
		
		public  global::Array<T> s;
		
		public  global::Array<object> f1;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Priority_removeElement_202__Fun : global::haxe.lang.Function {
		public    Priority_removeElement_202__Fun() : base(2, 1){
			unchecked {
			}
			#line default
		}
		
		
		public static  global::pony.Priority_removeElement_202__Fun __hx_current;
		
		public override   double __hx_invoke2_f(double __fn_float1, object __fn_dyn1, double __fn_float2, object __fn_dyn2){
			unchecked {
				#line 202 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int y = ( (global::haxe.lang.Runtime.eq(__fn_dyn2, global::haxe.lang.Runtime.undefined)) ? (((int) (__fn_float2) )) : (((int) (global::haxe.lang.Runtime.toInt(__fn_dyn2)) )) );
				#line 202 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				int x = ( (global::haxe.lang.Runtime.eq(__fn_dyn1, global::haxe.lang.Runtime.undefined)) ? (((int) (__fn_float1) )) : (((int) (global::haxe.lang.Runtime.toInt(__fn_dyn1)) )) );
				#line 202 "C:\\data\\GitHub\\Pony\\pony\\Priority.hx"
				return ((double) (( x - y )) );
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  interface Priority : global::haxe.lang.IHxObject, global::haxe.lang.IGenericObject {
		   object pony_Priority_cast<T_c>();
		
	}
}


