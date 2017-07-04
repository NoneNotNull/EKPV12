define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"sys/zone/mobile/js/address/AddressZoneItemMixin"
	], function(declare, _TemplateItemMixin, AddressZoneItemMixin) {
	
	return declare("sys.zone.mobile.js.address.AddressZoneItemListMixin", [_TemplateItemMixin], {
		
		itemRenderer : AddressZoneItemMixin
		
	});
});