define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/category/CategoryItemMixin"
	], function(declare, _TemplateItemMixin, CategoryItemMixin) {
	
	return declare("mui.category.CategoryItemListMixin", [_TemplateItemMixin], {
		
		itemRenderer : CategoryItemMixin
		
	});
});