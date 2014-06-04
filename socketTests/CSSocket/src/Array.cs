
#pragma warning disable 109, 114, 219, 429, 168, 162
public sealed class Array<T> : global::haxe.lang.HxObject, global::Array {
	
	public Array(T[] native)
	{
		this.__a = native;
		this.length = native.Length;
	}
	public    Array(global::haxe.lang.EmptyObject empty){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public    Array(){
		unchecked {
			#line 56 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			global::Array<object>.__hx_ctor__Array<T>(this);
		}
		#line default
	}
	
	
	public static   void __hx_ctor__Array<T_c>(global::Array<T_c> __temp_me4){
		unchecked {
			#line 58 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			__temp_me4.length = 0;
			__temp_me4.__a = new T_c[((int) (0) )];
		}
		#line default
	}
	
	
	public static   object __hx_cast<T_c_c>(global::Array me){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return ( (( me != default(global::Array) )) ? (me.Array_cast<T_c_c>()) : (default(global::Array)) );
		}
		#line default
	}
	
	
	public static   global::Array<X> ofNative<X>(X[] native){
		
			return new Array<X>(native);
	
	}
	
	
	public static   global::Array<Y> alloc<Y>(int size){
		
			return new Array<Y>(new Y[size]);
	
	}
	
	
	public static  new object __hx_createEmpty(){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return new global::Array<object>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
		}
		#line default
	}
	
	
	public static  new object __hx_create(global::Array arr){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return new global::Array<object>();
		}
		#line default
	}
	
	
	public   object Array_cast<T_c>(){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (global::haxe.lang.Runtime.eq(typeof(T), typeof(T_c))) {
				#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return this;
			}
			
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			global::Array<T_c> new_me = new global::Array<T_c>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			{
				#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				object __temp_iterator115 = global::Reflect.fields(this).iterator();
				#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator115, "hasNext", 407283053, default(global::Array)))){
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					string field = global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.callField(__temp_iterator115, "next", 1224901875, default(global::Array)));
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					switch (field){
						case "__a":
						{
							#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
							if (( this.__a != default(T[]) )) {
								#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
								T_c[] __temp_new_arr1 = new T_c[((int) (this.__a.Length) )];
								#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
								int __temp_i2 = -1;
								#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
								while ((  ++ __temp_i2 < this.__a.Length )){
									#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
									object __temp_obj3 = ((object) (this.__a[__temp_i2]) );
									#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
									if ( ! (global::haxe.lang.Runtime.eq(__temp_obj3, default(T[]))) ) {
										#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
										__temp_new_arr1[__temp_i2] = global::haxe.lang.Runtime.genericCast<T_c>(__temp_obj3);
									}
									
								}
								
								#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
								new_me.__a = __temp_new_arr1;
							}
							 else {
								#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
								new_me.__a = default(T_c[]);
							}
							
							#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
							break;
						}
						
						
						default:
						{
							#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
							global::Reflect.setField(new_me, field, ((object) (global::Reflect.field(this, field)) ));
							#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
							break;
						}
						
					}
					
				}
				
			}
			
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return new_me;
		}
		#line default
	}
	
	
	public  int length;
	
	public  T[] __a;
	
	public   global::Array<T> concat(global::Array<T> a){
		unchecked {
			#line 64 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int len = ( this.length + a.length );
			T[] retarr = new T[((int) (len) )];
			global::System.Array.Copy(((global::System.Array) (this.__a) ), ((int) (0) ), ((global::System.Array) (retarr) ), ((int) (0) ), ((int) (this.length) ));
			global::System.Array.Copy(((global::System.Array) (a.__a) ), ((int) (0) ), ((global::System.Array) (retarr) ), ((int) (this.length) ), ((int) (a.length) ));
			#line 69 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return global::Array<object>.ofNative<T>(retarr);
		}
		#line default
	}
	
	
	public   void concatNative(T[] a){
		unchecked {
			#line 74 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] __a = this.__a;
			int len = ( this.length + ( a as global::System.Array ).Length );
			if (( ( __a as global::System.Array ).Length >= len )) {
				#line 78 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				global::System.Array.Copy(((global::System.Array) (a) ), ((int) (0) ), ((global::System.Array) (__a) ), ((int) (this.length) ), ((int) (this.length) ));
			}
			 else {
				#line 80 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				T[] newarr = new T[((int) (len) )];
				global::System.Array.Copy(((global::System.Array) (__a) ), ((int) (0) ), ((global::System.Array) (newarr) ), ((int) (0) ), ((int) (this.length) ));
				global::System.Array.Copy(((global::System.Array) (a) ), ((int) (0) ), ((global::System.Array) (newarr) ), ((int) (this.length) ), ((int) (( a as global::System.Array ).Length) ));
				#line 84 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				this.__a = newarr;
			}
			
			#line 87 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			this.length = len;
		}
		#line default
	}
	
	
	public   int indexOf(T x, global::haxe.lang.Null<int> fromIndex){
		unchecked {
			#line 92 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int len = this.length;
			#line 92 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int i = default(int);
			#line 92 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if ( ! (fromIndex.hasValue) ) {
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				i = 0;
			}
			 else {
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				i = fromIndex.@value;
			}
			
			#line 93 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( i < 0 )) {
				#line 95 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				i += len;
				if (( i < 0 )) {
					#line 96 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					i = 0;
				}
				
			}
			
			#line 98 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return global::System.Array.IndexOf<T>(((T[]) (this.__a) ), global::haxe.lang.Runtime.genericCast<T>(x), ((int) (i) ), ((int) (( len - i )) ));
		}
		#line default
	}
	
	
	public   int lastIndexOf(T x, global::haxe.lang.Null<int> fromIndex){
		unchecked {
			#line 103 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int len = this.length;
			#line 103 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int i = default(int);
			#line 103 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if ( ! (fromIndex.hasValue) ) {
				#line 103 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				i = ( len - 1 );
			}
			 else {
				#line 103 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				i = fromIndex.@value;
			}
			
			#line 104 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( i >= len )) {
				#line 106 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				i = ( len - 1 );
			}
			 else {
				#line 108 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				if (( i < 0 )) {
					#line 110 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					i += len;
					if (( i < 0 )) {
						#line 111 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return -1;
					}
					
				}
				
			}
			
			#line 113 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return global::System.Array.LastIndexOf<T>(((T[]) (this.__a) ), global::haxe.lang.Runtime.genericCast<T>(x), ((int) (i) ), ((int) (( i + 1 )) ));
		}
		#line default
	}
	
	
	public   string @join(string sep){
		unchecked {
			#line 118 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			global::StringBuf buf = new global::StringBuf();
			int i = -1;
			#line 121 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			bool first = true;
			int length = this.length;
			while ((  ++ i < length )){
				#line 125 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				if (first) {
					#line 126 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					first = false;
				}
				 else {
					#line 128 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					buf.b.Append(((object) (global::Std.@string(sep)) ));
				}
				
				#line 129 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				buf.b.Append(((object) (global::Std.@string(this.__a[i])) ));
			}
			
			#line 132 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return buf.toString();
		}
		#line default
	}
	
	
	public   global::haxe.lang.Null<T> pop(){
		unchecked {
			#line 137 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] __a = this.__a;
			int length = this.length;
			if (( length > 0 )) {
				#line 141 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				T val = __a[ -- length];
				__a[length] = default(T);
				this.length = length;
				#line 145 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return new global::haxe.lang.Null<T>(val, true);
			}
			 else {
				#line 147 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return default(global::haxe.lang.Null<T>);
			}
			
		}
		#line default
	}
	
	
	public   int push(T x){
		unchecked {
			#line 153 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( this.length >= ( this.__a as global::System.Array ).Length )) {
				#line 155 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				int newLen = ( (( this.length << 1 )) + 1 );
				T[] newarr = new T[((int) (newLen) )];
				( this.__a as global::System.Array ).CopyTo(((global::System.Array) (newarr) ), ((int) (0) ));
				#line 159 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				this.__a = newarr;
			}
			
			#line 162 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			this.__a[this.length] = x;
			return  ++ this.length;
		}
		#line default
	}
	
	
	public   void reverse(){
		unchecked {
			#line 168 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int i = 0;
			int l = this.length;
			T[] a = this.__a;
			int half = ( l >> 1 );
			l -= 1;
			while (( i < half )){
				#line 175 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				T tmp = a[i];
				a[i] = a[( l - i )];
				a[( l - i )] = tmp;
				i += 1;
			}
			
		}
		#line default
	}
	
	
	public   global::haxe.lang.Null<T> shift(){
		unchecked {
			#line 184 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int l = this.length;
			if (( l == 0 )) {
				#line 186 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return default(global::haxe.lang.Null<T>);
			}
			
			#line 188 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] a = this.__a;
			T x = a[0];
			l -= 1;
			global::System.Array.Copy(((global::System.Array) (a) ), ((int) (1) ), ((global::System.Array) (a) ), ((int) (0) ), ((int) (( this.length - 1 )) ));
			a[l] = default(T);
			this.length = l;
			#line 195 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return new global::haxe.lang.Null<T>(x, true);
		}
		#line default
	}
	
	
	public   global::Array<T> slice(int pos, global::haxe.lang.Null<int> end){
		unchecked {
			#line 200 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( pos < 0 )) {
				#line 201 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				pos = ( this.length + pos );
				if (( pos < 0 )) {
					#line 203 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					pos = 0;
				}
				
			}
			
			#line 205 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if ( ! (end.hasValue) ) {
				#line 206 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				end = new global::haxe.lang.Null<int>(this.length, true);
			}
			 else {
				#line 207 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				if (( end.@value < 0 )) {
					#line 208 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					end = new global::haxe.lang.Null<int>(( this.length + end.@value ), true);
				}
				
			}
			
			#line 209 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( end.@value > this.length )) {
				#line 210 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				end = new global::haxe.lang.Null<int>(this.length, true);
			}
			
			#line 211 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int len = ( end.@value - pos );
			if (( len < 0 )) {
				#line 212 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return new global::Array<T>();
			}
			
			#line 214 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] newarr = new T[((int) (len) )];
			global::System.Array.Copy(((global::System.Array) (this.__a) ), ((int) (pos) ), ((global::System.Array) (newarr) ), ((int) (0) ), ((int) (len) ));
			#line 217 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return global::Array<object>.ofNative<T>(newarr);
		}
		#line default
	}
	
	
	public   void sort(global::haxe.lang.Function f){
		unchecked {
			#line 222 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( this.length == 0 )) {
				#line 223 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return ;
			}
			
			#line 224 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			this.quicksort(0, ( this.length - 1 ), f);
		}
		#line default
	}
	
	
	public   void quicksort(int lo, int hi, global::haxe.lang.Function f){
		unchecked {
			#line 229 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] buf = this.__a;
			int i = lo;
			#line 230 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int j = hi;
			T p = buf[( ( i + j ) >> 1 )];
			while (( i <= j )){
				#line 234 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				while (( ((int) (f.__hx_invoke2_f(default(double), buf[i], default(double), p)) ) < 0 )){
					#line 234 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					i++;
				}
				
				#line 235 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				while (( ((int) (f.__hx_invoke2_f(default(double), buf[j], default(double), p)) ) > 0 )){
					#line 235 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					j--;
				}
				
				#line 236 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				if (( i <= j )) {
					#line 238 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					T t = buf[i];
					buf[i++] = buf[j];
					buf[j--] = t;
				}
				
			}
			
			#line 244 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( lo < j )) {
				#line 244 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				this.quicksort(lo, j, f);
			}
			
			#line 245 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( i < hi )) {
				#line 245 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				this.quicksort(i, hi, f);
			}
			
		}
		#line default
	}
	
	
	public   global::Array<T> splice(int pos, int len){
		unchecked {
			#line 250 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( len < 0 )) {
				#line 250 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return new global::Array<T>();
			}
			
			#line 251 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( pos < 0 )) {
				#line 252 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				pos = ( this.length + pos );
				if (( pos < 0 )) {
					#line 253 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					pos = 0;
				}
				
			}
			
			#line 255 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( pos > this.length )) {
				#line 256 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				pos = 0;
				len = 0;
			}
			 else {
				#line 258 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				if (( ( pos + len ) > this.length )) {
					#line 259 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					len = ( this.length - pos );
					if (( len < 0 )) {
						#line 260 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						len = 0;
					}
					
				}
				
			}
			
			#line 262 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] a = this.__a;
			#line 264 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] ret = new T[((int) (len) )];
			global::System.Array.Copy(((global::System.Array) (a) ), ((int) (pos) ), ((global::System.Array) (ret) ), ((int) (0) ), ((int) (len) ));
			global::Array<T> ret1 = global::Array<object>.ofNative<T>(ret);
			#line 268 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int end = ( pos + len );
			global::System.Array.Copy(((global::System.Array) (a) ), ((int) (end) ), ((global::System.Array) (a) ), ((int) (pos) ), ((int) (( this.length - end )) ));
			this.length -= len;
			while ((  -- len >= 0 )){
				#line 272 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				a[( this.length + len )] = default(T);
			}
			
			#line 273 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return ret1;
		}
		#line default
	}
	
	
	public   void spliceVoid(int pos, int len){
		unchecked {
			#line 278 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( len < 0 )) {
				#line 278 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return ;
			}
			
			#line 279 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( pos < 0 )) {
				#line 280 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				pos = ( this.length + pos );
				if (( pos < 0 )) {
					#line 281 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					pos = 0;
				}
				
			}
			
			#line 283 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( pos > this.length )) {
				#line 284 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				pos = 0;
				len = 0;
			}
			 else {
				#line 286 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				if (( ( pos + len ) > this.length )) {
					#line 287 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					len = ( this.length - pos );
					if (( len < 0 )) {
						#line 288 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						len = 0;
					}
					
				}
				
			}
			
			#line 290 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] a = this.__a;
			#line 292 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int end = ( pos + len );
			global::System.Array.Copy(((global::System.Array) (a) ), ((int) (end) ), ((global::System.Array) (a) ), ((int) (pos) ), ((int) (( this.length - end )) ));
			this.length -= len;
			while ((  -- len >= 0 )){
				#line 296 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				a[( this.length + len )] = default(T);
			}
			
		}
		#line default
	}
	
	
	public   string toString(){
		unchecked {
			#line 301 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			global::StringBuf ret = new global::StringBuf();
			T[] a = this.__a;
			ret.b.Append(((object) ("[") ));
			bool first = true;
			{
				#line 305 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				int _g1 = 0;
				#line 305 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				int _g = this.length;
				#line 305 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				while (( _g1 < _g )){
					#line 305 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					int i = _g1++;
					#line 307 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					if (first) {
						#line 308 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						first = false;
					}
					 else {
						#line 310 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						ret.b.Append(((object) (",") ));
					}
					
					#line 311 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					ret.b.Append(((object) (global::Std.@string(a[i])) ));
				}
				
			}
			
			#line 314 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			ret.b.Append(((object) ("]") ));
			return ret.toString();
		}
		#line default
	}
	
	
	public   void unshift(T x){
		unchecked {
			#line 320 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] __a = this.__a;
			int length = this.length;
			if (( length >= ( __a as global::System.Array ).Length )) {
				#line 324 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				int newLen = ( (( length << 1 )) + 1 );
				T[] newarr = new T[((int) (newLen) )];
				global::System.Array.Copy(((global::System.Array) (__a) ), ((int) (0) ), ((global::System.Array) (newarr) ), ((int) (1) ), ((int) (length) ));
				#line 328 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				this.__a = newarr;
			}
			 else {
				#line 330 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				global::System.Array.Copy(((global::System.Array) (__a) ), ((int) (0) ), ((global::System.Array) (__a) ), ((int) (1) ), ((int) (length) ));
			}
			
			#line 333 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			this.__a[0] = x;
			 ++ this.length;
		}
		#line default
	}
	
	
	public   void insert(int pos, T x){
		unchecked {
			#line 339 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int l = this.length;
			if (( pos < 0 )) {
				#line 341 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				pos = ( l + pos );
				if (( pos < 0 )) {
					#line 342 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					pos = 0;
				}
				
			}
			
			#line 344 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( pos >= l )) {
				#line 345 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				this.push(x);
				return ;
			}
			 else {
				#line 347 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				if (( pos == 0 )) {
					#line 348 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.unshift(x);
					return ;
				}
				
			}
			
			#line 352 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( l >= ( this.__a as global::System.Array ).Length )) {
				#line 354 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				int newLen = ( (( this.length << 1 )) + 1 );
				T[] newarr = new T[((int) (newLen) )];
				global::System.Array.Copy(((global::System.Array) (this.__a) ), ((int) (0) ), ((global::System.Array) (newarr) ), ((int) (0) ), ((int) (pos) ));
				newarr[pos] = x;
				global::System.Array.Copy(((global::System.Array) (this.__a) ), ((int) (pos) ), ((global::System.Array) (newarr) ), ((int) (( pos + 1 )) ), ((int) (( l - pos )) ));
				#line 360 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				this.__a = newarr;
				 ++ this.length;
			}
			 else {
				#line 363 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				T[] __a = this.__a;
				global::System.Array.Copy(((global::System.Array) (__a) ), ((int) (pos) ), ((global::System.Array) (__a) ), ((int) (( pos + 1 )) ), ((int) (( l - pos )) ));
				global::System.Array.Copy(((global::System.Array) (__a) ), ((int) (0) ), ((global::System.Array) (__a) ), ((int) (0) ), ((int) (pos) ));
				__a[pos] = x;
				 ++ this.length;
			}
			
		}
		#line default
	}
	
	
	public   bool @remove(T x){
		unchecked {
			#line 373 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] __a = this.__a;
			int i = -1;
			int length = this.length;
			while ((  ++ i < length )){
				#line 378 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				if (global::haxe.lang.Runtime.eq(__a[i], x)) {
					#line 380 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					global::System.Array.Copy(((global::System.Array) (__a) ), ((int) (( i + 1 )) ), ((global::System.Array) (__a) ), ((int) (i) ), ((int) (( ( length - i ) - 1 )) ));
					__a[ -- this.length] = default(T);
					#line 383 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return true;
				}
				
			}
			
			#line 387 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return false;
		}
		#line default
	}
	
	
	public   global::Array<S> map<S>(global::haxe.lang.Function f){
		unchecked {
			#line 391 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			global::Array<S> ret = new global::Array<S>(new S[]{});
			{
				#line 392 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				int _g = 0;
				#line 392 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				global::Array<T> _g1 = this;
				#line 392 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				while (( _g < _g1.length )){
					#line 392 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					T elt = _g1[_g];
					#line 392 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					 ++ _g;
					ret.push(global::haxe.lang.Runtime.genericCast<S>(f.__hx_invoke1_o(default(double), elt)));
				}
				
			}
			
			#line 394 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return ret;
		}
		#line default
	}
	
	
	public   global::Array<T> filter(global::haxe.lang.Function f){
		unchecked {
			#line 398 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			global::Array<T> ret = new global::Array<T>(new T[]{});
			{
				#line 399 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				int _g = 0;
				#line 399 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				global::Array<T> _g1 = this;
				#line 399 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				while (( _g < _g1.length )){
					#line 399 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					T elt = _g1[_g];
					#line 399 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					 ++ _g;
					if (global::haxe.lang.Runtime.toBool(f.__hx_invoke1_o(default(double), elt))) {
						#line 401 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						ret.push(elt);
					}
					
				}
				
			}
			
			#line 402 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return ret;
		}
		#line default
	}
	
	
	public   global::Array<T> copy(){
		unchecked {
			#line 407 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			int len = this.length;
			T[] __a = this.__a;
			T[] newarr = new T[((int) (len) )];
			global::System.Array.Copy(((global::System.Array) (__a) ), ((int) (0) ), ((global::System.Array) (newarr) ), ((int) (0) ), ((int) (len) ));
			return global::Array<object>.ofNative<T>(newarr);
		}
		#line default
	}
	
	
	public   object iterator(){
		unchecked {
			#line 416 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return new global::_Array.ArrayIterator<T>(((global::Array<T>) (this) ));
		}
		#line default
	}
	
	
	public   T __get(int idx){
		unchecked {
			#line 421 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			T[] __a = this.__a;
			uint idx1 = ((uint) (idx) );
			if (( idx1 >= this.length )) {
				#line 424 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return default(T);
			}
			
			#line 426 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return __a[((int) (idx1) )];
		}
		#line default
	}
	
	
	public   T __set(int idx, T v){
		unchecked {
			#line 431 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			uint idx1 = ((uint) (idx) );
			T[] __a = this.__a;
			if (( idx1 >= ( __a as global::System.Array ).Length )) {
				#line 435 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				uint len = ( idx1 + 1 );
				if (( idx1 == ( __a as global::System.Array ).Length )) {
					#line 437 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					len = ((uint) (( (( idx1 << 1 )) + 1 )) );
				}
				
				#line 438 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				T[] newArr = new T[((int) (len) )];
				( __a as global::System.Array ).CopyTo(((global::System.Array) (newArr) ), ((int) (0) ));
				this.__a = __a = newArr;
			}
			
			#line 443 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			if (( idx1 >= this.length )) {
				#line 444 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				this.length = ((int) (( idx1 + 1 )) );
			}
			
			#line 446 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return __a[((int) (idx1) )] = v;
		}
		#line default
	}
	
	
	public   T __unsafe_get(int idx){
		unchecked {
			#line 451 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return this.__a[idx];
		}
		#line default
	}
	
	
	public   T __unsafe_set(int idx, T val){
		unchecked {
			#line 456 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return this.__a[idx] = val;
		}
		#line default
	}
	
	
	public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			switch (hash){
				case 520590566:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.length = ((int) (@value) );
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return @value;
				}
				
				
				default:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return base.__hx_setField_f(field, hash, @value, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			switch (hash){
				case 4745537:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.__a = ((T[]) (@value) );
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return @value;
				}
				
				
				case 520590566:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.length = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return @value;
				}
				
				
				default:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return base.__hx_setField(field, hash, @value, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			switch (hash){
				case 1621420777:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("__unsafe_set") ), ((int) (1621420777) ))) );
				}
				
				
				case 1620824029:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("__unsafe_get") ), ((int) (1620824029) ))) );
				}
				
				
				case 1916009602:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("__set") ), ((int) (1916009602) ))) );
				}
				
				
				case 1915412854:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("__get") ), ((int) (1915412854) ))) );
				}
				
				
				case 328878574:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("iterator") ), ((int) (328878574) ))) );
				}
				
				
				case 1103412149:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("copy") ), ((int) (1103412149) ))) );
				}
				
				
				case 87367608:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("filter") ), ((int) (87367608) ))) );
				}
				
				
				case 5442204:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("map") ), ((int) (5442204) ))) );
				}
				
				
				case 76061764:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("remove") ), ((int) (76061764) ))) );
				}
				
				
				case 501039929:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("insert") ), ((int) (501039929) ))) );
				}
				
				
				case 2025055113:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("unshift") ), ((int) (2025055113) ))) );
				}
				
				
				case 946786476:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("toString") ), ((int) (946786476) ))) );
				}
				
				
				case 1352786672:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("spliceVoid") ), ((int) (1352786672) ))) );
				}
				
				
				case 1067353468:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("splice") ), ((int) (1067353468) ))) );
				}
				
				
				case 1282943179:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("quicksort") ), ((int) (1282943179) ))) );
				}
				
				
				case 1280845662:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("sort") ), ((int) (1280845662) ))) );
				}
				
				
				case 2127021138:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("slice") ), ((int) (2127021138) ))) );
				}
				
				
				case 2082663554:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("shift") ), ((int) (2082663554) ))) );
				}
				
				
				case 452737314:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("reverse") ), ((int) (452737314) ))) );
				}
				
				
				case 1247875546:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("push") ), ((int) (1247875546) ))) );
				}
				
				
				case 5594513:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("pop") ), ((int) (5594513) ))) );
				}
				
				
				case 1181037546:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("join") ), ((int) (1181037546) ))) );
				}
				
				
				case 359333139:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("lastIndexOf") ), ((int) (359333139) ))) );
				}
				
				
				case 1623148745:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("indexOf") ), ((int) (1623148745) ))) );
				}
				
				
				case 1532710347:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("concatNative") ), ((int) (1532710347) ))) );
				}
				
				
				case 1204816148:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("concat") ), ((int) (1204816148) ))) );
				}
				
				
				case 4745537:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.__a;
				}
				
				
				case 520590566:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.length;
				}
				
				
				default:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			switch (hash){
				case 520590566:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return ((double) (this.length) );
				}
				
				
				default:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			switch (hash){
				case 1621420777:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.__unsafe_set(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ), global::haxe.lang.Runtime.genericCast<T>(dynargs[1]));
				}
				
				
				case 1620824029:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.__unsafe_get(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ));
				}
				
				
				case 1916009602:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.__set(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ), global::haxe.lang.Runtime.genericCast<T>(dynargs[1]));
				}
				
				
				case 1915412854:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.__get(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ));
				}
				
				
				case 328878574:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.iterator();
				}
				
				
				case 1103412149:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.copy();
				}
				
				
				case 87367608:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.filter(((global::haxe.lang.Function) (dynargs[0]) ));
				}
				
				
				case 5442204:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.map<object>(((global::haxe.lang.Function) (dynargs[0]) ));
				}
				
				
				case 76061764:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.@remove(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]));
				}
				
				
				case 501039929:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.insert(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ), global::haxe.lang.Runtime.genericCast<T>(dynargs[1]));
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					break;
				}
				
				
				case 2025055113:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.unshift(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]));
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					break;
				}
				
				
				case 946786476:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.toString();
				}
				
				
				case 1352786672:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.spliceVoid(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ), ((int) (global::haxe.lang.Runtime.toInt(dynargs[1])) ));
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					break;
				}
				
				
				case 1067353468:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.splice(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ), ((int) (global::haxe.lang.Runtime.toInt(dynargs[1])) ));
				}
				
				
				case 1282943179:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.quicksort(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ), ((int) (global::haxe.lang.Runtime.toInt(dynargs[1])) ), ((global::haxe.lang.Function) (dynargs[2]) ));
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					break;
				}
				
				
				case 1280845662:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.sort(((global::haxe.lang.Function) (dynargs[0]) ));
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					break;
				}
				
				
				case 2127021138:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.slice(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
				}
				
				
				case 2082663554:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return (this.shift()).toDynamic();
				}
				
				
				case 452737314:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.reverse();
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					break;
				}
				
				
				case 1247875546:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.push(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]));
				}
				
				
				case 5594513:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return (this.pop()).toDynamic();
				}
				
				
				case 1181037546:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.@join(global::haxe.lang.Runtime.toString(dynargs[0]));
				}
				
				
				case 359333139:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.lastIndexOf(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
				}
				
				
				case 1623148745:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.indexOf(global::haxe.lang.Runtime.genericCast<T>(dynargs[0]), global::haxe.lang.Null<object>.ofDynamic<int>(dynargs[1]));
				}
				
				
				case 1532710347:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					this.concatNative(((T[]) (dynargs[0]) ));
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					break;
				}
				
				
				case 1204816148:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this.concat(((global::Array<T>) (global::Array<object>.__hx_cast<T>(((global::Array) (dynargs[0]) ))) ));
				}
				
				
				default:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return base.__hx_invokeField(field, hash, dynargs);
				}
				
			}
			
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			return default(object);
		}
		#line default
	}
	
	
	public override   void __hx_getFields(global::Array<object> baseArr){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			baseArr.push("__a");
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			baseArr.push("length");
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
			{
				#line 34 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				base.__hx_getFields(baseArr);
			}
			
		}
		#line default
	}
	
	
	public T this[int index]{
		get{
			return this.__get(index);
		}
		set{
			this.__set(index,value);
		}
	}
	object global::Array.this[int key]{
		get{
			return ((object) this.__get(key));
		}
		set{
			this.__set(key, (T) value);
		}
	}
	
	
	public override string ToString(){
		return this.toString();
	}
	
	
}



