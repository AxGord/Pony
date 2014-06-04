
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.io{
	public  class BytesBuffer : global::haxe.lang.HxObject {
		public    BytesBuffer(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    BytesBuffer(){
			unchecked {
				#line 45 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				global::haxe.io.BytesBuffer.__hx_ctor_haxe_io_BytesBuffer(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_io_BytesBuffer(global::haxe.io.BytesBuffer __temp_me38){
			unchecked {
				#line 56 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				__temp_me38.b = new global::System.IO.MemoryStream();
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				return new global::haxe.io.BytesBuffer(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				return new global::haxe.io.BytesBuffer();
			}
			#line default
		}
		
		
		public  global::System.IO.MemoryStream b;
		
		public virtual   global::haxe.io.Bytes getBytes(){
			unchecked {
				#line 183 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				byte[] buf = this.b.GetBuffer();
				global::haxe.io.Bytes bytes = new global::haxe.io.Bytes(((int) (( this.b as global::System.IO.Stream ).Length) ), ((byte[]) (buf) ));
				#line 194 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				this.b = default(global::System.IO.MemoryStream);
				return bytes;
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				switch (hash){
					case 98:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
						this.b = ((global::System.IO.MemoryStream) (@value) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
						return @value;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				switch (hash){
					case 493819893:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("getBytes") ), ((int) (493819893) ))) );
					}
					
					
					case 98:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
						return this.b;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				switch (hash){
					case 493819893:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
						return this.getBytes();
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				baseArr.push("b");
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
				{
					#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesBuffer.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}


