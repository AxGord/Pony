package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import pony.text.TextTools;

using pony.macro.Tools;
#end

/**
 * HasLinkBuilder
 * @author AxGord <axgord@gmail.com>
 */
class HasLinkBuilder {
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		for (field in fields) {
			switch field.kind {
				case FProp(get, set, type, expr) if (get == 'link' || set == 'link'):

					if (get == 'link') {
						get = 'get';
						
						var access = [AInline, APrivate];
						if (field.access.indexOf(AStatic) != -1)
							access.push(AStatic);
						fields.push({
							name: 'get_' + field.name,
							access: access,
							kind: FFun({
								args: [],
								ret: type,
								expr: macro return ${ expr }
							}),
							pos: field.pos,
							#if (js||flash) //for interfaces work only js or flash
							meta: [ { name:':extern', pos: field.pos } ]
							#end
						});
					}

					if (set == 'link') {
						set = 'set';
						
						var access = [AInline, APrivate];
						if (field.access.indexOf(AStatic) != -1)
							access.push(AStatic);
						fields.push({
							name: 'set_' + field.name,
							access: access,
							kind: FFun({
								args: [{name: 'v', type: type}],
								ret: type,
								expr: macro return ${ expr } = v
							}),
							pos: field.pos,
							#if (js||flash) //for interfaces work only js or flash
							meta: [ { name:':extern', pos: field.pos } ]
							#end
						});
					}

					field.kind = FProp(get, set, type);

				case _:
			}
		}
		return fields;
	}
}