package types;

typedef BmfontConfig = { > BAConfig,
	from: String,
	to: String,
	type: String,
	distance: Int,
	padding: Int,
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