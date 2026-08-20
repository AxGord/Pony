package pony.net.http.modules.mmodels.actions;

import pony.net.http.modules.mmodels.Action;
import pony.net.http.WebServer;
import pony.Pair;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.Valuator;

using pony.Tools;

/**
 * Single
 * @author AxGord <axgord@gmail.com>
 */
class Single extends Action {

	override public function connect(cpq: CPQ, modelConnect: ModelConnect): Pair<EConnect, ISubActionConnect> {
		return new Pair(REG(cast new SingleConnect(this, cpq, modelConnect)), null);
	}

}

/**
 * SingleConnect
 * @author AxGord <axgord@gmail.com>
 */
class SingleConnect extends ActionConnect {

	override public function tpl(parent: ITplPut): ITplPut {
		initTpl();
		return new SinglePut(this, cpq, parent);
	}

}

/**
 * SinglePut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
final class SinglePut extends pony.text.tpl.TplPut<SingleConnect, CPQ> {

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		if (Std.is(kid, SinglePutSub)) return @await parent.tag(name, content, arg, args, kid);
		if (!a.checkAccess()) return '';
		var mp: ModelPut = cast parent;
		final f = arg == null ? 'id' : arg;
		final v: String = mp.b == null ? null : Reflect.field(mp.b, f);
		final cargs: Array<String> = if (a.hasPathArg)
			(v == null ? [a.pathQuery] : [v])
		else if (v == null)
			[] else
			[v];
		final a: Dynamic = @await a.call(cargs);
		return if (args.exists('!'))
			a == null ? @await mp.tplData(content) : ''
		else if (a == null)
			''
		else if (args.exists('div'))
			@await div(arg, args, a)
		else
			@await sub(this, a, SinglePutSub, content);
	}

	@:async
	private function div(arg: String, args: Map<String, String>, e: Dynamic): String {
		final n: String = args['div'] == null ? 'single' : args['div'];
		final na: Array<String> = [];
		if (args.exists('cols')) {
			var s: String = '<div class="$n">';
			for (f in args['cols'].split(',').map(StringTools.trim)) s += '<div class="' + f + '">' + @await html(e, f) + '</div>';
			s += '</div>';
			na.push(s);
		} else {
			var s: String = '<div class="$n">';
			for (f in Reflect.fields(e)) s += '<div class="' + f + '">' + @await html(e, f) + '</div>';
			s += '</div>';
			na.push(s);
		}
		return na.join(arg == null ? '' : arg);
	}

	@:async
	private function html(e: Dynamic, f: String): String {
		final c = a.base.model.columns[f];
		if (c.tplPut == null) return Reflect.field(e, f);
		final o: Dynamic = Type.createInstance(c.tplPut, [c, e, this]);
		return @await o.html(f);
	}

}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class SinglePutSub extends Valuator<SinglePut, Dynamic> {

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		if (a.a.model.subactions.exists(name)) {
			return @await a.a.model.subactions[name].subtpl(parent, b).tag(name, content, arg, args, kid);
		}
		final c = a.a.base.model.columns[name];
		if (c == null || c.tplPut == null) return @await super1_tag(name, content, arg, args, kid);
		final o = Type.createInstance(c.tplPut, [c, b, this]);
		return @await o.tag(name, content, arg, args, kid);
	}

	@:async
	override public function shortTag(name: String, arg: String, ?kid: ITplPut): String {
		if (a.a.model.subactions.exists(name)) {
			return @await a.a.model.subactions[name].subtpl(parent, b).shortTag(name, arg, kid);
		}
		final c = a.a.base.model.columns[name];
		if (c == null || c.tplPut == null) return @await super1_shortTag(name, arg, kid);
		final o = Type.createInstance(c.tplPut, [c, b, this]);
		return @await o.shortTag(name, arg, kid);
	}

	@:async
	override public function valu(name: String, arg: String): String {
		return Reflect.hasField(b, name) ? '${Reflect.field(b, name)}' : null;
	}

}
