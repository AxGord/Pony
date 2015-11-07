package pony.flash.starling.displayFactory;
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObjectContainer;
import pony.flash.starling.displayFactory.DisplayFactory.IMovieClip;
import pony.flash.starling.displayFactory.DisplayFactory.ITextField;

/**
 * @author Maletin
 */

interface IDisplayFactory 
{
  function createSprite():IDisplayObjectContainer;
  function createTextField(width:Float, height:Float, text:String):ITextField;
  function createMovieClip():IMovieClip;
}