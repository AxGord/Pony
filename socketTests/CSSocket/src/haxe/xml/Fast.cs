
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.xml._Fast{
	public  class NodeAccess : global::haxe.lang.DynamicObject {
		public    NodeAccess(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    NodeAccess(global::Xml x){
			unchecked {
				#line 28 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				global::haxe.xml._Fast.NodeAccess.__hx_ctor_haxe_xml__Fast_NodeAccess(this, x);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_xml__Fast_NodeAccess(global::haxe.xml._Fast.NodeAccess __temp_me46, global::Xml x){
			unchecked {
				#line 29 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				__temp_me46.__x = x;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.NodeAccess(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.NodeAccess(((global::Xml) (arr[0]) ));
			}
			#line default
		}
		
		
		public  global::Xml __x;
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 4745560:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.__x = ((global::Xml) (@value) );
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 4745560:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.__x;
					}
					
					
					default:
					{
						#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("__x");
				#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
					#line 24 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.xml._Fast{
	public  class AttribAccess : global::haxe.lang.DynamicObject {
		public    AttribAccess(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    AttribAccess(global::Xml x){
			unchecked {
				#line 47 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				global::haxe.xml._Fast.AttribAccess.__hx_ctor_haxe_xml__Fast_AttribAccess(this, x);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_xml__Fast_AttribAccess(global::haxe.xml._Fast.AttribAccess __temp_me47, global::Xml x){
			unchecked {
				#line 48 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				__temp_me47.__x = x;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.AttribAccess(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.AttribAccess(((global::Xml) (arr[0]) ));
			}
			#line default
		}
		
		
		public  global::Xml __x;
		
		public virtual   string resolve(string name){
			unchecked {
				#line 52 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				if (( this.__x.nodeType == global::Xml.Document )) {
					#line 53 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					throw global::haxe.lang.HaxeException.wrap(global::haxe.lang.Runtime.concat("Cannot access document attribute ", name));
				}
				
				#line 54 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				string v = this.__x.@get(name);
				if (string.Equals(v, default(string))) {
					#line 56 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					throw global::haxe.lang.HaxeException.wrap(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(this.__x.get_nodeName(), " is missing attribute "), name));
				}
				
				#line 57 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return v;
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 4745560:
					{
						#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.__x = ((global::Xml) (@value) );
						#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					default:
					{
						#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 1734349548:
					{
						#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("resolve") ), ((int) (1734349548) ))) );
					}
					
					
					case 4745560:
					{
						#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.__x;
					}
					
					
					default:
					{
						#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 1734349548:
					{
						#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.resolve(global::haxe.lang.Runtime.toString(dynargs[0]));
					}
					
					
					default:
					{
						#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("__x");
				#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
					#line 43 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.xml._Fast{
	public  class HasAttribAccess : global::haxe.lang.DynamicObject {
		public    HasAttribAccess(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    HasAttribAccess(global::Xml x){
			unchecked {
				#line 66 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				global::haxe.xml._Fast.HasAttribAccess.__hx_ctor_haxe_xml__Fast_HasAttribAccess(this, x);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_xml__Fast_HasAttribAccess(global::haxe.xml._Fast.HasAttribAccess __temp_me48, global::Xml x){
			unchecked {
				#line 67 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				__temp_me48.__x = x;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.HasAttribAccess(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.HasAttribAccess(((global::Xml) (arr[0]) ));
			}
			#line default
		}
		
		
		public  global::Xml __x;
		
		public virtual   bool resolve(string name){
			unchecked {
				#line 71 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				if (( this.__x.nodeType == global::Xml.Document )) {
					#line 72 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					throw global::haxe.lang.HaxeException.wrap(global::haxe.lang.Runtime.concat("Cannot access document attribute ", name));
				}
				
				#line 73 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return this.__x.exists(name);
			}
			#line default
		}
		
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 4745560:
					{
						#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.__x = ((global::Xml) (@value) );
						#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					default:
					{
						#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 1734349548:
					{
						#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("resolve") ), ((int) (1734349548) ))) );
					}
					
					
					case 4745560:
					{
						#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.__x;
					}
					
					
					default:
					{
						#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 1734349548:
					{
						#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.resolve(global::haxe.lang.Runtime.toString(dynargs[0]));
					}
					
					
					default:
					{
						#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("__x");
				#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
					#line 62 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.xml._Fast{
	public  class HasNodeAccess : global::haxe.lang.DynamicObject {
		public    HasNodeAccess(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    HasNodeAccess(global::Xml x){
			unchecked {
				#line 82 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				global::haxe.xml._Fast.HasNodeAccess.__hx_ctor_haxe_xml__Fast_HasNodeAccess(this, x);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_xml__Fast_HasNodeAccess(global::haxe.xml._Fast.HasNodeAccess __temp_me49, global::Xml x){
			unchecked {
				#line 83 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				__temp_me49.__x = x;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.HasNodeAccess(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.HasNodeAccess(((global::Xml) (arr[0]) ));
			}
			#line default
		}
		
		
		public  global::Xml __x;
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 4745560:
					{
						#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.__x = ((global::Xml) (@value) );
						#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					default:
					{
						#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 4745560:
					{
						#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.__x;
					}
					
					
					default:
					{
						#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("__x");
				#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
					#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.xml._Fast{
	public  class NodeListAccess : global::haxe.lang.DynamicObject {
		public    NodeListAccess(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    NodeListAccess(global::Xml x){
			unchecked {
				#line 96 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				global::haxe.xml._Fast.NodeListAccess.__hx_ctor_haxe_xml__Fast_NodeListAccess(this, x);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_xml__Fast_NodeListAccess(global::haxe.xml._Fast.NodeListAccess __temp_me50, global::Xml x){
			unchecked {
				#line 97 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				__temp_me50.__x = x;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.NodeListAccess(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml._Fast.NodeListAccess(((global::Xml) (arr[0]) ));
			}
			#line default
		}
		
		
		public  global::Xml __x;
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 4745560:
					{
						#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.__x = ((global::Xml) (@value) );
						#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					default:
					{
						#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 4745560:
					{
						#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.__x;
					}
					
					
					default:
					{
						#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("__x");
				#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
					#line 92 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.xml{
	public  class Fast : global::haxe.lang.HxObject {
		public    Fast(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Fast(global::Xml x){
			unchecked {
				#line 122 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				global::haxe.xml.Fast.__hx_ctor_haxe_xml_Fast(this, x);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_xml_Fast(global::haxe.xml.Fast __temp_me51, global::Xml x){
			unchecked {
				#line 123 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				if (( ( x.nodeType != global::Xml.Document ) && ( x.nodeType != global::Xml.Element ) )) {
					#line 124 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					throw global::haxe.lang.HaxeException.wrap(global::haxe.lang.Runtime.concat("Invalid nodeType ", global::Std.@string(x.nodeType)));
				}
				
				#line 125 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				__temp_me51.x = x;
				__temp_me51.node = new global::haxe.xml._Fast.NodeAccess(((global::Xml) (x) ));
				__temp_me51.nodes = new global::haxe.xml._Fast.NodeListAccess(((global::Xml) (x) ));
				__temp_me51.att = new global::haxe.xml._Fast.AttribAccess(((global::Xml) (x) ));
				__temp_me51.has = new global::haxe.xml._Fast.HasAttribAccess(((global::Xml) (x) ));
				__temp_me51.hasNode = new global::haxe.xml._Fast.HasNodeAccess(((global::Xml) (x) ));
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml.Fast(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				return new global::haxe.xml.Fast(((global::Xml) (arr[0]) ));
			}
			#line default
		}
		
		
		public  global::Xml x;
		
		public  global::haxe.xml._Fast.NodeAccess node;
		
		public  global::haxe.xml._Fast.NodeListAccess nodes;
		
		public  global::haxe.xml._Fast.AttribAccess att;
		
		public  global::haxe.xml._Fast.HasAttribAccess has;
		
		public  global::haxe.xml._Fast.HasNodeAccess hasNode;
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 407775868:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.hasNode = ((global::haxe.xml._Fast.HasNodeAccess) (@value) );
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					case 5193562:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.has = ((global::haxe.xml._Fast.HasAttribAccess) (@value) );
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					case 4849697:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.att = ((global::haxe.xml._Fast.AttribAccess) (@value) );
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					case 532592689:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.nodes = ((global::haxe.xml._Fast.NodeListAccess) (@value) );
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					case 1225394690:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.node = ((global::haxe.xml._Fast.NodeAccess) (@value) );
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					case 120:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						this.x = ((global::Xml) (@value) );
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return @value;
					}
					
					
					default:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				switch (hash){
					case 407775868:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.hasNode;
					}
					
					
					case 5193562:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.has;
					}
					
					
					case 4849697:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.att;
					}
					
					
					case 532592689:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.nodes;
					}
					
					
					case 1225394690:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.node;
					}
					
					
					case 120:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return this.x;
					}
					
					
					default:
					{
						#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("hasNode");
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("has");
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("att");
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("nodes");
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("node");
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				baseArr.push("x");
				#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
				{
					#line 109 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Fast.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}