#pragma warning disable 109, 114, 219, 429, 168, 162
public  interface Array : global::haxe.lang.IHxObject, global::haxe.lang.IGenericObject {
	   object Array_cast<T_c>();
	
	object this[int key]{
		get;
		set;
	}
	
	
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace _Array{
	public sealed class ArrayIterator<T> : global::haxe.lang.HxObject, global::_Array.ArrayIterator {
		public    ArrayIterator(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    ArrayIterator(global::Array<T> a){
			unchecked {
				#line 467 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				global::_Array.ArrayIterator<object>.__hx_ctor__Array_ArrayIterator<T>(this, a);
			}
			#line default
		}
		
		
		public static   void __hx_ctor__Array_ArrayIterator<T_c>(global::_Array.ArrayIterator<T_c> __temp_me5, global::Array<T_c> a){
			unchecked {
				#line 469 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				__temp_me5.arr = a;
				__temp_me5.len = a.length;
				__temp_me5.i = 0;
			}
			#line default
		}
		
		
		public static   object __hx_cast<T_c_c>(global::_Array.ArrayIterator me){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return ( (( me != default(global::_Array.ArrayIterator) )) ? (me._Array_ArrayIterator_cast<T_c_c>()) : (default(global::_Array.ArrayIterator)) );
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return new global::_Array.ArrayIterator<object>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return new global::_Array.ArrayIterator<object>(((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (arr[0]) ))) ));
			}
			#line default
		}
		
		
		public   object _Array_ArrayIterator_cast<T_c>(){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				if (global::haxe.lang.Runtime.eq(typeof(T), typeof(T_c))) {
					#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					return this;
				}
				
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				global::_Array.ArrayIterator<T_c> new_me = new global::_Array.ArrayIterator<T_c>(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				{
					#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					object __temp_iterator116 = global::Reflect.fields(this).iterator();
					#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator116, "hasNext", 407283053, default(global::Array)))){
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						string field = global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.callField(__temp_iterator116, "next", 1224901875, default(global::Array)));
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						switch (field){
							default:
							{
								#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
								global::Reflect.setField(new_me, field, ((object) (global::Reflect.field(this, field)) ));
								#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
								break;
							}
							
						}
						
					}
					
				}
				
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return new_me;
			}
			#line default
		}
		
		
		public  global::Array<T> arr;
		
		public  int len;
		
		public  int i;
		
		public   bool hasNext(){
			unchecked {
				#line 474 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return ( this.i < this.len );
			}
			#line default
		}
		
		
		public   T next(){
			unchecked {
				#line 475 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				return this.arr[this.i++];
			}
			#line default
		}
		
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				switch (hash){
					case 105:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						this.i = ((int) (@value) );
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return @value;
					}
					
					
					case 5393365:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						this.len = ((int) (@value) );
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return @value;
					}
					
					
					default:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				switch (hash){
					case 105:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						this.i = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return @value;
					}
					
					
					case 5393365:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						this.len = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return @value;
					}
					
					
					case 4849249:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						this.arr = ((global::Array<T>) (global::Array<object>.__hx_cast<T>(((global::Array) (@value) ))) );
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return @value;
					}
					
					
					default:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				switch (hash){
					case 1224901875:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("next") ), ((int) (1224901875) ))) );
					}
					
					
					case 407283053:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("hasNext") ), ((int) (407283053) ))) );
					}
					
					
					case 105:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return this.i;
					}
					
					
					case 5393365:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return this.len;
					}
					
					
					case 4849249:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return this.arr;
					}
					
					
					default:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				switch (hash){
					case 105:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return ((double) (this.i) );
					}
					
					
					case 5393365:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return ((double) (this.len) );
					}
					
					
					default:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				switch (hash){
					case 1224901875:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return this.next();
					}
					
					
					case 407283053:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return this.hasNext();
					}
					
					
					default:
					{
						#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				baseArr.push("i");
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				baseArr.push("len");
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				baseArr.push("arr");
				#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
				{
					#line 461 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Array.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace _Array{
	public  interface ArrayIterator : global::haxe.lang.IHxObject, global::haxe.lang.IGenericObject {
		   object _Array_ArrayIterator_cast<T_c>();
		
	}
}


