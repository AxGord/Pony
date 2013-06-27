/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.evaluators;

import com.dongxiguo.hoo.selector.BinaryOperatorSelector;
import com.dongxiguo.hoo.selector.binopTag.AddTag;
import com.dongxiguo.hoo.selector.binopTag.SubTag;
import com.dongxiguo.hoo.selector.binopTag.AssignOpTag;
import com.dongxiguo.hoo.selector.binopTag.IntervalTag;

/*
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end
*/
/**
 * ...
 * @author AxGord
 */
/*
@:final @:macro class ArrayAOTAdd {
	static public function evaluate<T>(
		selector: ExprOf<BinaryOperatorSelector<AssignOpTag<AddTag>, T, T>>,
	left:ExprOf<T>, right:ExprOf<T>):ExprOf<T> return macro $left = $left.concat($right)
}
*/
class ArraySubInt {
	inline static public function evaluate<T>(
		selector: BinaryOperatorSelector<SubTag, Array<T>, Int>,
		left:Array<T>, right:Int):Array<T> return left.slice(0, -right)
}

class ArrayAOTInt {
	inline static public function evaluate<T>(
		selector: BinaryOperatorSelector<AssignOpTag<SubTag>, Array<T>, Int>,
		left:Array<T>, right:Int):Array<T> {
			for (null in 0...right) left.pop();
			return left;
		}
}

/*
class ArrayAdd {
	inline static public function evaluate<T>(
		selector: BinaryOperatorSelector<AddTag, Array<T>, Array<T>>,
		left:Array<T>, right:Array<T>):Array<T> return left.concat(right)
}
Array<Dynamic> == Array<String> - fail 
*/
class ArrayAddD {//lost type...
	inline static public function evaluate(
		selector: BinaryOperatorSelector<AddTag, Array<Dynamic>, Array<Dynamic>>,
		left:Array<Dynamic>, right:Array<Dynamic>):Array<Dynamic> return left.concat(right)
}

class ArrayAddT {
	inline static public function evaluate<T>(
		selector: BinaryOperatorSelector<AddTag, Array<T>, T>,
	left:Array<T>, right:T):Array<T> return left.concat([right])
}

class ArrayAddTD {
	inline static public function evaluate(
		selector: BinaryOperatorSelector<AddTag, Array<Dynamic>, Dynamic>,
	left:Array<Dynamic>, right:Dynamic):Array<Dynamic> return left.concat([right])
}

class ArrayAOTAdd {
	static public function evaluate<T, T2>(
		selector: BinaryOperatorSelector<AssignOpTag<AddTag>, Array<T>, Array<T2>>,
		left:Array<T>, right:Array<T>):Array<T> {
			for (e in right)
				left.push(e);
			return left;
		}
}

class ArrayAOTAddT {
	static public function evaluate<T>(
		selector: BinaryOperatorSelector<AssignOpTag<AddTag>, Array<T>, Dynamic>,
		left:Array<T>, right:T):Array<T> {
			left.push(right);
			return left;
		}
}

class ArrayInterval {
	static public function evaluate(
		selector: BinaryOperatorSelector<IntervalTag, Array<Int>, Int>,
		left:Array<Int>, right:Int):Array<Int> {
			var a:Array<Int> = [];
			for (i in left[0]...right) a.push(i);
			return a;
		}
}

class ArrayIntervalInv {
	static public function evaluate<T>(
		selector: BinaryOperatorSelector<IntervalTag, Int, Array<T>>,
		left:Int, right:Array<T>):Array<T> {
			var a:Array<T> = [];
			for (i in 0...left) a = a.concat(right);
			trace(left);
			return a;
		}
}