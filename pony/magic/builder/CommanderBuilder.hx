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
package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.xml.Fast;
import sys.io.File;
import pony.text.TextTools;
import pony.time.Time;
import pony.Pair;

using Lambda;
using pony.macro.Tools;
#end

/**
 * CommanderBuilder
 * @author AxGord <axgord@gmail.com>
 */
class CommanderBuilder {

	private static inline var DEFAULT_FILE:String = 'commands.xml';

	macro public static function build():Array<Field> {
		var file:String = DEFAULT_FILE;

		try {
			switch Context.getLocalClass().get().meta.extract(':file')[0].params[0].expr {
				case EConst(CString(v)): file = v;
				case _:
			}
		} catch (_:Any) {}

		Context.registerModuleDependency(Context.getLocalModule(), file);
		var fields:Array<Field> = Context.getBuildFields();

		var help:Array<String> = [];

		var cases:Array<Case> = [];

		var xml:Fast = new Fast(Xml.parse(File.getContent(file)));
		for (x in xml.node.commands.elements) {
			var cmd:String = x.name.toLowerCase();
			var h:String = getHelp(x);
			var bcmd:String = pony.text.TextTools.bigFirst(cmd);

			if (x.nodes.arg.length > 0) {
				h = h == null ? '' : h + '.\n\t';
				h += 'Arguments:\n\t\t' + [for (a in x.nodes.arg) getHelp(a)].join('\n\t\t');
			}

			if (h != null) {
				var shelp = '';
				if (x.nodes.syn.length > 0)
					shelp = '(' + [for (s in x.nodes.syn) StringTools.trim(s.innerData)].join(', ') + ') ';
				help.push(cmd + ' ' + shelp + '\n\t' + h);
			}

			var ed:String = 'e' + bcmd;

			var values:Array<Expr> = [macro $v{cmd}];

			if (cmd == 'nothing') values.push(macro null);

			for (s in x.nodes.syn) values.push(macro $v{s.innerData});

			cases.push({
				values: values,
				expr: switch x.nodes.arg.length {
					case 0: macro $i{ed}.dispatch();
					case 1: macro $i{ed}.dispatch(args != null ? args[0] : null);
					case 2: macro args != null ? $i{ed}.dispatch(args[0], args[1]) : $i{ed}.dispatch(null, null);
					case _: macro args != null ? $i{ed}.dispatch(args.shift(), args) : $i{ed}.dispatch(null, null);
				}
			});

			var signalType:ComplexType = switch x.nodes.arg.length {
				case 0: macro:pony.events.Signal0;
				case 1: macro:pony.events.Signal1<String>;
				case 2: macro:pony.events.Signal2<String, String>;
				case _: macro:pony.events.Signal2<String, Array<String>>;
			}

			fields.push({
				name: 'on' + bcmd,
				access: [APublic],
				pos: Context.currentPos(),
				kind: FVar(signalType),
				meta: [{name: ':auto', pos: Context.currentPos()}],
				doc: h
			});

			var args:Array<FunctionArg> = switch x.nodes.arg.length {
				case 0: [];
				case 1: [{name: 'arg1', type: macro:String}];
				case 2: [{name: 'arg1', type: macro:String}, {name: 'arg2', type: macro:String}];
				case _: [{name: 'arg1', type: macro:String}, {name: 'argN', type: macro:Array<String>}];
			}

			var cbody:Expr = switch x.nodes.arg.length {
				case 0: macro $i{ed}.dispatch();
				case 1: macro $i{ed}.dispatch(arg1);
				case 2: macro $i{ed}.dispatch(arg1, arg2);
				case _: macro $i{ed}.dispatch(arg1, argN);
			}

			fields.push({
				name: cmd,
				access: [APublic, AInline],
				pos: Context.currentPos(),
				kind: FFun({
					args: args,
					ret: macro:Void,
					expr: cbody
				}),
				doc: h
			});
		}

		var body:ExprDef = ESwitch(macro cmd, cases, macro error('Unknown command: ' + cmd));

		fields.push({
			name: 'runCommand',
			access: [APublic, AOverride],
			pos: Context.currentPos(),
			kind: FFun({
				args: [
					{name: 'cmd', type: macro:String},
					{name: 'args', type: macro:Array<String>, opt: true}
				],
				ret: macro:Void,
				expr: {expr: body, pos: Context.currentPos()}
			})
		});

		fields.push({
			name: 'helpData',
			access: [APublic],
			pos: Context.currentPos(),
			kind: FProp('default', 'never', macro:Array<String>, macro $v{help})
		});

		return fields;
	}

	#if macro
	private static function getHelp(x:Fast):String {
		return try StringTools.trim(x.hasNode.help ? x.node.help.innerData : x.innerData) catch (_:Any) null;
	}
	#end

}