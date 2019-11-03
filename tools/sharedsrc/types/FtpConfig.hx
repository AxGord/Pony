package types;

typedef FtpConfig = { > BAConfig,
	path: String,
	user: String,
	pass: String,
	host: String,
	port: UInt,
	output: String,
	input: Array<String>
}