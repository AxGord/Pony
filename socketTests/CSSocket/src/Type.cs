
#pragma warning disable 109, 114, 219, 429, 168, 162
public  class ValueType : global::haxe.lang.Enum {
	static ValueType() {
		#line 50 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
		global::ValueType.constructs = new global::Array<object>(new object[]{"TNull", "TInt", "TFloat", "TBool", "TObject", "TFunction", "TClass", "TEnum", "TUnknown"});
		global::ValueType.TNull = new global::ValueType(((int) (0) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
		global::ValueType.TInt = new global::ValueType(((int) (1) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
		global::ValueType.TFloat = new global::ValueType(((int) (2) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
		global::ValueType.TBool = new global::ValueType(((int) (3) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
		global::ValueType.TObject = new global::ValueType(((int) (4) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
		global::ValueType.TFunction = new global::ValueType(((int) (5) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
		#line 59 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
		global::ValueType.TUnknown = new global::ValueType(((int) (8) ), ((global::Array<object>) (new global::Array<object>(new object[]{})) ));
	}
	public    ValueType(global::haxe.lang.EmptyObject empty) : base(global::haxe.lang.EmptyObject.EMPTY){
		unchecked {
		}
		#line default
	}
	
	
	public    ValueType(int index, global::Array<object> @params) : base(index, @params){
		unchecked {
		}
		#line default
	}
	
	
	public static  global::Array<object> constructs;
	
	public static  global::ValueType TNull;
	
	public static  global::ValueType TInt;
	
	public static  global::ValueType TFloat;
	
	public static  global::ValueType TBool;
	
	public static  global::ValueType TObject;
	
	public static  global::ValueType TFunction;
	
	public static   global::ValueType TClass(global::System.Type c){
		unchecked {
			#line 57 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return new global::ValueType(((int) (6) ), ((global::Array<object>) (new global::Array<object>(new object[]{c})) ));
		}
		#line default
	}
	
	
	public static   global::ValueType TEnum(global::System.Type e){
		unchecked {
			#line 58 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return new global::ValueType(((int) (7) ), ((global::Array<object>) (new global::Array<object>(new object[]{e})) ));
		}
		#line default
	}
	
	
	public static  global::ValueType TUnknown;
	
	public static  new object __hx_createEmpty(){
		unchecked {
			#line 50 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return new global::ValueType(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
		}
		#line default
	}
	
	
	public static  new object __hx_create(global::Array arr){
		unchecked {
			#line 50 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return new global::ValueType(((int) (global::haxe.lang.Runtime.toInt(arr[0])) ), ((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (arr[1]) ))) ));
		}
		#line default
	}
	
	
}



#pragma warning disable 109, 114, 219, 429, 168, 162
public  class Type : global::haxe.lang.HxObject {
	public    Type(global::haxe.lang.EmptyObject empty){
		unchecked {
			#line 62 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public    Type(){
		unchecked {
			#line 62 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			global::Type.__hx_ctor__Type(this);
		}
		#line default
	}
	
	
	public static   void __hx_ctor__Type(global::Type __temp_me14){
		unchecked {
			#line 62 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public static   global::System.Type getClass<T>(T o){
		
		if (o == null || o is haxe.lang.DynamicObject || o is System.Type)
			return null;

		return o.GetType();
	
	}
	
	
	public static   global::System.Type getEnum(object o){
		
		if (o is System.Enum || o is haxe.lang.Enum)
			return o.GetType();
		return null;
	
	}
	
	
	public static   global::System.Type getSuperClass(global::System.Type c){
		unchecked {
			#line 87 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			global::System.Type t = ((global::System.Type) (c) );
			global::System.Type @base = t.BaseType;
			if (( ( global::haxe.lang.Runtime.typeEq(@base, default(global::System.Type)) || string.Equals(global::haxe.lang.Runtime.concat(global::Std.@string(@base), ""), "haxe.lang.HxObject") ) || string.Equals(global::haxe.lang.Runtime.concat(global::Std.@string(@base), ""), "System.Object") )) {
				#line 91 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				return default(global::System.Type);
			}
			
			#line 94 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return ((global::System.Type) (@base) );
		}
		#line default
	}
	
	
	public static   string getClassName(global::System.Type c){
		unchecked {
			#line 98 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			string ret = global::haxe.lang.Runtime.toString(((global::System.Type) (c) ));
			#line 104 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			switch (ret){
				case "System.Int32":
				{
					#line 106 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					return "Int";
				}
				
				
				case "System.Double":
				{
					#line 107 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					return "Float";
				}
				
				
				case "System.String":
				{
					#line 108 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					return "String";
				}
				
				
				case "System.Object":
				{
					#line 109 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					return "Dynamic";
				}
				
				
				case "System.Type":
				{
					#line 110 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					return "Class";
				}
				
				
				default:
				{
					#line 111 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					return global::haxe.lang.Runtime.toString(global::haxe.lang.StringExt.split(ret, "`")[0]);
				}
				
			}
			
		}
		#line default
	}
	
	
	public static   string getEnumName(global::System.Type e){
		unchecked {
			#line 117 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			string ret = global::haxe.lang.Runtime.toString(((global::System.Type) (e) ));
			#line 122 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			if (( ( ret.Length == 14 ) && string.Equals(ret, "System.Boolean") )) {
				#line 123 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				return "Bool";
			}
			
			#line 124 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return ret;
		}
		#line default
	}
	
	
	public static   global::System.Type resolveClass(string name){
		unchecked {
			#line 133 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			global::System.Type t = global::System.Type.GetType(((string) (name) ));
			#line 135 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			if (global::haxe.lang.Runtime.typeEq(t, default(global::System.Type))) {
				#line 137 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				global::System.Collections.IEnumerator all = ( global::System.AppDomain.CurrentDomain.GetAssemblies() as global::System.Array ).GetEnumerator();
				while (all.MoveNext()){
					#line 140 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					global::System.Reflection.Assembly t2 = ((global::System.Reflection.Assembly) (all.Current) );
					t = t2.GetType(((string) (name) ));
					if ( ! (global::haxe.lang.Runtime.typeEq(t, default(global::System.Type))) ) {
						#line 143 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
						break;
					}
					
				}
				
			}
			
			#line 147 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			if (global::haxe.lang.Runtime.typeEq(t, default(global::System.Type))) {
				#line 149 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				switch (name){
					case "Int":
					{
						#line 151 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
						return ((global::System.Type) (typeof(int)) );
					}
					
					
					case "Float":
					{
						#line 152 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
						return ((global::System.Type) (typeof(double)) );
					}
					
					
					case "Class":
					{
						#line 153 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
						return ((global::System.Type) (typeof(global::System.Type)) );
					}
					
					
					case "Dynamic":
					{
						#line 154 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
						return ((global::System.Type) (typeof(object)) );
					}
					
					
					case "String":
					{
						#line 155 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
						return ((global::System.Type) (typeof(string)) );
					}
					
					
					default:
					{
						#line 156 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
						return default(global::System.Type);
					}
					
				}
				
			}
			 else {
				#line 158 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				if (( t.IsInterface && (((global::System.Type) (typeof(global::haxe.lang.IGenericObject)) )).IsAssignableFrom(((global::System.Type) (t) )) )) {
					#line 159 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					t = default(global::System.Type);
					int i = 0;
					string ts = "";
					while (( global::haxe.lang.Runtime.typeEq(t, default(global::System.Type)) && ( i < 18 ) )){
						#line 164 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
						i++;
						ts = global::haxe.lang.Runtime.concat(ts, global::haxe.lang.Runtime.concat((( (( i == 1 )) ? ("") : (",") )), "System.Object"));
						t = global::System.Type.GetType(((string) (global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(name, "`"), global::haxe.lang.Runtime.toString(i)), "["), ts), "]")) ));
					}
					
					#line 169 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					return ((global::System.Type) (t) );
				}
				 else {
					#line 171 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					return ((global::System.Type) (t) );
				}
				
			}
			
		}
		#line default
	}
	
	
	public static   global::System.Type resolveEnum(string name){
		
		if (name == "Bool") return typeof(bool);
		System.Type t = resolveClass(name);
		if (t != null && (t.BaseType.Equals(typeof(System.Enum)) || t.BaseType.Equals(typeof(haxe.lang.Enum))))
			return t;
		return null;
	
	}
	
	
	public static   T createInstance<T>(global::System.Type cl, global::Array args){
		unchecked {
			#line 190 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			if (global::haxe.lang.Runtime.refEq(cl, typeof(string))) {
				#line 191 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				return global::haxe.lang.Runtime.genericCast<T>(args[0]);
			}
			
			#line 192 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			global::System.Type t = ((global::System.Type) (cl) );
			if (t.IsInterface) {
				#line 196 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				global::System.Type cl1 = global::Type.resolveClass(global::Type.getClassName(cl));
				#line 196 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				t = cl1;
			}
			
			#line 198 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			global::System.Reflection.ConstructorInfo[] ctors = t.GetConstructors();
			return global::haxe.lang.Runtime.genericCast<T>(global::haxe.lang.Runtime.callMethod(default(object), ((global::System.Reflection.MethodBase[]) (ctors) ), ( ctors as global::System.Array ).Length, args));
		}
		#line default
	}
	
	
	public static   T createEmptyInstance<T>(global::System.Type cl){
		unchecked {
			#line 204 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			global::System.Type t = ((global::System.Type) (cl) );
			if (t.IsInterface) {
				#line 208 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				global::System.Type cl1 = global::Type.resolveClass(global::Type.getClassName(cl));
				#line 208 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				t = cl1;
			}
			
			#line 211 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			if (global::Reflect.hasField(cl, "__hx_createEmpty")) {
				#line 212 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				return global::haxe.lang.Runtime.genericCast<T>(global::haxe.lang.Runtime.callField(cl, "__hx_createEmpty", 2084789794, default(global::Array)));
			}
			
			#line 213 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return global::Type.createInstance<T>(cl, new global::Array<object>(new object[]{}));
		}
		#line default
	}
	
	
	public static   T createEnum<T>(global::System.Type e, string constr, global::Array @params){
		
		if (@params == null || @params[0] == null)
		{
			object ret = haxe.lang.Runtime.slowGetField(e, constr, true);
			if (ret is haxe.lang.Function)
				throw haxe.lang.HaxeException.wrap("Constructor " + constr + " needs parameters");
			return (T) ret;
		} else {
			return (T) haxe.lang.Runtime.slowCallField(e, constr, @params);
		}
	
	}
	
	
	public static   T createEnumIndex<T>(global::System.Type e, int index, global::Array @params){
		unchecked {
			#line 233 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			global::Array<object> constr = global::Type.getEnumConstructs(e);
			return global::Type.createEnum<T>(e, global::haxe.lang.Runtime.toString(constr[index]), @params);
		}
		#line default
	}
	
	
	public static   global::Array<object> getInstanceFields(global::System.Type c){
		
		if (c == typeof(string))
		{
			return haxe.lang.StringRefl.fields;
		}

		Array<object> ret = new Array<object>();

        System.Reflection.MemberInfo[] mis = c.GetMembers(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.FlattenHierarchy);
        for (int i = 0; i < mis.Length; i++)
        {
			if (mis[i] is System.Reflection.PropertyInfo)
                continue;
			string n = mis[i].Name;
			if (!n.StartsWith("__hx_") && n[0] != '.' && !n.Equals("Equals") && !n.Equals("ToString") && !n.Equals("GetHashCode") && !n.Equals("GetType"))
				ret.push(mis[i].Name);
        }

		return ret;
	
	}
	
	
	public static   global::Array<object> getClassFields(global::System.Type c){
		
		Array<object> ret = new Array<object>();

		if (c == typeof(string))
		{
			ret.push("fromCharCode");
			return ret;
		}

        System.Reflection.MemberInfo[] mis = c.GetMembers(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Static);
        for (int i = 0; i < mis.Length; i++)
        {
            string n = mis[i].Name;
			if (!n.StartsWith("__hx_"))
				ret.push(mis[i].Name);
        }

        return ret;
	
	}
	
	
	public static   global::Array<object> getEnumConstructs(global::System.Type e){
		unchecked {
			#line 285 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			if (global::Reflect.hasField(e, "constructs")) {
				#line 286 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				return ((global::Array<object>) (global::Array<object>.__hx_cast<object>(((global::Array) (global::haxe.lang.Runtime.callField(global::haxe.lang.Runtime.getField(e, "constructs", 1744813180, true), "copy", 1103412149, default(global::Array))) ))) );
			}
			
			#line 287 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return global::cs.Lib.array<object>(((object[]) (global::System.Enum.GetNames(((global::System.Type) (global::cs.Lib.nativeType(e)) ))) ));
		}
		#line default
	}
	
	
	public static   global::ValueType @typeof(object v){
		
		if (v == null) return ValueType.TNull;

        System.Type t = v as System.Type;
        if (t != null)
        {
            //class type
            return ValueType.TObject;
        }

        t = v.GetType();
        if (t.IsEnum)
            return ValueType.TEnum(t);
        if (t.IsValueType)
        {
            System.IConvertible vc = v as System.IConvertible;
            if (vc != null)
            {
                switch (vc.GetTypeCode())
                {
                    case System.TypeCode.Boolean: return ValueType.TBool;
                    case System.TypeCode.Double:
						double d = vc.ToDouble(null);
						if (d >= int.MinValue && d <= int.MaxValue && d == vc.ToInt32(null))
							return ValueType.TInt;
						else
							return ValueType.TFloat;
                    case System.TypeCode.Int32:
                        return ValueType.TInt;
                    default:
                        return ValueType.TClass(t);
                }
            } else {
                return ValueType.TClass(t);
            }
        }

        if (v is haxe.lang.IHxObject)
        {
            if (v is haxe.lang.DynamicObject)
                return ValueType.TObject;
            else if (v is haxe.lang.Enum)
                return ValueType.TEnum(t);
            return ValueType.TClass(t);
        } else if (v is haxe.lang.Function) {
            return ValueType.TFunction;
        } else {
            return ValueType.TClass(t);
        }
	
	}
	
	
	public static   bool enumEq<T>(T a, T b){
		
			if (a is haxe.lang.Enum)
				return a.Equals(b);
			else
				return haxe.lang.Runtime.eq(a, b);
	
	}
	
	
	public static   string enumConstructor(object e){
		
		if (e is System.Enum)
			return e + "";
		else
			return ((haxe.lang.Enum) e).getTag();
	
	}
	
	
	public static   global::Array enumParameters(object e){
		
		return ( e is System.Enum ) ? new Array<object>() : ((haxe.lang.Enum) e).@params;
	
	}
	
	
	public static   int enumIndex(object e){
		
		if (e is System.Enum)
			return ((System.IConvertible) e).ToInt32(null);
		else
			return ((haxe.lang.Enum) e).index;
	
	}
	
	
	public static   global::Array<T> allEnums<T>(global::System.Type e){
		unchecked {
			#line 388 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			global::Array<object> ctors = global::Type.getEnumConstructs(e);
			global::Array<T> ret = new global::Array<T>(new T[]{});
			{
				#line 390 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				int _g = 0;
				#line 390 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
				while (( _g < ctors.length )){
					#line 390 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					string ctor = global::haxe.lang.Runtime.toString(ctors[_g]);
					#line 390 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					 ++ _g;
					#line 392 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
					T v = global::haxe.lang.Runtime.genericCast<T>(global::Reflect.field(e, ctor));
					if (global::Std.@is(v, e)) {
						#line 394 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
						ret.push(v);
					}
					
				}
				
			}
			
			#line 397 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return ret;
		}
		#line default
	}
	
	
	public static  new object __hx_createEmpty(){
		unchecked {
			#line 62 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return new global::Type(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
		}
		#line default
	}
	
	
	public static  new object __hx_create(global::Array arr){
		unchecked {
			#line 62 "C:\\HaxeToolkit\\haxe\\std\\cs\\_std\\Type.hx"
			return new global::Type();
		}
		#line default
	}
	
	
}


