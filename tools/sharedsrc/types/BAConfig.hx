package types;

import pony.text.XmlConfigReader;

typedef BAConfig = { > BaseConfig,
	before: Bool,
	section: BASection,
	allowCfg: Bool
	// runBefore: Array<String>,
	// runAfter: Array<String>
}