define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"km/imeeting/mobile/resource/js/list/item/MeetingCardItemMixin"
	], function(declare, _TemplateItemListMixin, CardItemMixin) {
	
	return declare("km.imeeting.list.MeetingCardItemListMixin", [_TemplateItemListMixin], {
		itemTemplateString : null,
		itemRenderer: CardItemMixin
	});
});