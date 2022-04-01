package pony.ui.xml;

typedef RepeatObject = {
	name: String,
	attrs: Dynamic<String>,
	content: Array<RepeatObject>,
	textContent: String
}