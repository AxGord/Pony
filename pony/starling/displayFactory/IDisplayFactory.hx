package pony.starling.displayFactory;
import pony.starling.displayFactory.DisplayFactory.IDisplayObjectContainer;
import pony.starling.displayFactory.DisplayFactory.IMovieClip;
import pony.starling.displayFactory.DisplayFactory.ITextField;

/**
 * @author Maletin
 */

interface IDisplayFactory 
{
  function createSprite():IDisplayObjectContainer;
  function createTextField(width:Float, height:Float, text:String):ITextField;
  function createMovieClip():IMovieClip;
}