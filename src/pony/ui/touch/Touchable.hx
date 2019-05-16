package pony.ui.touch;

/**
 * @author AxGord <axgord@gmail.com>
 */
typedef Touchable =
#if heaps
pony.ui.touch.heaps.Touchable
#elseif pixijs
pony.ui.touch.pixi.Touchable
#elseif (flash&&!starling)
pony.ui.touch.flash.Touchable
#elseif openfl
pony.ui.touch.openfl.Touchable
#else
pony.ui.touch.starling.Touchable
#end