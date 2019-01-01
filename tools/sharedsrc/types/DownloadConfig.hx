package types;

import pony.Pair;

typedef DownloadConfig = { > BAConfig,
	path: String,
	units:Array<Pair<String, String>>
}