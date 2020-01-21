package pony.ui.xml;

typedef RepeatObject = {
	name: String,
	attrs: Dynamic<String>,
	content: Array<Any> // RepeatObject or String
}