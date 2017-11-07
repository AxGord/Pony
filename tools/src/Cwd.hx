abstract Cwd(String) from String to String {

	@:extern inline public function new(path:String) {
		if (path != null && path.charAt(path.length-1) != '/')
			path += '/';
		this = path;
	}

	@:extern inline public function set():Void {
		if (this != null) Sys.setCwd(this);
	}

	@:extern inline public function undo():Void {
		if (this != null) Sys.setCwd([for (_ in 0...this.split('/').length) '../'].join(''));
	}

}