package pony.magic.builder;

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
 * CueBuilder
 * @author AxGord <axgord@gmail.com>
 */
class CueBuilder {
	#if macro
	inline private static var INDEX:String = 'INDEX';
	inline private static var TITLE:String = 'TITLE ';
	#end
	macro public static function build():Array<Field> {
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
			title = StringTools.replace(StringTools.replace(title, '/', '_'), ' ', '_');
			data.push(new Pair(title, Time.fromString(time)));
		}
		data.sort(function(a, b) return a.b - b.b);

		var fields:Array<Field> = Context.getBuildFields();

		var map: Map<String, {min: Int, max: Int}> = [ for (i in 0...data.length) {
			var title = data[i].a;
			var t: Pair<Time, Time> = i != data.length -1 ? {a: data[i].b, b: data[i + 1].b} : {a: data[i].b, b: 0};
			fields.push({
				name: title,
				access: [APublic, AStatic],
				pos: Context.currentPos(),
				kind: FVar(
					macro:pony.time.TimeInterval,
					{ expr: EBinop(OpInterval, macro $v{t.a}, macro $v{t.b}), pos:Context.currentPos() }
				)
			});
			title => {min: t.a, max: t.b};
		} ];

		fields.push({
			name: 'soundMap',
			access: [APublic, AStatic],
			pos: Context.currentPos(),
			kind: FVar(
				macro:Map<String, pony.time.TimeInterval>,
				macro cast $v{map}
			)
		});

		return fields;
	}

}