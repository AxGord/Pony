package types;

typedef PoeditorConfig = {
	> BAConfig,
	path: String,
	id: Null<UInt>,
	token: String,
	list: Map<String, String>
}