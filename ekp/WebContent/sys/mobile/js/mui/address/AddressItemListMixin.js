define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/address/AddressItemMixin"
	], function(declare, _TemplateItemMixin, AddressItemMixin) {
	
	return declare("mui.address.AddressItemListMixin", [_TemplateItemMixin], {
		
		itemRenderer : AddressItemMixin
		
	});
});