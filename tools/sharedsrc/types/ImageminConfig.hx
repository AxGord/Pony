package types;

typedef ImageminConfig = { > BAConfig,
	from: String,
	to: String,
	?format: String,
	?pngq: Int,
	jpgq: Int,
	webpq: Int,
	webpfrompng: Bool,
	jpgfrompng: Bool
}