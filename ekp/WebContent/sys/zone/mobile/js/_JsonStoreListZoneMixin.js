
define([
	'dojo/_base/declare', 
	'mui/list/_JsonStoreListMixin'
	], function(declare,_JsonStoreListMixin) {
	
	return declare("sys.zone.mobile.js._JsonStoreListZoneMixin", [_JsonStoreListMixin], {
		//是否加载list，当list隐藏时不加载
		isLoadMore : false,
		
		handleOnPush: function(widget, handle) {
			if(!this.isLoadMore)
				return;
			this.inherited(arguments);
		}
	});
});