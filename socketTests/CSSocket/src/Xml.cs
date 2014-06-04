
namespace _Xml{
	public enum RealXmlType{
		Element, PCData, CData, Comment, DocType, ProcessingInstruction, Document
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
public  class Xml : global::haxe.lang.HxObject {
	static Xml() {
		#line 335 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
		{
			#line 336 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			global::Xml.Element = ((global::_Xml.RealXmlType) (((object) (global::_Xml.RealXmlType.Element) )) );
			global::Xml.PCData = ((global::_Xml.RealXmlType) (((object) (global::_Xml.RealXmlType.PCData) )) );
			global::Xml.CData = ((global::_Xml.RealXmlType) (((object) (global::_Xml.RealXmlType.CData) )) );
			global::Xml.Comment = ((global::_Xml.RealXmlType) (((object) (global::_Xml.RealXmlType.Comment) )) );
			global::Xml.DocType = ((global::_Xml.RealXmlType) (((object) (global::_Xml.RealXmlType.DocType) )) );
			global::Xml.ProcessingInstruction = ((global::_Xml.RealXmlType) (((object) (global::_Xml.RealXmlType.ProcessingInstruction) )) );
			global::Xml.Document = ((global::_Xml.RealXmlType) (((object) (global::_Xml.RealXmlType.Document) )) );
		}
		
	}
	public    Xml(global::haxe.lang.EmptyObject empty){
		unchecked {
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public    Xml(){
		unchecked {
			#line 61 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			global::Xml.__hx_ctor__Xml(this);
		}
		#line default
	}
	
	
	public static   void __hx_ctor__Xml(global::Xml __temp_me15){
		unchecked {
			#line 61 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public static  global::_Xml.RealXmlType Element;
	
	public static  global::_Xml.RealXmlType PCData;
	
	public static  global::_Xml.RealXmlType CData;
	
	public static  global::_Xml.RealXmlType Comment;
	
	public static  global::_Xml.RealXmlType DocType;
	
	public static  global::_Xml.RealXmlType ProcessingInstruction;
	
	public static  global::_Xml.RealXmlType Document;
	
	public static   global::Xml parse(string str){
		unchecked {
			#line 58 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			return global::haxe.xml.Parser.parse(str);
		}
		#line default
	}
	
	
	public static   global::Xml createElement(string name){
		unchecked {
			#line 65 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			global::Xml r = new global::Xml();
			r.nodeType = global::Xml.Element;
			r._children = new global::Array<object>();
			r._attributes = new global::haxe.ds.StringMap<object>();
			r.set_nodeName(name);
			return r;
		}
		#line default
	}
	
	
	public static   global::Xml createPCData(string data){
		unchecked {
			#line 74 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			global::Xml r = new global::Xml();
			r.nodeType = global::Xml.PCData;
			r.set_nodeValue(data);
			return r;
		}
		#line default
	}
	
	
	public static   global::Xml createCData(string data){
		unchecked {
			#line 81 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			global::Xml r = new global::Xml();
			r.nodeType = global::Xml.CData;
			r.set_nodeValue(data);
			return r;
		}
		#line default
	}
	
	
	public static   global::Xml createComment(string data){
		unchecked {
			#line 88 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			global::Xml r = new global::Xml();
			r.nodeType = global::Xml.Comment;
			r.set_nodeValue(data);
			return r;
		}
		#line default
	}
	
	
	public static   global::Xml createDocType(string data){
		unchecked {
			#line 95 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			global::Xml r = new global::Xml();
			r.nodeType = global::Xml.DocType;
			r.set_nodeValue(data);
			return r;
		}
		#line default
	}
	
	
	public static   global::Xml createProcessingInstruction(string data){
		unchecked {
			#line 102 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			global::Xml r = new global::Xml();
			r.nodeType = global::Xml.ProcessingInstruction;
			r.set_nodeValue(data);
			return r;
		}
		#line default
	}
	
	
	public static   global::Xml createDocument(){
		unchecked {
			#line 109 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			global::Xml r = new global::Xml();
			r.nodeType = global::Xml.Document;
			r._children = new global::Array<object>();
			return r;
		}
		#line default
	}
	
	
	public static  new object __hx_createEmpty(){
		unchecked {
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			return new global::Xml(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
		}
		#line default
	}
	
	
	public static  new object __hx_create(global::Array arr){
		unchecked {
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			return new global::Xml();
		}
		#line default
	}
	
	
	public  global::_Xml.RealXmlType nodeType;
	
	public  string _nodeName;
	
	public  string _nodeValue;
	
	public  global::haxe.ds.StringMap<object> _attributes;
	
	public  global::Array<object> _children;
	
	public  global::Xml _parent;
	
	public virtual   string get_nodeName(){
		unchecked {
			#line 116 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			if (( this.nodeType != global::Xml.Element )) {
				#line 117 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
				throw global::haxe.lang.HaxeException.wrap("bad nodeType");
			}
			
			#line 118 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			return this._nodeName;
		}
		#line default
	}
	
	
	public virtual   string set_nodeName(string n){
		unchecked {
			#line 122 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			if (( this.nodeType != global::Xml.Element )) {
				#line 123 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
				throw global::haxe.lang.HaxeException.wrap("bad nodeType");
			}
			
			#line 124 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			return this._nodeName = n;
		}
		#line default
	}
	
	
	public virtual   string set_nodeValue(string v){
		unchecked {
			#line 134 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			if (( ( this.nodeType == global::Xml.Element ) || ( this.nodeType == global::Xml.Document ) )) {
				#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
				throw global::haxe.lang.HaxeException.wrap("bad nodeType");
			}
			
			#line 136 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			return this._nodeValue = v;
		}
		#line default
	}
	
	
	public virtual   string @get(string att){
		unchecked {
			#line 144 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			if (( this.nodeType != global::Xml.Element )) {
				#line 145 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
				throw global::haxe.lang.HaxeException.wrap("bad nodeType");
			}
			
			#line 146 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			return global::haxe.lang.Runtime.toString(this._attributes.@get(att).@value);
		}
		#line default
	}
	
	
	public virtual   void @set(string att, string @value){
		unchecked {
			#line 150 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			if (( this.nodeType != global::Xml.Element )) {
				#line 151 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
				throw global::haxe.lang.HaxeException.wrap("bad nodeType");
			}
			
			#line 152 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			this._attributes.@set(att, @value);
		}
		#line default
	}
	
	
	public virtual   bool exists(string att){
		unchecked {
			#line 162 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			if (( this.nodeType != global::Xml.Element )) {
				#line 163 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
				throw global::haxe.lang.HaxeException.wrap("bad nodeType");
			}
			
			#line 164 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			return this._attributes.exists(att);
		}
		#line default
	}
	
	
	public virtual   void addChild(global::Xml x){
		unchecked {
			#line 273 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			if (( this._children == default(global::Array<object>) )) {
				#line 273 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
				throw global::haxe.lang.HaxeException.wrap("bad nodetype");
			}
			
			#line 274 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			if (( x._parent != default(global::Xml) )) {
				#line 274 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
				x._parent._children.@remove(x);
			}
			
