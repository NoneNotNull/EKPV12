define([
    "dojo/_base/declare",
    "dojo/topic",
    'dojo/when',
    "mui/calendar/CalendarJsonStoreList",
	"dojo/date",
	"mui/util",
	'dojo/_base/lang',
	"dojo/request",
	"mui/calendar/CalendarUtil"
	], function(declare,topic,when,CalendarJsonStoreList,dateClz,util,lang,request,cutil) {
	
	return declare("km.calendar.mobile.resource.js.GroupJsonStoreList", [CalendarJsonStoreList], {
		
		//群组日历的数据格式跟标准日历数据格式不一致,覆盖处理...
		formatData:function(datas){
			var data=[];
			var calendars=datas.data.calendars;
			for(var key in calendars){
				data=data.concat(calendars[key]);
			}
			return data;
		}
		
		
	});
});