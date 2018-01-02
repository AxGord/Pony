/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.magic;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import sys.io.File;
import pony.text.TextTools;
import pony.time.Time;
import pony.Pair;
using Lambda;
using pony.macro.Tools;
#end

/**
 * Cue
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.CueBuilder.build())
#end
interface Cue {}

class CueBuilder {
	#if macro
	inline private static var INDEX:String = 'INDEX';
	inline private static var TITLE:String = 'TITLE ';
	#end
	macro static public function build():Array<Field> {
		
		var cl = Context.getLocalClass();
		var meta = cl.get().meta.get();
		var cueFile = null;
		for (m in meta) switch m {
			case {name:':cue', params: [{expr: EConst(CString(v))}]}:
				cueFile = v;
			case _:
		}
		if (cueFile == null) throw 'Error';
		Context.registerModuleDependency(Context.getLocalModule(), cueFile);
		var cue = File.getContent(cueFile);
		var map:Map<String, Map<String, Array<String>>> = TextTools.tabParser(cue);
		var data:Array<Pair<String, Int>> = [];
		for (e in map.iterator().next()) {
			var title:String = null;
			var time:String = null;
			for (v in e) {
				if (v.substr(0, INDEX.length) == INDEX)
					time = v.substr(INDEX.length + 4);
				if (v.substr(0, TITLE.length) == TITLE)
					title = TextTools.removeQuotes(v.substr(TITLE.length));
			}
			if (title == null || time == null) throw 'Error';
			title = StringTools.replace(title, ' ', '_');
			var a = time.split(':');
			var t = Time.createft('0', '0', a[0], a[1]) + Std.parseInt(a[2]) * 10;
			data.push(new Pair(title, t));
		}
		data.sort(function(a, b) return a.b - b.b);
		
		var fields:Array<Field> = Context.getBuildFields();
		
		for (i in 0...data.length) {
			var title = data[i].a;
			var t:Pair<Time, Time> = i != data.length -1 ? {a: data[i].b, b: data[i + 1].b} : {a: data[i].b, b: null};
			
			fields.push({
				name: title,
				access: [APublic, AStatic],
				pos: Context.currentPos(),
				kind: FVar(macro:pony.time.TimeInterval, {expr: EBinop(OpInterval, macro $v{t.a}, macro $v{t.b}), pos:Context.currentPos()})
			});
			
		}
		
		return fields;
	}
	
}