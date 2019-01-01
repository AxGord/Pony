package pony.text.tpl;

/**
 * TplData
 * @author AxGord
 */
typedef TplData = Array<TplContent>;

enum TplContent {
	Text(t:String);
	Tag(t:TplTag);
	ShortTag(t:TplShortTag);
}

typedef TplTag = {
	name: TplTagName,
	args: Map<String, TplData>,
	arg: TplData,
	content: TplData
};

typedef TplShortTag = {
	name: TplTagName,
	arg: TplData
};

typedef TplTagName = {
	up:Int,
	name:Array<String>
};

typedef TplStyle = {
	begin:String,
	end:String,
	endClose:String,
	closeBegin:String,
	closeEnd:String,
	shortBegin:String,
	shortEnd:String,
	args:TplStyleArgs,
	group:String,
	up:String,
	space:Bool
};

typedef TplStyleArgs = {
	begin: String,
	end: String,
	delemiter: String,
	set: String,
	valueq: String,
	qalltime: Bool,
	nonamearg: Bool
};