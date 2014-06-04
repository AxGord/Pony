
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.ds{
	public  class StringMap<T> : global::haxe.lang.HxObject, global::haxe.ds.StringMap, global::IMap<object, T> {
		public    StringMap(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    StringMap(){
			unchecked {
				#line 59 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				global::haxe.ds.StringMap<object>.__hx_ctor_haxe_ds_StringMap<T>(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_ds_StringMap<T_c>(global::haxe.ds.StringMap<T_c> __temp_me36){
			unchecked {
				#line 61 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				__temp_me36.cachedIndex = -1;
			}
			#line default
		}
		
		
		public static   object __hx_cast<T_c_c>(global::haxe.ds.StringMap me){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				return ( (( me != default(global::haxe.ds.StringMap) )) ? (me.haxe_ds_StringMap_cast<T_c_c>()) : (default(global::haxe.ds.StringMap)) );
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				return new global::haxe.ds.StringMap<object>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				return new global::haxe.ds.StringMap<object>();
			}
			#line default
		}
		
		
		public virtual   object haxe_ds_StringMap_cast<T_c>(){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				if (global::haxe.lang.Runtime.eq(typeof(T), typeof(T_c))) {
					#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					return this;
				}
				
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				global::haxe.ds.StringMap<T_c> new_me = new global::haxe.ds.StringMap<T_c>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				{
					#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					object __temp_iterator123 = global::Reflect.fields(this).iterator();
					#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator123, "hasNext", 407283053, default(global::Array)))){
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						string field = global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.callField(__temp_iterator123, "next", 1224901875, default(global::Array)));
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						switch (field){
							case "vals":
							{
								#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								if (( this.vals != default(T[]) )) {
									#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									T_c[] __temp_new_arr33 = new T_c[((int) (this.vals.Length) )];
									#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									int __temp_i34 = -1;
									#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									while ((  ++ __temp_i34 < this.vals.Length )){
										#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
										object __temp_obj35 = ((object) (this.vals[__temp_i34]) );
										#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
										if ( ! (global::haxe.lang.Runtime.eq(__temp_obj35, default(T[]))) ) {
											#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
											__temp_new_arr33[__temp_i34] = global::haxe.lang.Runtime.genericCast<T_c>(__temp_obj35);
										}
										
									}
									
									#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									new_me.vals = __temp_new_arr33;
								}
								 else {
									#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									new_me.vals = default(T_c[]);
								}
								
								#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								break;
							}
							
							
							default:
							{
								#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								global::Reflect.setField(new_me, field, ((object) (global::Reflect.field(this, field)) ));
								#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								break;
							}
							
						}
						
					}
					
				}
				
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				return new_me;
			}
			#line default
		}
		
		
		public virtual   object IMap_cast<K_c, V_c>(){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				return this.haxe_ds_StringMap_cast<V_c>();
			}
			#line default
		}
		
		
		public  int[] hashes;
		
		public  string[] _keys;
		
		public  T[] vals;
		
		public  int nBuckets;
		
		public  int size;
		
		public  int nOccupied;
		
		public  int upperBound;
		
		public  string cachedKey;
		
		public  int cachedIndex;
		
		public virtual   void @set(string key, T @value){
			unchecked {
				#line 66 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				int x = default(int);
				#line 66 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				int k = default(int);
				if (( this.nOccupied >= this.upperBound )) {
					#line 69 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					if (( this.nBuckets > ( this.size << 1 ) )) {
						#line 70 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.resize(( this.nBuckets - 1 ));
					}
					 else {
						#line 72 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.resize(( this.nBuckets + 2 ));
					}
					
				}
				
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				int[] hashes = this.hashes;
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				string[] keys = this._keys;
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				int[] hashes1 = hashes;
				{
					#line 77 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int mask = default(int);
					#line 77 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					if (( this.nBuckets == 0 )) {
						#line 77 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						mask = 0;
					}
					 else {
						#line 77 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						mask = ( this.nBuckets - 1 );
					}
					
					#line 78 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int site = x = this.nBuckets;
					{
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						int k1 = key.GetHashCode();
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k1 = ( ( k1 + 2127912214 ) + (( k1 << 12 )) );
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k1 = ( ( k1 ^ -949894596 ) ^ ( k1 >> 19 ) );
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k1 = ( ( k1 + 374761393 ) + (( k1 << 5 )) );
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k1 = ( ( k1 + -744332180 ) ^ ( k1 << 9 ) );
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k1 = ( ( k1 + -42973499 ) + (( k1 << 3 )) );
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k1 = ( ( k1 ^ -1252372727 ) ^ ( k1 >> 16 ) );
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						int ret = k1;
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						if (( (( ret & -2 )) == 0 )) {
							#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							if (( ret == 0 )) {
								#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								ret = 2;
							}
							 else {
								#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								ret = -1;
							}
							
						}
						
						#line 79 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k = ret;
					}
					
					#line 80 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int i = ( k & mask );
					#line 80 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int nProbes = 0;
					#line 83 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					if (( (( hashes1[i] & -2 )) == 0 )) {
						#line 84 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						x = i;
					}
					 else {
						#line 87 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						int last = i;
						#line 87 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						int flag = default(int);
						do {
							#line 88 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							bool __temp_stmt253 = default(bool);
							#line 88 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							{
								#line 88 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								int v = flag = hashes1[i];
								#line 88 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								__temp_stmt253 = ( (( v & -2 )) == 0 );
							}
							
							#line 88 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							bool __temp_boolv254 = false;
							#line 88 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							if ( ! (__temp_stmt253) ) {
								#line 88 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								__temp_boolv254 = ( ( flag == k ) && string.Equals(this._keys[i], key) );
							}
							
							#line 88 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							bool __temp_stmt252 = ( __temp_stmt253 || __temp_boolv254 );
							#line 90 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							if ( ! ((__temp_stmt252)) ) {
								#line 90 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								i = ( ( i +  ++ nProbes ) & mask );
							}
							 else {
								#line 90 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								break;
							}
							
						}
						while (true);
						#line 97 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						x = i;
					}
					
				}
				
				#line 107 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				int flag1 = hashes1[x];
				if (( flag1 == 0 )) {
					#line 110 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					keys[x] = key;
					this.vals[x] = @value;
					hashes1[x] = k;
					this.size++;
					this.nOccupied++;
				}
				 else {
					#line 115 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					if (( flag1 == 1 )) {
						#line 116 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						keys[x] = key;
						this.vals[x] = @value;
						hashes1[x] = k;
						this.size++;
					}
					 else {
						#line 122 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.vals[x] = @value;
					}
					
				}
				
				#line 125 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				this.cachedIndex = x;
				this.cachedKey = key;
			}
			#line default
		}
		
		
		public   int lookup(string key){
			unchecked {
				#line 131 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				if (( this.nBuckets != 0 )) {
					#line 133 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int[] hashes = this.hashes;
					#line 133 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					string[] keys = this._keys;
					#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int mask = ( this.nBuckets - 1 );
					#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int hash = default(int);
					#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					{
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						int k = key.GetHashCode();
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k = ( ( k + 2127912214 ) + (( k << 12 )) );
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k = ( ( k ^ -949894596 ) ^ ( k >> 19 ) );
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k = ( ( k + 374761393 ) + (( k << 5 )) );
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k = ( ( k + -744332180 ) ^ ( k << 9 ) );
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k = ( ( k + -42973499 ) + (( k << 3 )) );
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						k = ( ( k ^ -1252372727 ) ^ ( k >> 16 ) );
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						int ret = k;
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						if (( (( ret & -2 )) == 0 )) {
							#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							if (( ret == 0 )) {
								#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								ret = 2;
							}
							 else {
								#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								ret = -1;
							}
							
						}
						
						#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						hash = ret;
					}
					
					#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int k1 = hash;
					#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int nProbes = 0;
					int i = ( k1 & mask );
					int last = i;
					#line 137 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int flag = default(int);
					#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					do {
						#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						bool __temp_stmt258 = default(bool);
						#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						{
							#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							int v = flag = hashes[i];
							#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							__temp_stmt258 = ( v == 0 );
						}
						
						#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						bool __temp_boolv257 =  ! (__temp_stmt258) ;
						#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						bool __temp_boolv256 = false;
						#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						if (__temp_boolv257) {
							#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							__temp_boolv256 = (( ( ( flag == 1 ) || ( flag != k1 ) ) ||  ! (string.Equals(keys[i], key))  ));
						}
						
						#line 139 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						bool __temp_stmt255 = ( __temp_boolv257 && __temp_boolv256 );
						#line 141 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						if (__temp_stmt255) {
							#line 141 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							i = ( ( i +  ++ nProbes ) & mask );
						}
						 else {
							#line 141 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							break;
						}
						
					}
					while (true);
					#line 154 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					if (( (( flag & -2 )) == 0 )) {
						#line 154 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return -1;
					}
					 else {
						#line 154 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return i;
					}
					
				}
				
				#line 157 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				return -1;
			}
			#line default
		}
		
		
		public   void resize(int newNBuckets){
			unchecked {
				#line 163 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				int[] newHash = default(int[]);
				int j = 1;
				{
					#line 166 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					{
						#line 166 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						int x = newNBuckets;
						#line 166 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						 -- x;
						#line 166 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						x |= ((int) (( ((uint) (x) ) >> 1 )) );
						#line 166 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						x |= ((int) (( ((uint) (x) ) >> 2 )) );
						#line 166 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						x |= ((int) (( ((uint) (x) ) >> 4 )) );
						#line 166 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						x |= ((int) (( ((uint) (x) ) >> 8 )) );
						#line 166 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						x |= ((int) (( ((uint) (x) ) >> 16 )) );
						#line 166 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						newNBuckets =  ++ x;
					}
					
					#line 167 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					if (( newNBuckets < 4 )) {
						#line 167 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						newNBuckets = 4;
					}
					
					#line 168 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					if (( this.size >= ( ( newNBuckets * 0.77 ) + 0.5 ) )) {
						#line 170 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						j = 0;
					}
					 else {
						#line 172 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						int nfSize = newNBuckets;
						newHash = new int[((int) (nfSize) )];
						if (( this.nBuckets < newNBuckets )) {
							#line 176 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							string[] k = new string[((int) (newNBuckets) )];
							if (( this._keys != default(string[]) )) {
								#line 178 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								global::System.Array.Copy(((global::System.Array) (this._keys) ), ((int) (0) ), ((global::System.Array) (k) ), ((int) (0) ), ((int) (this.nBuckets) ));
							}
							
							#line 179 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							this._keys = k;
							#line 181 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							T[] v = new T[((int) (newNBuckets) )];
							if (( this.vals != default(T[]) )) {
								#line 183 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								global::System.Array.Copy(((global::System.Array) (this.vals) ), ((int) (0) ), ((global::System.Array) (v) ), ((int) (0) ), ((int) (this.nBuckets) ));
							}
							
							#line 184 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							this.vals = v;
						}
						
					}
					
				}
				
				#line 189 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				if (( j != 0 )) {
					#line 192 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					this.cachedKey = default(string);
					this.cachedIndex = -1;
					#line 195 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					j = -1;
					int nBuckets = this.nBuckets;
					#line 196 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					string[] _keys = this._keys;
					#line 196 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					T[] vals = this.vals;
					#line 196 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int[] hashes = this.hashes;
					#line 198 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					int newMask = ( newNBuckets - 1 );
					while ((  ++ j < nBuckets )){
						#line 201 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						int k1 = default(int);
						bool __temp_stmt259 = default(bool);
						#line 202 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						{
							#line 202 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							int v1 = k1 = hashes[j];
							#line 202 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							__temp_stmt259 = ( (( v1 & -2 )) == 0 );
						}
						
						#line 202 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						if ( ! (__temp_stmt259) ) {
							#line 204 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							string key = _keys[j];
							T val = vals[j];
							#line 207 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							hashes[j] = 1;
							while (true){
								#line 210 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								int nProbes = 0;
								#line 212 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								int i = ( k1 & newMask );
								#line 214 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								while ( ! ((( newHash[i] == 0 ))) ){
									#line 215 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									i = ( ( i +  ++ nProbes ) & newMask );
								}
								
								#line 217 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								newHash[i] = k1;
								#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								bool __temp_boolv262 = ( i < nBuckets );
								#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								bool __temp_boolv261 = false;
								#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								if (__temp_boolv262) {
									#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									bool __temp_stmt263 = default(bool);
									#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									{
										#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
										int v2 = k1 = hashes[i];
										#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
										__temp_stmt263 = ( (( v2 & -2 )) == 0 );
									}
									
									#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									__temp_boolv261 =  ! (__temp_stmt263) ;
								}
								
								#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								bool __temp_stmt260 = ( __temp_boolv262 && __temp_boolv261 );
								#line 219 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
								if (__temp_stmt260) {
									#line 221 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									{
										#line 222 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
										string tmp = _keys[i];
										_keys[i] = key;
										key = tmp;
									}
									
									#line 226 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									{
										#line 227 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
										T tmp1 = vals[i];
										vals[i] = val;
										val = tmp1;
									}
									
									#line 232 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									hashes[i] = 1;
								}
								 else {
									#line 234 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
									_keys[i] = key;
									vals[i] = val;
									break;
								}
								
							}
							
						}
						
					}
					
					#line 242 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					if (( nBuckets > newNBuckets )) {
						#line 244 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						{
							#line 245 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							string[] k2 = new string[((int) (newNBuckets) )];
							global::System.Array.Copy(((global::System.Array) (_keys) ), ((int) (0) ), ((global::System.Array) (k2) ), ((int) (0) ), ((int) (newNBuckets) ));
							this._keys = k2;
						}
						
						#line 249 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						{
							#line 250 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
							T[] v3 = new T[((int) (newNBuckets) )];
							global::System.Array.Copy(((global::System.Array) (vals) ), ((int) (0) ), ((global::System.Array) (v3) ), ((int) (0) ), ((int) (newNBuckets) ));
							this.vals = v3;
						}
						
					}
					
					#line 256 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					this.hashes = newHash;
					this.nBuckets = newNBuckets;
					this.nOccupied = this.size;
					this.upperBound = ((int) (( ( newNBuckets * 0.77 ) + .5 )) );
				}
				
			}
			#line default
		}
		
		
		public virtual   global::haxe.lang.Null<T> @get(string key){
			unchecked {
				#line 265 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				int idx = -1;
				if (( string.Equals(this.cachedKey, key) && ( (idx = this.cachedIndex) != -1 ) )) {
					#line 268 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					return new global::haxe.lang.Null<T>(this.vals[idx], true);
				}
				
				#line 271 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				idx = this.lookup(key);
				if (( idx != -1 )) {
					#line 274 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					this.cachedKey = key;
					this.cachedIndex = idx;
					#line 277 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					return new global::haxe.lang.Null<T>(this.vals[idx], true);
				}
				
				#line 280 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				return default(global::haxe.lang.Null<T>);
			}
			#line default
		}
		
		
		public virtual   bool exists(string key){
			unchecked {
				#line 305 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				int idx = -1;
				if (( string.Equals(this.cachedKey, key) && ( (idx = this.cachedIndex) != -1 ) )) {
					#line 308 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					return true;
				}
				
				#line 311 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				idx = this.lookup(key);
				if (( idx != -1 )) {
					#line 314 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					this.cachedKey = key;
					this.cachedIndex = idx;
					#line 317 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					return true;
				}
				
				#line 320 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				return false;
			}
			#line default
		}
		
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				switch (hash){
					case 922671056:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.cachedIndex = ((int) (@value) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 2022294396:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.upperBound = ((int) (@value) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 480756972:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.nOccupied = ((int) (@value) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 1280549057:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.size = ((int) (@value) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 1537812987:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.nBuckets = ((int) (@value) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					default:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				switch (hash){
					case 922671056:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.cachedIndex = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 1395555037:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.cachedKey = global::haxe.lang.Runtime.toString(@value);
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 2022294396:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.upperBound = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 480756972:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.nOccupied = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 1280549057:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.size = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 1537812987:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.nBuckets = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 1313416818:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.vals = ((T[]) (@value) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 2048392659:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this._keys = ((string[]) (@value) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					case 995006396:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.hashes = ((int[]) (@value) );
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return @value;
					}
					
					
					default:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				switch (hash){
					case 1071652316:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("exists") ), ((int) (1071652316) ))) );
					}
					
					
					case 5144726:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get") ), ((int) (5144726) ))) );
					}
					
					
					case 142301684:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("resize") ), ((int) (142301684) ))) );
					}
					
					
					case 1639293562:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("lookup") ), ((int) (1639293562) ))) );
					}
					
					
					case 5741474:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("set") ), ((int) (5741474) ))) );
					}
					
					
					case 922671056:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.cachedIndex;
					}
					
					
					case 1395555037:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.cachedKey;
					}
					
					
					case 2022294396:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.upperBound;
					}
					
					
					case 480756972:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.nOccupied;
					}
					
					
					case 1280549057:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.size;
					}
					
					
					case 1537812987:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.nBuckets;
					}
					
					
					case 1313416818:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.vals;
					}
					
					
					case 2048392659:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this._keys;
					}
					
					
					case 995006396:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.hashes;
					}
					
					
					default:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				switch (hash){
					case 922671056:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((double) (this.cachedIndex) );
					}
					
					
					case 2022294396:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((double) (this.upperBound) );
					}
					
					
					case 480756972:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((double) (this.nOccupied) );
					}
					
					
					case 1280549057:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((double) (this.size) );
					}
					
					
					case 1537812987:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return ((double) (this.nBuckets) );
					}
					
					
					default:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				switch (hash){
					case 1071652316:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.exists(global::haxe.lang.Runtime.toString(dynargs[0]));
					}
					
					
					case 5144726:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return (this.@get(global::haxe.lang.Runtime.toString(dynargs[0]))).toDynamic();
					}
					
					
					case 142301684:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.resize(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ));
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						break;
					}
					
					
					case 1639293562:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return this.lookup(global::haxe.lang.Runtime.toString(dynargs[0]));
					}
					
					
					case 5741474:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						this.@set(global::haxe.lang.Runtime.toString(dynargs[0]), global::haxe.lang.Runtime.genericCast<T>(dynargs[1]));
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						break;
					}
					
					
					default:
					{
						#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				baseArr.push("cachedIndex");
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				baseArr.push("cachedKey");
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				baseArr.push("upperBound");
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				baseArr.push("nOccupied");
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				baseArr.push("size");
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				baseArr.push("nBuckets");
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				baseArr.push("vals");
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				baseArr.push("_keys");
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				baseArr.push("hashes");
				#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
				{
					#line 26 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\haxe\\ds\\StringMap.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.ds{
	public  interface StringMap : global::haxe.lang.IHxObject, global::haxe.lang.IGenericObject {
		   object haxe_ds_StringMap_cast<T_c>();
		
	}
}


