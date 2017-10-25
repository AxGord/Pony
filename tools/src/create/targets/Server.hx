package create.targets;

class Server {

	public static function set(project:Project):Void {
		project.server.active = true;
		project.server.haxe = true;
	}

}