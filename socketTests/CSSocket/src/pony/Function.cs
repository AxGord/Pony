
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony._Function{
	public sealed class Function_Impl_ {
		static Function_Impl_() {
			#line 70 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
			{
				#line 71 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				global::pony._Function.Function_Impl_.unusedCount = 0;
				#line 73 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				global::pony._Function.Function_Impl_.cslist = new global::pony.Dictionary<object, object>(new global::haxe.lang.Null<int>(1, true));
				global::pony._Function.Function_Impl_.list = new global::pony.Dictionary<object, object>(new global::haxe.lang.Null<int>(1, true));
				#line 78 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				global::pony._Function.Function_Impl_.counter = -1;
				global::pony._Function.Function_Impl_.searchFree = false;
			}
			
		}
		public static  int unusedCount;
		
		public static  global::pony.Dictionary<object, object> cslist;
		
		public static  global::pony.Dictionary<object, object> list;
		
		public static  int counter;
		
		public static  bool searchFree;
		
		public static   object _new(object f, int count, global::Array args){
			unchecked {
				#line 82 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				object this1 = default(object);
				global::pony._Function.Function_Impl_.counter++;
				if (global::pony._Function.Function_Impl_.searchFree) {
					#line 85 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					while (true){
						#line 86 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						{
							#line 86 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
							object __temp_iterator132 = ((object) (new global::_Array.ArrayIterator<object>(((global::Array<object>) (global::pony._Function.Function_Impl_.list.vs) ))) );
							#line 86 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
							while (global::haxe.lang.Runtime.toBool(global::haxe.lang.Runtime.callField(__temp_iterator132, "hasNext", 407283053, default(global::Array)))){
								#line 86 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
								object e = ((object) (global::haxe.lang.Runtime.callField(__temp_iterator132, "next", 1224901875, default(global::Array))) );
								if (( ((int) (global::haxe.lang.Runtime.getField_f(e, "id", 23515, true)) ) != global::pony._Function.Function_Impl_.counter )) {
									#line 88 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
									break;
								}
								
							}
							
						}
						
						#line 90 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						global::pony._Function.Function_Impl_.counter++;
					}
					
				}
				 else {
					#line 92 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					if (( global::pony._Function.Function_Impl_.counter == -1 )) {
						#line 93 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						global::pony._Function.Function_Impl_.searchFree = true;
					}
					
				}
				
				#line 94 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				this1 = new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{102, 1081380189}), new global::Array<object>(new object[]{f, ( (( args == default(global::Array) )) ? (new global::Array<object>(new object[]{})) : (args) )}), new global::Array<int>(new int[]{23515, 1248019663, 1303220797}), new global::Array<double>(new double[]{((double) (global::pony._Function.Function_Impl_.counter) ), ((double) (count) ), ((double) (0) )}));
				#line 82 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return this1;
			}
			#line default
		}
		
		
		public static   object @from(object f, int argc){
			unchecked {
				#line 99 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				object h = global::pony._Function.Function_Impl_.buildCSHash(f);
				bool __temp_stmt297 = default(bool);
				#line 100 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				{
					#line 100 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					global::pony.Dictionary<object, object> _this = global::pony._Function.Function_Impl_.cslist;
					#line 100 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					__temp_stmt297 = ( global::pony.Tools.superIndexOf<object>(_this.ks, h, new global::haxe.lang.Null<int>(_this.maxDepth, true)) != -1 );
				}
				
				#line 100 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				if (__temp_stmt297) {
					#line 101 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					return global::pony._Function.Function_Impl_.cslist.@get(h);
				}
				 else {
					#line 103 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					global::pony._Function.Function_Impl_.unusedCount++;
					object o = global::pony._Function.Function_Impl_._new(f, argc, default(global::Array));
					global::pony._Function.Function_Impl_.cslist.@set(h, o);
					return o;
				}
				
			}
			#line default
		}
		
		
		public static   object buildCSHash(object f){
			unchecked {
				#line 122 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				if (( f is global::haxe.lang.Closure )) {
					#line 123 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					{
						#line 123 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						object __temp_odecl298 = global::haxe.lang.Runtime.getField(f, "obj", 5541879, true);
						#line 123 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						string __temp_odecl299 = global::haxe.lang.Runtime.toString(global::haxe.lang.Runtime.getField(f, "field", 9671866, true));
						#line 123 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						return new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{110, 111}), new global::Array<object>(new object[]{__temp_odecl299, __temp_odecl298}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
					}
					
				}
				 else {
					#line 125 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					string key = global::Std.@string(f);
					global::System.Type t = f.GetType();
					global::System.Reflection.FieldInfo[] a = t.GetFields();
					global::Array data = new global::Array<object>(new object[]{});
					{
						#line 129 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						int _g1 = 0;
						#line 129 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						int _g = ( a as global::System.Array ).Length;
						#line 129 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						while (( _g1 < _g )){
							#line 129 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
							int i = _g1++;
							global::haxe.lang.Runtime.callField(data, "push", 1247875546, new global::Array<object>(new object[]{global::Reflect.field(f, ( a[i] as global::System.Reflection.MemberInfo ).Name)}));
						}
						
					}
					
					#line 132 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					return new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{110, 111}), new global::Array<object>(new object[]{key, ((object) (data) )}), new global::Array<int>(new int[]{}), new global::Array<double>(new double[]{}));
				}
				
			}
			#line default
		}
		
		
		public static   object from0<R>(global::haxe.lang.Function f){
			unchecked {
				#line 138 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return global::pony._Function.Function_Impl_.@from(f, 0);
			}
			#line default
		}
		
		
		public static   object from1<R>(global::haxe.lang.Function f){
			unchecked {
				#line 141 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return global::pony._Function.Function_Impl_.@from(f, 1);
			}
			#line default
		}
		
		
		public static   object from2<R>(global::haxe.lang.Function f){
			unchecked {
				#line 144 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return global::pony._Function.Function_Impl_.@from(f, 2);
			}
			#line default
		}
		
		
		public static   object from3<R>(global::haxe.lang.Function f){
			unchecked {
				#line 147 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return global::pony._Function.Function_Impl_.@from(f, 3);
			}
			#line default
		}
		
		
		public static   object from4<R>(global::haxe.lang.Function f){
			unchecked {
				#line 150 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return global::pony._Function.Function_Impl_.@from(f, 4);
			}
			#line default
		}
		
		
		public static   object from5<R>(global::haxe.lang.Function f){
			unchecked {
				#line 153 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return global::pony._Function.Function_Impl_.@from(f, 5);
			}
			#line default
		}
		
		
		public static   object from6<R>(global::haxe.lang.Function f){
			unchecked {
				#line 156 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return global::pony._Function.Function_Impl_.@from(f, 6);
			}
			#line default
		}
		
		
		public static   object from7<R>(global::haxe.lang.Function f){
			unchecked {
				#line 159 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return global::pony._Function.Function_Impl_.@from(f, 7);
			}
			#line default
		}
		
		
		public static   object call(object this1, global::Array args){
			unchecked {
				#line 162 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				if (( args == default(global::Array) )) {
					#line 162 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					args = new global::Array<object>(new object[]{});
				}
				
				#line 163 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return global::Reflect.callMethod(default(object), global::haxe.lang.Runtime.getField(this1, "f", 102, true), ((global::Array) (global::haxe.lang.Runtime.callField(((global::Array) (global::haxe.lang.Runtime.getField(this1, "args", 1081380189, true)) ), "concat", 1204816148, new global::Array<object>(new object[]{args}))) ));
			}
			#line default
		}
		
		
		public static   int get_id(object this1){
			unchecked {
				#line 166 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return ((int) (global::haxe.lang.Runtime.getField_f(this1, "id", 23515, true)) );
			}
			#line default
		}
		
		
		public static   int get_count(object this1){
			unchecked {
				#line 167 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return ((int) (global::haxe.lang.Runtime.getField_f(this1, "count", 1248019663, true)) );
			}
			#line default
		}
		
		
		public static   void _setArgs(object this1, global::Array args){
			unchecked {
				#line 170 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				{
					#line 170 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					object __temp_dynop133 = this1;
					#line 170 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					global::haxe.lang.Runtime.setField_f(__temp_dynop133, "count", 1248019663, ((double) (( ((int) (global::haxe.lang.Runtime.getField_f(__temp_dynop133, "count", 1248019663, true)) ) - ((int) (global::haxe.lang.Runtime.getField_f(args, "length", 520590566, true)) ) )) ));
				}
				
				#line 171 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				global::haxe.lang.Runtime.setField(this1, "args", 1081380189, ((global::Array) (global::haxe.lang.Runtime.callField(((global::Array) (global::haxe.lang.Runtime.getField(this1, "args", 1081380189, true)) ), "concat", 1204816148, new global::Array<object>(new object[]{args}))) ));
			}
			#line default
		}
		
		
		public static   void _use(object this1){
			unchecked {
				#line 174 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				{
					#line 174 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					object __temp_getvar134 = this1;
					#line 174 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					int __temp_ret135 = ((int) (global::haxe.lang.Runtime.getField_f(__temp_getvar134, "used", 1303220797, true)) );
					#line 174 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					global::haxe.lang.Runtime.setField_f(__temp_getvar134, "used", 1303220797, ((double) (( __temp_ret135 + 1 )) ));
					#line 174 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					int __temp_expr300 = __temp_ret135;
				}
				
			}
			#line default
		}
		
		
		public static   void unuse(object this1){
			unchecked {
				#line 177 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				{
					#line 177 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					object __temp_getvar136 = this1;
					#line 177 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					int __temp_ret137 = ((int) (global::haxe.lang.Runtime.getField_f(__temp_getvar136, "used", 1303220797, true)) );
					#line 177 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					global::haxe.lang.Runtime.setField_f(__temp_getvar136, "used", 1303220797, ((double) (( __temp_ret137 - 1 )) ));
					#line 177 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					int __temp_expr301 = __temp_ret137;
				}
				
				#line 178 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				if (( global::haxe.lang.Runtime.compare(((int) (global::haxe.lang.Runtime.getField_f(this1, "used", 1303220797, true)) ), 0) <= 0 )) {
					#line 180 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					if (( global::haxe.lang.Runtime.getField(this1, "f", 102, true) is global::haxe.lang.Closure )) {
						#line 181 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						global::pony._Function.Function_Impl_.cslist.@remove(global::pony._Function.Function_Impl_.buildCSHash(global::haxe.lang.Runtime.getField(this1, "f", 102, true)));
					}
					 else {
						#line 183 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
						global::pony._Function.Function_Impl_.list.@remove(global::pony._Function.Function_Impl_.buildCSHash(global::haxe.lang.Runtime.getField(this1, "f", 102, true)));
					}
					
					#line 187 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
					this1 = default(object);
					global::pony._Function.Function_Impl_.unusedCount--;
				}
				
			}
			#line default
		}
		
		
		public static   int get_used(object this1){
			unchecked {
				#line 192 "C:\\data\\GitHub\\Pony\\pony\\Function.hx"
				return ((int) (global::haxe.lang.Runtime.getField_f(this1, "used", 1303220797, true)) );
			}
			#line default
		}
		
		
	}
}


