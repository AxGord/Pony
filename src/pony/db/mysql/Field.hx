package pony.db.mysql;

/**
 * MySQL field
 * @author AxGord <axgord@gmail.com>
 */
typedef Field = {
	name:String,
	type: Types,
	?length:Int,
	?flags:Array < Flags >
}