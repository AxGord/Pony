package pony.openfl;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * TextButton
 * @author AxGord <axgord@gmail.com>
 */
class TextButton extends Button {

	private var tf:TextField;
	
	public function new(states:Array<String>, text:String, ?format:TextFormat, w:Float=0, h:Float=0) {
		super(states);
		tf = new TextField();
		tf.autoSize = TextFieldAutoSize.LEFT;
		if (format != null) tf.defaultTextFormat = format;
		tf.text = text;
		tf.x = Std.int((zone.width - tf.textWidth + w) / 2);
		tf.y = Std.int((zone.height - tf.textHeight + h) / 2);
		tf.selectable = false;
		tf.mouseEnabled = false;
		addChild(tf);
	}
	
	override function change(img:Int):Void {
		super.change(img);
		tf.visible = img != 4;
	}
	
}