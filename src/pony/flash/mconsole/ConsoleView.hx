package pony.flash.mconsole;

import haxe.PosInfos;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import mconsole.Printer;
import pony.ui.gui.SlideCore;

/**
 * ConsoleView
 * @author AxGord
 */
class ConsoleView extends PrinterBase implements Printer
{
	/**
	The sprite container for the log panel
	*/
	public var sprite(default, null):Sprite;

	/**
	The background color of the log panel.
	*/
	var background:Sprite;

	/**
	The log output text field.
	*/
	var textField:TextField;

	/**
	Is the panel currently scrolled to the bottom? When true, new messages will 
	automatically scroll to the bottom.
	*/
	var atBottom:Bool;
	
	private var slideCore:SlideCore;

	public function new()
	{
		super();

		var backzone:Float = 100000;
		
		atBottom = true;

		// create panel
		sprite = new Sprite();
		
		background = new Sprite();
		sprite.addChild(background);

		background.graphics.beginFill(0x002B36, 0.8);
		background.graphics.drawRect(-backzone, -(backzone+FLTools.height/3), FLTools.width + backzone*2, FLTools.height/3 + backzone);

		textField = new TextField();
		//textField.backgroundColor = 0x002B36;
		//textField.background = true;
		sprite.addChild(textField);

		textField.mouseWheelEnabled = true;
		textField.x = textField.y = 8;
		textField.y -= FLTools.height / 3;
		textField.width = FLTools.width - textField.x*2;
		textField.height = FLTools.height/3 - textField.x*2;
		textField.multiline = true;
		textField.wordWrap = true;

		var format = new TextFormat();
		format.font = "_typewriter";
		format.size = 13;
		format.color = 0xFFFFFF;
		textField.defaultTextFormat = format;

		// listen for scrolling
		//textField.addEventListener(flash.events.Event.SCROLL, textScrolled);

		// attach
		//var current = flash.Lib.current;
		//var stage = current.stage;
		
		//stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		//stage.addEventListener(flash.events.Event.RESIZE, resize);
		
		//resize(null);
		
		slideCore = new SlideCore(FLTools.height/3);
		slideCore.update.add(update);
		sprite.visible = false;
	}
	
	private function update(v:Float, opened:Bool, closed:Bool):Void {
		sprite.y = v;
		sprite.visible = !closed;
	}

	/**
	Resize the log panel when the stage resizes.
	*/
	function resize(_)
	{
		var stage = flash.Lib.current.stage;

		background.width = stage.stageWidth;
		background.height = stage.stageHeight;

		textField.width = stage.stageWidth - 16;
		textField.height = stage.stageHeight - 16;

		updateScroll();
	}

	/**
	When the log output scrolls, evaluate atBottom.
	*/
	function textScrolled(_)
	{
		atBottom = textField.scrollV == textField.maxScrollV;
	}

	/**
	Scroll to the bottom of output if atBottom is true.
	*/
	function updateScroll()
	{
		if (atBottom) textField.scrollV = textField.maxScrollV;
	}

	/**
	Add a single formatted line of output to the log panel. Scroll to the bottom 
	of the output if atBottom is true.
	*/
	override function printLine(color:ConsoleColor, line:String, pos:PosInfos)
	{
		var format = new TextFormat();
		format.color = switch (color)
		{
			case none: 0x839496;
			case white: 0xffffff;
			case blue: 0x248bd2;
			case green: 0x859900;
			case yellow: 0xb58900;
			case red: 0xdc322f;
		};
		
		var start = textField.text.length;
		textField.appendText(line + "\n");
		textField.setTextFormat(format, start, textField.text.length);

		updateScroll();
		
		//textField.scrollV = textField.maxScrollV;
	}

	public function attach()
	{
		flash.Lib.current.addChild(sprite);
	}

	public function remove()
	{
		flash.Lib.current.removeChild(sprite);
	}
	
	public inline function show():Void slideCore.open();
	
	public inline function hide():Void slideCore.close();
	
}