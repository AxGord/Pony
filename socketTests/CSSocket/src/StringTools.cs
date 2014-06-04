
#pragma warning disable 109, 114, 219, 429, 168, 162
public  class StringTools : global::haxe.lang.HxObject {
	public    StringTools(global::haxe.lang.EmptyObject empty){
		unchecked {
			#line 32 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public    StringTools(){
		unchecked {
			#line 32 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			global::StringTools.__hx_ctor__StringTools(this);
		}
		#line default
	}
	
	
	public static   void __hx_ctor__StringTools(global::StringTools __temp_me12){
		unchecked {
			#line 32 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public static   string urlEncode(string s){
		unchecked {
			#line 52 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return global::System.Uri.EscapeUriString(((string) (s) ));
		}
		#line default
	}
	
	
	public static   string urlDecode(string s){
		unchecked {
			#line 79 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return global::System.Uri.UnescapeDataString(((string) (s) ));
		}
		#line default
	}
	
	
	public static   string htmlEscape(string s, global::haxe.lang.Null<bool> quotes){
		unchecked {
			#line 102 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			s = global::haxe.lang.StringExt.split(global::haxe.lang.StringExt.split(global::haxe.lang.StringExt.split(s, "&").@join("&amp;"), "<").@join("&lt;"), ">").@join("&gt;");
			if ((quotes).@value) {
				#line 103 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				return global::haxe.lang.StringExt.split(global::haxe.lang.StringExt.split(s, "\"").@join("&quot;"), "\'").@join("&#039;");
			}
			 else {
				#line 103 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				return s;
			}
			
		}
		#line default
	}
	
	
	public static   string htmlUnescape(string s){
		unchecked {
			#line 121 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return global::haxe.lang.StringExt.split(global::haxe.lang.StringExt.split(global::haxe.lang.StringExt.split(global::haxe.lang.StringExt.split(global::haxe.lang.StringExt.split(s, "&gt;").@join(">"), "&lt;").@join("<"), "&quot;").@join("\""), "&#039;").@join("\'"), "&amp;").@join("&");
		}
		#line default
	}
	
	
	public static   bool startsWith(string s, string start){
		unchecked {
			#line 135 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return s.StartsWith(start);
		}
		#line default
	}
	
	
	public static   bool endsWith(string s, string end){
		unchecked {
			#line 152 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return s.EndsWith(end);
		}
		#line default
	}
	
	
	public static   bool isSpace(string s, int pos){
		unchecked {
			#line 173 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			global::haxe.lang.Null<int> c = global::haxe.lang.StringExt.charCodeAt(s, pos);
			return ( ( ( c.@value > 8 ) && ( c.@value < 14 ) ) || global::haxe.lang.Runtime.eq((c).toDynamic(), 32) );
		}
		#line default
	}
	
	
	public static   string ltrim(string s){
		unchecked {
			#line 188 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return s.TrimStart();
		}
		#line default
	}
	
	
	public static   string rtrim(string s){
		unchecked {
			#line 213 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return s.TrimEnd();
		}
		#line default
	}
	
	
	public static   string trim(string s){
		unchecked {
			#line 235 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return s.Trim();
		}
		#line default
	}
	
	
	public static   string lpad(string s, string c, int l){
		unchecked {
			#line 256 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			if (( c.Length <= 0 )) {
				#line 257 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				return s;
			}
			
			#line 259 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			while (( s.Length < l )){
				#line 260 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				s = global::haxe.lang.Runtime.concat(c, s);
			}
			
			#line 262 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return s;
		}
		#line default
	}
	
	
	public static   string rpad(string s, string c, int l){
		unchecked {
			#line 278 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			if (( c.Length <= 0 )) {
				#line 279 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				return s;
			}
			
			#line 281 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			while (( s.Length < l )){
				#line 282 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				s = global::haxe.lang.Runtime.concat(s, c);
			}
			
			#line 284 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return s;
		}
		#line default
	}
	
	
	public static   string replace(string s, string sub, string @by){
		unchecked {
			#line 305 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			if (( sub.Length == 0 )) {
				#line 306 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				return global::haxe.lang.StringExt.split(s, sub).@join(@by);
			}
			 else {
				#line 308 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				return s.Replace(sub, @by);
			}
			
		}
		#line default
	}
	
	
	public static   string hex(int n, global::haxe.lang.Null<int> digits){
		unchecked {
			#line 326 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			string s = "";
			string hexChars = "0123456789ABCDEF";
			do {
				#line 329 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				s = global::haxe.lang.Runtime.concat(global::haxe.lang.StringExt.charAt(hexChars, ( n & 15 )), s);
				n = ((int) (( ((uint) (n) ) >> 4 )) );
			}
			while (( n > 0 ));
			#line 341 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			if (digits.hasValue) {
				#line 342 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				while (( s.Length < digits.@value )){
					#line 343 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
					s = global::haxe.lang.Runtime.concat("0", s);
				}
				
			}
			
			#line 345 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return s;
		}
		#line default
	}
	
	
	public static   int fastCodeAt(string s, int index){
		unchecked {
			#line 374 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			if (( ((uint) (index) ) < s.Length )) {
				#line 374 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				return ((int) (s[index]) );
			}
			 else {
				#line 374 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
				return -1;
			}
			
		}
		#line default
	}
	
	
	public static   bool isEof(int c){
		unchecked {
			#line 397 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return ( c == -1 );
		}
		#line default
	}
	
	
	public static  new object __hx_createEmpty(){
		unchecked {
			#line 32 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return new global::StringTools(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
		}
		#line default
	}
	
	
	public static  new object __hx_create(global::Array arr){
		unchecked {
			#line 32 "C:\\HaxeToolkit\\haxe\\std\\StringTools.hx"
			return new global::StringTools();
		}
		#line default
	}
	
	
}


