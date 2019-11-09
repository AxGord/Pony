package types;

typedef UglifyConfig = {
	> BAConfig,
	output: String,
	input: Array<String>,
	sourcemap: {
		input: String,
		output: String,
		url: String,
		source: String,
		offset: Int
	},
	mangle: Bool,
	compress: Bool,
	libcache: String
}