import sys.FileSystem;

/**
 * Cwd
 * @author AxGord <axgord@gmail.com>
 */
abstract Cwd(String) from String to String {

	@:extern public inline function new(path: String, md: Bool = false) {
		if (path != null && path.charAt(path.length - 1) != '/') path += '/';
		if (md && !FileSystem.exists(path)) FileSystem.createDirectory(path);
		this = path;
	}

	@:extern public inline function sw(): Void {
		if (this != null) {
			var p = Sys.getCwd();
			Sys.setCwd(this);
			this = p;
		}
	}

}