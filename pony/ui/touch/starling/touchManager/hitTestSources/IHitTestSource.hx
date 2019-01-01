package pony.ui.touch.starling.touchManager.hitTestSources;

/**
 * @author Maletin
 */

interface IHitTestSource 
{
  function hitTest(x:Float, y:Float):Dynamic;
  function parent(object:Dynamic):Dynamic;
}