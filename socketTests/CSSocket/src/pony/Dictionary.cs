
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Dictionary<K, V> : global::haxe.lang.HxObject, global::pony.Dictionary {
		public    Dictionary(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Dictionary(global::haxe.lang.Null<int> maxDepth){
			unchecked {
				#line 46 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				global::pony.Dictionary<object, object>.__hx_ctor_pony_Dictionary<K, V>(this, maxDepth);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_Dictionary<K_c, V_c>(global::pony.Dictionary<K_c, V_c> __temp_me56, global::haxe.lang.Null<int> maxDepth){
			unchecked {
				#line 46 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				int __temp_maxDepth55 = ( ( ! (maxDepth.hasValue) ) ? (((int) (1) )) : (maxDepth.@value) );
				__temp_me56.maxDepth = __temp_maxDepth55;
				{
					#line 48 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					__temp_me56.ks = new global::Array<K_c>(new K_c[]{});
					#line 48 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					__temp_me56.vs = new global::Array<V_c>(new V_c[]{});
				}
				
			}
			#line default
		}
		
		
		public static   object __hx_cast<K_c_c, V_c_c>(global::pony.Dictionary me){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return ( (( me != default(global::pony.Dictionary) )) ? (me.pony_Dictionary_cast<K_c_c, V_c_c>()) : (default(global::pony.Dictionary)) );
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return new global::pony.Dictionary<object, object>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return new global::pony.Dictionary<object, object>(global::haxe.lang.Null<object>.ofDynamic<int>(arr[0]));
			}
			#line default
		}
		
		
		public virtual   object pony_Dictionary_cast<K_c, V_c>(){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				if (( global::haxe.lang.Runtime.eq(typeof(K), typeof(K_c)) && global::haxe.lang.Runtime.eq(typeof(V), typeof(V_c)) )) {
					#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					return this;
				}
				
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				global::pony.Dictionary<K_c, V_c> new_me = new global::pony.Dictionary<K_c, V_c>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				{
					#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					object __temp_iterator130 = global::Reflect.fields(this).iterator();
					#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator130, "hasNext", 407283053, default(global::Array)))){
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						string field = global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.callField(__temp_iterator130, "next", 1224901875, default(global::Array)));
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						switch (field){
							default:
							{
								#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
								global::Reflect.setField(new_me, field, ((object) (global::Reflect.field(this, field)) ));
								#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
								break;
							}
							
						}
						
					}
					
				}
				
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return new_me;
			}
			#line default
		}
		
		
		public  global::Array<K> ks;
		
		public  global::Array<V> vs;
		
		public  int count;
		
		public  int maxDepth;
		
		public   int getIndex(K k){
			unchecked {
				#line 51 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return global::pony.Tools.superIndexOf<K>(this.ks, k, new global::haxe.lang.Null<int>(this.maxDepth, true));
			}
			#line default
		}
		
		
		public virtual   int @set(K k, V v){
			unchecked {
				#line 54 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				int i = global::pony.Tools.superIndexOf<K>(this.ks, k, new global::haxe.lang.Null<int>(this.maxDepth, true));
				if (( i != -1 )) {
					#line 56 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					this.vs[i] = v;
					return i;
				}
				 else {
					#line 59 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					this.ks.push(k);
					return this.vs.push(v);
				}
				
			}
			#line default
		}
		
		
		public virtual   V @get(K k){
			unchecked {
				#line 65 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				int i = global::pony.Tools.superIndexOf<K>(this.ks, k, new global::haxe.lang.Null<int>(this.maxDepth, true));
				if (( i == -1 )) {
					#line 67 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					return default(V);
				}
				 else {
					#line 69 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					return this.vs[i];
				}
				
			}
			#line default
		}
		
		
		public   bool exists(K k){
			unchecked {
				#line 72 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return ( global::pony.Tools.superIndexOf<K>(this.ks, k, new global::haxe.lang.Null<int>(this.maxDepth, true)) != -1 );
			}
			#line default
		}
		
		
		public virtual   bool @remove(K k){
			unchecked {
				#line 75 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				int i = global::pony.Tools.superIndexOf<K>(this.ks, k, new global::haxe.lang.Null<int>(this.maxDepth, true));
				if (( i != -1 )) {
					#line 77 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					{
						#line 77 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.ks.splice(i, 1);
						#line 77 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.vs.splice(i, 1);
					}
					
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					return true;
				}
				 else {
					#line 80 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					return false;
				}
				
			}
			#line default
		}
		
		
		public   void removeIndex(int i){
			unchecked {
				#line 84 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				this.ks.splice(i, 1);
				this.vs.splice(i, 1);
			}
			#line default
		}
		
		
		public   void clear(){
			unchecked {
				#line 89 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				this.ks = new global::Array<K>(new K[]{});
				this.vs = new global::Array<V>(new V[]{});
			}
			#line default
		}
		
		
		public   object iterator(){
			unchecked {
				#line 93 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return ((object) (new global::_Array.ArrayIterator<V>(((global::Array<V>) (this.vs) ))) );
			}
			#line default
		}
		
		
		public   object keys(){
			unchecked {
				#line 95 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return ((object) (new global::_Array.ArrayIterator<K>(((global::Array<K>) (this.ks) ))) );
			}
			#line default
		}
		
		
		public virtual   string toString(){
			unchecked {
				#line 98 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				global::Array<object> a = new global::Array<object>(new object[]{});
				{
					#line 99 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					object __temp_iterator131 = ((object) (new global::_Array.ArrayIterator<K>(((global::Array<K>) (this.ks) ))) );
					#line 99 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator131, "hasNext", 407283053, default(global::Array)))){
						#line 99 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						K k = global::haxe.lang.Runtime.genericCast<K>(global::haxe.lang.Runtime.callField(__temp_iterator131, "next", 1224901875, default(global::Array)));
						a.push(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::Std.@string(k), ": "), global::Std.@string(this.@get(k))));
					}
					
				}
				
				#line 102 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("[", a.@join(", ")), "]");
			}
			#line default
		}
		
		
		public virtual   void removeValue(V v){
			unchecked {
				#line 106 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				int i = this.vs.indexOf(v, default(global::haxe.lang.Null<int>));
				if (( i != -1 )) {
					#line 108 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					this.ks.splice(i, 1);
					this.vs.splice(i, 1);
				}
				
			}
			#line default
		}
		
		
		public virtual   K getKey(V v){
			unchecked {
				#line 114 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				int i = this.vs.indexOf(v, default(global::haxe.lang.Null<int>));
				if (( i == -1 )) {
					#line 115 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
					return default(K);
				}
				
				#line 116 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return this.ks[i];
			}
			#line default
		}
		
		
		public   int getValueIndex(V v){
			unchecked {
				#line 119 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return this.vs.indexOf(v, default(global::haxe.lang.Null<int>));
			}
			#line default
		}
		
		
		public   int get_count(){
			unchecked {
				#line 121 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return this.ks.length;
			}
			#line default
		}
		
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				switch (hash){
					case 21447615:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.maxDepth = ((int) (@value) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return @value;
					}
					
					
					case 1248019663:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.count = ((int) (@value) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return @value;
					}
					
					
					default:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				switch (hash){
					case 21447615:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.maxDepth = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return @value;
					}
					
					
					case 1248019663:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.count = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return @value;
					}
					
					
					case 26429:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.vs = ((global::Array<V>) (global::Array<object>.__hx_cast<V>(((global::Array) (@value) ))) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return @value;
					}
					
					
					case 23976:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.ks = ((global::Array<K>) (global::Array<object>.__hx_cast<K>(((global::Array) (@value) ))) );
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return @value;
					}
					
					
					default:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				switch (hash){
					case 235708710:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_count") ), ((int) (235708710) ))) );
					}
					
					
					case 1109610007:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("getValueIndex") ), ((int) (1109610007) ))) );
					}
					
					
					case 589349545:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("getKey") ), ((int) (589349545) ))) );
					}
					
					
					case 804019341:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeValue") ), ((int) (804019341) ))) );
					}
					
					
					case 946786476:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("toString") ), ((int) (946786476) ))) );
					}
					
					
					case 1191633396:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("keys") ), ((int) (1191633396) ))) );
					}
					
					
					case 328878574:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("iterator") ), ((int) (328878574) ))) );
					}
					
					
					case 1213952397:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("clear") ), ((int) (1213952397) ))) );
					}
					
					
					case 1011382318:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("removeIndex") ), ((int) (1011382318) ))) );
					}
					
					
					case 76061764:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("remove") ), ((int) (76061764) ))) );
					}
					
					
					case 1071652316:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("exists") ), ((int) (1071652316) ))) );
					}
					
					
					case 5144726:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get") ), ((int) (5144726) ))) );
					}
					
					
					case 5741474:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("set") ), ((int) (5741474) ))) );
					}
					
					
					case 501983900:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("getIndex") ), ((int) (501983900) ))) );
					}
					
					
					case 21447615:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.maxDepth;
					}
					
					
					case 1248019663:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						if (handleProperties) {
							#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
							return this.get_count();
						}
						 else {
							#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
							return this.count;
						}
						
					}
					
					
					case 26429:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.vs;
					}
					
					
					case 23976:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.ks;
					}
					
					
					default:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				switch (hash){
					case 21447615:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return ((double) (this.maxDepth) );
					}
					
					
					case 1248019663:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						if (handleProperties) {
							#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
							return ((double) (this.get_count()) );
						}
						 else {
							#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
							return ((double) (this.count) );
						}
						
					}
					
					
					default:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				switch (hash){
					case 235708710:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.get_count();
					}
					
					
					case 1109610007:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.getValueIndex(global::haxe.lang.Runtime.genericCast<V>(dynargs[0]));
					}
					
					
					case 589349545:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.getKey(global::haxe.lang.Runtime.genericCast<V>(dynargs[0]));
					}
					
					
					case 804019341:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.removeValue(global::haxe.lang.Runtime.genericCast<V>(dynargs[0]));
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						break;
					}
					
					
					case 946786476:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.toString();
					}
					
					
					case 1191633396:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.keys();
					}
					
					
					case 328878574:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.iterator();
					}
					
					
					case 1213952397:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.clear();
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						break;
					}
					
					
					case 1011382318:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						this.removeIndex(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ));
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						break;
					}
					
					
					case 76061764:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.@remove(global::haxe.lang.Runtime.genericCast<K>(dynargs[0]));
					}
					
					
					case 1071652316:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.exists(global::haxe.lang.Runtime.genericCast<K>(dynargs[0]));
					}
					
					
					case 5144726:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.@get(global::haxe.lang.Runtime.genericCast<K>(dynargs[0]));
					}
					
					
					case 5741474:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.@set(global::haxe.lang.Runtime.genericCast<K>(dynargs[0]), global::haxe.lang.Runtime.genericCast<V>(dynargs[1]));
					}
					
					
					case 501983900:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return this.getIndex(global::haxe.lang.Runtime.genericCast<K>(dynargs[0]));
					}
					
					
					default:
					{
						#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				baseArr.push("maxDepth");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				baseArr.push("count");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				baseArr.push("vs");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				baseArr.push("ks");
				#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
				{
					#line 37 "C:\\data\\GitHub\\Pony\\pony\\Dictionary.hx"
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
	public  interface Dictionary : global::haxe.lang.IHxObject, global::haxe.lang.IGenericObject {
		   object pony_Dictionary_cast<K_c, V_c>();
		
	}
}


