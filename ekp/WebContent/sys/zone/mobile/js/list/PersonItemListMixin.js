define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"sys/zone/mobile/js/list/item/PersonItemMixin"
	], function(declare, _TemplateItemListMixin, PersonItemMixin) {
	
	//横向排列
	return declare("sys.zone.mobile.js.list.PersonItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,

		itemRenderer : PersonItemMixin 
	});
});