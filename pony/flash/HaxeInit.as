package {
	
	public class HaxeInit {
		
		private static var inited:Boolean = false;
		
		public static function init():void {
			if (inited) return;
			inited = true;
			{
				Math["NaN"] = Number.NaN;
				Math["NEGATIVE_INFINITY"] = Number.NEGATIVE_INFINITY;
				Math["POSITIVE_INFINITY"] = Number.POSITIVE_INFINITY;
				Math["isFinite"] = function(i : Number) : Boolean {
					return isFinite(i);
				}
				Math["isNaN"] = function(i1 : Number) : Boolean {
					return isNaN(i1);
				}
			}
			{
				var aproto : * = Array.prototype;
				aproto.copy = function() : * {
					return this.slice();
				}
				aproto.insert = function(i : *,x : *) : void {
					this.splice(i,0,x);
				}
				aproto.remove = function(obj : *) : Boolean {
					var idx : int = this.indexOf(obj);
					if(idx == -1) return false;
					this.splice(idx,1);
					return true;
				}
				aproto.iterator = function() : * {
					var cur : int = 0;
					var arr : Array = this;
					return { hasNext : function() : Boolean {
						return cur < arr.length;
					}, next : function() : * {
						return arr[cur++];
					}}
				}
				aproto.setPropertyIsEnumerable("copy",false);
				aproto.setPropertyIsEnumerable("insert",false);
				aproto.setPropertyIsEnumerable("remove",false);
				aproto.setPropertyIsEnumerable("iterator",false);
				String.prototype.charCodeAtHX = function(i1 : *) : * {
					var s : String = this;
					var x1 : Number = s.charCodeAt(i1);
					if(isNaN(x1)) return null;
					return Std._int(x1);
				}
			}
		}
		
	}
	
}