package types;

typedef NpmPackage = {
	name: String,
	version: String,
	main: String,
	build: {
		productName: String
	},
	?dependencies: Dynamic<String>,
	?devDependencies: Dynamic<String>
}