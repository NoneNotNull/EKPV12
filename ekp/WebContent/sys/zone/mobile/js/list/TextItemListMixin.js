define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"sys/zone/mobile/js/list/item/ZoneTextItemMixin"
	], function(declare, _TemplateItemListMixin, ZoneTextItemMixin) {
	
	
	return declare("mui.list.TextItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,

		itemRenderer : ZoneTextItemMixin
	});
});