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
package pony.net.rpc;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Compiler;
import haxe.xml.Fast;
import sys.io.File;
import pony.text.XmlConfigReader;
import pony.text.XmlTools;
using pony.macro.Tools;
using Lambda;
#end

/**
 * IRPC - Remove Procedure Call Build System
 * -lib hxbit
 * use with RPC
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.net.rpc.IRPC.RPCBuilder.build())
#end
interface IRPC
#if !macro
extends hxbit.Serializable
#end
{
	private function send():Void;
	public function checkRemoteCalls():Void;
}

class RPCBuilder {

	macro public static function build():Array<Field> {
		var smeta = [{name: ':s', pos: Context.currentPos()}];
		var fields:Array<Field> = Context.getBuildFields();
		var checks:Array<String> = [];

		//function reg(name:String)

		var tonew:Array<Expr> = [];

		for (field in fields) {
			if (field.meta.checkMeta([':sub'])) switch field.kind {

				case FieldType.FVar(TPath(t)):
					
					var n = field.name;
					var sn = 'on' + pony.text.TextTools.bigFirst(n);

					fields.push({
						name: sn,
						access: [APrivate],
						pos: Context.currentPos(),
						kind: FVar(macro:Signal1<Bytes>),
						meta: [{name: ':rpc', pos: Context.currentPos()}]
					});

					var en:Expr = {expr: ENew(t, []), pos: Context.currentPos()};
					tonew.push( macro $i{n} = ${en} );
					tonew.push( macro $i{n}.onData << $i{n + 'Remote'});
					tonew.push( macro $i{sn} << $i{n}.data);

				case _:

			}
		}

		var newf:Function = null;

		for (field in fields) {
			switch field.kind {
				case FieldType.FFun(f) if (field.name == 'new'):
					newf = f;
				case _:
			}

			if (field.meta.checkMeta([':rpc'])) switch field.kind {

				case FieldType.FVar(t):

					field.meta = [{name:':auto',pos:Context.currentPos()}];
					var n = field.name;
					var flagName = n + 'RemoteCall';
					fields.push({
						name: flagName,
						access: [APrivate],
						pos: Context.currentPos(),
						kind: FVar(macro:Bool, macro false),
						meta: smeta
					});

					var args:Array<ComplexType> = [];
					switch t {
						case TPath(p):
							for (param in p.params) {
								switch param {
									case TPType(t):
										args.push(t);
									case _:
								}
							}
						case _:
							throw 'error';
					}

					for (arg in 0...args.length) {
						fields.push({
							name: n + '_' + arg,
							access: [APrivate],
							pos: Context.currentPos(),
							kind: FVar(args[arg]),
							meta: smeta
						});
					}

					var nf = n.substr(0, 2);
					var en = 'e' + (nf == 'on' ? n.substr(2) : pony.text.TextTools.bigFirst(n));
					
					{
						var rn = nf == 'on' ? n.charAt(2).toLowerCase() + n.substr(3) : n;
						var ae:Array<Expr> = [macro $i{flagName} = true];
						for (arg in 0...args.length)
							ae.push(macro $i{n + '_' + arg} = $i{'arg'+arg});
						ae.push(macro send());
						for (arg in 0...args.length)
							ae.push(macro $i{n + '_' + arg} = null);
						ae.push(macro $i{flagName} = false);
						fields.push({
							name: rn + 'Remote',
							access: [APublic],
							pos: Context.currentPos(),
							kind: FFun({
								args: [for (arg in 0...args.length) {name: 'arg$arg', type: args[arg]}],
								ret: macro:Void,
								expr: {expr: EBlock(ae), pos: Context.currentPos()}
							})
						});
					}
					{
						var rc:Array<Expr> = [macro $i{flagName} = false];
						var ca:Array<Expr> = [];
						for (arg in 0...args.length) {
							rc.push({expr: EVars([{
								name: 'arg$arg',
								type: args[arg],
								expr: macro $i{n + '_' + arg}
							}]), pos: Context.currentPos()});
							rc.push(macro $i{n + '_' + arg} = null);
							ca.push(macro $i{'arg$arg'});
						}

						rc.push({expr: ECall(macro $i{en}.dispatch, [for (arg in 0...args.length) macro $i{'arg$arg'}]), pos: Context.currentPos()});
						var bl = {expr: EBlock(rc), pos: Context.currentPos()};
						
						var chname = n + 'RemoteCheck';
						fields.push({
							name: chname,
							access: [APrivate, AInline],
							pos: Context.currentPos(),
							kind: FFun({
								args: [],
								ret: macro:Void,
								expr: macro if ($i{flagName}) $bl
							}),
							meta: [{name: ':extern', pos: Context.currentPos()}]
						});

						checks.push(chname);
					}

				case FieldType.FFun(f) if (field.meta.checkMeta([':rpc'])):
					var n = field.name;
					var flagName = n + 'RemoteCall';
					fields.push({
						name: flagName,
						access: [APrivate],
						pos: Context.currentPos(),
						kind: FVar(macro:Bool, macro false),
						meta: smeta
					});

					for (arg in f.args) {
						fields.push({
							name: n + '_' + arg.name,
							access: [APrivate],
							pos: Context.currentPos(),
							kind: FVar(arg.type),
							meta: smeta
						});
					}

					{
						var ae:Array<Expr> = [macro $i{flagName} = true];
						for (arg in f.args)
							ae.push(macro $i{n + '_' + arg.name} = $i{arg.name});
						ae.push(macro send());
						for (arg in f.args)
							ae.push(macro $i{n + '_' + arg.name} = null);
						ae.push(macro $i{flagName} = false);
						fields.push({
							name: n + 'Remote',
							access: [APublic],
							pos: Context.currentPos(),
							kind: FFun({
								args: f.args,
								ret: f.ret,
								expr: {expr: EBlock(ae), pos: Context.currentPos()}
							})
						});
					}
					{
						var rc:Array<Expr> = [macro $i{flagName} = false];
						var ca:Array<Expr> = [];
						for (arg in f.args) {
							rc.push({expr: EVars([{
								name: arg.name,
								type: arg.type,
								expr: macro $i{n + '_' + arg.name}
							}]), pos: Context.currentPos()});
							rc.push(macro $i{n + '_' + arg.name} = null);
							ca.push(macro $i{arg.name});
						}
						rc.push({expr: ECall(macro $i{n}, ca), pos: Context.currentPos()});
						var bl = {expr: EBlock(rc), pos: Context.currentPos()};
						
						var chname = n + 'RemoteCheck';
						fields.push({
							name: chname,
							access: [APrivate, AInline],
							pos: Context.currentPos(),
							kind: FFun({
								args: [],
								ret: macro:Void,
								expr: macro if ($i{flagName}) $bl
							}),
							meta: [{name: ':extern', pos: Context.currentPos()}]
						});

						checks.push(chname);
					}
				case _:
			}
		}

		fields.push({
			name: 'checkRemoteCalls',
			access: [APublic],
			pos: Context.currentPos(),
			kind: FFun({
				args: [],
				ret: macro:Void,
				expr: {expr: EBlock([for (ch in checks) macro $i{ch}()]), pos: Context.currentPos()}
			})
		});

		if (tonew.length > 0) {
			if (newf == null) {
				newf = {
					args: [{name: 'socket', type: macro:pony.net.INet}],
					expr: macro super(socket),
					ret: null
				};
				fields.push({
					name: 'new',
					access: [APublic],
					kind: FFun(newf),
					pos: Context.currentPos()
				});
			}
			tonew.unshift(newf.expr);
			newf.expr = {expr: EBlock(tonew), pos: Context.currentPos()};
		}

		return fields;
	}

}