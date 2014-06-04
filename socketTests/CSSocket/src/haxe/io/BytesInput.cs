
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.io{
	public  class BytesInput : global::haxe.io.Input {
		public    BytesInput(global::haxe.lang.EmptyObject empty) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
			}
			#line default
		}
		
		
		public    BytesInput(global::haxe.io.Bytes b, global::haxe.lang.Null<int> pos, global::haxe.lang.Null<int> len){
			unchecked {
				#line 38 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				global::haxe.io.BytesInput.__hx_ctor_haxe_io_BytesInput(this, b, pos, len);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_io_BytesInput(global::haxe.io.BytesInput __temp_me39, global::haxe.io.Bytes b, global::haxe.lang.Null<int> pos, global::haxe.lang.Null<int> len){
			unchecked {
				#line 39 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				if ( ! (pos.hasValue) ) {
					#line 39 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
					pos = new global::haxe.lang.Null<int>(0, true);
				}
				
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				if ( ! (len.hasValue) ) {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
					len = new global::haxe.lang.Null<int>(( b.length - pos.@value ), true);
				}
				
				#line 41 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				if (( ( ( pos.@value < 0 ) || ( len.@value < 0 ) ) || ( ( pos.@value + len.@value ) > b.length ) )) {
					#line 41 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
					throw global::haxe.lang.HaxeException.wrap(global::haxe.io.Error.OutsideBounds);
				}
				
				#line 53 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				__temp_me39.b = b.b;
				__temp_me39.pos = pos.@value;
				__temp_me39.len = len.@value;
				__temp_me39.totlen = len.@value;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				return new global::haxe.io.BytesInput(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				return new global::haxe.io.BytesInput(((global::haxe.io.Bytes) (arr[0]) ), global::haxe.lang.Null<object>.ofDynamic<int>(arr[1]), global::haxe.lang.Null<object>.ofDynamic<int>(arr[2]));
			}
			#line default
		}
		
		
		public  byte[] b;
		
		public  int pos;
		
		public  int len;
		
		public  int totlen;
		
		public override   int readByte(){
			unchecked {
				#line 94 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				if (( this.len == 0 )) {
					#line 95 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
					throw global::haxe.lang.HaxeException.wrap(new global::haxe.io.Eof());
				}
				
				#line 96 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				this.len--;
				#line 106 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				return ((int) (this.b[this.pos++]) );
			}
			#line default
		}
		
		
		public override   int readBytes(global::haxe.io.Bytes buf, int pos, int len){
			unchecked {
				#line 113 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				if (( ( ( pos < 0 ) || ( len < 0 ) ) || ( ( pos + len ) > buf.length ) )) {
					#line 114 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
					throw global::haxe.lang.HaxeException.wrap(global::haxe.io.Error.OutsideBounds);
				}
				
				#line 129 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				int avail = this.len;
				if (( len > avail )) {
					#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
					len = avail;
				}
				
				#line 131 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				if (( len == 0 )) {
					#line 132 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
					throw global::haxe.lang.HaxeException.wrap(new global::haxe.io.Eof());
				}
				
				#line 133 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				global::System.Array.Copy(((global::System.Array) (this.b) ), ((int) (this.pos) ), ((global::System.Array) (buf.b) ), ((int) (pos) ), ((int) (len) ));
				this.pos += len;
				this.len -= len;
				#line 154 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				return len;
			}
			#line default
		}
		
		
		public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				switch (hash){
					case 400509660:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						this.totlen = ((int) (@value) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return @value;
					}
					
					
					case 5393365:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						this.len = ((int) (@value) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return @value;
					}
					
					
					case 5594516:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						this.pos = ((int) (@value) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return @value;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return base.__hx_setField_f(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				switch (hash){
					case 400509660:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						this.totlen = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return @value;
					}
					
					
					case 5393365:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						this.len = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return @value;
					}
					
					
					case 5594516:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						this.pos = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return @value;
					}
					
					
					case 98:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						this.b = ((byte[]) (@value) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return @value;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				switch (hash){
					case 243225909:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("readBytes") ), ((int) (243225909) ))) );
					}
					
					
					case 1763375486:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("readByte") ), ((int) (1763375486) ))) );
					}
					
					
					case 400509660:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return this.totlen;
					}
					
					
					case 5393365:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return this.len;
					}
					
					
					case 5594516:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return this.pos;
					}
					
					
					case 98:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return this.b;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				switch (hash){
					case 400509660:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return ((double) (this.totlen) );
					}
					
					
					case 5393365:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return ((double) (this.len) );
					}
					
					
					case 5594516:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return ((double) (this.pos) );
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				baseArr.push("totlen");
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				baseArr.push("len");
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				baseArr.push("pos");
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				baseArr.push("b");
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
				{
					#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\BytesInput.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}


