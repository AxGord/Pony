package types;

import pony.text.XmlConfigReader;

typedef BAConfig = {
	> BaseConfig,
	before: Bool,
	section: BASection,
	?group: Array<String>,
	allowCfg: Bool
	// runBefore: Array<String>,
	// runAfter: Array<String>
}