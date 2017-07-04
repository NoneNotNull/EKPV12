define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"sys/task/mobile/resource/js/list/item/FeedbackItemMixin",
	"sys/task/mobile/resource/js/list/_CollpaseListItemMixin"
	], function(declare, _TemplateItemListMixin, FeedbackItemMixin,_CollpaseListItemMixin) {
	
	return declare("sys.task.list.FeedbackItemListMixin", [_TemplateItemListMixin,_CollpaseListItemMixin], {
		
		itemTemplateString : null,
		
		itemRenderer: FeedbackItemMixin
	});
});