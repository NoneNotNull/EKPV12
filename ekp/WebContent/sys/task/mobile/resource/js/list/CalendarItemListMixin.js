define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"sys/task/mobile/resource/js/list/item/CalendarItemMixin"
	], function(declare, _TemplateItemListMixin, SysTaskItemMixin) {
	
	return declare("sys.task.list.CalendarItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,
		
		itemRenderer: SysTaskItemMixin
	});
});