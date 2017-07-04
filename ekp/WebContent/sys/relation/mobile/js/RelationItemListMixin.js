define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	dojoConfig.baseUrl + "sys/relation/mobile/js/RelationItemMixin.js"
	], function(declare, _TemplateItemListMixin, RelationItemMixin) {
	
	
	return declare("sys.relation.RelationItemListMixin", [_TemplateItemListMixin], {
		
		itemRenderer: RelationItemMixin
	});
});