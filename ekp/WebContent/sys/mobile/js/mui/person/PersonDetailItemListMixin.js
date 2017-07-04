define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"mui/person/PersonDetailItemMixin"
	], function(declare, _TemplateItemListMixin, PersonDetailItemMixin) {
	
	return declare("mui.person.PersonDetailItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,
		
		itemRenderer: PersonDetailItemMixin
	});
});