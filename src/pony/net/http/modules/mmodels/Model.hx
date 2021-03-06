package pony.net.http.modules.mmodels;

import haxe.rtti.Meta;
import pony.db.mysql.Field;
import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.db.Table;
import pony.net.http.CPQ;
import pony.net.http.WebServer.EConnect;
import pony.Pair;
import pony.net.http.modules.mmodels.fields.FInt;
import pony.magic.SuperPuper;

using pony.Tools;
using Lambda;

enum ActResult {
	OK; ERROR(e:Map<String, String>); DBERROR;
}

/**
 * Model
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class Model implements SuperPuper {
	public var lang:String;
	public var mm:MModels;
	public var name:String;
	public var columns:Map<String, pony.net.http.modules.mmodels.Field>;
	public var actions:Map<String, Action>;
	public var db:Table;
	public var cl:Class<ModelConnect>;
	public var pathes:Map<String, Array<String>>;
	public var activePathes:Map<String, {path:String, field:String}>;
	public var access:Map<String, String>;

	public function new(mm:MModels, actionsClasses:Map<String, Dynamic>) {
		lang = 'en';
		name = Type.getClassName(Type.getClass(this));
		name = name.substr(name.lastIndexOf('.') + 1);
		this.mm = mm;
		var n = Type.getClassName(Type.getClass(this)) + 'Connect';
		cl = cast Type.resolveClass(n);
		if (cl == null) throw "Can't resolve class (dce?): " + n;
		var ma:Dynamic<Array<{name: String, type: String}>> = untyped cl.__methoArgs__;

		var o = untyped cl.__methoPathes__;
		var o2 = untyped cl.__methoActivePathes__;
		pathes = [for (f in Reflect.fields(o)) f => Reflect.field(o, f)];
		activePathes = [for (f in Reflect.fields(o2)) f => Reflect.field(o2, f)];

		var o = untyped cl.__methoAccess__;
		access = [for (f in Reflect.fields(o)) f => Reflect.field(o, f)];

		actions = new Map<String, Action>();
		var fields:Dynamic = Meta.getFields(cl);
		for (f in Reflect.fields(fields)) {
			var ff:Dynamic = Reflect.field(fields, f);
			for (sf in Reflect.fields(ff))
				if (sf == 'action') {
					actions.set(f, Type.createInstance(actionsClasses.get(Reflect.field(ff, sf)[0]), [this, f, Reflect.field(ma, f)]));
				}
		}
		columns = new Map < String, pony.net.http.modules.mmodels.Field > ();
		columns['id'] = new FInt(10, true);
		columns['id'].model = this;
		columns['id'].name = 'id';
		var cs = untyped Type.getClass(this).fields;
		for (f in Reflect.fields(cs)) {
			var c:pony.net.http.modules.mmodels.Field = Reflect.field(cs, f);
			c.init(f, this);
			columns.set(f, c);
		}

		db = mm.db.resolve(name);

		init();
	}

	private function init():Void {

	}

	@:async @:puper
	public function prepare():Bool {
		var a:Array<Field> = [
			{name: 'id', type: Types.INT, flags: [Flags.UNSIGNED, Flags.NOT_NULL, Flags.PRI_KEY, Flags.AUTO_INCREMENT]}
		];
		for (c in columns.kv()) if (c.key != 'id') a.push(c.value.create());
		return @await db.prepare(a);
	}

	/*
	public function update():Void {
		db.describeAsync(function(r:Stream<DBDescribe>) {

			var f:Void->Void = null;
			f = function() {
				db.backup();
				f = function() { };
			};

			var el:List<String> = new List<String>();

			for (e in r)
				if (e.Field == 'id')
					el.push('id');
				else if (columns.exists(e.Field)) {
					el.push(e.Field);
				} else {
					f();
					db.dropColumn(e.Field);
				}

			if (el.indexOf('id') == -1) {
				f();
				db.addColumn('id', 'INT NOT NULL AUTO_INCREMENT PRIMARY KEY');
			}
			for (c in columns) {
				if (el.indexOf(c.name) == -1) {
					f();
					db.addColumn(c.name, c.create());
				}
			}
		}, err);
	}
	*/
	public static function err(e:Dynamic):Void {
		throw e;
	}

	public function connect(cpq:CPQ):EConnect {
		var mc:ModelConnect = Type.createInstance(cl, [this, cpq]);
		var a = new Map<String, ActionConnect>();
		var sub = new Map<String, ISubActionConnect>();
		for (k in actions.keys()) {
			var r = actions[k].connect(cpq, mc);
			if (r.b != null) sub[k] = r.b;
			switch r.a {
				case BREAK: return BREAK;
				case REG(obj): a[k] = cast obj;
				case NOTREG:
			}
		}
		mc.actions = a;
		mc.subactions = sub;
		return REG(cast mc);
	}

	inline public static function dbr(r:Bool):ActResult return r ? OK : DBERROR;

}