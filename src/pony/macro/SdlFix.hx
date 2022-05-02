package pony.macro;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;

/**
 * GL C generation error fix
 * @author AxGord <axgord@gmail.com>s
 */
@:nullSafety(Strict) class SdlFix {

	public static function build(): Array<Field> {
		final fields: Array<Field> = Context.getBuildFields();
		for (field in fields) if (field.meta != null) {
			for (meta in field.meta) if (meta.name == ':hlNative' && meta.params != null && meta.params.length > 0) {
				switch meta.params[0].expr {
					case EConst(CString(s, k)) if (s.startsWith('?')):
						meta.params[0] = macro $v{s.substr(1)};
					case _:
				}
			}
		}
		return fields;
	}

}

#end