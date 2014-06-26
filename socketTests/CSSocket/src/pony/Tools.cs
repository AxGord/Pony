
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Tools : global::haxe.lang.HxObject {
		public    Tools(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 52 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Tools(){
			unchecked {
				#line 52 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::pony.Tools.__hx_ctor_pony_Tools(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_Tools(global::pony.Tools __temp_me67){
			unchecked {
				#line 52 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public static   bool nore<T>(T v){
			unchecked {
				#line 64 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ( global::haxe.lang.Runtime.eq(v, default(T)) || ( ((int) (global::haxe.lang.Runtime.getField_f(v, "length", 520590566, true)) ) == 0 ) );
			}
			#line default
		}
		
		
		public static   T or<T>(T v1, T v2){
			unchecked {
				#line 66 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (global::haxe.lang.Runtime.eq(v1, default(T))) {
					#line 66 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return v2;
				}
				 else {
					#line 66 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return v1;
				}
				
			}
			#line default
		}
		
		
		public static   bool equal(object a, object b, global::haxe.lang.Null<int> maxDepth){
			unchecked {
				#line 107 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				int __temp_maxDepth64 = ( ( ! (maxDepth.hasValue) ) ? (((int) (1) )) : (maxDepth.@value) );
				if (global::haxe.lang.Runtime.eq(a, b)) {
					#line 108 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return true;
				}
				
				#line 109 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (( __temp_maxDepth64 == 0 )) {
					#line 109 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return false;
				}
				
				#line 111 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::ValueType type = global::Type.@typeof(a);
				#line 113 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				switch (global::Type.enumIndex(type)){
					case 1:case 2:case 3:case 0:
					{
						#line 114 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						return false;
					}
					
					
					case 5:
					{
						#line 117 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						try {
							#line 117 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							return global::Reflect.compareMethods(a, b);
						}
						catch (global::System.Exception __temp_catchallException315){
							#line 117 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							global::haxe.lang.Exceptions.exception = __temp_catchallException315;
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							object __temp_catchall316 = __temp_catchallException315;
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							if (( __temp_catchall316 is global::haxe.lang.HaxeException )) {
								#line 119 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								__temp_catchall316 = ((global::haxe.lang.HaxeException) (__temp_catchallException315) ).obj;
							}
							
							#line 119 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							{
								#line 119 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								object _ = __temp_catchall316;
								#line 119 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								return false;
							}
							
						}
						
						
					}
					
					
					case 7:
					{
						#line 113 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						global::System.Type t = ((global::System.Type) (type.@params[0]) );
						#line 121 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						{
							#line 122 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							if ( ! (global::haxe.lang.Runtime.typeEq(t, global::Type.getEnum(b))) ) {
								#line 122 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								return false;
							}
							
							#line 124 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							if (( global::Type.enumIndex(a) != global::Type.enumIndex(b) )) {
								#line 124 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								return false;
							}
							
							#line 126 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							global::Array a1 = global::Type.enumParameters(a);
							global::Array b1 = global::Type.enumParameters(b);
							#line 129 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							if (( ((int) (global::haxe.lang.Runtime.getField_f(a1, "length", 520590566, true)) ) != ((int) (global::haxe.lang.Runtime.getField_f(b1, "length", 520590566, true)) ) )) {
								#line 129 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								return false;
							}
							
							#line 130 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							{
								#line 130 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								int _g1 = 0;
								#line 130 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								int _g = ((int) (global::haxe.lang.Runtime.getField_f(a1, "length", 520590566, true)) );
								#line 130 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								while (( _g1 < _g )){
									#line 130 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
									int i = _g1++;
									if ( ! (global::pony.Tools.equal(a1[i], b1[i], new global::haxe.lang.Null<int>(( __temp_maxDepth64 - 1 ), true))) ) {
										#line 131 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
										return false;
									}
									
								}
								
							}
							
							#line 132 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							return true;
						}
						
					}
					
					
					case 4:
					{
						#line 134 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						if (( a is global::System.Type )) {
							#line 134 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							return false;
						}
						
						#line 134 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						break;
					}
					
					
					case 8:
					{
						#line 135 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						{
						}
						
						#line 135 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						break;
					}
					
					
					case 6:
					{
						#line 113 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						global::System.Type t1 = ((global::System.Type) (type.@params[0]) );
						#line 138 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						if (global::haxe.lang.Runtime.refEq(t1, typeof(global::Array))) {
							#line 139 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							if ( ! (( b is global::Array )) ) {
								#line 139 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								return false;
							}
							
							#line 141 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							if (( ! (global::haxe.lang.Runtime.eq(global::haxe.lang.Runtime.getField(a, "length", 520590566, true), global::haxe.lang.Runtime.getField(b, "length", 520590566, true))) )) {
								#line 141 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								return false;
							}
							
							#line 142 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							{
								#line 142 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								int _g11 = 0;
								#line 142 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								int _g2 = ((int) (global::haxe.lang.Runtime.toInt(global::haxe.lang.Runtime.getField(a, "length", 520590566, true))) );
								#line 142 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								while (( _g11 < _g2 )){
									#line 142 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
									int i1 = _g11++;
									if ( ! (global::pony.Tools.equal(((object) (global::haxe.lang.Runtime.callField(a, "__get", 1915412854, new global::Array<object>(new object[]{i1}))) ), ((object) (global::haxe.lang.Runtime.callField(b, "__get", 1915412854, new global::Array<object>(new object[]{i1}))) ), new global::haxe.lang.Null<int>(( __temp_maxDepth64 - 1 ), true))) ) {
										#line 143 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
										return false;
									}
									
								}
								
							}
							
							#line 144 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							return true;
						}
						
						#line 136 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						break;
					}
					
					
				}
				
				#line 149 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
					#line 149 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					global::ValueType _g3 = global::Type.@typeof(b);
					#line 149 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					switch (global::Type.enumIndex(_g3)){
						case 1:case 2:case 3:case 5:case 7:case 0:
						{
							#line 150 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							return false;
						}
						
						
						case 4:
						{
							#line 151 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							if (( b is global::System.Type )) {
								#line 151 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								return false;
							}
							
							#line 151 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							break;
						}
						
						
						case 6:
						{
							#line 149 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							global::System.Type t2 = ((global::System.Type) (_g3.@params[0]) );
							#line 152 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							if (global::haxe.lang.Runtime.refEq(t2, typeof(global::Array))) {
								#line 152 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								return false;
							}
							
							#line 152 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							break;
						}
						
						
						case 8:
						{
							#line 153 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							{
							}
							
							#line 153 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							break;
						}
						
						
					}
					
				}
				
				#line 156 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::Array<object> fields = global::Reflect.fields(a);
				#line 159 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (( fields.length == global::Reflect.fields(b).length )) {
					#line 160 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					if (( fields.length == 0 )) {
						#line 160 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						return true;
					}
					
					#line 161 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					{
						#line 161 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						int _g4 = 0;
						#line 161 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						while (( _g4 < fields.length )){
							#line 161 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							string f = global::haxe.lang.Runtime.toString(fields[_g4]);
							#line 161 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							 ++ _g4;
							if ((  ! (global::Reflect.hasField(b, f))  ||  ! (global::pony.Tools.equal(global::Reflect.field(a, f), global::Reflect.field(b, f), new global::haxe.lang.Null<int>(( __temp_maxDepth64 - 1 ), true)))  )) {
								#line 163 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								return false;
							}
							
						}
						
					}
					
					#line 164 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return true;
				}
				
				#line 166 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return false;
			}
			#line default
		}
		
		
		public static   int superIndexOf<T>(object it, T v, global::haxe.lang.Null<int> maxDepth){
			unchecked {
				#line 169 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				int __temp_maxDepth65 = ( ( ! (maxDepth.hasValue) ) ? (((int) (1) )) : (maxDepth.@value) );
				int i = 0;
				{
					#line 171 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					object __temp_iterator143 = ((object) (global::haxe.lang.Runtime.callField(it, "iterator", 328878574, default(global::Array))) );
					#line 171 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator143, "hasNext", 407283053, default(global::Array)))){
						#line 171 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						T e = global::haxe.lang.Runtime.genericCast<T>(global::haxe.lang.Runtime.callField(__temp_iterator143, "next", 1224901875, default(global::Array)));
						if (global::pony.Tools.equal(e, v, new global::haxe.lang.Null<int>(__temp_maxDepth65, true))) {
							#line 172 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							return i;
						}
						
						#line 173 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						i++;
					}
					
				}
				
				#line 175 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return -1;
			}
			#line default
		}
		
		
		public static   int superMultyIndexOf<T>(object it, global::Array<T> av, global::haxe.lang.Null<int> maxDepth){
			unchecked {
				#line 178 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				int __temp_maxDepth66 = ( ( ! (maxDepth.hasValue) ) ? (((int) (1) )) : (maxDepth.@value) );
				int i = 0;
				{
					#line 180 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					object __temp_iterator144 = ((object) (global::haxe.lang.Runtime.callField(it, "iterator", 328878574, default(global::Array))) );
					#line 180 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator144, "hasNext", 407283053, default(global::Array)))){
						#line 180 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						T e = global::haxe.lang.Runtime.genericCast<T>(global::haxe.lang.Runtime.callField(__temp_iterator144, "next", 1224901875, default(global::Array)));
						{
							#line 181 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							int _g = 0;
							#line 181 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							while (( _g < av.length )){
								#line 181 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								T v = av[_g];
								#line 181 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								 ++ _g;
								#line 181 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								if (global::pony.Tools.equal(e, v, new global::haxe.lang.Null<int>(__temp_maxDepth66, true))) {
									#line 181 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
									return i;
								}
								
							}
							
						}
						
						#line 182 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						i++;
					}
					
				}
				
				#line 184 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return -1;
			}
			#line default
		}
		
		
		public static   int multyIndexOf<T>(object it, global::Array<T> av){
			unchecked {
				#line 188 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				int i = 0;
				{
					#line 189 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					object __temp_iterator145 = ((object) (global::haxe.lang.Runtime.callField(it, "iterator", 328878574, default(global::Array))) );
					#line 189 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator145, "hasNext", 407283053, default(global::Array)))){
						#line 189 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						T e = global::haxe.lang.Runtime.genericCast<T>(global::haxe.lang.Runtime.callField(__temp_iterator145, "next", 1224901875, default(global::Array)));
						{
							#line 190 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							int _g = 0;
							#line 190 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							while (( _g < av.length )){
								#line 190 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								T v = av[_g];
								#line 190 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								 ++ _g;
								#line 190 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								if (global::haxe.lang.Runtime.eq(e, v)) {
									#line 190 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
									return i;
								}
								
							}
							
						}
						
						#line 191 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						i++;
					}
					
				}
				
				#line 193 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return -1;
			}
			#line default
		}
		
		
		public static   global::haxe.io.BytesInput cut(global::haxe.io.BytesInput inp){
			unchecked {
				#line 202 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::haxe.io.BytesOutput @out = new global::haxe.io.BytesOutput();
				int cntNull = 0;
				bool flagNull = true;
				int cur = -99;
				while (true){
					#line 209 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					try {
						#line 209 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						cur = inp.readByte();
					}
					catch (global::System.Exception __temp_catchallException317){
						#line 209 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						global::haxe.lang.Exceptions.exception = __temp_catchallException317;
						#line 211 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						object __temp_catchall318 = __temp_catchallException317;
						#line 211 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						if (( __temp_catchall318 is global::haxe.lang.HaxeException )) {
							#line 211 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							__temp_catchall318 = ((global::haxe.lang.HaxeException) (__temp_catchallException317) ).obj;
						}
						
						#line 211 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						{
							#line 211 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							object _ = __temp_catchall318;
							#line 211 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							break;
						}
						
					}
					
					
					#line 213 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					if (( cur == 0 )) {
						#line 215 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						if ( ! (flagNull) ) {
							#line 216 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							flagNull = true;
						}
						
						#line 217 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						cntNull++;
					}
					 else {
						#line 221 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						if (flagNull) {
							#line 222 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							while (( cntNull-- > 0 )){
								#line 223 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								@out.writeByte(0);
							}
							
						}
						
						#line 224 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						flagNull = false;
						@out.writeByte(cur);
					}
					
				}
				
				#line 228 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				@out.close();
				return new global::haxe.io.BytesInput(((global::haxe.io.Bytes) (@out.getBytes()) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) ), ((global::haxe.lang.Null<int>) (default(global::haxe.lang.Null<int>)) ));
			}
			#line default
		}
		
		
		public static   bool exists<T>(object a, T e){
			unchecked {
				#line 246 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ( global::Lambda.indexOf<T>(a, e) != -1 );
			}
			#line default
		}
		
		
		public static   object bytesIterator(global::haxe.io.Bytes b){
			unchecked {
				#line 248 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::Array<object> b1 = new global::Array<object>(new object[]{b});
				global::Array<int> i = new global::Array<int>(new int[]{0});
				{
					#line 251 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					global::haxe.lang.Function __temp_odecl319 = new global::pony.Tools_bytesIterator_251__Fun(((global::Array<int>) (i) ), ((global::Array<object>) (b1) ));
					global::haxe.lang.Function __temp_odecl320 = new global::pony.Tools_bytesIterator_252__Fun(((global::Array<int>) (i) ), ((global::Array<object>) (b1) ));
					#line 250 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{407283053, 1224901875}), new global::Array<object>(new object[]{__temp_odecl319, __temp_odecl320}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
				}
				
			}
			#line default
		}
		
		
		public static   object bytesInputIterator(global::haxe.io.BytesInput b){
			unchecked {
				#line 256 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::Array<object> b1 = new global::Array<object>(new object[]{b});
				global::haxe.lang.Null<int> i = new global::haxe.lang.Null<int>(0, true);
				{
					#line 259 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					global::haxe.lang.Function __temp_odecl321 = new global::pony.Tools_bytesInputIterator_259__Fun(((global::Array<object>) (b1) ));
					global::haxe.lang.Function __temp_odecl322 = new global::pony.Tools_bytesInputIterator_260__Fun(((global::Array<object>) (b1) ));
					#line 258 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{407283053, 1224901875}), new global::Array<object>(new object[]{__temp_odecl321, __temp_odecl322}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
				}
				
			}
			#line default
		}
		
		
		public static   void setFields(object a, object b){
			unchecked {
				#line 279 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				int _g = 0;
				#line 279 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::Array<object> _g1 = global::Reflect.fields(b);
				#line 279 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				while (( _g < _g1.length )){
					#line 279 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					string p = global::haxe.lang.Runtime.toString(_g1[_g]);
					#line 279 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					 ++ _g;
					object d = global::Reflect.field(b, p);
					if (( global::Reflect.isObject(d) &&  ! (( d is string ))  )) {
						#line 282 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						global::pony.Tools.setFields(global::Reflect.field(a, p), d);
					}
					 else {
						#line 284 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						global::Reflect.setField(a, p, d);
					}
					
				}
				
			}
			#line default
		}
		
		
		public static   object parsePrefixObjects(object a, string delimiter){
			unchecked {
				#line 288 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (string.Equals(delimiter, default(string))) {
					#line 288 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					delimiter = "_";
				}
				
				#line 289 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				object result = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{}), new global::Array<object>(new object[]{}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
				{
					#line 290 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					int _g = 0;
					#line 290 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					global::Array<object> _g1 = global::Reflect.fields(a);
					#line 290 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					while (( _g < _g1.length )){
						#line 290 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						string f = global::haxe.lang.Runtime.toString(_g1[_g]);
						#line 290 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						 ++ _g;
						global::Array<object> d = global::haxe.lang.StringExt.split(f, delimiter);
						object obj = result;
						{
							#line 293 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							int _g3 = 0;
							#line 293 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							int _g2 = ( d.length - 1 );
							#line 293 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							while (( _g3 < _g2 )){
								#line 293 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
								int i = _g3++;
								if (global::Reflect.hasField(obj, global::haxe.lang.Runtime.toString(d[i]))) {
									#line 295 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
									obj = global::Reflect.field(obj, global::haxe.lang.Runtime.toString(d[i]));
								}
								 else {
									#line 297 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
									object newObj = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{}), new global::Array<object>(new object[]{}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
									global::Reflect.setField(obj, global::haxe.lang.Runtime.toString(d[i]), newObj);
									obj = newObj;
								}
								
							}
							
						}
						
						#line 302 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						global::Reflect.setField(obj, global::haxe.lang.Runtime.toString(d.pop().@value), global::Reflect.field(a, f));
					}
					
				}
				
				#line 304 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return result;
			}
			#line default
		}
		
		
		public static   object convertObject(object a, global::haxe.lang.Function fun){
			unchecked {
				#line 308 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				object result = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{}), new global::Array<object>(new object[]{}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
				{
					#line 309 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					int _g = 0;
					#line 309 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					global::Array<object> _g1 = global::Reflect.fields(a);
					#line 309 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					while (( _g < _g1.length )){
						#line 309 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						string p = global::haxe.lang.Runtime.toString(_g1[_g]);
						#line 309 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						 ++ _g;
						object d = global::Reflect.field(a, p);
						if (( global::Reflect.isObject(d) &&  ! (( d is string ))  )) {
							#line 312 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							global::Reflect.setField(result, p, global::pony.Tools.convertObject(d, fun));
						}
						 else {
							#line 314 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							global::Reflect.setField(result, p, ((object) (fun.__hx_invoke1_o(default(double), d)) ));
						}
						
					}
					
				}
				
				#line 316 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return result;
			}
			#line default
		}
		
		
		public static   void traceThrow(string e){
			unchecked {
				#line 320 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::haxe.Log.trace.__hx_invoke2_o(default(double), e, default(double), default(object));
				global::haxe.Log.trace.__hx_invoke2_o(default(double), global::haxe.CallStack.toString(global::haxe.CallStack.exceptionStack()), default(double), default(object));
			}
			#line default
		}
		
		
		public static   void writeStr(global::haxe.io.BytesOutput b, string s){
			unchecked {
				#line 325 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				b.writeInt32(s.Length);
				b.writeString(s);
			}
			#line default
		}
		
		
		public static   string readStr(global::haxe.io.BytesInput b){
			unchecked {
				#line 331 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				try {
					#line 331 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return b.readString(b.readInt32());
				}
				catch (global::System.Exception __temp_catchallException323){
					#line 331 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					global::haxe.lang.Exceptions.exception = __temp_catchallException323;
					object __temp_catchall324 = __temp_catchallException323;
					#line 332 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					if (( __temp_catchall324 is global::haxe.lang.HaxeException )) {
						#line 332 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						__temp_catchall324 = ((global::haxe.lang.HaxeException) (__temp_catchallException323) ).obj;
					}
					
					#line 332 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					{
						#line 332 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						object _ = __temp_catchall324;
						#line 332 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						return default(string);
					}
					
				}
				
				
			}
			#line default
		}
		
		
		public static   int min(global::IntIterator it){
			unchecked {
				#line 339 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ((int) (global::haxe.lang.Runtime.getField_f(it, "min", 5443986, false)) );
			}
			#line default
		}
		
		
		public static   int max(global::IntIterator it){
			unchecked {
				#line 340 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ((int) (global::haxe.lang.Runtime.getField_f(it, "max", 5442212, false)) );
			}
			#line default
		}
		
		
		public static   global::IntIterator copy(global::IntIterator it){
			unchecked {
				#line 341 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::IntIterator(((int) (global::haxe.lang.Runtime.getField_f(it, "min", 5443986, false)) ), ((int) (global::haxe.lang.Runtime.getField_f(it, "max", 5442212, false)) ));
			}
			#line default
		}
		
		
		public static   void nullFunction0(){
			unchecked {
				#line 343 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ;
			}
			#line default
		}
		
		
		public static   void nullFunction1(object _){
			unchecked {
				#line 344 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ;
			}
			#line default
		}
		
		
		public static   void nullFunction2(object _, object _1){
			unchecked {
				#line 345 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ;
			}
			#line default
		}
		
		
		public static   void nullFunction3(object _, object _1, object _2){
			unchecked {
				#line 346 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ;
			}
			#line default
		}
		
		
		public static   void nullFunction4(object _, object _1, object _2, object _3){
			unchecked {
				#line 347 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ;
			}
			#line default
		}
		
		
		public static   void nullFunction5(object _, object _1, object _2, object _3, object _4){
			unchecked {
				#line 348 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ;
			}
			#line default
		}
		
		
		public static   void errorFunction(object e){
			unchecked {
				#line 349 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				throw global::haxe.lang.HaxeException.wrap(e);
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 52 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::pony.Tools(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 52 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::pony.Tools();
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Tools_bytesIterator_251__Fun : global::haxe.lang.Function {
		public    Tools_bytesIterator_251__Fun(global::Array<int> i, global::Array<object> b1) : base(0, 0){
			unchecked {
				#line 251 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				this.i = i;
				#line 251 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				this.b1 = b1;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 251 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ( this.i[0] < ((global::haxe.io.Bytes) (this.b1[0]) ).length );
			}
			#line default
		}
		
		
		public  global::Array<int> i;
		
		public  global::Array<object> b1;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Tools_bytesIterator_252__Fun : global::haxe.lang.Function {
		public    Tools_bytesIterator_252__Fun(global::Array<int> i, global::Array<object> b1) : base(0, 1){
			unchecked {
				#line 252 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				this.i = i;
				#line 252 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				this.b1 = b1;
			}
			#line default
		}
		
		
		public override   double __hx_invoke0_f(){
			unchecked {
				#line 252 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
					#line 252 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					int pos = this.i[0]++;
					#line 252 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return ((double) (((global::haxe.io.Bytes) (this.b1[0]) ).b[pos]) );
				}
				
			}
			#line default
		}
		
		
		public  global::Array<int> i;
		
		public  global::Array<object> b1;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Tools_bytesInputIterator_259__Fun : global::haxe.lang.Function {
		public    Tools_bytesInputIterator_259__Fun(global::Array<object> b1) : base(0, 0){
			unchecked {
				#line 259 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				this.b1 = b1;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 259 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ( ((global::haxe.io.BytesInput) (this.b1[0]) ).pos < ((global::haxe.io.BytesInput) (this.b1[0]) ).totlen );
			}
			#line default
		}
		
		
		public  global::Array<object> b1;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class Tools_bytesInputIterator_260__Fun : global::haxe.lang.Function {
		public    Tools_bytesInputIterator_260__Fun(global::Array<object> b1) : base(0, 1){
			unchecked {
				#line 260 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				this.b1 = b1;
			}
			#line default
		}
		
		
		public override   double __hx_invoke0_f(){
			unchecked {
				#line 260 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ((double) (((global::haxe.io.BytesInput) (this.b1[0]) ).readByte()) );
			}
			#line default
		}
		
		
		public  global::Array<object> b1;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class ArrayTools : global::haxe.lang.HxObject {
		public    ArrayTools(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 353 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    ArrayTools(){
			unchecked {
				#line 353 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::pony.ArrayTools.__hx_ctor_pony_ArrayTools(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_ArrayTools(global::pony.ArrayTools __temp_me68){
			unchecked {
				#line 353 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public static   bool exists<T>(global::Array<T> a, T e){
			unchecked {
				#line 355 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return ( a.indexOf(e, default(global::haxe.lang.Null<int>)) != -1 );
			}
			#line default
		}
		
		
		public static   bool thereIs<T>(object a, global::Array<T> b){
			unchecked {
				#line 358 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
					#line 358 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					object __temp_iterator146 = ((object) (global::haxe.lang.Runtime.callField(a, "iterator", 328878574, default(global::Array))) );
					#line 358 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator146, "hasNext", 407283053, default(global::Array)))){
						#line 358 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						global::Array<T> e = ((global::Array<T>) (global::Array<object>.__hx_cast<T>(((global::Array) (global::haxe.lang.Runtime.callField(__temp_iterator146, "next", 1224901875, default(global::Array))) ))) );
						#line 358 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						if (global::pony.Tools.equal(e, b, default(global::haxe.lang.Null<int>))) {
							#line 358 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							return true;
						}
						
					}
					
				}
				
				#line 359 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return false;
			}
			#line default
		}
		
		
		public static   object kv<T>(object a){
			unchecked {
				#line 363 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::Array<int> i = new global::Array<int>(new int[]{0});
				#line 365 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::Array<object> it = new global::Array<object>(new object[]{((object) (global::haxe.lang.Runtime.callField(a, "iterator", 328878574, default(global::Array))) )});
				{
					#line 367 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					global::haxe.lang.Function __temp_odecl325 = ((global::haxe.lang.Function) (global::haxe.lang.Runtime.getField(it[0], "hasNext", 407283053, true)) );
					global::haxe.lang.Function __temp_odecl326 = new global::pony.ArrayTools_kv_368__Fun<T>(((global::Array<int>) (i) ), ((global::Array<object>) (it) ));
					#line 366 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{407283053, 1224901875}), new global::Array<object>(new object[]{__temp_odecl325, __temp_odecl326}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
				}
				
			}
			#line default
		}
		
		
		public static   global::haxe.io.BytesOutput toBytes(global::Array<int> a){
			unchecked {
				#line 377 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::haxe.io.BytesOutput b = new global::haxe.io.BytesOutput();
				{
					#line 378 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					int _g = 0;
					#line 378 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					while (( _g < a.length )){
						#line 378 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						int e = a[_g];
						#line 378 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						 ++ _g;
						#line 378 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						b.writeByte(e);
					}
					
				}
				
				#line 379 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return b;
			}
			#line default
		}
		
		
		public static   global::Array<T> randomize<T>(global::Array<T> a){
			unchecked {
				#line 387 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				a.sort(((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (typeof(global::pony.ArrayTools)) ), ((string) ("randomizeSort") ), ((int) (2073172271) ))) ));
				return a;
			}
			#line default
		}
		
		
		public static   int randomizeSort(T _, T _1){
			unchecked {
				#line 390 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (( global::Math.rand.NextDouble() > 0.5 )) {
					#line 390 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return 1;
				}
				 else {
					#line 390 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return -1;
				}
				
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 353 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::pony.ArrayTools(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 353 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::pony.ArrayTools();
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class ArrayTools_kv_368__Fun<T> : global::haxe.lang.Function {
		public    ArrayTools_kv_368__Fun(global::Array<int> i, global::Array<object> it) : base(0, 0){
			unchecked {
				#line 368 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				this.i = i;
				#line 368 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				this.it = it;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 369 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				object p = default(object);
				#line 369 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
					#line 369 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					T b = global::haxe.lang.Runtime.genericCast<T>(global::haxe.lang.Runtime.callField(this.it[0], "next", 1224901875, default(global::Array)));
					#line 369 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					p = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{98}), new global::Array<object>(new object[]{b}), new global::Array<int>(new int[]{97}), new global::Array<double>(new double[]{((double) (this.i[0]) )}));
				}
				
				#line 370 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				this.i[0]++;
				return ((object) (p) );
			}
			#line default
		}
		
		
		public  global::Array<int> i;
		
		public  global::Array<object> it;
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class FloatTools : global::haxe.lang.HxObject {
		public    FloatTools(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 393 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    FloatTools(){
			unchecked {
				#line 393 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::pony.FloatTools.__hx_ctor_pony_FloatTools(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_FloatTools(global::pony.FloatTools __temp_me70){
			unchecked {
				#line 393 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public static   string _toFixed(double v, int n, global::haxe.lang.Null<int> begin, string d, string beginS, string endS){
			unchecked {
				#line 414 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (string.Equals(endS, default(string))) {
					#line 414 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					endS = "0";
				}
				
				#line 414 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (string.Equals(beginS, default(string))) {
					#line 414 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					beginS = "0";
				}
				
				#line 414 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (string.Equals(d, default(string))) {
					#line 414 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					d = ".";
				}
				
				#line 414 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				int __temp_begin69 = ( ( ! (begin.hasValue) ) ? (((int) (0) )) : (begin.@value) );
				if (( __temp_begin69 != 0 )) {
					#line 416 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					string s = global::pony.FloatTools._toFixed(v, n, new global::haxe.lang.Null<int>(0, true), d, beginS, endS);
					global::Array<object> a = global::haxe.lang.StringExt.split(s, d);
					int d1 = ( __temp_begin69 - global::haxe.lang.Runtime.toString(a[0]).Length );
					return global::haxe.lang.Runtime.concat(global::pony.text.TextTools.repeat(beginS, d1), s);
				}
				
				#line 422 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (( n == 0 )) {
					#line 422 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return global::Std.@string(((int) (v) ));
				}
				
				#line 423 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				double p = global::System.Math.Pow(((double) (10) ), ((double) (n) ));
				int __temp_stmt327 = default(int);
				#line 424 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
					#line 424 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					double x = global::System.Math.Floor(((double) (( v * p )) ));
					#line 424 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					__temp_stmt327 = ((int) (x) );
				}
				
				#line 424 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				v = ( __temp_stmt327 / p );
				string s1 = global::Std.@string(v);
				global::Array<object> a1 = global::haxe.lang.StringExt.split(s1, ".");
				if (( a1.length <= 1 )) {
					#line 428 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(s1, d), global::pony.text.TextTools.repeat(endS, n));
				}
				 else {
					#line 430 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					return global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.toString(a1[0]), d), global::haxe.lang.Runtime.toString(a1[1])), global::pony.text.TextTools.repeat(endS, ( n - global::haxe.lang.Runtime.toString(a1[1]).Length )));
				}
				
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 393 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::pony.FloatTools(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 393 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::pony.FloatTools();
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony{
	public  class XMLTools : global::haxe.lang.HxObject {
		public    XMLTools(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 434 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    XMLTools(){
			unchecked {
				#line 434 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				global::pony.XMLTools.__hx_ctor_pony_XMLTools(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_XMLTools(global::pony.XMLTools __temp_me71){
			unchecked {
				#line 434 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public static   bool isTrue(global::haxe.xml.Fast x, string name){
			unchecked {
				#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				bool __temp_boolv330 = x.has.resolve(name);
				#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				bool __temp_boolv329 = false;
				#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				if (__temp_boolv330) {
					#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
					{
						#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						string s = x.att.resolve(name);
						#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						string __temp_stmt331 = default(string);
						#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						{
							#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							string s1 = s.ToLower();
							#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
							__temp_stmt331 = s1.Trim();
						}
						
						#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
						__temp_boolv329 = string.Equals(__temp_stmt331, "true");
					}
					
				}
				
				#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				bool __temp_stmt328 = ( __temp_boolv330 && __temp_boolv329 );
				#line 435 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return __temp_stmt328;
			}
			#line default
		}
		
		
		public static   global::haxe.xml.Fast fast(string text){
			unchecked {
				#line 436 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::haxe.xml.Fast(((global::Xml) (global::Xml.parse(text)) ));
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 434 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::pony.XMLTools(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 434 "C:\\data\\GitHub\\Pony\\pony\\Tools.hx"
				return new global::pony.XMLTools();
			}
			#line default
		}
		
		
	}
}


