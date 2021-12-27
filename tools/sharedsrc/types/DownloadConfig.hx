package types;

import pony.ds.Triple;

typedef DownloadConfig = {
	> BAConfig,
	path: String,
	units: Array<Triple<String, String, Bool>>
}