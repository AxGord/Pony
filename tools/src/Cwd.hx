abstract Cwd(String) from String to String {

	@:extern inline public function new(path:String) {
		if (path != null && path.charAt(path.length-1) != '/')
			path += '/';
		this = path;
	}

	@:extern inline public function sw():Void {
		if (this != null) {
			var p = Sys.getCwd();
			Sys.setCwd(this);
			this = p;
		}
	}

}