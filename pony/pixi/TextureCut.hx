package pony.pixi;

import pixi.core.math.shapes.Rectangle;
import pixi.core.textures.Texture;

/**
 * TextureCut
 * @author AxGord <axgord@gmail.com>
 */
class TextureCut {

	private static var list:Array<String> = [];
	
	public static function apply(texture:Texture, crop:Float):Void {
		if (list.indexOf(([
			texture.baseTexture.imageUrl,
			texture.frame.x,
			texture.frame.y,
			texture.frame.width,
			texture.frame.height
		]:Array<Any>).join(';')) != -1) return;
		texture.frame = new Rectangle(
			texture.frame.x + crop,
			texture.frame.y + crop,
			texture.frame.width - crop * 2,
			texture.frame.height - crop * 2
		);
		list.push(([
			texture.baseTexture.imageUrl,
			texture.frame.x,
			texture.frame.y,
			texture.frame.width,
			texture.frame.height
		]:Array<Any>).join(';'));
	}
	
}