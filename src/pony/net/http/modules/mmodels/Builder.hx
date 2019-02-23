package pony.net.http.modules.mmodels;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using pony.text.TextTools;
using Lambda;
#end

/**
 * Builder
 * @author AxGord <axgord@gmail.com>
 */
class Builder {
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var cur = Context.getLocalClass().get();
		if (cur.name == 'Model') return fields;
		for (f in fields) switch (f.name) {
			case 'many', 'insert', 'single', 'update', 'delete':
				if (!f.meta.exists(function(m) return m.name == 'action'))
					f.meta.push( { pos: Context.currentPos(), name: 'action', params: [{expr: EConst(CString(f.name.bigFirst())), pos: Context.currentPos()}] } );
			/*case 'manyAsync', 'insertAsync':
				var n:String = f.name.substr(0, f.name.length - 5).bigFirst();
				if (!f.meta.exists(function(m) return m.name == 'action'))
					f.meta.push( { pos: Context.currentPos(), name: 'action', params: [EConst(CString(n)).expr()] } );*/
		}
		var pathes:Array<ObjectField> = [];
		var activePathes:Array<ObjectField> = [];
		var acc:Array<ObjectField> = [];
		var data:Array<ObjectField> = [];
		for (f in fields) {
			for (m in f.meta) {
				switch m.name {
					case ':path':
						pathes.push({field:f.name, expr: m.params[0]});
					case ':activePath':
						activePathes.push(
							{field:f.name, expr: {expr: EObjectDecl([
									{field: 'path', expr: m.params[0]},
									{field: 'field', expr: m.params[1]}
							]), pos: Context.currentPos()}}
						);
					case 'action':
						var d:Array<Expr> = [];
						switch f.kind {
							case FFun(fun): for (a in fun.args)
								switch a.type {
									case TPath(p):
										d.push({expr: EObjectDecl([
												{field: 'name', expr: {expr: EConst(CString(a.name)), pos: Context.currentPos()}},
												{field: 'type', expr: {expr: EConst(CString(p.name)), pos: Context.currentPos()}}
										]), pos: Context.currentPos()});
									case _: throw 'Error';
								}
							case _: throw 'Error';
						}
						data.push({field: f.name, expr: {expr: EArrayDecl(d), pos: Context.currentPos()}});
					case ':check':
						acc.push(
							{field:f.name, expr: macro $v{switch m.params[0].expr {
								case EConst(CIdent(s)): s;
								case _: throw 'error';
							}}}
						);
				}
				
			}
		}

		fields.push( {
			pos: Context.currentPos(),
			name: '__methoArgs__',
			meta: [],
			doc: null,
			access: [AStatic, APrivate],
			kind: FVar(null, {expr: EObjectDecl(data), pos: Context.currentPos()})
		});
		
		fields.push( {
			pos: Context.currentPos(),
			name: '__methoPathes__',
			meta: [],
			doc: null,
			access: [AStatic, APublic],
			kind: FVar(null, {expr: EObjectDecl(pathes), pos: Context.currentPos()})
		});
		
		fields.push( {
			pos: Context.currentPos(),
			name: '__methoActivePathes__',
			meta: [],
			doc: null,
			access: [AStatic, APublic],
			kind: FVar(null, {expr: EObjectDecl(activePathes), pos: Context.currentPos()})
		});
		
		fields.push( {
			pos: Context.currentPos(),
			name: '__methoAccess__',
			meta: [],
			doc: null,
			access: [AStatic, APublic],
			kind: FVar(null, {expr: EObjectDecl(acc), pos: Context.currentPos()})
		});
		
		return fields;
	}
	
}