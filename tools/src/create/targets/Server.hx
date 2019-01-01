package create.targets;

/**
 * Server
 * @author AxGord <axgord@gmail.com>
 */
class Server {

	public static function set(project:Project):Void {
		project.server.active = true;
		project.server.http = true;
	}

}