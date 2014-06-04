
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe.xml{
	public  class Parser : global::haxe.lang.HxObject {
		static Parser() {
			#line 51 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
			{
				#line 52 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				global::haxe.ds.StringMap<object> h = new global::haxe.ds.StringMap<object>();
				h.@set("lt", "<");
				h.@set("gt", ">");
				h.@set("amp", "&");
				h.@set("quot", "\"");
				h.@set("apos", "\'");
				h.@set("nbsp", new string(((char) (160) ), 1));
				global::haxe.xml.Parser.escapes = h;
			}
			
		}
		public    Parser(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 49 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Parser(){
			unchecked {
				#line 49 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				global::haxe.xml.Parser.__hx_ctor_haxe_xml_Parser(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_xml_Parser(global::haxe.xml.Parser __temp_me53){
			unchecked {
				#line 49 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public static  global::haxe.ds.StringMap<object> escapes;
		
		public static   global::Xml parse(string str){
			unchecked {
				#line 64 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				global::Xml doc = global::Xml.createDocument();
				global::haxe.xml.Parser.doParse(str, new global::haxe.lang.Null<int>(0, true), doc);
				return doc;
			}
			#line default
		}
		
		
		public static   int doParse(string str, global::haxe.lang.Null<int> p, global::Xml parent){
			unchecked {
				#line 70 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				int __temp_p52 = ( ( ! (p.hasValue) ) ? (((int) (0) )) : (p.@value) );
				global::Xml xml = default(global::Xml);
				int state = 1;
				int next = 1;
				string aname = default(string);
				int start = 0;
				int nsubs = 0;
				int nbrackets = 0;
				int c = default(int);
				#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				if (( ((uint) (__temp_p52) ) < str.Length )) {
					#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
					c = ((int) (str[__temp_p52]) );
				}
				 else {
					#line 78 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
					c = -1;
				}
				
				#line 79 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				global::StringBuf buf = new global::StringBuf();
				while ( ! ((( c == -1 ))) ){
					#line 82 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
					switch (state){
						case 0:
						{
							#line 85 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							switch (c){
								case 10:case 13:case 9:case 32:
								{
									#line 88 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									{
									}
									
									#line 88 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								default:
								{
									#line 93 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = next;
									continue;
								}
								
							}
							
							#line 85 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 1:
						{
							#line 97 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							switch (c){
								case 60:
								{
									#line 100 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = 0;
									next = 2;
									#line 99 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								default:
								{
									#line 103 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									start = __temp_p52;
									state = 13;
									continue;
								}
								
							}
							
							#line 97 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 13:
						{
							#line 108 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (( c == 60 )) {
								#line 113 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								global::Xml child = global::Xml.createPCData(global::haxe.lang.Runtime.concat(buf.toString(), global::haxe.lang.StringExt.substr(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true))));
								#line 115 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								buf = new global::StringBuf();
								parent.addChild(child);
								nsubs++;
								state = 0;
								next = 2;
							}
							 else {
								#line 122 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								if (( c == 38 )) {
									#line 123 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									buf.addSub(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true));
									state = 18;
									next = 13;
									start = ( __temp_p52 + 1 );
								}
								
							}
							
							#line 108 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 17:
						{
							#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_boolv269 = ( c == 93 );
							#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_boolv268 = false;
							#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_boolv267 = false;
							#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (__temp_boolv269) {
								#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								int __temp_stmt270 = default(int);
								#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								{
									#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									int index = ( __temp_p52 + 1 );
									#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									__temp_stmt270 = ( (( ((uint) (index) ) < str.Length )) ? (((int) (str[index]) )) : (-1) );
								}
								
								#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								__temp_boolv268 = ( __temp_stmt270 == 93 );
								#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								if (__temp_boolv268) {
									#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									int __temp_stmt271 = default(int);
									#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									{
										#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										int index1 = ( __temp_p52 + 2 );
										#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										__temp_stmt271 = ( (( ((uint) (index1) ) < str.Length )) ? (((int) (str[index1]) )) : (-1) );
									}
									
									#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									__temp_boolv267 = ( __temp_stmt271 == 62 );
								}
								
							}
							
							#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_stmt266 = ( ( __temp_boolv269 && __temp_boolv268 ) && __temp_boolv267 );
							#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (__temp_stmt266) {
								#line 132 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								global::Xml child1 = global::Xml.createCData(global::haxe.lang.StringExt.substr(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true)));
								parent.addChild(child1);
								nsubs++;
								__temp_p52 += 2;
								state = 1;
							}
							
							#line 130 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 2:
						{
							#line 139 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							switch (c){
								case 33:
								{
									#line 142 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									int __temp_stmt272 = default(int);
									#line 142 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									{
										#line 142 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										int index2 = ( __temp_p52 + 1 );
										#line 142 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										__temp_stmt272 = ( (( ((uint) (index2) ) < str.Length )) ? (((int) (str[index2]) )) : (-1) );
									}
									
									#line 142 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									if (( __temp_stmt272 == 91 )) {
										#line 144 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										__temp_p52 += 2;
										if ( ! (string.Equals(global::haxe.lang.StringExt.substr(str, __temp_p52, new global::haxe.lang.Null<int>(6, true)).ToUpper(), "CDATA[")) ) {
											#line 146 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											throw global::haxe.lang.HaxeException.wrap("Expected <![CDATA[");
										}
										
										#line 147 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										__temp_p52 += 5;
										state = 17;
										start = ( __temp_p52 + 1 );
									}
									 else {
										#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										int __temp_stmt275 = default(int);
										#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										{
											#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											int index3 = ( __temp_p52 + 1 );
											#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											__temp_stmt275 = ( (( ((uint) (index3) ) < str.Length )) ? (((int) (str[index3]) )) : (-1) );
										}
										
										#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										bool __temp_stmt274 = ( __temp_stmt275 == 68 );
										#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										bool __temp_boolv276 = false;
										#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										if ( ! (__temp_stmt274) ) {
											#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											int __temp_stmt277 = default(int);
											#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											{
												#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												int index4 = ( __temp_p52 + 1 );
												#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												__temp_stmt277 = ( (( ((uint) (index4) ) < str.Length )) ? (((int) (str[index4]) )) : (-1) );
											}
											
											#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											__temp_boolv276 = ( __temp_stmt277 == 100 );
										}
										
										#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										bool __temp_stmt273 = ( __temp_stmt274 || __temp_boolv276 );
										#line 151 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										if (__temp_stmt273) {
											#line 153 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											if ( ! (string.Equals(global::haxe.lang.StringExt.substr(str, ( __temp_p52 + 2 ), new global::haxe.lang.Null<int>(6, true)).ToUpper(), "OCTYPE")) ) {
												#line 154 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												throw global::haxe.lang.HaxeException.wrap("Expected <!DOCTYPE");
											}
											
											#line 155 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											__temp_p52 += 8;
											state = 16;
											start = ( __temp_p52 + 1 );
										}
										 else {
											#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											int __temp_stmt280 = default(int);
											#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											{
												#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												int index5 = ( __temp_p52 + 1 );
												#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												__temp_stmt280 = ( (( ((uint) (index5) ) < str.Length )) ? (((int) (str[index5]) )) : (-1) );
											}
											
											#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											bool __temp_stmt279 = ( __temp_stmt280 != 45 );
											#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											bool __temp_boolv281 = false;
											#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											if ( ! (__temp_stmt279) ) {
												#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												int __temp_stmt282 = default(int);
												#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												{
													#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
													int index6 = ( __temp_p52 + 2 );
													#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
													__temp_stmt282 = ( (( ((uint) (index6) ) < str.Length )) ? (((int) (str[index6]) )) : (-1) );
												}
												
												#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												__temp_boolv281 = ( __temp_stmt282 != 45 );
											}
											
											#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											bool __temp_stmt278 = ( __temp_stmt279 || __temp_boolv281 );
											#line 159 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
											if (__temp_stmt278) {
												#line 160 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												throw global::haxe.lang.HaxeException.wrap("Expected <!--");
											}
											 else {
												#line 163 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
												__temp_p52 += 2;
												state = 15;
												start = ( __temp_p52 + 1 );
											}
											
										}
										
									}
									
									#line 142 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								case 63:
								{
									#line 168 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = 14;
									start = __temp_p52;
									#line 167 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								case 47:
								{
									#line 171 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									if (( parent == default(global::Xml) )) {
										#line 172 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										throw global::haxe.lang.HaxeException.wrap("Expected node name");
									}
									
									#line 173 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									start = ( __temp_p52 + 1 );
									state = 0;
									next = 10;
									#line 170 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								default:
								{
									#line 177 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = 3;
									start = __temp_p52;
									continue;
								}
								
							}
							
							#line 139 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 3:
						{
							#line 182 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if ( ! ((( ( ( ( ( ( ( ( c >= 97 ) && ( c <= 122 ) ) || ( ( c >= 65 ) && ( c <= 90 ) ) ) || ( ( c >= 48 ) && ( c <= 57 ) ) ) || ( c == 58 ) ) || ( c == 46 ) ) || ( c == 95 ) ) || ( c == 45 ) ))) ) {
								#line 184 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								if (( __temp_p52 == start )) {
									#line 185 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									throw global::haxe.lang.HaxeException.wrap("Expected node name");
								}
								
								#line 186 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								xml = global::Xml.createElement(global::haxe.lang.StringExt.substr(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true)));
								parent.addChild(xml);
								state = 0;
								next = 4;
								continue;
							}
							
							#line 182 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 4:
						{
							#line 193 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							switch (c){
								case 47:
								{
									#line 196 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = 11;
									nsubs++;
									#line 195 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								case 62:
								{
									#line 199 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = 9;
									nsubs++;
									#line 198 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								default:
								{
									#line 202 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = 5;
									start = __temp_p52;
									continue;
								}
								
							}
							
							#line 193 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 5:
						{
							#line 207 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if ( ! ((( ( ( ( ( ( ( ( c >= 97 ) && ( c <= 122 ) ) || ( ( c >= 65 ) && ( c <= 90 ) ) ) || ( ( c >= 48 ) && ( c <= 57 ) ) ) || ( c == 58 ) ) || ( c == 46 ) ) || ( c == 95 ) ) || ( c == 45 ) ))) ) {
								#line 209 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								string tmp = default(string);
								if (( start == __temp_p52 )) {
									#line 211 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									throw global::haxe.lang.HaxeException.wrap("Expected attribute name");
								}
								
								#line 212 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								tmp = global::haxe.lang.StringExt.substr(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true));
								aname = tmp;
								if (xml.exists(aname)) {
									#line 215 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									throw global::haxe.lang.HaxeException.wrap("Duplicate attribute");
								}
								
								#line 216 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								state = 0;
								next = 6;
								continue;
							}
							
							#line 207 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 6:
						{
							#line 221 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							switch (c){
								case 61:
								{
									#line 224 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = 0;
									next = 7;
									#line 223 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								default:
								{
									#line 227 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									throw global::haxe.lang.HaxeException.wrap("Expected =");
								}
								
							}
							
							#line 221 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 7:
						{
							#line 230 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							switch (c){
								case 34:case 39:
								{
									#line 233 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = 8;
									start = __temp_p52;
									#line 232 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								default:
								{
									#line 236 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									throw global::haxe.lang.HaxeException.wrap("Expected \"");
								}
								
							}
							
							#line 230 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 8:
						{
							#line 239 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (( c == (( (( ((uint) (start) ) < str.Length )) ? (((int) (str[start]) )) : (-1) )) )) {
								#line 241 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								string val = global::haxe.lang.StringExt.substr(str, ( start + 1 ), new global::haxe.lang.Null<int>(( ( __temp_p52 - start ) - 1 ), true));
								xml.@set(aname, val);
								state = 0;
								next = 4;
							}
							
							#line 239 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 9:
						{
							#line 247 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							__temp_p52 = global::haxe.xml.Parser.doParse(str, new global::haxe.lang.Null<int>(__temp_p52, true), xml);
							start = __temp_p52;
							state = 1;
							#line 246 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 11:
						{
							#line 251 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							switch (c){
								case 62:
								{
									#line 254 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									state = 1;
									#line 254 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									break;
								}
								
								
								default:
								{
									#line 256 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									throw global::haxe.lang.HaxeException.wrap("Expected >");
								}
								
							}
							
							#line 251 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 12:
						{
							#line 259 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							switch (c){
								case 62:
								{
									#line 262 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									if (( nsubs == 0 )) {
										#line 263 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										parent.addChild(global::Xml.createPCData(""));
									}
									
									#line 264 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									return __temp_p52;
								}
								
								
								default:
								{
									#line 266 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									throw global::haxe.lang.HaxeException.wrap("Expected >");
								}
								
							}
							
						}
						
						
						case 10:
						{
							#line 269 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if ( ! ((( ( ( ( ( ( ( ( c >= 97 ) && ( c <= 122 ) ) || ( ( c >= 65 ) && ( c <= 90 ) ) ) || ( ( c >= 48 ) && ( c <= 57 ) ) ) || ( c == 58 ) ) || ( c == 46 ) ) || ( c == 95 ) ) || ( c == 45 ) ))) ) {
								#line 271 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								if (( start == __temp_p52 )) {
									#line 272 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									throw global::haxe.lang.HaxeException.wrap("Expected node name");
								}
								
								#line 274 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								string v = global::haxe.lang.StringExt.substr(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true));
								if ( ! (string.Equals(v, parent.get_nodeName())) ) {
									#line 276 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									throw global::haxe.lang.HaxeException.wrap(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("Expected </", parent.get_nodeName()), ">"));
								}
								
								#line 278 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								state = 0;
								next = 12;
								continue;
							}
							
							#line 269 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 15:
						{
							#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_boolv286 = ( c == 45 );
							#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_boolv285 = false;
							#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_boolv284 = false;
							#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (__temp_boolv286) {
								#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								int __temp_stmt287 = default(int);
								#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								{
									#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									int index7 = ( __temp_p52 + 1 );
									#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									__temp_stmt287 = ( (( ((uint) (index7) ) < str.Length )) ? (((int) (str[index7]) )) : (-1) );
								}
								
								#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								__temp_boolv285 = ( __temp_stmt287 == 45 );
								#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								if (__temp_boolv285) {
									#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									int __temp_stmt288 = default(int);
									#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									{
										#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										int index8 = ( __temp_p52 + 2 );
										#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										__temp_stmt288 = ( (( ((uint) (index8) ) < str.Length )) ? (((int) (str[index8]) )) : (-1) );
									}
									
									#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									__temp_boolv284 = ( __temp_stmt288 == 62 );
								}
								
							}
							
							#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_stmt283 = ( ( __temp_boolv286 && __temp_boolv285 ) && __temp_boolv284 );
							#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (__temp_stmt283) {
								#line 285 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								parent.addChild(global::Xml.createComment(global::haxe.lang.StringExt.substr(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true))));
								__temp_p52 += 2;
								state = 1;
							}
							
							#line 283 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 16:
						{
							#line 290 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (( c == 91 )) {
								#line 291 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								nbrackets++;
							}
							 else {
								#line 292 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								if (( c == 93 )) {
									#line 293 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									nbrackets--;
								}
								 else {
									#line 294 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									if (( ( c == 62 ) && ( nbrackets == 0 ) )) {
										#line 296 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										parent.addChild(global::Xml.createDocType(global::haxe.lang.StringExt.substr(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true))));
										state = 1;
									}
									
								}
								
							}
							
							#line 290 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 14:
						{
							#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_boolv291 = ( c == 63 );
							#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_boolv290 = false;
							#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (__temp_boolv291) {
								#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								int __temp_stmt292 = default(int);
								#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								{
									#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									int index9 = ( __temp_p52 + 1 );
									#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									__temp_stmt292 = ( (( ((uint) (index9) ) < str.Length )) ? (((int) (str[index9]) )) : (-1) );
								}
								
								#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								__temp_boolv290 = ( __temp_stmt292 == 62 );
							}
							
							#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							bool __temp_stmt289 = ( __temp_boolv291 && __temp_boolv290 );
							#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (__temp_stmt289) {
								#line 302 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								__temp_p52++;
								string str1 = global::haxe.lang.StringExt.substr(str, ( start + 1 ), new global::haxe.lang.Null<int>(( ( __temp_p52 - start ) - 2 ), true));
								parent.addChild(global::Xml.createProcessingInstruction(str1));
								state = 1;
							}
							
							#line 300 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
						case 18:
						{
							#line 308 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							if (( c == 59 )) {
								#line 310 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								string s = global::haxe.lang.StringExt.substr(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true));
								if (( (( (( ((uint) (0) ) < s.Length )) ? (((int) (s[0]) )) : (-1) )) == 35 )) {
									#line 312 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									global::haxe.lang.Null<int> i = default(global::haxe.lang.Null<int>);
									#line 312 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									if (( (( (( ((uint) (1) ) < s.Length )) ? (((int) (s[1]) )) : (-1) )) == 120 )) {
										#line 313 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										i = global::Std.parseInt(global::haxe.lang.Runtime.concat("0", global::haxe.lang.StringExt.substr(s, 1, new global::haxe.lang.Null<int>(( s.Length - 1 ), true))));
									}
									 else {
										#line 314 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										i = global::Std.parseInt(global::haxe.lang.StringExt.substr(s, 1, new global::haxe.lang.Null<int>(( s.Length - 1 ), true)));
									}
									
									#line 315 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									{
										#line 315 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										string x = new string(((char) (i.@value) ), 1);
										#line 315 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										buf.b.Append(((object) (global::Std.@string(x)) ));
									}
									
								}
								 else {
									#line 316 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
									if ( ! (global::haxe.xml.Parser.escapes.exists(s)) ) {
										#line 317 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										buf.b.Append(((object) (global::Std.@string(global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.concat("&", s), ";"))) ));
									}
									 else {
										#line 319 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										string x1 = global::haxe.lang.Runtime.toString(global::haxe.xml.Parser.escapes.@get(s).@value);
										#line 319 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
										buf.b.Append(((object) (global::Std.@string(x1)) ));
									}
									
								}
								
								#line 320 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
								start = ( __temp_p52 + 1 );
								state = next;
							}
							
							#line 308 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							break;
						}
						
						
					}
					
					#line 324 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
					{
						#line 324 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
						int index10 =  ++ __temp_p52;
						#line 324 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
						if (( ((uint) (index10) ) < str.Length )) {
							#line 324 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							c = ((int) (str[index10]) );
						}
						 else {
							#line 324 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
							c = -1;
						}
						
					}
					
				}
				
				#line 327 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				if (( state == 1 )) {
					#line 329 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
					start = __temp_p52;
					state = 13;
				}
				
				#line 333 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				if (( state == 13 )) {
					#line 335 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
					if (( ( __temp_p52 != start ) || ( nsubs == 0 ) )) {
						#line 336 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
						parent.addChild(global::Xml.createPCData(global::haxe.lang.Runtime.concat(buf.toString(), global::haxe.lang.StringExt.substr(str, start, new global::haxe.lang.Null<int>(( __temp_p52 - start ), true)))));
					}
					
					#line 337 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
					return __temp_p52;
				}
				
				#line 340 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				throw global::haxe.lang.HaxeException.wrap("Unexpected end");
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 49 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				return new global::haxe.xml.Parser(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 49 "C:\\HaxeToolkit\\haxe\\std\\haxe\\xml\\Parser.hx"
				return new global::haxe.xml.Parser();
			}
			#line default
		}
		
		
	}
}


