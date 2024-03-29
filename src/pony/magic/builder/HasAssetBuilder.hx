package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using Lambda;
using pony.macro.Tools;
#end

/**
 * HasAssetBuilder
 * @author AxGord <axgord@gmail.com>
 */
class HasAssetBuilder {

	macro public static function build(): Array<Field> {
		var keepMeta: MetadataEntry = { name: ':keep', pos: Context.currentPos() };
		var list: Array<Expr> = [];
		var names: Array<Expr> = [];
		var fields: Array<Field> = Context.getBuildFields();
		var cl: Null<Ref<ClassType>> = Context.getLocalClass();
		var meta: Metadata = cl.get().meta.get();
		var prefix: String = getPrefix(meta);
		for (f in fields) if (f.meta.checkMeta([':asset', 'asset'])) {
			if (f.access.indexOf(AStatic) == -1) Context.error('Asset can be only static', f.pos);
			switch f.kind {
				case FieldType.FVar(null, e):
					if (e == null) Context.error('Need value', f.pos);
					switch e.expr {
						case EConst(CString(s)):
							f.kind = FieldType.FVar(null, macro $v { list.length } );
							if (f.access.indexOf(AInline) == -1) f.access.push(AInline);
							list.push(e);
							if (f.meta.checkMeta([':asset'])) {
								if (f.meta.getMeta(':asset').params.length == 0)
									names.push(macro null);
								else if (f.meta.getMeta(':asset').params.length == 1)
									names.push({expr: EConst(CString(prefix + getAssetName(f.meta, true))), pos: f.pos});
								else
									Context.error('Wrong :asset format', f.pos);
							} else {
								if (f.meta.getMeta('asset').params.length == 0)
									names.push(macro null);
								else if (f.meta.getMeta('asset').params.length == 1)
									names.push({expr: EConst(CString(prefix + getAssetName(f.meta))), pos: f.pos});
								else
									Context.error('Wrong :asset format', f.pos);
							}
						case _:
							Context.error('Wrong value', f.pos);
					}
				case _:
					Context.error('Asset can be only string var', f.pos);
			}
		}
		var patchesFields: Map<String, String> = getPatches(meta, cl);
		if (patchesFields == null) Context.error('Wrong parent class', cl.get().pos);
		addBaseFields(fields, names, list, patchesFields);
		addBaseMethods(fields, cl);
		for (f in patchesFields.keys()) addMethods(fields, f, patchesFields[f]);
		return fields;
	}

	#if macro

	private static function addBaseFields(
		fields: Array<Field>, names: Array<Expr>, list: Array<Expr>, patchesFields: Map<String, String>
	): Void {
		var patches: Expr =  { expr: EArrayDecl([for (field in patchesFields) macro $v{field} ]), pos: Context.currentPos() };
		fields.push( {
				name: 'ASSETS_LIST',
				access: [APrivate, AStatic],
				kind: FieldType.FVar(macro:Array<String>, macro $a { list } ),
				pos: Context.currentPos()
			});
		fields.push( {
				name: 'ASSETS_NAMES',
				access: [APrivate, AStatic],
				kind: FieldType.FVar(macro:Array<Null<String>>, macro $a { names } ),
				pos: Context.currentPos()
			});
		fields.push( {
				name: 'ASSETS_PATHES',
				access: [APrivate, AStatic],
				kind: FieldType.FVar(macro: Array<String>, macro $patches ),
				pos: Context.currentPos()
			});
	}

