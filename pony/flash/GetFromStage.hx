package pony.flash;
import flash.display.DisplayObjectContainer;

/**
 * GetFromStage
 * @author AxGord <axgord@gmail.com>
 */
class GetFromStage<T> implements Dynamic<T> {

	private var obj:DisplayObjectContainer;
	
	public function new(obj:DisplayObjectContainer) {
		this.obj = obj;
	}
	
	inline public function resolve(field:String):T return untyped obj[field];
	
}