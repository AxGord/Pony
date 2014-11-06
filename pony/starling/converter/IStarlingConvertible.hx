package pony.starling.converter;

/**
 * @author Maletin
 */

interface IStarlingConvertible 
{
  function convert(coordinateSpace:flash.display.DisplayObject):starling.display.DisplayObject;
}