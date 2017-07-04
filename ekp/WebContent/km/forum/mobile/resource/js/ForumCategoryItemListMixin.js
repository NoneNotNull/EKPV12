define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"km/forum/mobile/resource/js/ForumCategoryItemMixin"
	], function(declare, _TemplateItemMixin, ForumCategoryItemMixin) {
	
	return declare("km.forum.mobile.resource.js.ForumCategoryItemListMixin", [_TemplateItemMixin], {
		
		itemRenderer : ForumCategoryItemMixin
		
	});
});