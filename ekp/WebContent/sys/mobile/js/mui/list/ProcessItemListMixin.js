define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/list/item/ProcessItemMixin"
	], function(declare, _TemplateItemListMixin, ProcessItemMixin) {
	
	return declare("mui.list.ProcessItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,
		
		itemRenderer: ProcessItemMixin
	});
});