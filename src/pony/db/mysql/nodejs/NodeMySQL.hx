package pony.db.mysql.nodejs;

#if nodejs
import js.Node;
import js.node.events.EventEmitter;

/**
 * NodeMySQL api
 * @author AxGord <axgord@gmail.com>
 */
typedef NodeMySQL = {
	createConnection:Dynamic->NodeMySQL_Connection
}

typedef NodeMySQL_Connection = {
	connect:(Dynamic->Void)->Void,
	changeUser:Dynamic->(Dynamic->Void)->Void,
	escape:String->String,
	escapeId:String->String,
	pause:(Dynamic->Void)->Void,
	end:Void->Void,
	query:String->?(Dynamic->Dynamic->Array<Dynamic>->Void)->NodeMySQL_QueryResult
}

class NodeMySQL_QueryResult extends EventEmitter<NodeMySQL_QueryResult> {}
#end