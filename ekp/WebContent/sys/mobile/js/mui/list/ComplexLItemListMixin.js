define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/list/item/ComplexLItemMixin"
	], function(declare, _TemplateItemListMixin, ComplexLItemMixin) {
	
	return declare("mui.list.ComplexLItemListMixin", [_TemplateItemListMixin], {
		
		itemRenderer : ComplexLItemMixin
	});
});