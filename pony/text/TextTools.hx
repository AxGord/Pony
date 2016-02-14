/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.text;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Serializer;
#end

/**
 * TextTools
 * @author AxGord <axgord@gmail.com>
 */
class TextTools {
	public inline static function exists(s:String, ch:String):Bool return s.indexOf(ch) != -1;
	
	public static function repeat(s:String, count:Int):String {
		var r:String = '';
		while (count-->0) r += s;
		return r;
	}
	
	inline public static function isTrue(s:String):Bool return StringTools.trim(s.toLowerCase()) == 'true';
	
	public static function explode(s:String, delimiters:Array<String>):Array<String> {
		var r:Array<String> = [s];
		for (d in delimiters) {
			var sr:Array<String> = [];
			for ( e in r ) for ( se in e.split(d) ) if (se != '') sr.push(se);
			r = sr;
		}
		return r;
	}
	
	
	macro public static function includeFile(file:String):Expr {
		var s:String = sys.io.File.getContent(file);
		return macro $v{s};
	}
	
	macro public static function includeFileFromCurrentDir(file:String):Expr {
		var f:String = Context.getPosInfos(Context.currentPos()).file;
		f = sys.FileSystem.fullPath(f).split('\\').slice(0, -1).join('/') + '/';
		var s:String = sys.io.File.getContent(f+file);
		return macro $v{s};
	}
	
	macro public static function includeJson(file:String):Expr {
		var s:String = sys.io.File.getContent(file);
		haxe.Json.parse(s);//check
		return macro haxe.Json.parse($v{s});//todo: not parse on runtime
	}
	
	macro public static function includeJsonFromCurrentDir(file:String):Expr {
		var f:String = Context.getPosInfos(Context.currentPos()).file;
		f = sys.FileSystem.fullPath(f).split('\\').slice(0, -1).join('/') + '/';
		var s:String = sys.io.File.getContent(f+file);
		haxe.Json.parse(s);//check
		return macro haxe.Json.parse($v{s});//todo: not parse on runtime
	}
	
	inline public static function parsePercent(s:String):Float {
		if (s.indexOf('%') != -1) {
			return Std.parseFloat(s.substr(0,s.length-1))/100;
		} else
			return Std.parseFloat(s);
	}
	
	inline public static function last(s:String):String return s.charAt(s.length - 1);
	
	public static function bigFirst(s:String):String return s.charAt(0).toUpperCase() + s.substr(1);
	
	public static function smallFirst(s:String):String return s.charAt(0).toLowerCase() + s.substr(1);
	
	public static function lines(s:String):Array<String> { 
 		var a:Array<String> = s.split('\r\n'); 
 		if (a.length == 1) { 
 			a = s.split('\r'); 
 			if (a.length == 1) 
 				a = s.split('\n'); 
 		} 
 		return a; 
 	} 

}