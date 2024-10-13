package pony.net.http.sn;

typedef VKDB = {
	count:Int,
	items:Array<VKDBItem>
}

private typedef VKDBResponse = {
	response: VKDB
}

private typedef VKDBShortResponse = {
	response: Array<VKDBItem>
}

typedef VKDBItem = { id:Int, title:String, ?area:String };

#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract VKDBMethod(String) from String to String {
	var getCountries = 'getCountries';
	var getRegions = 'getRegions';
	var getCities = 'getCities';
}

/**
 * VKDatabase
 * @author AxGord
 */
class VKDatabase {

	public static function vkRequest(method:VKDBMethod, ?lang:String, ?country_id:Null<Int>, ?region_id:Null<Int>, ?code:String, cb:VKDB->Void, offset:Int=0):Void {
		var url = 'http://api.vk.com/method/database.$method?v=5.30&need_all=1&count=1000';
		if (lang != null) url += '&lang=$lang';
		if (country_id != null) url += '&country_id=$country_id';
		if (region_id != null) url += '&region_id=$region_id';
		if (offset > 0) url += '&offset=$offset';
		if (code != null) url += '&code=$code';
		HttpTools.getJson(url, function(r:VKDBResponse):Void {
			if (r.response.count-offset > 1000) {
				vkRequest(method, lang, country_id, region_id, function(nr:VKDB) {
					cb({
						count: r.response.count,
						items: r.response.items.concat(nr.items)
					});
				}, offset + 1000);

			} else {
				cb(r.response);
			}
		} );
	}

	public static function getCountry(id:Int, cb:String->Void):Void {
		var url = 'http://api.vk.com/method/database.getCountriesById?v=5.30&country_ids=$id';
		HttpTools.getJson(url, function(r:VKDBShortResponse) cb(r.response[0].title));
	}

	public static function getRegion(country_id:Int, id:Int, cb:String->Void):Void {
		VKDatabase.vkRequest(VKDBMethod.getRegions, country_id, function(r:VKDB){
			for (item in r.items) {
				if (item.id == id) {
					cb(item.title);
					return;
				}
			}
			cb(Std.string(id));
		});
	}

	public static function getCity(id:Int, cb:String->Void):Void {
		var url = 'http://api.vk.com/method/database.getCitiesById?v=5.30&city_ids=$id';
		HttpTools.getJson(url, function(r:VKDBShortResponse) cb(r.response[0].title));
	}
}