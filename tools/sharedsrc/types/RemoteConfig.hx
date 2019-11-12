package types;

typedef RemoteConfig = {
	> BAConfig,
	host: String,
	port: Int,
	key: String,
	commands: Array<RemoteCommand>
}

enum RemoteCommand {
	Get(file: String);
	Send(file: String);
	Exec(command: String);
	Command(command: String);
}