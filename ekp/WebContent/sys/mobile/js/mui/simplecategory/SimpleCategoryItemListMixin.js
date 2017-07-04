define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/simplecategory/SimpleCategoryItemMixin"
	], function(declare, _TemplateItemMixin, SimpleCategoryItemMixin) {
	
	return declare("mui.simplecategory.SimpleCategoryItemListMixin", [_TemplateItemMixin], {
		
		itemRenderer : SimpleCategoryItemMixin
		
	});
});