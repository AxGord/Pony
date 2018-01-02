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
package pony.text.tpl;

import pony.text.ParseBoy;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData;

using StringTools;
using pony.Tools;

/**
 * Tpl parser
 * @author AxGord
 */
class Parse extends ParseBoy<TplContent>
{
	
	public static var VAR_SYMBOLS:String = 'qwertyuiopasdfghjklzxcvbnm1234567890-';
	
	public static function parse(t:String, s:TplStyle):TplData {
		var o:Parse = new Parse(t, s);
		return o.data;
	}
	
	private var s:TplStyle;

	public function new(t:String, s:TplStyle)
	{
		/////
		/* todo:
		{type: TplData, content: ParseEnum([
			{type: TplTag, content: ParseType([
				'<_',
				{type: TplTagName, content: ParseAll() },
				[
					['="', { type: TplData, content: ParseRecursive() }, '"'],
					['=', { type: TplData, content: ParseRecursive() } ]
				],
				[' ', { type: Hash<TplData>, content: ParseHash(' ', {type: String, ParseAll()}, '=', {type: TplData, ParseQ(ParseRecursive(), '"')}) } ],
				'/>'
			]) },
			{type: TplShortTag, content: ParseType([
				'%', {type: TplTagName, content: ParseAll()}, ['=', {type: TplData, content: ParseQ(ParseRecursive(), '"')}], '%'
			]) },
			{type: String, content: ParseAll()}
		])};
		*/
		////
		this.s = s;
		super(t, s.space);
		searchOpen();
	}
	
