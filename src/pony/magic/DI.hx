package pony.magic;

/**
 * DI
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.builder.DIBuilder.build())
#end
interface DI {

	private final provider: ServiceProvider;

	public function destroy(): Void;

}