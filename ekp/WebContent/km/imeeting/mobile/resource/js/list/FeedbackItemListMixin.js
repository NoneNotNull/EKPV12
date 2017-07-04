define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	dojoConfig.baseUrl+"km/imeeting/mobile/resource/js/list/item/FeedbackItemMixin.js"
	], function(declare, _TemplateItemListMixin, FeedbackItemMixin) {
	
	return declare("km.imeeting.list.FeedbackItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,
		
		itemRenderer: FeedbackItemMixin
	});
});