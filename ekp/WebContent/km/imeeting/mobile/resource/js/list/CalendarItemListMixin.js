define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	dojoConfig.baseUrl+"km/imeeting/mobile/resource/js/list/item/CalendarItemMixin.js"
	], function(declare, _TemplateItemListMixin, KmImeetingItemMixin) {
	
	return declare("km.imeeting.list.CalendarItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,
		
		itemRenderer: KmImeetingItemMixin
	});
});