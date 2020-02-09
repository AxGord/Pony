package pony.flash;

import flash.display.DisplayObjectContainer;

/**
 * GetFromStage
 * Save time for access to big count elements
 * @author AxGord <axgord@gmail.com>
 */
class GetFromStage<T> implements Dynamic<T> {

	private var obj: DisplayObjectContainer;

	public function new(obj: DisplayObjectContainer) this.obj = obj;

	public inline function resolve(field: String): T return untyped obj[field];

}