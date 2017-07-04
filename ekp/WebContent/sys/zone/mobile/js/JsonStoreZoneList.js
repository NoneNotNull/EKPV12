define([
    "dojo/_base/declare",
    "dojox/mobile/EdgeToEdgeStoreList",
	"./_JsonStoreListZoneMixin"
	], function(declare,EdgeToEdgeStoreList,_JsonStoreListZoneMixin) {
	
	return declare("sys.zone.mobile.js.JsonStoreZoneList", 
			[EdgeToEdgeStoreList, _JsonStoreListZoneMixin], {
		
	});
});