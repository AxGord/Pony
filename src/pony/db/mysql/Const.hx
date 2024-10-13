package pony.db.mysql;

/**
 * Constants
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract Const(String) {

	var createDB = 'CREATE DATABASE IF NOT EXISTS ';
	var createDBPostfix = ' DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci';

}