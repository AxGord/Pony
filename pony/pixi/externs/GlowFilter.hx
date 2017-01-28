package pony.pixi.externs;

/**
 * GlowFilter, originally by mishaa
 * http://www.html5gamedevs.com/topic/12756-glow-filter/?hl=mishaa#entry73578
 * http://codepen.io/mishaa/pen/raKzrm
 *
 * @example
 *  someSprite.filters = [
 *      new GlowFilter(15, 2, 1, 0xFF0000, 0.5)
 *  ];
 */
@:native("PIXI.filters.GlowFilter")
extern class GlowFilter extends pixi.core.renderers.webgl.filters.Filter {
	
/**
 * @param distance {number} The distance of the glow. Make it 2 times more for resolution=2. It cant be changed after filter creation
 * @param outerStrength {number} The strength of the glow outward from the edge of the sprite.
 * @param innerStrength {number} The strength of the glow inward from the edge of the sprite.
 * @param color {number} The color of the glow.
 * @param quality {number} A number between 0 and 1 that describes the quality of the glow.
 */
	function new(distance:Int, outerStrength:Float, innerStrength:Float, color:UInt, quality:Float);
	
	var outerStrength:Float;
	
}