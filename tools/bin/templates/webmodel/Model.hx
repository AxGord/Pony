package models;

import pony.db.DBV;
import pony.net.http.modules.mmodels.Model;
import pony.net.http.modules.mmodels.ModelConnect;
import pony.net.http.modules.mmodels.Field;
import pony.net.http.modules.mmodels.fields.FString;
import pony.tests.Errors;

@:enum abstract ::NAME::Fields(String) to String {

	var ID = 'id';
	var NAME = 'name';

}

@:enum abstract ValidateErrors(String) to String {

	var EMPTY = 'Empty';
	var SHORT = 'Is short';
	var LONG = 'Is long';

}

@:keep class ::NAME:: extends Model {

	public static var NAME_MIN: Int = 3;
	public static var NAME_MAX: Int = 60;

	private static var fields: Dynamic<Field> = {
		name: new FString(NAME_MAX)
	};

}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
@:keep class ::NAME::Connect extends ModelConnect {

	@:async function many(): Array<Dynamic> return @await db.select(ID, NAME).asc(NAME).get();

	@:path(['rm::name::'])
	@:async function single(id: Int): Dynamic return @await db.where(id == $id).first();

	@:async function insert(name: String): Bool {
		var t: Dynamic = @await db.where(name == $name).first();
		if (t != null)
			return false;
		else
			return @await db.insert([
				NAME => (name: DBV)
			]);
	}

	@:async function delete(id: Int): Bool return @await db.where(id == $id).delete();

	function validate(name: String): Errors {
		var e: Errors = new Errors();
		e.arg = NAME;
		e.test(name == '', EMPTY);
		e.test(name.length < ::NAME::.NAME_MIN, SHORT);
		e.test(name.length > ::NAME::.NAME_MAX, LONG);
		return e;
	}

}