define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"sys/zone/mobile/js/list/item/PersonItemVerMixin"
	], function(declare, _TemplateItemListMixin, PersonItemVerMinxin) {
	
	//纵向
	return declare("sys.zone.mobile.js.list.PersonItemVerListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,

		itemRenderer : PersonItemVerMinxin //vertical
	});
});