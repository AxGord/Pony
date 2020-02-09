package pony.flash.ui;

import flash.display.MovieClip;
#if starling
import pony.flash.starling.converter.IStarlingConvertible;
import pony.flash.starling.converter.StarlingConverter;
import pony.flash.starling.utils.StarlingUtils;
#end

/**
 * TooltipSource
 * @author Maletin
 */
#if starling
class TooltipSource extends MovieClip implements IStarlingConvertible {
#else
class TooltipSource extends MovieClip {
#end

	public function new() {
		super();
		#if !starling
		Tooltip.instance = new Tooltip(untyped this);
		#end
	}

	#if starling
	public function convert(coordinateSpace: flash.display.DisplayObject): starling.display.DisplayObject {
		var result = StarlingConverter.getSprite(this, coordinateSpace, false);
		StarlingUtils.setChildrenTextureSmoothing(result);
		Tooltip.instance = new Tooltip(untyped result);
		return result;
	}
	#end

}