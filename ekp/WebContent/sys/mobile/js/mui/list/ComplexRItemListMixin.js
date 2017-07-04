define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/list/item/ComplexRItemMixin"
	], function(declare, _TemplateItemListMixin, ComplexRItemMixin) {
	
	return declare("mui.list.ComplexRItemListMixin", [_TemplateItemListMixin], {
		
		itemRenderer: ComplexRItemMixin
	});
});