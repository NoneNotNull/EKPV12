define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"km/forum/mobile/resource/js/ForumPostItemMixin"
	], function(declare, _TemplateItemListMixin, ForumPostItemMixin) {
	//回帖混编
	return declare("km.forum.mobile.resource.js.ForumPostItemListMixin", [_TemplateItemListMixin], {
		
		rowsize:10,
		
		itemTemplateString : null,
		
		itemRenderer: ForumPostItemMixin
	});
});