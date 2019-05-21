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
	
	macro static public function build():Array<Field> {
		var keepMeta:MetadataEntry = { name:':keep', pos:Context.currentPos() };
		var list:Array<Expr> = [];
		var names:Array<Expr> = [];
		var fields:Array<Field> = Context.getBuildFields();
		for (f in fields) if (f.meta.checkMeta([':asset','asset'])) {
			if (f.access.indexOf(AStatic) == -1) Context.error('Asset can be only static', f.pos);
			switch f.kind {
				case FieldType.FVar(null, e):
					if (e == null) Context.error('Need value', f.pos);
					switch e.expr {
						case EConst(CString(_)):
							f.kind = FieldType.FVar(null, macro $v { list.length } );
							if (f.access.indexOf(AInline) == -1) f.access.push(AInline);
							list.push(e);
							if (f.meta.checkMeta([':asset'])) {
								if (f.meta.getMeta(':asset').params.length == 0)
									names.push(macro null);
								else if (f.meta.getMeta(':asset').params.length == 1)
									names.push(f.meta.getMeta(':asset').params[0]);
								else
									Context.error('Wrong :asset format', f.pos);
							} else {
								if (f.meta.getMeta('asset').params.length == 0)
									names.push(macro null);
								else if (f.meta.getMeta('asset').params.length == 1)
									names.push(f.meta.getMeta('asset').params[0]);
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
		fields.push( {
				name: 'ASSETS_LIST',
				access: [APrivate, AStatic],
				kind: FieldType.FVar(macro:Array<String>, macro $a { list } ),
				pos: Context.currentPos()
			});
			
		fields.push( {
				name: 'ASSETS_NAMES',
				access: [APrivate, AStatic],
				kind: FieldType.FVar(macro:Array<String>, macro $a { names } ),
				pos: Context.currentPos()
			});
			
		var cl = Context.getLocalClass();
		var meta = cl.get().meta.get();
		
		var patchesFields:Map<String, String> = getPatches(meta, cl);
		if (patchesFields == null) Context.error('Wrong parent class', cl.get().pos);
		var patches:Expr =  { expr: EArrayDecl([for (field in patchesFields) macro $v{field} ]), pos: Context.currentPos() };
		
		fields.push( {
				name: 'ASSETS_PATHES',
				access: [APrivate, AStatic],
				kind: FieldType.FVar(macro:Array<String>, macro $patches ),
				pos: Context.currentPos()
			});
			
		fields.push({
				name: 'loadAllAssets',
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
						args: [{name: 'childs', type:macro:Bool, value:macro true}, {name: 'cb', type:macro:Int->Int->Void}],
						ret: macro:Void,
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
						args: [{name: 'childs', type:macro:Bool, value:macro true}],
						ret: macro:Int,
						expr:
							macro return childs
							? pony.ui.AssetManager.allCountWithChilds($v { cl.toString() }, ASSETS_PATHES, ASSETS_LIST)
							: pony.ui.AssetManager.allCount(ASSETS_PATHES, ASSETS_LIST)
					}),
				pos: Context.currentPos(),
				meta: [keepMeta]
			});
		
		for (f in patchesFields.keys()) {
			var v = macro $v{patchesFields[f]};
			fields.push({
					name: f == 'def' ? 'loadAsset' : 'loadAsset_' + f,
					access: [APublic, AStatic],
					kind: FieldType.FFun( {
					args: [{name: 'asset', type:macro:pony.Or<Int,Array<Int>>, opt: true}, {name: 'cb', type:macro:Int->Int->Void}],
							ret: macro:Void,
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
			fields.push({//todo: childs
				name: f == 'def' ? 'loadAssets' : 'loadAssets_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'cb', type:macro:Int->Int->Void}],
						ret: macro:Void,
						expr: macro pony.ui.AssetManager.load($v, ASSETS_LIST, cb)
					}),
				pos: Context.currentPos()
			});
			fields.push({
				name: f == 'def' ? 'asset' : 'asset_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'asset', type:macro:Int}],
						ret: macro:String,
						expr: macro return ASSETS_NAMES[asset] == null ? $v + '/' + ASSETS_LIST[asset] : ASSETS_NAMES[asset]
					}),
				pos: Context.currentPos()
			});
			
			fields.push({
				name: f == 'def' ? 'assetName' : 'assetName_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'asset', type:macro:Int}],
						ret: macro:String,
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
						expr: macro return $v + '/' + ASSETS_LIST[asset]
					}),
				pos: Context.currentPos()
			});
			fields.push({
				name: f == 'def' ? 'image' : 'image_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'asset', type:macro:Int}],
						ret: null,
						expr: macro return pony.ui.AssetManager.image($v+'/'+ASSETS_LIST[asset], ASSETS_NAMES[asset])
					}),
				pos: Context.currentPos()
			});
			fields.push({
				name: f == 'def' ? 'spine' : 'spine_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'asset', type:macro:Int}],
						ret: null,
						expr: macro return pony.ui.AssetManager.spine($v+'/'+ASSETS_LIST[asset])
					}),
				pos: Context.currentPos()
			});
			
			fields.push({
				name: f == 'def' ? 'sound' : 'sound_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'asset', type:macro:Int}],
						ret: null,
						expr: macro return pony.ui.AssetManager.sound($v+'/'+ASSETS_LIST[asset])
					}),
				pos: Context.currentPos()
			});
			
			fields.push({
				name: f == 'def' ? 'getTexture' : 'getTexture_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'asset', type:macro:Int}],
						ret: null,
						expr: macro return pony.ui.AssetManager.texture($v+'/'+ASSETS_LIST[asset], ASSETS_NAMES[asset])
					}),
				pos: Context.currentPos()
			});

			fields.push({
				name: f == 'def' ? 'animation' : 'animation_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'asset', type:macro:Int}],
						ret: null,
						expr: macro return pony.ui.AssetManager.animation($v+'/'+ASSETS_LIST[asset], ASSETS_NAMES[asset])
					}),
				pos: Context.currentPos()
			});

			fields.push({
				name: f == 'def' ? 'clip' : 'clip_' + f,
				access: [APublic, AStatic],
				kind: FieldType.FFun( {
				args: [{name: 'asset', type:macro:Int}],
						ret: null,
						expr: macro return pony.ui.AssetManager.clip($v+'/'+ASSETS_LIST[asset], ASSETS_NAMES[asset])
					}),
				pos: Context.currentPos()
			});
		}
		
		return fields;
	}
	
	#if macro
	private static function getPatches(meta:Metadata, clss:Ref<ClassType>):Map<String, String> {
		var parentPathes:Map<String, String> = null;
		if (meta.checkMeta([':assets_parent'])) {
			var parent:Expr = meta.getMeta(':assets_parent').params[0];
			switch parent.expr {
				case EConst(CIdent(s)):
					switch Context.getType(s) {
						case TInst(cl, _):
							var m = cl.get().meta;
							parentPathes = getPatches(m.get(), cl);
							var e = { expr:EConst(CString(clss.toString())), pos:Context.currentPos() };
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
				case _:
					Context.error('Wrong assets_parent format', parent.pos);
			}
		}
		
		var patchesFields:Map<String, String> = new Map();
		if (meta.checkMeta([':assets_path'])) {
			var patches:Expr = meta.getMeta(':assets_path').params[0];	
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
		
		var result:Map<String, String> = new Map();
		for (pk in parentPathes.keys()) {
			if (patchesFields.iterator().hasNext()) {
				var prefix = pk == 'def' ? '' : pk + '_';
				var path = parentPathes[pk] + '/';
				for (k in patchesFields.keys()) {
					result[prefix + k] = path + patchesFields[k];
				}
			} else {
				result[pk] = parentPathes[pk];
			}
		}
		return result;
	}
	#end
	
}