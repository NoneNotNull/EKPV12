define(["dojo/_base/declare","dojo/date/locale","mui/i18n/i18n!sys-mobile"],function(declare,locale,msg){
	var clz=declare("mui.calendar.CalendarUtil", null, {
		
		//日期转字符串
		formatDate:function(/*Date*/date,timePattern){
			var patterns=[msg['mui.date.format.date'],msg['mui.date.format.datetime'],msg['mui.date.format.time']];
			if(timePattern){
				patterns.unshift(timePattern);
			}
			try{
				for(var i in patterns){
					var _pattern=patterns[i];
					var _date=locale.format(date,{selector : 'time',timePattern : _pattern});
					if(_date!=null){
						return _date;
					}
				}
			}catch(e){
				return null;
			}
			return null;
		},
		
		//字符串转日期
		parseDate:function(/*String*/date,timePattern){
			var patterns=[msg['mui.date.format.date'],msg['mui.date.format.datetime'],msg['mui.date.format.time']];
			if(timePattern){
				patterns.unshift(timePattern);
			}
			try{
				for(var i in patterns){
					var _pattern=patterns[i];
					var _date=locale.parse(date,{selector : 'time',timePattern : _pattern});
					if(_date!=null){
						return _date;
					}
				}
			}catch(e){
				return null;
			}
			return null;
		}
		
		
	});
	
	return new clz();
	
	
});