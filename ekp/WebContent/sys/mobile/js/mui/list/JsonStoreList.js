define([
    "dojo/_base/declare",
	"dojox/mobile/EdgeToEdgeStoreList",
	"./_JsonStoreListMixin",
	'mui/list/_ListNoDataMixin'
	], function(declare, EdgeToEdgeStoreList, _JsonStoreListMixin,_ListNoDataMixin) {
	
	return declare("mui.list.JsonStoreList", [EdgeToEdgeStoreList, _JsonStoreListMixin,_ListNoDataMixin], {
		
	});
});