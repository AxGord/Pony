package pony.db.mysql;

/**
 * MySQL connection config
 * @author AxGord <axgord@gmail.com>
 */
typedef Config = {
	?host:String,
	?port:Int,
	?user:String,
	?password:String,
	database:String
}