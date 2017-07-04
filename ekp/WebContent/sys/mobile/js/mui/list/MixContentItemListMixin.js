define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/list/item/MixContentItemMixin"
	], function(declare, _TemplateItemListMixin, MixContentItemMixin) {
	//图文混编
	return declare("mui.list.MixContentItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,
		
		itemRenderer: MixContentItemMixin
	});
});