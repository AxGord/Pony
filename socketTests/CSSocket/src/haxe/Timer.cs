
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe{
	public  class Timer : global::haxe.lang.HxObject {
		public    Timer(global::haxe.lang.EmptyObject empty){
			unchecked {
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				{
				}
				
			}
			#line default
		}
		
		
		public    Timer(int time_ms){
			unchecked {
				#line 48 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				global::haxe.Timer.__hx_ctor_haxe_Timer(this, time_ms);
			}
			#line default
		}
		
		
		public static   void __hx_ctor_haxe_Timer(global::haxe.Timer __temp_me28, int time_ms){
			unchecked {
				#line 90 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				__temp_me28.run = ( (( global::haxe.Timer___hx_ctor_haxe_Timer_90__Fun.__hx_current != default(global::haxe.Timer___hx_ctor_haxe_Timer_90__Fun) )) ? (global::haxe.Timer___hx_ctor_haxe_Timer_90__Fun.__hx_current) : (global::haxe.Timer___hx_ctor_haxe_Timer_90__Fun.__hx_current = ((global::haxe.Timer___hx_ctor_haxe_Timer_90__Fun) (new global::haxe.Timer___hx_ctor_haxe_Timer_90__Fun()) )) );
				#line 50 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				__temp_me28.id = new global::haxe.lang.Null<int>(1, true);
				global::haxe.lang.Function f = ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (__temp_me28) ), ((string) ("runRun") ), ((int) (998578368) ))) );
				global::System.Timers.Timer tt = __temp_me28.t = new global::System.Timers.Timer(((double) (time_ms) ));
				__temp_me28.t.Enabled = global::haxe.lang.Runtime.toBool(true);
				tt.Elapsed+=delegate(System.Object o, System.Timers.ElapsedEventArgs e){f.__hx_invoke0_o();};
			}
			#line default
		}
		
		
		public static   global::haxe.Timer delay(global::haxe.lang.Function f, int time_ms){
			unchecked {
				#line 97 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				global::Array<object> f1 = new global::Array<object>(new object[]{f});
				global::Array<object> t = new global::Array<object>(new object[]{new global::haxe.Timer(((int) (time_ms) ))});
				((global::haxe.Timer) (t[0]) ).run = new global::haxe.Timer_delay_99__Fun(((global::Array<object>) (t) ), ((global::Array<object>) (f1) ));
				#line 103 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				return ((global::haxe.Timer) (t[0]) );
			}
			#line default
		}
		
		
		public static   T measure<T>(global::haxe.lang.Function f, object pos){
			unchecked {
				#line 112 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				double t0 = global::haxe.Timer.stamp();
				T r = global::haxe.lang.Runtime.genericCast<T>(f.__hx_invoke0_o());
				global::haxe.Log.trace.__hx_invoke2_o(default(double), global::haxe.lang.Runtime.concat(global::haxe.lang.Runtime.toString(( global::haxe.Timer.stamp() - t0 )), "s"), default(double), pos);
				return r;
			}
			#line default
		}
		
		
		public static   double stamp(){
			unchecked {
				#line 123 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				global::System.TimeSpan ts = default(global::System.TimeSpan);
				ts = System.DateTime.UtcNow - new System.DateTime(1970, 1, 1);
				return ts.TotalMilliseconds;
			}
			#line default
		}
		
		
		public static  new object __hx_createEmpty(){
			unchecked {
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				return new global::haxe.Timer(((global::haxe.lang.EmptyObject) (global::haxe.lang.EmptyObject.EMPTY) ));
			}
			#line default
		}
		
		
		public static  new object __hx_create(global::Array arr){
			unchecked {
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				return new global::haxe.Timer(((int) (global::haxe.lang.Runtime.toInt(arr[0])) ));
			}
			#line default
		}
		
		
		public  global::System.Timers.Timer t;
		
		public  global::haxe.lang.Null<int> id;
		
		public virtual   void runRun(){
			unchecked {
				#line 43 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				this.run.__hx_invoke0_o();
			}
			#line default
		}
		
		
		public virtual   void stop(){
			unchecked {
				#line 71 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				if ( ! (this.id.hasValue) ) {
					#line 72 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
					return ;
				}
				
				#line 74 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				this.t.Stop();
				this.t.Enabled = global::haxe.lang.Runtime.toBool(false);
				this.t = default(global::System.Timers.Timer);
				#line 84 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				this.id = default(global::haxe.lang.Null<int>);
			}
			#line default
		}
		
		
		public  global::haxe.lang.Function run;
		
		public override   object __hx_setField(string field, int hash, object @value, bool handleProperties){
			unchecked {
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				switch (hash){
					case 5695307:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						this.run = ((global::haxe.lang.Function) (@value) );
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return @value;
					}
					
					
					case 23515:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						this.id = global::haxe.lang.Null<object>.ofDynamic<int>(@value);
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return @value;
					}
					
					
					case 116:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						this.t = ((global::System.Timers.Timer) (@value) );
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return @value;
					}
					
					
					default:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return base.__hx_setField(field, hash, @value, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_getField(string field, int hash, bool throwErrors, bool isCheck, bool handleProperties){
			unchecked {
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				switch (hash){
					case 5695307:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return this.run;
					}
					
					
					case 1281093634:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("stop") ), ((int) (1281093634) ))) );
					}
					
					
					case 998578368:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return ((global::haxe.lang.Function) (new global::haxe.lang.Closure(((object) (this) ), ((string) ("runRun") ), ((int) (998578368) ))) );
					}
					
					
					case 23515:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return (this.id).toDynamic();
					}
					
					
					case 116:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return this.t;
					}
					
					
					default:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return base.__hx_getField(field, hash, throwErrors, isCheck, handleProperties);
					}
					
				}
				
			}
			#line default
		}
		
		
		public override   object __hx_invokeField(string field, int hash, global::Array dynargs){
			unchecked {
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				switch (hash){
					case 1281093634:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						this.stop();
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						break;
					}
					
					
					case 998578368:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						this.runRun();
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						break;
					}
					
					
					default:
					{
						#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
						return base.__hx_invokeField(field, hash, dynargs);
					}
					
				}
				
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				return default(object);
			}
			#line default
		}
		
		
		public override   void __hx_getFields(global::Array<object> baseArr){
			unchecked {
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				baseArr.push("run");
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				baseArr.push("id");
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				baseArr.push("t");
				#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				{
					#line 36 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
					base.__hx_getFields(baseArr);
				}
				
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe{
	public  class Timer___hx_ctor_haxe_Timer_90__Fun : global::haxe.lang.Function {
		public    Timer___hx_ctor_haxe_Timer_90__Fun() : base(0, 0){
			unchecked {
			}
			#line default
		}
		
		
		public static  global::haxe.Timer___hx_ctor_haxe_Timer_90__Fun __hx_current;
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 91 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				global::haxe.Log.trace.__hx_invoke2_o(default(double), "run", default(double), new global::haxe.lang.DynamicObject(new global::Array<int>(new int[]{302979532, 1547539107, 1648581351}), new global::Array<object>(new object[]{"run", "haxe.Timer", "Timer.hx"}), new global::Array<int>(new int[]{1981972957}), new global::Array<double>(new double[]{((double) (91) )})));
				#line 91 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				return default(object);
			}
			#line default
		}
		
		
	}
}



#pragma warning disable 109, 114, 219, 429, 168, 162
namespace haxe{
	public  class Timer_delay_99__Fun : global::haxe.lang.Function {
		public    Timer_delay_99__Fun(global::Array<object> t, global::Array<object> f1) : base(0, 0){
			unchecked {
				#line 99 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				this.t = t;
				#line 99 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				this.f1 = f1;
			}
			#line default
		}
		
		
		public override   object __hx_invoke0_o(){
			unchecked {
				#line 100 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				((global::haxe.Timer) (this.t[0]) ).stop();
				((global::haxe.lang.Function) (this.f1[0]) ).__hx_invoke0_o();
				#line 99 "C:\\HaxeToolkit\\haxe\\lib\\HUGS\\0,1,4\\haxe\\Timer.hx"
				return default(object);
			}
			#line default
		}
		
		
		public  global::Array<object> t;
		
		public  global::Array<object> f1;
		
	}
}