			#line 275 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			x._parent = this;
			this._children.push(x);
		}
		#line default
	}
	
	
	public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
		unchecked {
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			switch (hash){
				case 1542788809:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					this._parent = ((global::Xml) (@value) );
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return @value;
				}
				
				
				case 939528350:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					this._children = ((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (@value) ))) );
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return @value;
				}
				
				
				case 1778087414:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					this._attributes = ((global::haxe.ds.StringMap<object>) (global::haxe.ds.StringMap<object>.__hx_cast<object>(((global::haxe.ds.StringMap) (@value) ))) );
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return @value;
				}
				
				
				case 831576528:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					this._nodeValue = global::haxe.lang.Runtime.toString(@value);
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return @value;
				}
				
				
				case 974309580:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					this._nodeName = global::haxe.lang.Runtime.toString(@value);
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return @value;
				}
				
				
				case 1988514268:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					this.nodeType = ((global::_Xml.RealXmlType) (@value) );
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return @value;
				}
				
				
				default:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return base.__hx_setField(field, hash, @value, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
		unchecked {
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			switch (hash){
				case 1058459579:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("addChild") ), ((int) (1058459579) ))) );
				}
				
				
				case 1071652316:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("exists") ), ((int) (1071652316) ))) );
				}
				
				
				case 5741474:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("set") ), ((int) (5741474) ))) );
				}
				
				
				case 5144726:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get") ), ((int) (5144726) ))) );
				}
				
				
				case 1549276146:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("set_nodeValue") ), ((int) (1549276146) ))) );
				}
				
				
				case 1016047850:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("set_nodeName") ), ((int) (1016047850) ))) );
				}
				
				
				case 664175990:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("get_nodeName") ), ((int) (664175990) ))) );
				}
				
				
				case 1542788809:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this._parent;
				}
				
				
				case 939528350:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this._children;
				}
				
				
				case 1778087414:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this._attributes;
				}
				
				
				case 831576528:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this._nodeValue;
				}
				
				
				case 974309580:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this._nodeName;
				}
				
				
				case 1988514268:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this.nodeType;
				}
				
				
				default:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
		unchecked {
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			switch (hash){
				case 1058459579:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					this.addChild(((global::Xml) (dynargs[0]) ));
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					break;
				}
				
				
				case 1071652316:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this.exists(global::haxe.lang.Runtime.toString(dynargs[0]));
				}
				
				
				case 5741474:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					this.@set(global::haxe.lang.Runtime.toString(dynargs[0]), global::haxe.lang.Runtime.toString(dynargs[1]));
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					break;
				}
				
				
				case 5144726:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this.@get(global::haxe.lang.Runtime.toString(dynargs[0]));
				}
				
				
				case 1549276146:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this.set_nodeValue(global::haxe.lang.Runtime.toString(dynargs[0]));
				}
				
				
				case 1016047850:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this.set_nodeName(global::haxe.lang.Runtime.toString(dynargs[0]));
				}
				
				
				case 664175990:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return this.get_nodeName();
				}
				
				
				default:
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
					return base.__hx_invokeField(field, hash, dynargs);
				}
				
			}
			
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			return default(object);
		}
		#line default
	}
	
	
	public override   void __hx_getFields(global::Array<object> baseArr){
		unchecked {
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			baseArr.push("_parent");
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			baseArr.push("_children");
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			baseArr.push("_attributes");
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			baseArr.push("_nodeValue");
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			baseArr.push("_nodeName");
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			baseArr.push("nodeType");
			#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
			{
				#line 36 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Xml.hx"
				base.__hx_getFields(baseArr);
			}
			
		}
		#line default
	}
	
	
}


