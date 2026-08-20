package pony.text.tpl;

import pony.text.ParseBoy;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData;

using StringTools;

/**
 * Tpl parser
 * @author AxGord
 */
class Parse extends ParseBoy<TplContent> {

	public static var VAR_SYMBOLS: String = 'qwertyuiopasdfghjklzxcvbnm1234567890-';

	public static function parse(t: String, s: TplStyle): TplData {
		final o: Parse = new Parse(t, s);
		return o.data;
	}

	private final s: TplStyle;

	public function new(t: String, s: TplStyle) {
		/////
		// todo:
		// {type: TplData, content: ParseEnum([
		// 	{type: TplTag, content: ParseType([
		// 		'<_',
		// 		{type: TplTagName, content: ParseAll() },
		// 		[
		// 			['="', { type: TplData, content: ParseRecursive() }, '"'],
		// 			['=', { type: TplData, content: ParseRecursive() } ]
		// 		],
		// 		[' ', { type: Hash<TplData>, content: ParseHash(' ', {type: String, ParseAll()}, '=', {type: TplData, ParseQ(ParseRecursive(), '"')}) } ],
		// 		'/>'
		// 	]) },
		// 	{type: TplShortTag, content: ParseType([
		// 		'%', {type: TplTagName, content: ParseAll()}, ['=', {type: TplData, content: ParseQ(ParseRecursive(), '"')}], '%'
		// 	]) },
		// 	{type: String, content: ParseAll()}
		// ])};
		////
		this.s = s;
		super(t, s.space);
		searchOpen();
	}

	private function searchOpen(closed: Bool = false): Void {

		// BEGIN CHECK VARS
		gt([s.shortBegin]);
		final p_sh: Int = pos;
		pos = beforeGoto;
		gt([s.begin]);
		final p_nrml: Int = pos;
		pos = beforeGoto;

		if (p_sh < p_nrml) {
			final bef: Int = pos;
			pos = p_sh;
			switch gt([s.args.set, s.shortEnd]) {
				case 0:
					var r: Bool = false;
					final name: String = StringTools.trim(str());
					for (i in 0...name.length) {
						if (VAR_SYMBOLS.indexOf(name.charAt(i)) == -1) {
							beforeGoto = bef;
							pos = p_sh + s.args.set.length;
							pushText();
							r = true;
							break;
						}
					}
					pos = !r ? bef : p_sh;
				case 1:
					var r: Bool = false;
					final name: String = StringTools.trim(str());
					for (i in 0...name.length) {
						if (VAR_SYMBOLS.indexOf(name.charAt(i)) == -1) {
							beforeGoto = bef;
							pos = p_sh + s.shortEnd.length;
							pushText();
							r = true;
							break;
						}
					}
					pos = !r ? bef : p_sh;
				case _:
					beforeGoto = bef;
					pos = p_sh;
					pushText();
			}
		}
		// END CHECK VARS

		var o: Int = openPos();
		var c: Int = closePos();

		if (o >= c) {
			if (o == c) {
				if (closed) throw 'Not closed tag';
				pushEndText();
				return;
			}
			if (closed) return;
			// push(Text(t.substr(pos, (t.length - pos) - (t.length - o))));
			// pos = o;
			gt([s.closeEnd]);
			throw 'Closed not opened tag [' + t.substr(c, pos - c) + ']';
		}
		switch (gt([s.begin, s.shortBegin])) {
			case 0:
				pushText();
				tag();
				searchOpen(closed);
			case 1:
				pushText();
				switch (gt([s.shortEnd, s.args.set])) {
					case 0:
						data.push(ShortTag({ name: parseName(str()), arg: null }));
					case 1:
						final name: String = str();
						switch (gt([s.shortEnd, s.args.valueq])) {
							case 0:
								if (s.args.qalltime) throw '["] - not found';
								data.push(ShortTag({ name: parseName(name), arg: parse(str(), s) }));
							case 1:
								if (gt([s.args.valueq]) == -1) throw '["] - not closed';
								data.push(ShortTag({ name: parseName(name), arg: parse(str(), s) }));
								if (gt([s.shortEnd]) == -1)
									throw 'Oops';
							case _:
								throw 'Oops';
						}
					case _:
						throw 'Oops';
				}
				searchOpen(closed);
			case _:
		}

	}

	private function pushText(): Void {
		final t: String = str();
		if (t != '') data.push(Text(t));
	}

	private function pushEndText(): Void {
		final t: String = t.substr(pos);
		if (t != '') data.push(Text(t));
	}

	private function parseName(n: String): TplTagName {
		var lvl: Int = 0;
		var i: Int = -1;
		while (++i < n.length) {
			final c: String = n.charAt(i);
			if (c == s.up)
				lvl++;
			else if (s.space && c == ' ')
				continue;
			else
				break;
		}
		var a: Array<String> = n.substr(i).split(s.group);
		if (s.space) a = a.map(StringTools.trim);
		return { up: lvl, name: a };
	}

