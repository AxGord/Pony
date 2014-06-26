
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.text{
	public  class TextTools : global::haxe.lang.HxObject {
		public    TextTools(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 40 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    TextTools(){
			unchecked {
				#line 40 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				global::pony.text.TextTools.__hx_ctor_pony_text_TextTools(this);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_pony_text_TextTools(global::pony.text.TextTools __temp_me114){
			unchecked {
				#line 40 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public static   bool exists(string s, string ch){
			unchecked {
				#line 41 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				return ( global::haxe.lang.StringExt.indexOf(s, ch, default(global::haxe.lang.Null<int>)) != -1 );
			}
			#line default
		}
		
		
		public static   string repeat(string s, int count){
			unchecked {
				#line 44 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				string r = "";
				while (( count-- > 0 )){
					#line 45 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
					r = global::haxe.lang.Runtime.concat(r, s);
				}
				
				#line 46 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				return r;
			}
			#line default
		}
		
		
		public static   bool isTrue(string s){
			unchecked {
				#line 49 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				string __temp_stmt528 = default(string);
				#line 49 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				{
					#line 49 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
					string s1 = s.ToLower();
					#line 49 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
					__temp_stmt528 = s1.Trim();
				}
				
				#line 49 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				return string.Equals(__temp_stmt528, "true");
			}
			#line default
		}
		
		
		public static   global::Array<object> explode(string s, global::Array<object> delimiters){
			unchecked {
				#line 52 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				global::Array<object> r = new global::Array<object>(new object[]{s});
				{
					#line 53 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
					int _g = 0;
					#line 53 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
					while (( _g < delimiters.length )){
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
						string d = global::haxe.lang.Runtime.toString(delimiters[_g]);
						#line 53 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
						 ++ _g;
						global::Array<object> sr = new global::Array<object>(new object[]{});
						{
							#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
							int _g1 = 0;
							#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
							while (( _g1 < r.length )){
								#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
								string e = global::haxe.lang.Runtime.toString(r[_g1]);
								#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
								 ++ _g1;
								#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
								int _g2 = 0;
								#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
								global::Array<object> _g3 = global::haxe.lang.StringExt.split(e, d);
								#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
								while (( _g2 < _g3.length )){
									#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
									string se = global::haxe.lang.Runtime.toString(_g3[_g2]);
									#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
									 ++ _g2;
									#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
									if ( ! (string.Equals(se, "")) ) {
										#line 55 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
										sr.push(se);
									}
									
								}
								
							}
							
						}
						
						#line 56 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
						r = sr;
					}
					
				}
				
				#line 58 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				return r;
			}
			#line default
		}
		
		
		public static   double parsePercent(string s){
			unchecked {
				#line 75 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				if (( global::haxe.lang.StringExt.indexOf(s, "%", default(global::haxe.lang.Null<int>)) != -1 )) {
					#line 76 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
					return ( global::Std.parseFloat(global::haxe.lang.StringExt.substr(s, 0, new global::haxe.lang.Null<int>(( s.Length - 1 ), true))) / 100 );
				}
				 else {
					#line 78 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
					return global::Std.parseFloat(s);
				}
				
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 40 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				return new global::pony.text.TextTools(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 40 "C:\\data\\GitHub\\Pony\\pony\\text\\TextTools.hx"
				return new global::pony.text.TextTools();
			}
			#line default
		}
		
		
	}
}


