package types;

typedef ImageminConfig = {
	> BAConfig,
	from: String,
	to: String,
	recursive: Bool,
	?format: String,
	?pngq: Int,
	jpgq: Int,
	webpq: Int,
	webpfrompng: Bool,
	jpgfrompng: Bool,
	fast: Bool,
	checkHash: Bool,
	ignore: Array<String>
}