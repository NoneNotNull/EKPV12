define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/list/item/TextItemMixin"
	], function(declare, _TemplateItemListMixin, TextItemMixin) {
	
	
	return declare("mui.list.TextItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,

		itemRenderer : TextItemMixin
	});
});