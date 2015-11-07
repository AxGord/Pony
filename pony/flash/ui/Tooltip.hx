package pony.flash.ui;
import pony.flash.starling.displayFactory.DisplayFactory;
import flash.geom.Point;
import flash.Lib;
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObject;
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObjectContainer;
import pony.flash.starling.displayFactory.DisplayFactory.ITextField;
import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;
#if starling
import starling.core.Starling;
#end

using pony.flash.starling.displayFactory.DisplayListStaticExtentions;

/**
 * Tooltip
 * @author Maletin
 */
class Tooltip 
{
	private var _tooltip:IDisplayObject;
	private var _container:IDisplayObjectContainer;
	private var _data:Map<IDisplayObject, Dynamic> = new Map<IDisplayObject, Dynamic>();
	
	private var _previousTarget:Dynamic;
	
	public var dataSetFunction:IDisplayObject->Dynamic->Void;
	public var distanceFromMouse:Float = 15;
	public var distanceFromBorder:Float = 15;
	
	public static var instance:Tooltip = null;

	public function new(tooltip:IDisplayObject) 
	{
		_tooltip = tooltip;
		
		#if starling
		_container = untyped Starling.current.root;
		#else
		_container = untyped Lib.current;
		#end
		
		_tooltip.visible = false;
		_tooltip.setTouchable(false);
		dataSetFunction = defaultDataSet;
	}
	
	private function defaultDataSet(tooltip:IDisplayObject, data:Dynamic):Void
	{
		var textField:ITextField = untyped tooltip.getChildByName("textField");
		var longTextField:ITextField = untyped tooltip.getChildByName("longTextField");
		var background:IDisplayObject = untyped tooltip.getChildByName("background");
		var longBackground:IDisplayObject = untyped tooltip.getChildByName("longBackground");
		
		var distanceBetweenTextFields:Int = 0;
		if (textField != null && longTextField != null)
			distanceBetweenTextFields = Std.int(longTextField.y - (textField.getTextHeight() + textField.y));
		
		var bgExtraHeight:Int = 0;
		if (background != null && textField != null)
			bgExtraHeight = Std.int( background.y + background.height - (textField.getTextHeight() + textField.y) );
			
		var longBgExtraHeight:Int = 0;
		if (longBackground != null && longTextField != null)
			longBgExtraHeight = Std.int( longBackground.y + longBackground.height - (longTextField.getTextHeight() + longTextField.y) );
			
		
		var text:String = Std.is(data, String) ? data : data.text;
		var longText:String = Std.is(data, String) ? "" : data.longText;
		
		if (textField != null)
		{
			textField.text = text;
			textField.height = textField.getTextHeight() + 10;
		}
		if (longTextField != null)
		{
			//longTextField.border = true;//DELETE!
			longTextField.visible = longText != "";
			longTextField.text = longText;
			longTextField.height = longTextField.getTextHeight() + 10;
			longTextField.y = distanceBetweenTextFields + textField.getTextHeight() + textField.y;
		}
		
		if (background != null && textField != null)
		{
			background.height = bgExtraHeight - background.y + textField.getTextHeight() + textField.y;
		}
		if (longBackground != null && longTextField != null)
		{
			longBackground.height = longBgExtraHeight - longBackground.y + longTextField.getTextHeight() + longTextField.y;
		}
		longBackground.visible = !(longTextField == null || longTextField.text == "");
		
	}
	
	/**
	* Tooltip.addDefault adds a tooltip with a style provided by an instance of TooltipSource class. Data can be either String or {text:String, longText:String}
	* @param data can be either String or {text:String, longText:String}
	*/
	public static function addDefault(object:IDisplayObject, data:Dynamic):Void
	{
		if (instance == null) throw "Set tooltip style first";
		
		instance.add(object, data);
	}
	
	/**
	* Tooltip.add adds a tooltip to an object. Data can be either String or {text:String, longText:String}, or you can use your own format by adding your own data set function to dataSetFunction variable of this Tooltip object.
	* @param data can be either String or {text:String, longText:String}, or you can use your own format by adding your own data set function to dataSetFunction variable of this Tooltip object.
	*/
	public function add(object:IDisplayObject, data:Dynamic):Void
	{
		if (object == null) throw "Can't add a tooltip to a null object";
		_container.addChild(_tooltip);
		_data.set(object, data);
		TouchManager.addListener(object, listener);
	}
	
	private function listener(e:TouchManagerEvent):Void
	{
		switch(e.type)
		{
			case TouchEventType.Hover:
				_tooltip.visible = true;
				if (_previousTarget != e.target)
				{
					defaultDataSet(_tooltip, _data.get(e.target));
					_previousTarget = e.target;
				}
				place(e.globalX, e.globalY);
				
			case TouchEventType.HoverOut:
				_tooltip.visible = false;
			default:
		}
	}
	
	private function place(x:Float, y:Float):Void
	{
		var point = _tooltip.parent.globalToLocal(new Point(x, y));
		var rect = _tooltip.getBounds(_tooltip);
		_tooltip.x = Std.int(point.x - rect.width / 2);
		_tooltip.y = Std.int(point.y - rect.height - distanceFromMouse);
		
		var stageWidth:Float = FLTools.width;
		var stageHeight:Float = FLTools.height;
		
		if (_tooltip.x < distanceFromBorder) _tooltip.x = distanceFromBorder;
		if (_tooltip.y < distanceFromBorder) _tooltip.y = distanceFromBorder;
		if (_tooltip.x + rect.width > stageWidth - distanceFromBorder) _tooltip.x = stageWidth - distanceFromBorder - rect.width;
		if (_tooltip.y + rect.height > stageHeight - distanceFromBorder) _tooltip.y = stageHeight - distanceFromBorder - rect.height;
	}
	
}