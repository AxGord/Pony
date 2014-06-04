
#pragma warning disable 109, 114, 219, 429, 168, 162
public  class IntIterator : global::haxe.lang.HxObject {
	public    IntIterator(global::haxe.lang.EmptyObject empty){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			{
			}
			
		}
		#line default
	}
	
	
	public    IntIterator(int min, int max){
		unchecked {
			#line 44 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			global::IntIterator.__hx_ctor__IntIterator(this, min, max);
		}
		#line default
	}
	
	
	public static   void __hx_ctor__IntIterator(global::IntIterator __temp_me6, int min, int max){
		unchecked {
			#line 45 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			__temp_me6.min = min;
			__temp_me6.max = max;
		}
		#line default
	}
	
	
	public static  new object __hx_createEmpty(){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			return new global::IntIterator(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
		}
		#line default
	}
	
	
	public static  new object __hx_create(global::Array arr){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			return new global::IntIterator(((int) (global::haxe.lang.Runtime.toInt(arr[0])) ), ((int) (global::haxe.lang.Runtime.toInt(arr[1])) ));
		}
		#line default
	}
	
	
	public  int min;
	
	public  int max;
	
	public override   double __hx_setField_f(string field, int hash, double @value, bool handleProperties){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			switch (hash){
				case 5442212:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					this.max = ((int) (@value) );
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return @value;
				}
				
				
				case 5443986:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					this.min = ((int) (@value) );
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return @value;
				}
				
				
				default:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return base.__hx_setField_f(field, hash, @value, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			switch (hash){
				case 5442212:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					this.max = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return @value;
				}
				
				
				case 5443986:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					this.min = ((int) (global::haxe.lang.Runtime.toInt(@value)) );
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return @value;
				}
				
				
				default:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return base.__hx_setField(field, hash, @value, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			switch (hash){
				case 5442212:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return this.max;
				}
				
				
				case 5443986:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return this.min;
				}
				
				
				default:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   double __hx_getField_f(string field, int hash, bool throwErrors, bool handleProperties){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			switch (hash){
				case 5442212:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return ((double) (this.max) );
				}
				
				
				case 5443986:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return ((double) (this.min) );
				}
				
				
				default:
				{
					#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
					return base.__hx_getField_f(field, hash, throwErrors, handleProperties);
				}
				
			}
			
		}
		#line default
	}
	
	
	public override   void __hx_getFields(global::Array<object> baseArr){
		unchecked {
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			baseArr.push("max");
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			baseArr.push("min");
			#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
			{
				#line 34 "C:\\HaxeToolkit\\haxe\\std\\IntIterator.hx"
				base.__hx_getFields(baseArr);
			}
			
		}
		#line default
	}
	
	
}


