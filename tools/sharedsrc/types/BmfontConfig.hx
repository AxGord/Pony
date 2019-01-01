package types;

typedef BmfontConfig = { > BAConfig,
	from: String,
	to: String,
	type: String,
	format: String,
	font: Array<{
		file: String,
		face: String,
		size: Int,
		charset: String,
		output: String,
		?lineHeight: Int
	}>
}