	private static function addBaseMethods(fields: Array<Field>, cl: Null<Ref<ClassType>>): Void {
		var keepMeta: MetadataEntry = { name: ':keep', pos: Context.currentPos() };
		fields.push({
				name: 'loadAllAssets',
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
						args: [{ name: 'childs', type: macro: Bool, value: macro true }, { name: 'cb', type: macro: Int -> Int -> Void }],
						ret: macro: Void,
						expr:
							macro childs
							? pony.ui.AssetManager.loadPackWithChilds($v { cl.toString() }, ASSETS_PATHES, ASSETS_LIST, cb)
							: pony.ui.AssetManager.loadPack(ASSETS_PATHES, ASSETS_LIST, cb)
					}),
				pos: Context.currentPos(),
				meta: [keepMeta]
			});
		fields.push({
				name: 'countAllAssets',
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
						args: [{ name: 'childs', type: macro: Bool, value: macro true }],
						ret: macro:Int,
						expr:
							macro return childs
							? pony.ui.AssetManager.allCountWithChilds($v { cl.toString() }, ASSETS_PATHES, ASSETS_LIST)
							: pony.ui.AssetManager.allCount(ASSETS_PATHES, ASSETS_LIST)
					}),
				pos: Context.currentPos(),
				meta: [keepMeta]
			});
	}

	private static function addMethods(fields: Array<Field>, f: String, vs: String): Void {
		if (vs.length > 0) vs += '/';
		var v = macro $v{vs};
		fields.push({
				name: f == 'def' ? 'loadAsset' : 'loadAsset_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'asset', type: macro: pony.Or<Int, Array<Int>>, opt: false}, {name: 'cb', type: macro: Int -> Int -> Void}],
						ret: macro: Void,
						expr: macro pony.ui.AssetManager.load(
							$v,
							switch asset {
								case pony.Or.OrState.A(asset): ASSETS_LIST[asset];
								case pony.Or.OrState.B(assets): [for (asset in assets) ASSETS_LIST[asset]];
							},
							cb)
					}),
				pos: Context.currentPos()
			});
		fields.push({ //todo: childs
			name: f == 'def' ? 'loadAssets' : 'loadAssets_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{ name: 'cb', type: macro: Int -> Int -> Void }],
					ret: macro:Void,
					expr: macro pony.ui.AssetManager.load($v, ASSETS_LIST, cb)
				}),
			pos: Context.currentPos()
		});
		fields.push({
			name: f == 'def' ? 'asset' : 'asset_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{ name: 'asset', type: macro: Int }],
					ret: macro: String,
					expr: macro @:nullSafety(Off) return ASSETS_NAMES[asset] == null ? $v + ASSETS_LIST[asset] : ASSETS_NAMES[asset]
				}),
			pos: Context.currentPos()
		});

		fields.push({
			name: f == 'def' ? 'assetName' : 'assetName_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{ name: 'asset', type: macro: Int }],
					ret: macro: Null<String>,
					expr: macro return ASSETS_NAMES[asset]
				}),
			pos: Context.currentPos()
		});

		fields.push({
			name: f == 'def' ? 'assetValue' : 'assetValue_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: macro:String,
					expr: macro return $v + ASSETS_LIST[asset]
				}),
			pos: Context.currentPos()
		});
		fields.push({
			name: f == 'def' ? 'image' : 'image_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: null,
					expr: macro return pony.ui.AssetManager.image($v + ASSETS_LIST[asset], ASSETS_NAMES[asset])
				}),
			pos: Context.currentPos()
		});
		fields.push({
			name: f == 'def' ? 'spine' : 'spine_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: null,
					expr: macro return pony.ui.AssetManager.spine($v + ASSETS_LIST[asset])
				}),
			pos: Context.currentPos()
		});

		fields.push({
			name: f == 'def' ? 'sound' : 'sound_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: null,
					expr: macro return pony.ui.AssetManager.sound($v + ASSETS_LIST[asset])
				}),
			pos: Context.currentPos()
		});

		fields.push({
			name: f == 'def' ? 'getTexture' : 'getTexture_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: null,
					expr: macro return pony.ui.AssetManager.texture($v + ASSETS_LIST[asset], ASSETS_NAMES[asset])
				}),
			pos: Context.currentPos()
		});

		fields.push({
			name: f == 'def' ? 'font' : 'font_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: null,
					expr: macro return pony.ui.AssetManager.font($v + ASSETS_LIST[asset])
				}),
			pos: Context.currentPos()
		});

		fields.push({
			name: f == 'def' ? 'animation' : 'animation_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: null,
					expr: macro return pony.ui.AssetManager.animation($v + ASSETS_LIST[asset], ASSETS_NAMES[asset])
				}),
			pos: Context.currentPos()
		});

		fields.push({
			name: f == 'def' ? 'clip' : 'clip_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: null,
					expr: macro return pony.ui.AssetManager.clip($v + ASSETS_LIST[asset], ASSETS_NAMES[asset])
				}),
			pos: Context.currentPos()
		});

		fields.push({
			name: f == 'def' ? 'text' : 'text_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: null,
					expr: macro return pony.ui.AssetManager.text($v + ASSETS_LIST[asset])
				}),
			pos: Context.currentPos()
		});

		fields.push({
			name: f == 'def' ? 'bin' : 'bin_' + f,
			access: [APublic, AStatic],
			kind: FieldType.FFun( {
			args: [{name: 'asset', type:macro:Int}],
					ret: null,
					expr: macro return pony.ui.AssetManager.bin($v + ASSETS_LIST[asset])
				}),
			pos: Context.currentPos()
		});
	}

	private static function getPatches(meta: Metadata, clss: Ref<ClassType>): Map<String, String> {
		var parentPathes: Map<String, String> = null;
		if (meta.checkMeta([':assets_parent'])) {
			var parent: Expr = meta.getMeta(':assets_parent').params[0];
			switch parent.expr {
				case EConst(CIdent(s)):
					switch Context.getType(s) {
						case TInst(cl, _):
							var m = cl.get().meta;
							parentPathes = getPatches(m.get(), cl);
							var e = { expr: EConst(CString(clss.toString())), pos: Context.currentPos() };
							if (!m.has('assets_childs')) {
								m.add('assets_childs', [e], Context.currentPos());
							} else {
								var a = m.get().find(function(v) return v.name == 'assets_childs').params;
								a.push(e);
								m.remove('assets_childs');
								m.add('assets_childs', a, Context.currentPos());
							}
						case _:
							Context.error('Wrong assets_parent type', parent.pos);
					}
					case EField({expr: EConst(CIdent(pack))}, field):
						var name: String = pack + '.' + field;
						for (f in Context.getModule(name)) switch f {
							case TInst(t, params) if (t.toString() == name):
								var m = t.get().meta;
								parentPathes = getPatches(m.get(), t);
								var e = { expr: EConst(CString(clss.toString())), pos: Context.currentPos() };
								if (!m.has('assets_childs')) {
									m.add('assets_childs', [e], Context.currentPos());
								} else {
									var a = m.get().find(function(v) return v.name == 'assets_childs').params;
									a.push(e);
									m.remove('assets_childs');
									m.add('assets_childs', a, Context.currentPos());
								}
								break;
							case _:
						}
				case _:
					Context.error('Wrong assets_parent format', parent.pos);
			}
		}

		var patchesFields: Map<String, String> = new Map();
		if (meta.checkMeta([':assets_path'])) {
			var patches: Expr = meta.getMeta(':assets_path').params[0];
			switch patches.expr {
				case EObjectDecl(fs):
					for (f in fs) {
						switch f.expr.expr {
							case EConst(CString(s)): patchesFields[f.field] = s;
							case _: Context.error('Wrong assets_path format', patches.pos);
						}
					}
				case EConst(CString(s)):
					patchesFields['def'] = s;
				case _:
					Context.error('Wrong assets_path format', patches.pos);
			}
		}

		if (parentPathes == null) {
			return patchesFields.iterator().hasNext() ? patchesFields : null;
		}

		var result: Map<String, String> = new Map();
		for (pk in parentPathes.keys()) {
			if (patchesFields.iterator().hasNext()) {
				var prefix: String = pk == 'def' ? '' : pk + '_';
				var path: String = parentPathes[pk];
				if (path.length > 0) path += '/';
				for (k in patchesFields.keys()) {
					result[prefix + k] = path + patchesFields[k];
				}
			} else {
				result[pk] = parentPathes[pk];
			}
		}
		return result;
	}

	private static function getPrefix(meta: Metadata): String {
		var parentPrefix: String = '';
		if (meta.checkMeta([':assets_parent'])) {
			var parent: Expr = meta.getMeta(':assets_parent').params[0];
			switch parent.expr {
				case EConst(CIdent(s)):
					switch Context.getType(s) {
						case TInst(cl, _):
							parentPrefix = getPrefix(cl.get().meta.get());
						case _:
							Context.error('Wrong assets_parent type', parent.pos);
					}
				case EField({expr: EConst(CIdent(pack))}, field):
					var name: String = pack + '.' + field;
					for (f in Context.getModule(name)) switch f {
						case TInst(t, params) if (t.toString() == name):
							parentPrefix = getPrefix(t.get().meta.get());
							break;
						case _:
					}
				case v: trace(v);
					Context.error('Wrong assets_parent format', parent.pos);
			}
		}
		if (meta.checkMeta([':assets_prefix'])) {
			var patches: Expr = meta.getMeta(':assets_prefix').params[0];
			switch patches.expr {
				case EConst(CString(s)):
					return parentPrefix + s;
				case _:
					Context.error('Wrong assets_prefix format', patches.pos);
			}
		}
		return parentPrefix;
	}

	private static function getAssetName(meta: Metadata, colon: Bool = false): String {
		var p: Expr = meta.getMeta((colon ? ':' : '') + 'asset').params[0];
		return switch p.expr {
			case EConst(CString(s)):
				s;
			case _:
				Context.error('Wrong asset format', p.pos);
				'';
		}
	}
	#end

}