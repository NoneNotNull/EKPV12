define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/list/item/CardItemMixin"
	], function(declare, _TemplateItemListMixin, CardItemMixin) {
	
	return declare("mui.list.CardItemListMixin", [_TemplateItemListMixin], {
		itemTemplateString : null,
		itemRenderer: CardItemMixin
	});
});