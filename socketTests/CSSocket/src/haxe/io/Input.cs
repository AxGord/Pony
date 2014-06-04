
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.io{
	public  class Input : global::haxe.lang.HxObject {
		public    Input(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Input(){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				global::haxe.io.Input.__hx_ctor_haxe_io_Input(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_io_Input(global::haxe.io.Input __temp_me24){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				return new global::haxe.io.Input(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				return new global::haxe.io.Input();
			}
			#line default
		}
		
		
		public  bool bigEndian;
		
		public virtual   int readByte(){
			unchecked {
				#line 42 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				throw global::haxe.lang.HaxeException.wrap("Not implemented");
			}
			#line default
		}
		
		
		public virtual   int readBytes(global::haxe.io.Bytes s, int pos, int len){
			unchecked {
				#line 47 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				int k = len;
				byte[] b = s.b;
				if (( ( ( pos < 0 ) || ( len < 0 ) ) || ( ( pos + len ) > s.length ) )) {
					#line 50 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
					throw global::haxe.lang.HaxeException.wrap(global::haxe.io.Error.OutsideBounds);
				}
				
				#line 51 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				while (( k > 0 )){
					#line 59 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
					b[pos] = ((byte) (this.readByte()) );
					#line 61 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
					pos++;
					k--;
				}
				
				#line 64 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				return len;
			}
			#line default
		}
		
		
		public virtual   void readFullBytes(global::haxe.io.Bytes s, int pos, int len){
			unchecked {
				#line 100 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				while (( len > 0 )){
					#line 101 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
					int k = this.readBytes(s, pos, len);
					pos += k;
					len -= k;
				}
				
			}
			#line default
		}
		
		
		public virtual   global::haxe.io.Bytes read(int nbytes){
			unchecked {
				#line 108 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				global::haxe.io.Bytes s = global::haxe.io.Bytes.alloc(nbytes);
				int p = 0;
				while (( nbytes > 0 )){
					#line 111 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
					int k = this.readBytes(s, p, nbytes);
					if (( k == 0 )) {
						#line 112 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						throw global::haxe.lang.HaxeException.wrap(global::haxe.io.Error.Blocked);
					}
					
					#line 113 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
					p += k;
					nbytes -= k;
				}
				
				#line 116 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				return s;
			}
			#line default
		}
		
		
		public virtual   int readInt32(){
			unchecked {
				#line 311 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				int ch1 = this.readByte();
				int ch2 = this.readByte();
				int ch3 = this.readByte();
				int ch4 = this.readByte();
				#line 322 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				if (this.bigEndian) {
					#line 322 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
					return ( ( ( ch4 | ( ch3 << 8 ) ) | ( ch2 << 16 ) ) | ( ch1 << 24 ) );
				}
				 else {
					#line 322 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
					return ( ( ( ch1 | ( ch2 << 8 ) ) | ( ch3 << 16 ) ) | ( ch4 << 24 ) );
				}
				
			}
			#line default
		}
		
		
		public virtual   string readString(int len){
			unchecked {
				#line 327 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				global::haxe.io.Bytes b = global::haxe.io.Bytes.alloc(len);
				this.readFullBytes(b, 0, len);
				#line 332 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				return b.toString();
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				switch (hash){
					case 542823803:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						this.bigEndian = global::haxe.lang.Runtime.toBool(@value);
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return @value;
					}
					
					
					default:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				switch (hash){
					case 179047623:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("readString") ), ((int) (179047623) ))) );
					}
					
					
					case 252174360:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("readInt32") ), ((int) (252174360) ))) );
					}
					
					
					case 1269254998:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("read") ), ((int) (1269254998) ))) );
					}
					
					
					case 1309344294:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("readFullBytes") ), ((int) (1309344294) ))) );
					}
					
					
					case 243225909:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("readBytes") ), ((int) (243225909) ))) );
					}
					
					
					case 1763375486:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("readByte") ), ((int) (1763375486) ))) );
					}
					
					
					case 542823803:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return this.bigEndian;
					}
					
					
					default:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				switch (hash){
					case 179047623:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return this.readString(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ));
					}
					
					
					case 252174360:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return this.readInt32();
					}
					
					
					case 1269254998:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return this.read(((int) (global::haxe.lang.Runtime.toInt(dynargs[0])) ));
					}
					
					
					case 1309344294:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						this.readFullBytes(((global::haxe.io.Bytes) (dynargs[0]) ), ((int) (global::haxe.lang.Runtime.toInt(dynargs[1])) ), ((int) (global::haxe.lang.Runtime.toInt(dynargs[2])) ));
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						break;
					}
					
					
					case 243225909:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return this.readBytes(((global::haxe.io.Bytes) (dynargs[0]) ), ((int) (global::haxe.lang.Runtime.toInt(dynargs[1])) ), ((int) (global::haxe.lang.Runtime.toInt(dynargs[2])) ));
					}
					
					
					case 1763375486:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return this.readByte();
					}
					
					
					default:
					{
						#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				baseArr.push("bigEndian");
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
				{
					#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\io\\Input.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}


