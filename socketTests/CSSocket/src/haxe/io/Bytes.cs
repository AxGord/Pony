
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.io{
	public  class Bytes : global::haxe.lang.HxObject {
		public    Bytes(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Bytes(int length, byte[] b){
			unchecked {
				#line 33 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				global::haxe.io.Bytes.__hx_ctor_haxe_io_Bytes(this, length, b);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_io_Bytes(global::haxe.io.Bytes __temp_me37, int length, byte[] b){
			unchecked {
				#line 34 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				__temp_me37.length = length;
				__temp_me37.b = b;
			}
			#line default
		}
		
		
		public static   global::haxe.io.Bytes alloc(int length){
			unchecked {
				#line 379 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				return new global::haxe.io.Bytes(((int) (length) ), ((byte[]) (new byte[((int) (length) )]) ));
			}
			#line default
		}
		
		
		public static   global::haxe.io.Bytes ofString(string s){
			unchecked {
				#line 407 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				byte[] b = global::System.Text.Encoding.UTF8.GetBytes(((string) (s) ));
				return new global::haxe.io.Bytes(((int) (( b as global::System.Array ).Length) ), ((byte[]) (b) ));
			}
			#line default
		}
		
		
		public static   global::haxe.io.Bytes ofData(byte[] b){
			unchecked {
				#line 458 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				return new global::haxe.io.Bytes(((int) (( b as global::System.Array ).Length) ), ((byte[]) (b) ));
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				return new global::haxe.io.Bytes(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				return new global::haxe.io.Bytes(((int) (global::haxe.lang.Runtime.toInt(arr[0])) ), ((byte[]) (arr[1]) ));
			}
			#line default
		}
		
		
		public  int length;
		
		public  byte[] b;
		
		public virtual   string toString(){
			unchecked {
				#line 335 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				return global::System.Text.Encoding.UTF8.GetString(((byte[]) (this.b) ), ((int) (0) ), ((int) (this.length) ));
			}
			#line default
		}
		
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				switch (hash){
					case 520590566:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						this.length = ((int) (@value) );
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return @value;
					}
					
					
					default:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				switch (hash){
					case 98:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						this.b = ((byte[]) (@value) );
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return @value;
					}
					
					
					case 520590566:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						this.length = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return @value;
					}
					
					
					default:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				switch (hash){
					case 946786476:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("toString") ), ((int) (946786476) ))) );
					}
					
					
					case 98:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return this.b;
					}
					
					
					case 520590566:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return this.length;
					}
					
					
					default:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				switch (hash){
					case 520590566:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return ((double) (this.length) );
					}
					
					
					default:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				switch (hash){
					case 946786476:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return this.toString();
					}
					
					
					default:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				baseArr.push("b");
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				baseArr.push("length");
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
				{
					#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Bytes.hx"
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