	private inline function tag(): Bool {
		var result: Bool = false;
		skipSpace();
		switch (gt([s.end, s.endClose, s.args.begin, s.args.set])) {
			case 0:
				final name: String = str();
				final d: TplData = tagContent(name);
				data.push(Tag({ name: parseName(name), arg: null, args: new Map<String, TplData>(), content: d }));
				result = true;
			case 1:
				data.push(Tag({ name: parseName(str()), arg: null, args: new Map<String, TplData>(), content: null }));
				result = true;
			case 2:
				final name: String = str();
				var a: { args: Map<String, TplData>, closedTag: Bool } = args();
				final d: TplData = a.closedTag ? null : tagContent(name);
				data.push(Tag({ name: parseName(name), arg: null, args: a.args, content: d }));
			case 3:
				final name: String = str();
				switch (gt([s.end, s.endClose, s.args.valueq], true)) {
					case -2:
						switch (gt([s.end, s.endClose, s.args.begin])) {
							case 0:
								final arg: TplData = parse(str(), s);
								final d: TplData = tagContent(name);
								data.push(Tag({ name: parseName(name), arg: arg, args: new Map<String, TplData>(), content: d }));
							case 1:
								final arg: TplData = parse(str(), s);
								data.push(Tag({ name: parseName(name), arg: arg, args: new Map<String, TplData>(), content: null }));
							case 2:
								final arg: TplData = parse(str(), s);
								var a: { args: Map<String, TplData>, closedTag: Bool } = args();
								final d: TplData = a.closedTag ? null : tagContent(name);
								data.push(Tag({ name: parseName(name), arg: arg, args: a.args, content: d }));
							case _:
								throw 'Oops';
						}
					/*
					case 0:
						if (s.args.qalltime)
							throw '["] - not found';
						var st:String = str();
						var arg:TplData = parse(st, s);
						var d:TplData = tagContent(name);
						data.push(Tag({name: parseName(name), arg: arg, args: new Hash<TplData>(), content: d}));

					case 1:
						throw 'todo';
					 */
					case 2:
						if (gt([s.args.valueq]) == -1) throw '["] - not closed';
						final arg: TplData = parse(str(), s);
						switch (gt([s.end, s.endClose, s.args.begin])) {
							case 0:
								final d: TplData = tagContent(name);
								data.push(Tag({ name: parseName(name), arg: arg, args: new Map<String, TplData>(), content: d }));
							case 1:
								data.push(Tag({ name: parseName(name), arg: arg, args: new Map<String, TplData>(), content: null }));
							case 2:
								var a: { args: Map<String, TplData>, closedTag: Bool } = args();
								final d: TplData = a.closedTag ? null : tagContent(name);
								data.push(Tag({ name: parseName(name), arg: arg, args: a.args, content: d }));
							case _:
								throw 'Oops';
						}
					case _:
						throw 'Oops';
				}
				result = true;
			case _:
				trace('end tag');
		}
		return result;
	}

	private function args(): { args: Map<String, TplData>, closedTag: Bool } {
		final args: Map<String, TplData> = [];
		while (true) {
			switch (gt([s.args.end, s.end, s.endClose], true)) {
				case -2:
					switch (gt([s.args.set, s.args.delemiter, s.args.end, s.end, s.endClose])) {
						case 0:
							final n: String = str();
							switch (gt([s.args.valueq], true)) {
								case -2:
									switch (gt([s.args.delemiter, s.end, s.args.end, s.endClose])) {
										case 0:
											args[n] = parse(str(), s);
										case 1:
											args[n] = parse(str(), s);
											if (s.args.end != '') throw 'Oops';
											break;
										case 2:
											args[n] = parse(str(), s);
											if (gt([s.args.valueq]) == -1)
												throw 'Oops';
										case 3:
											args[n] = parse(str(), s);
											return { args: args, closedTag: true };
										case _:
											throw 'Oops';
									}
								case 0:
									if (gt([s.args.valueq]) == -1) throw 'Oops';
									args[n] = parse(str(), s);

								case _:
									throw 'Oops';
							}
						case 1:
							args[str()] = null;
						case 2:
							args[str()] = null;
							if (gt([s.end]) == -1)
								throw 'Oops';
						case 3:
							args[str()] = null;
							if (s.args.end != '') throw 'Oops';
							break;
						case 4:
							args[str()] = null;
							if (s.args.end != '') throw 'Oops';
							return { args: args, closedTag: true };
						case _:
							throw 'Oops';
					}
				case 0:
					if (gt([s.end]) == -1) throw 'Oops';
					break;
				case 1:
					if (s.args.end != '') throw 'Oops';
					break;
				case 2:
					return { args: args, closedTag: true };
			}
		}
		return { args: args, closedTag: false };
	}

	private function tagContent(name: String): TplData {
		beginContent();
		searchOpen(true);
		closeTag(name);
		final d: TplData = data;
		endContent();
		return d;
	}

	private function closeTag(name: String): Void {
		if (gt([s.closeBegin]) == -1) throw 'Tag ' + name + ' is not closed';
		data.push(Text(str()));
		skipSpace();
		if (gt([s.closeEnd]) == -1) throw 'Tag ' + name + ' is not closed';
		if (s.space) {
			if (str().trim() != name) throw 'Close tag ' + str().trim() + ', but close tag has be ' + name;
		} else if (str() != name)
			throw 'Close tag ' + str() + ', but close tag has be ' + name;
	}

	private function openPos(): Int {
		gt([s.begin, s.shortBegin]);
		final p: Int = pos - lengthGoto;
		pos = beforeGoto;
		return p;
	}

	private function closePos(): Int {
		gt([s.closeBegin]);
		final p: Int = pos - lengthGoto;
		pos = beforeGoto;
		return p;
	}

}
