define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"sys/task/mobile/resource/js/list/item/EvaluateItemMixin",
	"sys/task/mobile/resource/js/list/_CollpaseListItemMixin"
	], function(declare, _TemplateItemListMixin, EvaluateItemMixin,_CollpaseListItemMixin) {
	
	return declare("sys.task.list.EvaluateItemListMixin", [_TemplateItemListMixin,_CollpaseListItemMixin], {
		
		itemTemplateString : null,
		
		itemRenderer: EvaluateItemMixin
	});
});