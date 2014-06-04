
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.lang{
	public  interface IHxObject {
		   bool __hx_deleteField(string field, int hash);
		
		   object __hx_lookupField(string field, int hash, bool throwErrors, bool isCheck);
		
		   double __hx_lookupField_f(string field, int hash, bool throwErrors);
		
		   object __hx_lookupSetField(string field, int hash, object @value);
		
		   double __hx_lookupSetField_f(string field, int hash, double @value);
		
		   double __hx_setField_f(string field, int hash, double @value, bool handleProperties);
		
		   object __hx_setField(string field, int hash, object @value, bool handleProperties);
		
		   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties);
		
		   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties);
		
		   object __hx_invokeField(string field, int hash, global::Array dynargs);
		
		   void __hx_getFields(global::Array<object> baseArr);
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.lang{
	public  class HxObject : global::haxe.lang.IHxObject {
		public    HxObject(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    HxObject(){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				global::haxe.lang.HxObject.__hx_ctor_haxe_lang_HxObject(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_lang_HxObject(global::haxe.lang.HxObject __temp_me19){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public static   object __hx_createEmpty(){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return new global::haxe.lang.HxObject(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static   object __hx_create(global::Array arr){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return new global::haxe.lang.HxObject();
			}
			#line default
		}
		
		
		public virtual   bool __hx_deleteField(string field, int hash){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return false;
			}
			#line default
		}
		
		
		public virtual   object __hx_lookupField(string field, int hash, bool throwErrors, bool isCheck){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (isCheck) {
					#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return global::haxe.lang.Runtime.undefined;
				}
				 else {
					#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					if (throwErrors) {
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						throw global::haxe.lang.HaxeException.wrap("Field not found.");
					}
					 else {
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return default(object);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   double __hx_lookupField_f(string field, int hash, bool throwErrors){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (throwErrors) {
					#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					throw global::haxe.lang.HaxeException.wrap("Field not found or incompatible field type.");
				}
				 else {
					#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return default(double);
				}
				
			}
			#line default
		}
		
		
		public virtual   object __hx_lookupSetField(string field, int hash, object @value){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				throw global::haxe.lang.HaxeException.wrap("Cannot access field for writing.");
			}
			#line default
		}
		
		
		public virtual   double __hx_lookupSetField_f(string field, int hash, double @value){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				throw global::haxe.lang.HaxeException.wrap("Cannot access field for writing or incompatible type.");
			}
			#line default
		}
		
		
		public virtual   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				switch (hash){
					default:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.__hx_lookupSetField_f(field, hash, @value);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				switch (hash){
					default:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.__hx_lookupSetField(field, hash, @value);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				switch (hash){
					default:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.__hx_lookupField(field, hash, throwErrors, isCheck);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				switch (hash){
					default:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.__hx_lookupField_f(field, hash, throwErrors);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				switch (hash){
					default:
					{
						#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return ((global::haxe.lang.Function) (this.__hx_getField(field, hash, true, false, false)) ).__hx_invokeDynamic(dynargs);
					}
					
				}
				
			}
			#line default
		}
		
		
		public virtual   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 27 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				{
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.lang{
	public  class DynamicObject : global::haxe.lang.HxObject {
		public    DynamicObject(global::haxe.lang.EmptyObject empty) : base(global::haxe.lang.EmptyObject.EMPTY){
			unchecked {
			}
			#line default
		}
		
		
		public    DynamicObject(){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				global::haxe.lang.DynamicObject.__hx_ctor_haxe_lang_DynamicObject(((global::haxe.lang.DynamicObject) (this) ));
			}
			#line default
		}
		
		
		public    DynamicObject(global::Array<int> __hx_hashes, global::Array<object> __hx_dynamics, global::Array<int> __hx_hashes_f, global::Array<double> __hx_dynamics_f){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				global::haxe.lang.DynamicObject.__hx_ctor_haxe_lang_DynamicObject(((global::haxe.lang.DynamicObject) (this) ), ((global::Array<int>) (__hx_hashes) ), ((global::Array<object>) (__hx_dynamics) ), ((global::Array<int>) (__hx_hashes_f) ), ((global::Array<double>) (__hx_dynamics_f) ));
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_lang_DynamicObject(global::haxe.lang.DynamicObject __temp_me21){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				__temp_me21.__hx_hashes = new global::Array<int>(new int[]{});
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				__temp_me21.__hx_dynamics = new global::Array<object>(new object[]{});
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				__temp_me21.__hx_hashes_f = new global::Array<int>(new int[]{});
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				__temp_me21.__hx_dynamics_f = new global::Array<double>(new double[]{});
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_lang_DynamicObject(global::haxe.lang.DynamicObject __temp_me20, global::Array<int> __hx_hashes, global::Array<object> __hx_dynamics, global::Array<int> __hx_hashes_f, global::Array<double> __hx_dynamics_f){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				__temp_me20.__hx_hashes = __hx_hashes;
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				__temp_me20.__hx_dynamics = __hx_dynamics;
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				__temp_me20.__hx_hashes_f = __hx_hashes_f;
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				__temp_me20.__hx_dynamics_f = __hx_dynamics_f;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return new global::haxe.lang.DynamicObject(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return new global::haxe.lang.DynamicObject(((global::Array<int>) (global::Array<object>.__hx_cast<int>(((global::Array) (arr[0]) ))) ), ((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (arr[1]) ))) ), ((global::Array<int>) (global::Array<object>.__hx_cast<int>(((global::Array) (arr[2]) ))) ), ((global::Array<double>) (global::Array<object>.__hx_cast<double>(((global::Array) (arr[3]) ))) ));
			}
			#line default
		}
		
		
		public virtual   string toString(){
			unchecked {
				#line 44 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				global::haxe.lang.Function ts = ((global::haxe.lang.Function) (global::haxe.lang.Runtime.getField(this, "toString", 946786476, false)) );
				if (( ts != default(global::haxe.lang.Function) )) {
					#line 46 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return global::haxe.lang.Runtime.toString(ts.__hx_invoke0_o());
				}
				
				#line 47 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				global::StringBuf ret = new global::StringBuf();
				ret.b.Append(((object) ("{") ));
				bool first = true;
				{
					#line 50 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					int _g = 0;
					#line 50 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					global::Array<object> _g1 = global::Reflect.fields(this);
					#line 50 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					while (( _g < _g1.length )){
						#line 50 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						string f = global::haxe.lang.Runtime.toString(_g1[_g]);
						#line 50 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						 ++ _g;
						#line 52 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						if (first) {
							#line 53 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							first = false;
						}
						 else {
							#line 55 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							ret.b.Append(((object) (",") ));
						}
						
						#line 56 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						ret.b.Append(((object) (" ") ));
						#line 56 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						ret.b.Append(((object) (global::Std.@string(f)) ));
						ret.b.Append(((object) (" : ") ));
						{
							#line 58 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							object x = global::Reflect.field(this, f);
							#line 58 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							ret.b.Append(((object) (global::Std.@string(x)) ));
						}
						
					}
					
				}
				
				#line 60 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if ( ! (first) ) {
					#line 60 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					ret.b.Append(((object) (" ") ));
				}
				
				#line 61 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				ret.b.Append(((object) ("}") ));
				return ret.toString();
			}
			#line default
		}
		
		
		public override   bool __hx_deleteField(string field, int hash){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				int res = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes);
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (( res >= 0 )) {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					this.__hx_hashes.splice(res, 1);
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					this.__hx_dynamics.splice(res, 1);
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return true;
				}
				 else {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					res = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes_f);
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					if (( res >= 0 )) {
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						this.__hx_hashes_f.splice(res, 1);
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						this.__hx_dynamics_f.splice(res, 1);
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return true;
					}
					
				}
				
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return false;
			}
			#line default
		}
		
		
		public  global::Array<int> __hx_hashes = new global::Array<int>(new int[]{});
		
		public  global::Array<object> __hx_dynamics = new global::Array<object>(new object[]{});
		
		public  global::Array<int> __hx_hashes_f = new global::Array<int>(new int[]{});
		
		public  global::Array<double> __hx_dynamics_f = new global::Array<double>(new double[]{});
		
		public override   object __hx_lookupField(string field, int hash, bool throwErrors, bool isCheck){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				int res = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes);
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (( res >= 0 )) {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return this.__hx_dynamics[res];
				}
				 else {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					res = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes_f);
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					if (( res >= 0 )) {
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.__hx_dynamics_f[res];
					}
					
				}
				
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (isCheck) {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return global::haxe.lang.Runtime.undefined;
				}
				 else {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return default(object);
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_lookupField_f(string field, int hash, bool throwErrors){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				int res = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes_f);
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (( res >= 0 )) {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return this.__hx_dynamics_f[res];
				}
				 else {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					res = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes);
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					if (( res >= 0 )) {
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return ((double) (global::haxe.lang.Runtime.toDouble(this.__hx_dynamics[res])) );
					}
					
				}
				
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return default(double);
			}
			#line default
		}
		
		
		public override   object __hx_lookupSetField(string field, int hash, object @value){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				int res = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes);
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (( res >= 0 )) {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return this.__hx_dynamics[res] = @value;
				}
				 else {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					int res2 = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes_f);
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					if (( res2 >= 0 )) {
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						this.__hx_hashes_f.splice(res2, 1);
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						this.__hx_dynamics_f.splice(res2, 1);
					}
					
				}
				
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				this.__hx_hashes.insert( ~ (res) , hash);
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				this.__hx_dynamics.insert( ~ (res) , @value);
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return @value;
			}
			#line default
		}
		
		
		public override   double __hx_lookupSetField_f(string field, int hash, double @value){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				int res = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes_f);
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (( res >= 0 )) {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return this.__hx_dynamics_f[res] = @value;
				}
				 else {
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					int res2 = global::haxe.lang.FieldLookup.findHash(hash, this.__hx_hashes);
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					if (( res2 >= 0 )) {
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						this.__hx_hashes.splice(res2, 1);
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						this.__hx_dynamics.splice(res2, 1);
					}
					
				}
				
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				this.__hx_hashes_f.insert( ~ (res) , hash);
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				this.__hx_dynamics_f.insert( ~ (res) , @value);
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return @value;
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				{
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					{
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						object __temp_iterator120 = this.__hx_hashes.iterator();
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator120, "hasNext", 407283053, default(global::Array)))){
							#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							int __temp_field23 = ((int) (global::haxe.lang.Runtime.toInt(global::haxe.lang.Runtime.callField(__temp_iterator120, "next", 1224901875, default(global::Array)))) );
							#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							baseArr.push(global::haxe.lang.FieldLookup.lookupHash(__temp_field23));
						}
						
					}
					
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					{
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						object __temp_iterator121 = this.__hx_hashes_f.iterator();
						#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator121, "hasNext", 407283053, default(global::Array)))){
							#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							int __temp_field22 = ((int) (global::haxe.lang.Runtime.toInt(global::haxe.lang.Runtime.callField(__temp_iterator121, "next", 1224901875, default(global::Array)))) );
							#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							baseArr.push(global::haxe.lang.FieldLookup.lookupHash(__temp_field22));
						}
						
					}
					
					#line 40 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
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
namespace haxe.lang{
	public  interface IGenericObject : global::haxe.lang.IHxObject {
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.lang{
	public  class Enum : global::haxe.lang.HxObject {
		public    Enum(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Enum(int index, global::Array<object> @params){
			unchecked {
				#line 82 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				this.index = index;
				this.@params = @params;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return new global::haxe.lang.Enum(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return new global::haxe.lang.Enum(((int) (global::haxe.lang.Runtime.toInt(arr[0])) ), ((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (arr[1]) ))) ));
			}
			#line default
		}
		
		
		public readonly int index;
		
		public readonly global::Array<object> @params;
		
		public   string getTag(){
			unchecked {
				#line 87 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				object cl = global::Type.getClass<object>(this);
				return global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.callField(global::haxe.lang.Runtime.getField(cl, "constructs", 1744813180, true), "__get", 1915412854, new global::Array<object>(new object[]{this.index})));
			}
			#line default
		}
		
		
		public virtual   string toString(){
			unchecked {
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (( ( this.@params == default(global::Array<object>) ) || ( this.@params.length == 0 ) )) {
					#line 92 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return this.getTag();
				}
				
				#line 93 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				global::StringBuf ret = new global::StringBuf();
				{
					#line 94 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					string x = this.getTag();
					#line 94 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					ret.b.Append(((object) (global::Std.@string(x)) ));
				}
				
				#line 94 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				ret.b.Append(((object) ("(") ));
				bool first = true;
				{
					#line 96 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					int _g = 0;
					#line 96 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					global::Array<object> _g1 = this.@params;
					#line 96 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					while (( _g < _g1.length )){
						#line 96 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						object p = _g1[_g];
						#line 96 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						 ++ _g;
						#line 98 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						if (first) {
							#line 99 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							first = false;
						}
						 else {
							#line 101 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							ret.b.Append(((object) (",") ));
						}
						
						#line 102 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						ret.b.Append(((object) (global::Std.@string(p)) ));
					}
					
				}
				
				#line 104 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				ret.b.Append(((object) (")") ));
				return ret.toString();
			}
			#line default
		}
		
		
		public override   bool Equals(object obj){
			unchecked {
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (global::haxe.lang.Runtime.eq(obj, this)) {
					#line 110 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return true;
				}
				
				#line 111 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				global::haxe.lang.Enum obj1 = ((global::haxe.lang.Enum) (obj) );
				bool ret = ( ( ( obj1 != default(global::haxe.lang.Enum) ) && global::Std.@is(obj1, global::Type.getClass<object>(this)) ) && ( obj1.index == this.index ) );
				if ( ! (ret) ) {
					#line 114 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return false;
				}
				
				#line 115 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				if (( obj1.@params == this.@params )) {
					#line 116 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return true;
				}
				
				#line 117 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				int len = 0;
				if (( ( ( obj1.@params == default(global::Array<object>) ) || ( this.@params == default(global::Array<object>) ) ) || ( (len = this.@params.length) != obj1.@params.length ) )) {
					#line 119 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					return false;
				}
				
				#line 120 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				{
					#line 120 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					int _g = 0;
					#line 120 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					while (( _g < ((int) (len) ) )){
						#line 120 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						int i = _g++;
						#line 122 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						if ( ! (global::Type.enumEq<object>(obj1.@params[i], this.@params[i])) ) {
							#line 123 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							return false;
						}
						
					}
					
				}
				
				#line 125 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				return true;
			}
			#line default
		}
		
		
		public override   int GetHashCode(){
			unchecked {
				#line 130 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				int h = 19;
				if (( this.@params != default(global::Array<object>) )) {
					#line 131 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					int _g = 0;
					#line 131 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					global::Array<object> _g1 = this.@params;
					#line 131 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
					while (( _g < _g1.length )){
						#line 131 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						object p = _g1[_g];
						#line 131 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						 ++ _g;
						#line 133 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						h = ( h * 31 );
						if (( ! (global::haxe.lang.Runtime.refEq(p, default(object))) )) {
							#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
							h += p.GetHashCode();
						}
						
					}
					
				}
				
				#line 137 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				h += this.index;
				return h;
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				switch (hash){
					case 295397041:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("GetHashCode") ), ((int) (295397041) ))) );
					}
					
					
					case 1955029599:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("Equals") ), ((int) (1955029599) ))) );
					}
					
					
					case 946786476:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("toString") ), ((int) (946786476) ))) );
					}
					
					
					case 589796196:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("getTag") ), ((int) (589796196) ))) );
					}
					
					
					case 1836776262:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.@params;
					}
					
					
					case 1041537810:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.index;
					}
					
					
					default:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
			unchecked {
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				switch (hash){
					case 1041537810:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return ((double) (this.index) );
					}
					
					
					default:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				switch (hash){
					case 295397041:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.GetHashCode();
					}
					
					
					case 1955029599:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.Equals(dynargs[0]);
					}
					
					
					case 946786476:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.toString();
					}
					
					
					case 589796196:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return this.getTag();
					}
					
					
					default:
					{
						#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				baseArr.push("params");
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				baseArr.push("index");
				#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
				{
					#line 75 "C:\\HaxeToolkit\\haxe\\std\\cs\\internal\\HxObject.hx"
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