	private function searchOpen(closed:Bool = false):Void {
		
		//BEGIN CHECK VARS
		gt([s.shortBegin]);
		var p_sh = pos;
		pos = beforeGoto;
		gt([s.begin]);
		var p_nrml = pos;
		pos = beforeGoto;
		
		if (p_sh < p_nrml) {
			var bef = pos;
			pos = p_sh;
			switch gt([s.args.set, s.shortEnd]) {
				case 0:
					var r:Bool = false;
					var name = StringTools.trim(str());
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
					var r:Bool = false;
					var name = StringTools.trim(str());
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
		//END CHECK VARS
		
		var o:Int = openPos(), c:Int = closePos();
				
		if (o >= c) {
			if (o == c) {
				if (closed)
					throw 'Not closed tag';
				pushEndText();
				return;
			}
			else {
				if (closed) return;
				//push(Text(t.substr(pos, (t.length - pos) - (t.length - o))));
				//pos = o;
				gt([s.closeEnd]);
				throw 'Closed not opened tag ['+t.substr(c, pos-c)+']';
			}
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
						data.push(ShortTag( { name: parseName(str()), arg: null } ));
					case 1:
						var name:String = str();
						switch (gt([s.shortEnd, s.args.valueq])) {
							case 0:
								if (s.args.qalltime)
									throw '["] - not found';
								data.push(ShortTag( { name: parseName(name), arg: parse(str(), s) } ));
							case 1:
								if (gt([s.args.valueq]) == -1)
									throw '["] - not closed';
								data.push(ShortTag( { name: parseName(name), arg: parse(str(), s) } ));
								if (gt([s.shortEnd]) == -1)
									throw 'Oops';
							default: 
								throw 'Oops';
						}
					default:
						throw 'Oops';
				}
				searchOpen(closed);
			default:
		}
		
	}
	
	private function pushText():Void {
		var t:String = str();
		if (t != '')
			data.push(Text(t));
	}
	
	private function pushEndText():Void {
		var t:String = t.substr(pos);
		if (t != '')
			data.push(Text(t));
	}
	
	private function parseName(n:String): TplTagName {
		var lvl:Int = 0;
		var i:Int = -1;
		while (++i < n.length) {
			var c:String = n.charAt(i);
			if (c == s.up)
				lvl++;
			else if (s.space && c == ' ')
				continue;
			else
				break;
		}
		var a:Array<String> = n.substr(i).split(s.group);
		if (s.space)
			a = a.map(StringTools.trim);
		return {up: lvl, name: a};
	}
	
	private inline function tag():Bool {
		var result:Bool = false;
		skipSpace();
		switch (gt([s.end, s.endClose, s.args.begin, s.args.set])) {
			case 0:
				var name:String = str();
				var d:TplData = tagContent(name);
				data.push(Tag({name: parseName(name), arg: null, args: new Map<String, TplData>(), content: d}));
				result = true;
			case 1:
				data.push(Tag({name: parseName(str()), arg: null, args: new Map<String, TplData>(), content: null}));
				result = true;
			case 2:
				var name:String = str();
				var a: { args: Map<String, TplData>, closedTag: Bool } = args();
				var d:TplData = a.closedTag ? null : tagContent(name);
				data.push(Tag( { name: parseName(name), arg: null, args: a.args, content: d } ));
			case 3:
				var name:String = str();
				switch (gt([s.end, s.endClose, s.args.valueq], true)) {
					case -2:
						switch (gt([s.end, s.endClose, s.args.begin])) {
							case 0:
								var arg:TplData = parse(str(), s);
								var d:TplData = tagContent(name);
								data.push(Tag( { name: parseName(name), arg: arg, args: new Map<String, TplData>(), content: d } ));
							case 1:
								var arg:TplData = parse(str(), s);
								data.push(Tag( { name: parseName(name), arg: arg, args: new Map<String, TplData>(), content: null } ));
							case 2:
								var arg:TplData = parse(str(), s);
								var a: { args: Map<String, TplData>, closedTag: Bool } = args();
								var d:TplData = a.closedTag ? null : tagContent(name);
								data.push(Tag( { name: parseName(name), arg: arg, args: a.args, content: d } ));
							default: throw 'Oops';
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
						if (gt([s.args.valueq]) == -1)
							throw '["] - not closed';
						var arg:TplData = parse(str(), s);
						switch (gt([s.end, s.endClose, s.args.begin])) {
							case 0:
								var d:TplData = tagContent(name);
								data.push(Tag( { name: parseName(name), arg: arg, args: new Map<String, TplData>(), content: d } ));
							case 1:
								data.push(Tag( { name: parseName(name), arg: arg, args: new Map<String, TplData>(), content: null } ));
							case 2:
								var a: { args: Map<String, TplData>, closedTag: Bool } = args();
								var d:TplData = a.closedTag ? null : tagContent(name);
								data.push(Tag( { name: parseName(name), arg: arg, args: a.args, content: d } ));
							default: throw 'Oops';
						}
					default: throw 'Oops';
				}
				result = true;
			default:
				trace('end tag');
		}
		return result;
	}
	
	private function args():{args: Map<String, TplData>, closedTag: Bool} {
		var args:Map<String, TplData> = new Map<String, TplData>();
		while (true) {
			switch (gt([s.args.end, s.end, s.endClose], true)) {
				case -2:
					switch (gt([s.args.set, s.args.delemiter, s.args.end, s.end, s.endClose])) {
						case 0:
							var n:String = str();
							switch (gt([s.args.valueq], true)) {
								case -2:
									switch (gt([s.args.delemiter, s.end, s.args.end, s.endClose])) {
										case 0:
											args.set(n, parse(str(), s));
										case 1:
											args.set(n, parse(str(), s));
											if (s.args.end != '') throw 'Oops';
											break;
										case 2:
											args.set(n, parse(str(), s));
											if (gt([s.args.valueq]) == -1) throw 'Oops';
										case 3:
											args.set(n, parse(str(), s));
											return { args: args, closedTag: true };
										default: throw 'Oops';
									}
								case 0:
									if (gt([s.args.valueq]) == -1) throw 'Oops';
									args.set(n, parse(str(), s));
									
								default: throw 'Oops';
							}
						case 1:
							args.set(str(), null);
						case 2:
							args.set(str(), null);
							if (gt([s.end]) == -1) throw 'Oops';
						case 3:
							args.set(str(), null);
							if (s.args.end != '') throw 'Oops';
							break;
						case 4:
							args.set(str(), null);
							if (s.args.end != '') throw 'Oops';
							return { args: args, closedTag: true };
						default: throw 'Oops';
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
	
	private function tagContent(name:String):TplData {
		beginContent();
			searchOpen(true);
			closeTag(name);
			var d:TplData = data;
		endContent();
		return d;
	}
	
	private function closeTag(name:String):Void {
		if (gt([s.closeBegin]) == -1)
			throw 'Tag ' + name + ' is not closed';
		data.push(Text(str()));
		skipSpace();
		if (gt([s.closeEnd]) == -1)
			throw 'Tag ' + name + ' is not closed';
		if (s.space) {
			if (str().trim() != name)
				throw 'Close tag ' + str().trim() + ', but close tag has be ' + name;
		} else {
			if (str() != name)
				throw 'Close tag ' + str() + ', but close tag has be ' + name;
		}
	}
	
	private function openPos():Int {
		gt([s.begin, s.shortBegin]);
		var p:Int = pos - lengthGoto;
		pos = beforeGoto;
		return p;
	}
	
	private function closePos():Int {
		gt([s.closeBegin]);
		var p:Int = pos-lengthGoto;
		pos = beforeGoto;
		return p;
	}
	
}