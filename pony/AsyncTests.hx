package pony ;
import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import pony.Pair;

/**
 * AsyncTests
 * @author DIS
 */
class AsyncTests extends TestCase
{
		 static var isRead:Map<Int, Bool>;
		 public static var assertList:List < Pair < Dynamic, Dynamic >> = new List();
		
		static public function init(count:Int):Void 
		{
			isRead = [for (i in 0...count) i => false];
		}

		static public inline function equals<T>(a:T, b:T):Void 
		{
			assertList.push(new Pair(a,b));
		}
		
		static public function setFlag(n:Int) 
		{
			trace("Test # " + n +  " finished");
			isRead[n] = true;
			for (e in isRead) if (!e) return;
			
			var test:TestRunner = new TestRunner();
			test.add(new AsyncTests());
			test.run();
		}
		
		public function testRun() 
		{
			for (e in assertList) 
			{
				assertEquals(e.a, e.b);
			}
		}
		
}