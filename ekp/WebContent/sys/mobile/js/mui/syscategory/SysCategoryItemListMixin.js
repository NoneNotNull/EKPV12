define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/syscategory/SysCategoryItemMixin"
	], function(declare, _TemplateItemMixin, SysCategoryItemMixin) {
	
	return declare("mui.syscategory.SysCategoryItemListMixin", [_TemplateItemMixin], {
		
		itemRenderer : SysCategoryItemMixin
		
	});
});