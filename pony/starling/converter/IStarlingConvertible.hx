package pony.starling.converter;

/**
 * @author Maletin
 */
#if starling
interface IStarlingConvertible 
{
  function convert(coordinateSpace:flash.display.DisplayObject):starling.display.DisplayObject;
}
#end