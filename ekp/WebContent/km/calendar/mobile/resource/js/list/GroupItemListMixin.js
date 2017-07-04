define([
    "dojo/_base/declare",
	"mui/list/_TemplateItemListMixin",
	"km/calendar/mobile/resource/js/list/item/GroupItemMixin"
	], function(declare, _TemplateItemListMixin, ItemMixin) {
	
	return declare("km.calendar.mobile.resource.js.GroupItemListMixin", [_TemplateItemListMixin], {
		
		itemTemplateString : null,
		
		itemRenderer: ItemMixin,
		
		currentDate:new Date(),
		
		buildRendering:function(){
			this.inherited(arguments);
			this.subscribe('/mui/calendar/valueChange','saveCurrentDate');
		},
	
		//选中日期改变时,缓存选中日期
		saveCurrentDate:function(widget,args){
			this.currentDate=args.currentDate;
		}
		
	});
});