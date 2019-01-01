package pony.magic;

/**
 * HasAsset
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.builder.HasAssetBuilder.build())
#end
interface HasAsset {}