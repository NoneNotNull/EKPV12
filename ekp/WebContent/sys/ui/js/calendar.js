define(function(require, exports, module) {
	require("sys/ui/extend/theme/default/style/fullcalendar.css");
	require("theme!calendar");
	var Class = require("lui/Class");
	var Evented = require('lui/Evented');
	var base = require("lui/base");
	var source = require("lui/data/source");
	var layout = require("lui/view/layout");
	var dialog = require("lui/dialog");
	var topic = require("lui/topic");
	//var $ = require("lui/jquery");
	var $=require("resource/js/jquery-ui/jquery.ui");
	require("lui/calender/fullcalendar")($);
	var lang = require('lang!sys-ui');
	var commonlang=require('lang!');
	
	//日历中空白日期选择事件
	var LUI_CALENDAR_SELECT = "calendar.select";
	//日历中空白日期失去选择事件
	var LUI_CALENDAR_UNSELECT = "calendar.unselect";
	//日历中日历数据的点击事件
	var LUI_CALENDAR_THING_CLICK = "calendar.thing.click";
	//日历中日历数据的改变事件
	var LUI_CALENDAR_THING_CHANGE = "calendar.thing.change";
	
	/**************************************************************
	 * 农历及节日常量表
	 **************************************************************/
	var Gan = ["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"];
	var Zhi = ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"];
	var Animals = ["鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪"];
	var LunarDate = ['日', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
	var LunarOdate = ['初', '十', '廿', '卅', '　'];
	var lunarInfo = [0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2, 0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977, 0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970, 0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950, 0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557, 0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0, 0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0, 0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6, 0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570, 0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0, 0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5, 0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930, 0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530, 0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45, 0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0];
	var sTermInfo = [0, 21208, 42467, 63836, 85337, 107014, 128867, 150921, 173149, 195551, 218072, 240693, 263343, 285989, 308563, 331033, 353350, 375494, 397447, 419210, 440795, 462224, 483532, 504758];
	var solarTerms = ["小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至"];
	var solarFestivals = ["0101 元旦", "0214 情人节", "0308 妇女节", "0312 植树节", "0401 愚人节", "0501 劳动节", "0504 青年节", "0512 护士节", "0601 儿童节", "0701 建党节", "0801 建军节", "0910 教师节", "1001 国庆节", "1031 万圣节","1225 圣诞节"];
	var lunarFestivals = ["0101 春节", "0115 元宵节", "0505 端午节", "0707 七夕", "0715 中元节", "0815 中秋节", "0909 重阳节", "1208 腊八节", "1224 小年", "0100 除夕"];
	var weekFestivals=["0520 母亲节","0630 父亲节","1144 感恩节"];
	/**************************************************************
	 * 功能：农历对象
	 * 参数：refDate		参考阳历日期
	 **************************************************************/
	var Lunar = function(refDate){
			var _cyclical = function(num){				
			   num = num-1900+36;
			   return(Gan[num%10] + Zhi[num%12] + Animals[(num-4)%12]);
			};
			var _leapMonth = function (y) { 				
				return (lunarInfo[y - 1900] & 0xf);
			};
			var _monthDays = function monthDays(y, m) { 
				return ((lunarInfo[y - 1900] & (0x10000 >> m)) ? 30 : 29); 
			};
			var _leapDays = function(y) {					
			    if (_leapMonth(y)) 
			    	return ((lunarInfo[y - 1900] & 0x10000) ? 30 : 29);
			    else 
			    	return (0);
			};
			var _lYearDays = function(y) {
			    var i, sum = 348;
			    for (i = 0x8000; i > 0x8; i >>= 1){ 
			    	sum += (lunarInfo[y - 1900] & i) ? 1 : 0;
			    }
			    return (sum + _leapDays(y));
			};
			var i, leap = 0, temp = 0;
		    var baseDate = new Date(1900, 0, 31);
		    var offset = (refDate - baseDate.getTime())/86400000;
		    this.dayCyl = offset + 40;
		    this.monCyl = 14;
		    for (i = 1900; i < 2050 && offset > 0; i++) {
		        temp = _lYearDays(i);
		        offset -= temp;
		        this.monCyl += 12;
		    }
		    if (offset < 0) {
		        offset += temp;
		        i--;
		        this.monCyl -= 12;
		    }
		    this.year = i;
		    this.yearCyl = i - 1864;
		    leap =_leapMonth(i);
		    this.isLeap = false;
		    for (i = 1; i < 13 && offset > 0; i++) {
		        if (leap > 0 && i == (leap + 1) && this.isLeap == false){ 
		        	--i; this.isLeap = true; temp = _leapDays(this.year); 
		        }else{ 
		        	temp = _monthDays(this.year, i); 
		        }
		        if (this.isLeap == true && i == (leap + 1)) 
		        	this.isLeap = false;
		        offset -= temp;
		        if (this.isLeap == false) 
		        	this.monCyl++;
		    }
		    if (offset == 0 && leap > 0 && i == leap + 1){
		        if (this.isLeap){ 
		        	this.isLeap = false; 
		        }
		        else{
		        	this.isLeap = true; --i; --this.monCyl; 
		        }
		    }
		    if (offset < 0) { 
		    	offset += temp; --i; --this.monCyl; 
		    }
		    this.month = i;
		    this.day = offset + 1;
	};
	/**************************************************************
	 * 功能：获取日期对应的阴历或节日
	 * 参数：refDate			日期
	 **************************************************************/
	var solarDay = function(refDate){
		var SY = refDate.getFullYear();
		var SM = refDate.getMonth();
		var SD =  refDate.getDate();
		var SW=refDate.getDay();//星期几
		var SN=Math.ceil((SD+6-SW)/7);//第几周
		var cDay = function(m, d){
			var s = "";
		    switch (parseInt(d)) {
		        case 10: s += '初十'; break;
		        case 20: s += '二十'; break;
		        case 30: s += '三十'; break;
		        default: s += LunarOdate[Math.floor(d / 10)]; s += LunarDate[Math.round(d % 10)];
		    }
			return (s);
		};
	    var lDObj = new Lunar(refDate);
	    var solarTerm = '', solarFestival = '', lunarFestival = '',sFtv = '', tmp1, tmp2;
	    if(!lDObj.isLeap){
	    	 for (i in lunarFestivals){//农历节日
	 	        if (lunarFestivals[i].match(/^(\d{2})(.{2})([\s\*])(.+)$/)) {
	 	            tmp1 = Number(RegExp.$1) - lDObj.month;
	 	            tmp2 = Number(RegExp.$2) - lDObj.day;
	 	            if (tmp1 == 0 && tmp2 == 0 ) {
	 	            	lunarFestival = RegExp.$4;
	 	            }
	 	        }
	 	    }
	    }
	    if (lunarFestival == '') {
	        for (i in solarFestivals){										//阳历节日
	            if (solarFestivals[i].match(/^(\d{2})(\d{2})([\s\*])(.+)$/)) {
	                tmp1 = Number(RegExp.$1) - (SM + 1);
	                tmp2 = Number(RegExp.$2) - SD;
	                if (tmp1 == 0 && tmp2 == 0) 
	                	solarFestival = RegExp.$4;
	            }
	        }
	        for(i in weekFestivals){							//月周节日
	        	if(weekFestivals[i].match(/^(\d{2})(\d)(\d)([\s\*])(.+)$/)){
				  if(Number(RegExp.$1)==(SM+1)) {
					  var firstWeek=new Date(SY,SM,1).getDay();
			          tmp1=Number(RegExp.$2);
			          tmp2=Number(RegExp.$3);  
			          if(((firstWeek>tmp2)?7:0) + 7*(tmp1-1) + tmp2 -firstWeek+1==SD)
			        	  solarFestival = RegExp.$5;
			          //this[((this.firstWeek>tmp2)?7:0) + 7*(tmp1-1) + tmp2 - this.firstWeek].solarFestival += RegExp.$5 + ' '  
			       }  
				}  
	        }
	        if (solarFestival == '') {							//阴历节气						
	            tmp1 = new Date((31556925974.7 * (SY - 1900) + sTermInfo[SM * 2 + 1] * 60000) + Date.UTC(1900, 0, 6, 2, 5));
	            tmp2 = tmp1.getUTCDate();
	            if (tmp2 == SD){ 
	            	solarTerm = solarTerms[SM * 2 + 1];
	            }
	            tmp1 = new Date((31556925974.7 * (SY - 1900) + sTermInfo[SM * 2] * 60000) + Date.UTC(1900, 0, 6, 2, 5));
	            tmp2 = tmp1.getUTCDate();
	            if (tmp2 == SD){ 
	            	solarTerm = solarTerms[SM * 2];
	            }
	            if (solarTerm == ''){ 
	            	sFtv = ''; 
	            }else{ 
	            	sFtv = solarTerm;
	            }
	        }else {
	        	sFtv = solarFestival;
	        }
	    } else{
	    	sFtv = lunarFestival;
	    }
		if(sFtv!=""){
			return sFtv;
		}else{
			return cDay(lDObj.month,lDObj.day);
		}
	};
	
	/********************************************************************
	 *功能：视图展示虚拟类 
	 ******************************************************************/
	var AbstractCalenderMode  = new Class.create(Evented,{
		/**************************************************
		 *功能： 初始化参数配置
		 *************************************************/
		initialize:function(_config){
			this.calendarDiv = _config.container;
			this.calendar = _config.calendar;
			this.calSetting = $.extend({},_config.setting);
		},
		/**********************************************
		 *功能： 视图绘制
		 *********************************************/
		draw : function(){
			
		},
		/*************************************************
		 * 功能：日历数据的视图显示
		 * 参数：dom		日历中时间的Dom元素
		 * 		html	格式化后的日历数据
		 ************************************************/
		scheduleShow:function(dom, html){
			
		},
		/*************************************************
		 * 功能：获取当前视图信息json
		 * 返回：json对象，包含如下信息		
		 *		name: 名称，如FullCalendarMode的month,basicWeek，ListCalendarMode的listMonth等
		 *		title: 视图时间标题内容,如2013年11月
		 *		start: Date类型, 该视图下的第一天.
		 *		end:	Date类型, 该view下的最后一天. 
		 ************************************************/
		getView : function(){
			
		},
		/*************************************************
		 * 功能：切换到对应的视图中
		 * 参数：name	视图名称标示
		 *************************************************/
		changeView:function(name){
			
		},
		/*************************************************
		 * 功能：视图中,前一页
		 *************************************************/
		prev:function(){
			
		},
		/*************************************************
		 * 功能：视图中,后一页
		 *************************************************/
		next:function(){
			
		},
		/*************************************************
		 * 功能：视图切换回当天
		 *************************************************/
		today:function(){
			
		},
		/*************************************************
		 * 功能：视图刷新（数据重新获取）
		 *************************************************/
		refreshSchedules:function(){
			
		},
		/*************************************************
		 * 功能：增加视图数据
		 * 参数：schedule	数据（json格式）
		 * 格式说明：
		 * 	{
		 *		id			标示	 		
		 * 		title		标题（必填）
		 * 		start		开始时间（必填）
		 * 		end			结束时间
		 *		allDay		是否整天（true/false）
		 *		url			指定后，点击后会跳转至该url中
		 * 		className	日历事务显示样式
		 *		editable	是够允许拖拽
		 *		color		背景颜色和边框颜色
		 *		backgroundColor背景样色
		 *		borderColor	边框颜色
		 *		textColor	文本颜色	
		 * 	}
		 *************************************************/
		addSchedule:function(schedule){
			
		},
		/*************************************************
		 * 功能：删除某个视图数据或全部数据
		 * 参数：id	数据标示，id为空表示删除所有
		 *************************************************/
		removeSchedule:function(id){
			
		},
		/*************************************************
		 * 功能：更新某项视图数据
		 * 参数：schedule	数据
		 *************************************************/
		updateSchedule:function(schedule){
			
		},
		/*************************************************
		 * 功能：重新定义mode显示时间区间
		 * 参数：refStartDate		参考开始时间
		 *		refEndDate			参考结束时间
		 *************************************************/
		resizeDateRange:function(refStartDate,refEndDate){
			
		},
		/*************************************************
		 * 功能：清理时间的时分秒信息
		 * 参数：d		时间
		 *************************************************/
		clearTime : function(d) {
			d.setHours(0);
			d.setMinutes(0);
			d.setSeconds(0); 
			d.setMilliseconds(0);
			return d;
		}
	});
	
	/****************************************************
	 * 功能：简单列表视图显示
	 ******************************************************/
	var ListCalendarMode = AbstractCalenderMode.extend({
		initialize:function($super,_config){
			$super(_config);
			
			this.dateFormat=seajs.data.env.pattern.date;
			
			this.dataFirst = true;
			this.schedules =[];
			this.init();
		},
		/********************************************
		 * 功能：绘制日期时，日期显示时调用
		 * 参数：date 	当前日期时间
		 * 		cellObj	日期显示所在单元格对象
		 ********************************************/
		_dayShow:function(date,cellObj){
			if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn')
				cellObj.append("&nbsp;&nbsp;" + solarDay(date)); 
		},
		/*********************************************
		 * 配置初始化
		 *********************************************/
		init:function(){
			var self = this;
			//绘制日期时调用
			var tmpModeCfg = {};
			tmpModeCfg.dayRender = function(date,cellObj){
				self._dayShow(date,cellObj);
			};
			this.calSetting = Object.extend(this.calSetting,tmpModeCfg);
		},
		/******************************************************
		 * 功能：简单列表绘制
		 *****************************************************/
		draw : function(){
			if(!this.drawed){
				if(this.start == null){
					var today = new Date();
					this.start = this.clearTime(today);
					this.start.setDate(1);
				}
				this.end = $.fullCalendar.cloneDate(this.start);
				this.end.setMonth(this.start.getMonth()+1);
				this.end.setDate(1);
				this.renderList();
			}
			this.drawed = true;
			this.calendarDiv.show();
		},
		/******************************************************
		 * 功能：列表展示
		 *****************************************************/
		renderList:function(){
			var self = this; 
			var evts = self.calSetting.events;
			var startVar = $.fullCalendar.cloneDate(self.start);
			var endVar = $.fullCalendar.cloneDate(self.end);
			if(self.calSetting.loading)
				self.calSetting.loading(true);
			if(evts){
				if ($.isFunction(evts)) {
					evts(startVar, endVar , function(data){
						self.schedules = data;
						self._dataShow(startVar, endVar , data);
					});
				}else if($.isArray(evts)){
					self.schedules = evts;
					self._dataShow(startVar,endVar,evts);
				}
			}else{
				self.schedules = [];
				self._dataShow(startVar,endVar,null);
			}
		},
		/******************************************************
		 * 功能：根据时间区间展示数据
		 * 参数：
		 * 		start	开始时间
		 * 		end		结束时间
		 * 		evts	事务数据	
		 ******************************************************/
		_dataShow : function(start ,end ,evts){
			var renderObj =  $('<table class="lui_calendar_content_list"></table>');
			var tmpTd =  this._getSpanRow(renderObj);
			tmpTd.append(this._getCheckbox());
			if(this.dataFirst && (evts == null||evts.length==0)){
				tmpTd = this._getSpanRow(renderObj);
				tmpTd.append('<div class="lui_calendar_list_noData">'+lang['ui.calendar.no.datas']+'</div>');
			}else{
				var daySum = (24*60*60*1000);
				var sum = (end.getTime()- start.getTime())/daySum;
				for(var i=0; i<sum; i++){
					var cellStartDate = $.fullCalendar.cloneDate(start);
					cellStartDate.setDate(start.getDate() + i);
					var cellEndDate = $.fullCalendar.cloneDate(cellStartDate);
					cellEndDate.setDate(cellEndDate.getDate() + 1);
					var tmpTR  = $('<tr date="'+ $.fullCalendar.formatDate(cellStartDate,this.dateFormat) +'"/>');
					var dateTd = $('<td class="lui_calendar_list_first"/>');
					this.dayRender(cellStartDate,dateTd);
					dateTd.appendTo(tmpTR);
					var dataTd = $('<td class="lui_calendar_list_second"/>');
					dataTd.appendTo(tmpTR);
					var isHasData = false;
					if(evts!=null){
						for(var j = 0; j<evts.length; j++){
							var tmpFlag = this._chkInstect(cellStartDate,cellEndDate,evts[j],dataTd);
							if(tmpFlag == true && !isHasData){
								isHasData = true;
							}
						}
					}
					if(isHasData || !this.dataFirst){
						tmpTR.appendTo(renderObj);
					}
				}
			}
			this.calendarDiv.html('');
			this.calendarDiv.append(renderObj);
			if(this.calSetting.loading)
				this.calSetting.loading(false);
		},
		/**********************************************************************
		 * 功能：较验日程信息是否在时间区域内
		 *******************************************************************/
		_chkInstect : function(start, end, evt , dataTd){
			var dataStart = evt.start;
			if(typeof(dataStart)=="string")
				dataStart = $.fullCalendar.parseDate(evt.start,this.calSetting.ignoreTimezone);
			evt.start = dataStart;
			var dataStartInt = dataStart.getTime();
			var dataEnd = evt.end;
			if(dataEnd==null || dataEnd==''){
				if(dataStartInt>=start.getTime() && dataStartInt< end.getTime()){
					this.dataRender(evt,dataTd);
					return true;
				}
			}else{
				var dataEndInt = dataEnd;
				if(typeof(dataEnd)=="string")
					dataEndInt = $.fullCalendar.parseDate(dataEnd,this.calSetting.ignoreTimezone);
				evt.end = dataEndInt;
				if((dataEndInt>=start.getTime() && dataEndInt< end.getTime())
						|| (dataEndInt>=end.getTime() && dataStartInt<=start.getTime())){
					this.dataRender(evt,dataTd);
					return true;
				}
			}
			return false;
		},
		/*************************************************************************
		 * 功能：获取合并的操作列
		 *********************************************************************/
		_getSpanRow : function(table){
			var tmpTR =  $('<tr/>').appendTo(table);
			return $('<td colspan="2"/>').appendTo(tmpTR);
		},
		/************************************************************************
		 * 功能：获取头部附加操作区域
		 ************************************************************************/
		_getCheckbox : function(){
			var self = this;
			var tmpChk =  $('<input type="checkbox" name="__list_calendar_chk"/>');
			var label = '<label class="lui_calendar_list_operate">'+lang['ui.calendar.datas.show']+'&nbsp;&nbsp;</label>';
			if(this.dataFirst){
				tmpChk.attr("checked","checked");
			}else{
				tmpChk.removeAttr("checked");
			}
			tmpChk.click(function(){
				var dataFirst = $(this).is(":checked");
				self.dataFirst = dataFirst;
				self.renderList();
			});
			return $(label).append(tmpChk);
		},
		/********************************************************************
		 * 功能：绘制日期表格内容
		 ********************************************************************/
		dayRender : function(date,cellObj){
			var divObj = $('<div class="lui_calendar_list_date"/>').append($.fullCalendar.formatDate(date,this.dateFormat));
			divObj.append("&nbsp;&nbsp;" + this.calSetting.dayNames[date.getDay()]);
			divObj.appendTo(cellObj);
			if(this.calSetting.dayRender)
				this.calSetting.dayRender(date,cellObj);
		},
		/**********************************************************
		 * 功能:绘制数据
		 * 参数：
		 * 			id			标示	 		
		 * 			title		标题（必填）
		 * 			start		开始时间（必填）
		 * 			end			结束时间
		 *			allDay		是否整天（true/false）
		 *			url			指定后，点击后会跳转至该url中
		 * 			className	日历事务显示样式
		 *			editable	是够允许拖拽
		 *			color		背景颜色和边框颜色
		 *			backgroundColor背景样色
		 *			borderColor	边框颜色
		 *			textColor	文本颜色	
		 ***********************************************************/
		dataRender:function(data,cellObj){
			var self = this;
			var divObj = $('<div class="lui_calendar_list_data_inner"/>').append(data.title);
			divObj = $('<div class="lui_calendar_list_data"/>').append(divObj);
			if(data.className){
				divObj.addClass(data.className);
			}
			var cssObj={};
			if(data.color){
				cssObj['backgroundColor'] = data.color;
				cssObj['borderColor'] = data.color;
			}
			if(data.backgroundColor){
				cssObj['backgroundColor'] = data.backgroundColor;
			}
			if(data.borderColor){
				cssObj['borderColor'] = data.borderColor;
			}
			if(data.textColor){
				cssObj['color'] = data.textColor;
			}
			divObj.css(cssObj);
			divObj.appendTo(cellObj);
			if(this.calSetting.eventRender){
				this.calSetting.eventRender(data,divObj);
			}
			if(this.calSetting.eventClick){
				divObj.click(function(evt){
					self.calSetting.eventClick(data,evt);
				});
			}
			if(this.calSetting.eventMouseover){
				divObj.mouseover(function(evt){
					self.calSetting.eventMouseover(data,evt);
				});
			}
			if(this.calSetting.eventMouseout){
				divObj.mouseout(function(evt){
					self.calSetting.eventMouseout(data,evt);
				});
			}
		},
		
		/*****************************************************
		 * 功能：将格式化的html，显示在对应位置
		 * 参数：
		 * 		dom 	显示区域
		 * 		html	格式化后的html
		 ****************************************************/
		scheduleShow : function(dom, html){
			dom.find(".lui_calendar_list_data_inner").html(html);
		},
		/*****************************************************
		 * 功能：获取当前view信息
		 ****************************************************/
		getView : function(){
			var formaStr = this.calSetting.titleFormat.month;
			if(formaStr==null)
				formaStr = "yyyy-MM";
			return {name:'listMonth' , title:$.fullCalendar.formatDate(this.start,formaStr), start:this.start, end:this.end};
		},
		/*****************************************************
		 * 功能：更改视图类型
		 ****************************************************/
		changeView : function(viewName){
			//TODO ListCalendar目前仅支持listMonth视图
		},
		/*****************************************************
		 * 功能：上一页
		 ****************************************************/
		prev: function(){
			this.start.setMonth(this.start.getMonth()-1);
			this.end.setMonth(this.end.getMonth()-1);
			this.renderList(); 
			if(this.calSetting.viewDisplay){
				this.calSetting.viewDisplay(this.getView());
			}
		},
		/*****************************************************
		 * 功能：下一页
		 ****************************************************/
		next : function(){
			this.start.setMonth(this.start.getMonth()+1);
			this.end.setMonth(this.end.getMonth()+1);
			this.renderList(); 
			if(this.calSetting.viewDisplay){
				this.calSetting.viewDisplay(this.getView());
			}
		},
		/*****************************************************
		 * 功能：回到今天
		 ****************************************************/
		today : function(){
			var today = new Date();
			if(today.getTime()>=this.start.getTime() && today.getTime()<this.end.getTime())
				return;
			this.start = this.clearTime(today);
			this.start.setDate(1);
			this.end = $.fullCalendar.cloneDate(this.start);
			this.end.setMonth(today.getMonth()+1);
			this.end.setDate(1);
			this.renderList(); 
			if(this.calSetting.viewDisplay){
				this.calSetting.viewDisplay(this.getView());
			}
		},
		/*****************************************************
		 * 功能：刷新视图数据
		 ****************************************************/
		refreshSchedules : function(){
			this.renderList(); 
			if(this.calSetting.viewDisplay){
				this.calSetting.viewDisplay(this.getView());
			}
		},
		/*****************************************************
		 * 功能：增加日程记录
		 ****************************************************/
		addSchedule : function(schedule){
			this.schedules.push(schedule);
			this._dataShow(this.start,this.end,this.schedules);
		},
		/*****************************************************
		 * 功能：删除日程记录
		 ****************************************************/
		removeSchedule : function(id){
			if(id!=null){
				var tmpArr = [];
				for(var i=0;i<this.schedules.length;i++){
					var tmpSch = this.schedules[i];
					if(tmpSch.id !=id){
						tmpArr.push(tmpSch);
					}
				}
				this.schedules = tmpArr;
			}else{
				this.schedules = [];
			}
			this._dataShow(this.start,this.end,this.schedules);
		},
		/*****************************************************
		 * 功能：更新日程记录
		 ****************************************************/
		updateSchedule : function(schedule){
			var isFind = false;
			for(var i=0;i<this.schedules.length;i++){
				var tmpSch = this.schedules[i];
				if(schedule.id && tmpSch.id == schedule.id){
					this.schedules[i] = schedule;
					if(!isFind)
						isFind = true;
				}
			}
			if(isFind){
				this._dataShow(this.start,this.end,this.schedules);
			}
		},
		/*****************************************************
		 * 功能：重定义时间区间
		 ****************************************************/
		 resizeDateRange:function(refStartDate,refEndDate){
			var today = new Date();
			if(today.getTime() >= refStartDate.getTime() && today.getTime()<refEndDate.getTime()){
				this.start = this.clearTime(today);
				this.start.setDate(1);
				this.end = $.fullCalendar.cloneDate(this.start);
				this.end.setMonth(today.getMonth()+1);
				this.end.setDate(1);
			}else{
				var tmpEndDate = $.fullCalendar.cloneDate(refEndDate);
				tmpEndDate.setDate(tmpEndDate.getDate()-1);
				this.start = this.clearTime(tmpEndDate);
				this.start.setDate(1);
				this.end = $.fullCalendar.cloneDate(this.start);
				this.end.setMonth(this.start.getMonth()+1);
				this.end.setDate(1);
			}
			this.drawed = false;
		}
	});
	
	var FullCalendarMode = AbstractCalenderMode.extend({
		initialize:function($super,_config){
			$super(_config);
			this.calSources = [];
			this.init();
		},
		/********************************************
		 * 功能：绘制日期时，日期显示时调用
		 * 参数：date 	当前日期时间
		 * 		cellObj	日期显示所在单元格对象
		 ********************************************/
		_dayShow : function(date,cellObj){
			var numberObj = cellObj.find(".fc-day-number");
			if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn'){
				numberObj.append("&nbsp;&nbsp;" + solarDay(date)); 
			}
			if(window.console)
				window.console.log("FullCalendar:_dayShow");
		},
		/********************************************
		 * 功能：日历点击或选择时执行
		 * 参数：
		 * 		startDate	开始时间
		 * 		endDate		结束时间
		 * 		allDay		是否是全天
		 * 		evt			jquery事件对象
		 ********************************************/
		_select : function(startDate, endDate, allDay , evt){
			if(this.calendar.showStatus!='view')
				topic.channel(this.calendar).publish(LUI_CALENDAR_SELECT,{'start':startDate,'end':endDate,'allDay':allDay,'evt':evt});
			if(window.console)
				window.console.log("FullCalendar:_select");
		},
		/********************************************
		 * 功能：日历空白区域失去选择时执行
		 * 参数：
		 * 		evt  jquery事件对象
		 ********************************************/
		_unselect : function(evt){
			if(this.calendar.showStatus!='view')
				topic.channel(this.calendar).publish(LUI_CALENDAR_UNSELECT,{'evt':evt});
			if(window.console)
				window.console.log("FullCalendar:_unselect");
		},
		/***********************************************
		 * 功能：	日历数据日期大小改变
		 * 参数：
		 * 			thing			日历数据
		 * 			dayDelta		天数位移量 负值表示往前移动
		 * 			minuteDelta     分钟位移量
		 * 			moveFun			移动函数（自定义操作后回调此函数）//暂时无用
		 * 			evt				此种情况下为空
		 * 			ui				jqueryui变量
		 *说明：		发布事件中，传递resize后的日历数据
		 **********************************************/
		_scheduleResize : function(thing,dayDelta,minuteDelta,moveFun,evt,ui){
			if(this.calendar.showStatus=='drag'){
				var param={
						'resize':true,
						'schedule':thing,
						'dayDelta':dayDelta,
						'minuteDelta':minuteDelta,
						'start':thing.start,
						'end':thing.end,
						'evt':evt
				};
				topic.channel(this.calendar).publish(LUI_CALENDAR_THING_CHANGE,param);
			}
			if(window.console)
				window.console.log("FullCalendar:_scheduleResize");
		},
		/***********************************************
		 * 功能：	日历数据拖拽
		 * 参数：
		 * 			thing			日历数据
		 * 			dayDelta		天数位移量 负值表示往前移动
		 * 			minuteDelta     分钟位移量
		 * 			allday			是否为整天
		 * 			moveFun			移动函数（自定义操作后回调此函数）//暂时无用
		 * 			evt				jquery事件变量
		 * 			ui				jqueryui变量
		 *说明：		发布事件中，传递拖拽后的日历数据
		 **********************************************/
		_scheduleDrag : function(thing, dayDelta, minuteDelta, allDay , moveFun , evt, ui){
			if(this.calendar.showStatus=='drag'){
				var param={
						'schedule':thing,
						'dayDelta':dayDelta,
						'minuteDelta':minuteDelta,
						'start':thing.start,
						'end':thing.end,
						'evt':evt,
						'allDay':allDay,
						'moveFun':moveFun
				};
				topic.channel(this.calendar).publish(LUI_CALENDAR_THING_CHANGE,param);
			}
			if(window.console)
				window.console.log("FullCalendar:_scheduleDrag");
		},
		/*********************************************
		 * 配置初始化
		 *********************************************/
		init : function(){
			var self = this;
			var tmpConfig={};
			//绘制日历时调用
			tmpConfig.dayRender = function(date,cellObj){
				self._dayShow(date,cellObj);
			};
			//日历点击时触发
			tmpConfig.dayClick = function(date, allDay, evt){
				if(window.console)
					window.console.log("FullCalendar:click");
			};
			
			//日历数据拖动开始时调用
			tmpConfig.eventDragStart = function(thing, evt, ui){
				if(window.console)
					window.console.log("FullCalendar:eventDragStart");
			};
			
			//日历数据拖动结束时调用
			tmpConfig.eventDragStop = function(thing, evt, ui){
				if(window.console)
					window.console.log("FullCalendar:eventDragStop");
			};
			//日历数据拖动后调用
			tmpConfig.eventDrop = function(thing, dayDelta, minuteDelta, allDay , moveFun , evt, ui){
				self._scheduleDrag(thing, dayDelta, minuteDelta, allDay , moveFun , evt, ui);
			};
			//日历数据时间事件区域开始时执行
			tmpConfig.eventResizeStart = function(thing,evt){
				if(window.console)
					window.console.log("FullCalendar:eventResizeStart");
			};
			//日历数据时间事件区域结束时执行
			tmpConfig.eventResizeStop = function(thing,evt){
				if(window.console)
					window.console.log("FullCalendar:eventResizeStop");	
			};
			//日历数据调整时间区域时执行
			tmpConfig.eventResize = function(thing,dayDelta,minuteDelta,moveFun,evt,ui){
				self._scheduleResize(thing,dayDelta,minuteDelta,moveFun,evt,ui);
			};
			
			//日历区域选择时执行
			tmpConfig.select = function(startDate, endDate, allDay , evt){
				self._select(startDate, endDate, allDay , evt);
			};
			//日历区域选择离开时执行
			tmpConfig.unselect = function(evt){
				self._unselect(evt);
			};
			//TODO 暂不清楚什么时候调用
			tmpConfig.drop = function(){
				if(window.console)
					window.console.log("drop");
			};
			this.calSetting = Object.extend(this.calSetting,tmpConfig);
		},
		/****************************************************
		 * 功能：fullCalander 绘制
		 ****************************************************/
		draw : function(){
			if(!this.drawed){
				this.calendarDiv.fullCalendar(this.calSetting);
			}
			this.drawed = true;
			this.calendarDiv.show();
			if(this.refDate!=null)
				this.calendarDiv.fullCalendar("gotoDate",this.refDate);
		},
		/*****************************************************
		 * 功能：将格式化的html，显示在对应位置
		 * 参数：
		 * 		dom 	显示区域
		 * 		html	格式化后的html
		 ****************************************************/
		scheduleShow : function(dom, html){
			dom.find(".fc-event-inner").html(html);
		},
		/********************************************
		 * 功能：获取当前视图信息
		 ********************************************/
		getView : function(){
			return this.calendarDiv.fullCalendar('getView');
		},
		/***********************************************
		 * 功能：更改为另一种日历视图
		 * 参数：view	日历视图名称
		 * 		支持的视图名有：month,basicWeek,basicDay,agendaWeek,agendaDay
		 ********************************************/
		changeView : function(viewName){
			this.calendarDiv.fullCalendar('changeView',viewName);
		},
		/*******************************************
		 * 功能：日历翻页上一页
		 ********************************************/
		prev : function(){
			var self = this;
			if(this.calSources.length>0){
				for ( var i = 0; i < this.calSources.length; i++) {
					this.calendarDiv.fullCalendar("removeEventSource",this.calSources[i]);
				}
				this.calSources = [];
			}
			this.calendarDiv.fullCalendar('prev');
		},
		/********************************************
		 * 功能：日历翻页下一页
		 ********************************************/
		next : function(){
			var self = this;
			if(this.calSources.length>0){
				for ( var i = 0; i < this.calSources.length; i++) {
					this.calendarDiv.fullCalendar("removeEventSource",this.calSources[i]);
				}
				this.calSources = [];
			}
			this.calendarDiv.fullCalendar('next');
		},
		/*********************************************
		 * 功能：日历回到当前日期页
		 ********************************************/
		today : function(){
			var self = this;
			if(this.calSources.length>0){
				for ( var i = 0; i < this.calSources.length; i++) {
					this.calendarDiv.fullCalendar("removeEventSource",this.calSources[i]);
				}
				this.calSources = [];
			}
			this.calendarDiv.fullCalendar('today');
		},
		/*********************************************
		 * 功能：重新获取当前视图数据
		 ********************************************/
		refreshSchedules : function(){
			var self = this;
			if(this.calSources.length>0){
				for ( var i = 0; i < this.calSources.length; i++) {
					this.calendarDiv.fullCalendar("removeEventSource",this.calSources[i]);
				}
				this.calSources = [];
			}
			this.calendarDiv.fullCalendar('refetchEvents');
		},
		/*********************************************
		 * 功能：新增日历数据展示
		 * 参数：schedule	数据信息，数组,对象或函数,
		 *				数据格式参考函数_scheduleGet中数据要求
		 *********************************************/
		addSchedule : function(schedule){
			if(!$.isArray(schedule) && schedule.start != null){
				schedule = [schedule];
			}
			this.calSources.push(schedule);
			this.calendarDiv.fullCalendar("addEventSource",schedule);
		},
		/*********************************************
		 * 功能：删除视图数据
		 * 参数：id		数据id信息，为空则全部删除
		 ********************************************/
		removeSchedule : function(id){
			this.calendarDiv.fullCalendar("removeEvents",id);
		},
		/*********************************************
		 * 功能：修改视图数据
		 * 参数：
		 *		schedule 数据信息，数据格式参考函数_scheduleGet中数据要求,
		 *           修改前后数据的id必须一致
		 ********************************************/
		updateSchedule : function(schedule){
			if(schedule.id){
				if(typeof(schedule.start)=="string")
					schedule.start = $.fullCalendar.parseDate(schedule.start,this.calSetting.ignoreTimezone);
				if(schedule.end!=null && schedule.end!='')
					schedule.end = $.fullCalendar.parseDate(schedule.end,this.calSetting.ignoreTimezone);
				var eventArray=this.calendarDiv.fullCalendar('clientEvents',schedule.id);//客户端保存的日程集合
				if(eventArray.length>0){
					var e=eventArray[0];
					for(var key in schedule){
						e[key]=schedule[key];
					}
				}
				this.calendarDiv.fullCalendar("updateEvent",e);
			}
		},
		/*****************************************************
		 * 功能：重定义时间区间
		 ****************************************************/
		 resizeDateRange:function(refStartDate,refEndDate){
			var today = new Date();
			if(today.getTime() >= refStartDate.getTime() && today.getTime()<refEndDate.getTime()){
			}else{
				var tmpDate = $.fullCalendar.cloneDate(refStartDate);
				this.refDate  = tmpDate;
				this.refDate = this.clearTime(this.refDate);
			}
		}
		
	});
	
	
	function getDayNamesShort(){
		var prefix=commonlang['resource.period.type.week.name'];
		var dayNamesShort=commonlang['calendar.week.shortNames'].split(',');
		if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn'){
			for(var i=0;i<dayNamesShort.length;i++){
				dayNamesShort[i]=prefix+dayNamesShort[i];
			}
		}
		return dayNamesShort;
	}
	
	/****************************************************************
	 *功能：Calendar对象，日历绘制及交互处理对象
	****************************************************************/
	var Calendar =  base.Container.extend({
		/***********************************************************
		 *	Calendar UI控件使用默认参数 
		 ***********************************************************/
		defaultSetting:{
			theme: false,  						//	是否应用
			header: {                           //	头部的布局
            	left: 'prev,today,next',		//	prevYear,prev,today,next,nextYear
            	center: 'title',				//	标题
            	right: 'month,agendaWeek'		//	month,basicWeek,basicDay,agendaWeek,agendaDay
        	},
        	monthNames: commonlang['calendar.month.shortNames'].split(','),
        	monthNamesShort: commonlang['calendar.month.names'].split(','),
        	dayNames:commonlang['calendar.week.names'].split(','),
        	dayNamesShort: getDayNamesShort(),
        	buttonText:{
        		today:    lang['ui.calendar.today'],
        		month:    lang['ui.calendar.mode.month'],
        		agendaWeek: lang['ui.calendar.mode.week'],
        		basicWeek: lang['ui.calendar.mode.list'],
        		day:    lang['ui.calendar.mode.day']
        	},
        	allDayDefault: true,
        	ignoreTimezone: true,
        	allDaySlot:true,					//  是否显示全天
        	allDayText:lang['ui.calendar.allDayText'],
        	slotMinutes:30,						//	时间间隔
        	slotEventOverlap:false,				//  数据是否可重叠
        	titleFormat:{						//  标题格式化
        	    month:(Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn')? 'yyyy年 M月':'MM/yyyy',                             
        	    week:(Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn')? "yyyy年M月d日{ ' -  'yyyy年M月d日 }":"MM/dd/yyyy{' - 'MM/dd/yyyy}",
        	    day: (Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn')?'yyyy年M月d日 ':'MM/dd/yyyy'   
        	},
        	
        	firstDay:1,							//	周一是第一天
        	weekends:true,						//	显示周末
        	isRTL:false,						//	日期从左算起
        	weekMode:'fixed',					//	周视图显示fixed（固定显示6周高，高度永远保持不变）、liquid（不固定周数，周高度可变化）、variable（不固定周数，但高度固定）
        	//height: 700,						//	日历高度（含表头）
        	//contentHeight: 550,				//  内容高度
        	aspectRatio:2,					    //	单元格宽与高度的比值   	注意：此属性不能与日历高度同时存在
        	defaultView:'month',				//  默认显示视图
        	editable:false,						//  是否编辑
        	disableDragging: true,				//  是否不允许拖拽
        	disableResizing: true,				//  是否不允许调节大小
        	lazyFetching: true,					//	日历切换时允许使用已有的日历缓存
        	startParam: 'fdStart',				//	数据请求参数开始时间
        	endParam: 'fdEnd',					//	数据请求参数结束时间
    		selectable: false,
    		axisFormat:'HH:mm',					//	agenda视图显示格式
    		//minTime:'7:00',					//  起始时间	
        	//maxTime:'21:00',					//  结束时间
    		//unselectAuto: true,
    		dragOpacity: {						//设置拖动时事件的透明度 
                agenda: .5,
                '': .6
            },
    		dropAccept: '*'	
		},
		/********************************************************************
		 * 功能：模式配置
		 ********************************************************************/
		modeSetting:{
			"default" : {
				id:"default",
				name : "默认日历",
				func : FullCalendarMode,
				cache: null
			},
			"list" :{
				id:"list",
				name : "列表日历",
				func : ListCalendarMode,
				cache: null
			}
		},
		/********************************************************************
		 * 功能：初始化
		 ********************************************************************/
		initProps : function($super,_config){
			$super(_config);
			this.config = _config;
			
			this.dateFormat=seajs.data.env.pattern.datetime
			
			this.mode = "default";			//calendar显示模式default，list
			if(this.config.mode != null && this.config.mode!=''){
				this.mode = this.config.mode;
			}
			//自定义视图mode的处理
			if(this.config.customMode !=null && this.config.customMode!=''){
				var funStr = "return " + this.config.customMode + ";";
				var cfgObj = new Function(funStr)();
				
				var custonCfg = null;
				if($.isFunction(cfgObj)){
					custonCfg = cfgObj.apply();
				}else if(typeof(cfgObj)=='object'){
					custonCfg = cfgObj;
				}else if(typeof(cfgObj)=='string'){
					custonCfg = window[cfgObj]();
				}
				
				if(custonCfg && custonCfg.id){
					var tmpObj={};
					tmpObj[custonCfg.id] = custonCfg;
					this.modeSetting = Object.extend(this.modeSetting,tmpObj);
				}
				
				/*
				if(custonCfg && custonCfg.id && custonCfg.func){
					var tmpFunc = custonCfg.func;
					var isRegular = false;
					while(tmpFunc.superclass){
						if(tmpFunc.superclass==AbstractCalenderMode){
							isRegular = true;
							break;
						}
						tmpFunc = tmpFunc.superclass;
					}
					if(isRegular==true){
						var tmpObj={};
						tmpObj[custonCfg.id] = custonCfg;
						this.modeSetting = Object.extend(this.modeSetting,tmpObj);
					}
				}
				*/
			}
			
			this.defaultSetting.header = null;
			this.showStatus = "view";			//calendar编辑模式view,edit,drag
			if(this.config.showStatus!=null && this.config.showStatus!=''){
				this.showStatus = this.config.showStatus;
			}
			if(this.showStatus=='view'){
				this.defaultSetting.editable = false;
				this.defaultSetting.disableDragging = true;
				this.defaultSetting.disableResizing = true;
				this.defaultSetting.selectable = false;
			}else if(this.showStatus=='edit'){
				this.defaultSetting.editable = true;
				this.defaultSetting.selectable = true;
				this.defaultSetting.disableDragging = true;
				this.defaultSetting.disableResizing = true;
			}else if(this.showStatus=='drag'){
				this.defaultSetting.editable = true;
				this.defaultSetting.selectable = true; 
				this.defaultSetting.disableDragging = false;
				this.defaultSetting.disableResizing = false;
			}
			this.eventInit();
			this.element.show();
		},
		/********************************************************************
		 * 功能：事件初始化
		 ********************************************************************/
		eventInit:function(){
			var self = this;
			//视图切换翻页时调用
			this.defaultSetting.viewDisplay = function(view){
				self._changeViewOrMode(view);
			};
			//获取日历数据时调用
			this.defaultSetting.events = function(start,end,callback,moreparams){
				self._scheduleGet(start,end,callback,moreparams);
			};
			//获取日历数据开始和结束时调用
			this.defaultSetting.loading = function(status){
				self._scheduleLoading(status);
			};
			//绘制日历数据时调用
			this.defaultSetting.eventRender = function(thing , element){
				self._scheduleRender(thing , element);
			};
			//日历数据绘制结束时调用
			//this.defaultSetting.eventAfterRender = function(thing , element){
			//};
			//日历数据鼠标放上去时执行
			this.defaultSetting.eventMouseover = function(thing,evt){
				if(window.console)
					window.console.log("Calendar:eventMouseover");
			};
			//日历数据鼠标移出时执行
			this.defaultSetting.eventMouseout = function(thing,evt){
				if(window.console)
					window.console.log("Calendar:eventMouseout");
			};
			//日历数据鼠标点击时执行
			this.defaultSetting.eventClick = function(thing,evt){
				self._scheduleClick(thing, evt);
			};
			
		},
		addChild: function($super,obj) {
			if(obj instanceof base.Layout){
				this.layout = obj;
			}
			if(obj instanceof source.BaseSource){
				this.source = obj;
			}
			
			if(obj instanceof base.DataRender){
				this.render = obj;
			}
		},
		startup: function(){
			var self = this;
			if(this.config.layout!=null){
				var _cfg = Object.extend({"parent":this,"kind":"calendar"},this.config.layout);
				this.layout = new layout[this.config.layout.type](_cfg);
			}
			if(this.config.source!=null){
				this.source = new source[this.config.source.type](this.config.source);
			}
		},
		/********************************************************************
		 * 功能：布局绘制
		 ********************************************************************/
		doLayout: function($super,obj){
			var calLayout = $(obj);
			this.element.append(calLayout);
			this.layoutDom = calLayout;
			this.changeMode(this.mode);
		},
		destroy:function(){
			
		},
		/***********************************************
		 * 功能：当日历视图切换、翻页、模式切换时触发此函数
		 * 参数：view	视图对象，主要信息有：
		 *             	name: 包括month,basicWeek,basicDay,agendaWeek,agendaDay
		 *				title: 标题内容(例如"September 2009" or "Sep 7 - 13 2009")
		 *				start:Date类型, 该view下的第一天.
		 *				end:Date类型, 该view下的最后一天.  由于是一个闭合的值, 所以, 比如在month view下, 10月这个月份, 那么end对应的应该是11月的第一天.
		 *				visStart:Date类型. 在该view下第一个可以访问的day. month view下, 该值是当月的第一天, week view下, 则通常和start一致.
		 *				visEnd: Date类型, 最后一个可访问的day
		 ************************************************/
		 _changeViewOrMode : function(view){
			this.emit("viewOrModeChange",{"mode":this.mode,"view":view});
			if(window.console){
				window.console.log("Calendar:_changeViewOrMode");
			}
		},
		/*******************************************************
		 * 功能：获取日历中数据
		 * 参数：start		开始时间
		 * 		 	  end		日历结束时间
		 * 		      callback	日历数据获取后回调函数
		 *      	  moreparams 更多查询参数:{}	
		 * 数据格式：
		 * [
		 * 		{
		 *			id			标示	 		
		 * 			title		标题（必填）
		 * 			start		开始时间（必填）
		 * 			end			结束时间
		 *			allDay		是否整天（true/false）
		 *			url			指定后，点击后会跳转至该url中
		 * 			className	日历事务显示样式
		 *			editable	是够允许拖拽
		 *			color		背景颜色和边框颜色
		 *			backgroundColor背景样色
		 *			borderColor	边框颜色
		 *			textColor	文本颜色	
		 * 		}
		 * ....
		 * ]
		 ******************************************************/
		_scheduleGet : function(start,end,callback,moreparams){
			if(this.source != null){
				var sourceVar = this.source;
				var params = {};
				if(moreparams!=null){
					params=$.extend(params,moreparams);
				}
				params[this.defaultSetting.startParam] = $.fullCalendar.formatDate(start,this.dateFormat);
				params[this.defaultSetting.endParam] = $.fullCalendar.formatDate(end,this.dateFormat) ;
				params['s_seq'] = Math.random();
				if(this.source.resolveUrl){
					this.source.params = params;
					this.source.resolveUrl(params);
				}
				this.source.one('data',function(data){
					callback(data);
				} , this);
				this.source.get();
			}else{
				callback(null);
			}
			if(window.console)
				window.console.log("Calendar:_scheduleGet");
		},
		/*********************************************
		 * 功能：calendar数据加载效果
		 * 参数：status	true正在加载中，false已加载完成
		 *********************************************/
		_scheduleLoading:function(status){
			if(status){
				this.__dialog = dialog.loading(lang['ui.calendar.loading']);
			}else{
				if(this.__dialog)
					this.__dialog.hide();
			}
			if(window.console)
				window.console.log("Calendar:_scheduleLoading");
		},
		/***********************************************
		 * 功能：	日历数据绘制
		 * 参数：
		 * 			thing   绘制的单个日历数据对象
		 * 			element	日历数据dom容器
		 **********************************************/
		_scheduleRender:function(thing,element){
			var self = this;
			if(this.render!=null){
				this.render.get(thing,function(html){
					if(self.CalenderObj.scheduleShow){
						self.CalenderObj.scheduleShow(element,html);
					}
				});
			}
		},
		/***********************************************
		 * 功能：	日历数据点击
		 * 参数：
		 * 			thing			日历数据
		 * 			evt				此种情况下为空
		 **********************************************/
		_scheduleClick:function(thing,evt){
			topic.channel(this).publish(LUI_CALENDAR_THING_CLICK,{'schedule':thing,'evt':evt});
			if(window.console)
				window.console.log("Calendar:_scheduleClick");
		},
		/*********************************************
		 * 功能：返回calendar对象
		 *********************************************/
		getCalendar:function(){
			return this.CalenderObj;
		},
		/********************************************
		 * 功能：获取当前视图信息
		 ********************************************/
		getView:function(){
			if(this.CalenderObj && this.CalenderObj.getView)
				return this.CalenderObj.getView();
			return null;
		},
		/***********************************************
		 * 功能：更改为另一种日历视图
		 * 参数：view	日历视图名称
		 * 		list模式下只有：listMonth
		 * 		default模式下视图名有：month,basicWeek,basicDay,agendaWeek,agendaDay
		 ********************************************/
		changeView:function(viewName){
			if(this.CalenderObj && this.CalenderObj.changeView)
				return this.CalenderObj.changeView(viewName);
			return null;
		},
		/************************************************
		 * 功能：更改为另一种展示模式
		 * 参数：modeName	显示模式名称
		 ********************************************/
		changeMode:function(modeName){
			var modeInfo = this.modeSetting[modeName];
			if(modeInfo == null) return;
			var oldView = this.getView();
			if(this.fullCal!=null)
				this.fullCal.hide();
			this.fullCal = this.layoutDom.find('[data-lui-mark="calender.content.inside.' + modeName + '"]');
			
			var self=this;
			this.createCalendarObj(modeInfo)
				.then(function(){//创建CalendarObj成功
					self.mode = modeName;
					if(oldView && oldView.start && oldView.end){
						self.CalenderObj.resizeDateRange(oldView.start,oldView.end);
					}
					self.CalenderObj.draw();
					self.fullCal.show();
					self._changeViewOrMode(self.getView());
				})
				.fail(function(){//创建CalendarObj失败
					console.log('未找到继承自AbstractCalenderMode的自定义视图,CalendarObj创建失败');
				});
		},
		/**
		 * 异步构建Calendar对象
		 */
		createCalendarObj:function(modeInfo){
			var self=this,
				deferred=$.Deferred();
			if(modeInfo.cache == null){//未缓存
				var tmpFunc = modeInfo.func;
				if(Object.isString(tmpFunc)){//tmpFunc为字符串时认为是文件路径
					seajs.use([tmpFunc],function(t){
						if(self.isAbstractCalenderMode(t)){
							self.CalenderObj = new t({container:self.fullCal,calendar:self,setting:self.defaultSetting});
							modeInfo.cache = self.CalenderObj;
							deferred.resolve();
						}else{
							deferred.reject();
						}
					});
				}else{//tmpFunc为function时认为是继承自AbstractCalenderMode的类
					if(self.isAbstractCalenderMode(tmpFunc)){
						this.CalenderObj = new tmpFunc({container:this.fullCal,calendar:this,setting:this.defaultSetting});
						modeInfo.cache = this.CalenderObj;
						deferred.resolve();
					}else{
						deferred.reject();
					}
				}
			}else{//已缓存
				this.CalenderObj = modeInfo.cache;
				deferred.resolve();
			}
			return deferred.promise();
		},
		//是否继承自isAbstractCalenderMode
		isAbstractCalenderMode:function(func){
			if(func){
				while(func.superclass){
					if(func.superclass==AbstractCalenderMode){
						return true;
					}
					tmpFunc = tmpFunc.superclass;
				}
			}
			return false;
		},
		/*******************************************
		 * 功能：日历翻页上一页
		 ********************************************/
		prev : function(){
			if(this.CalenderObj && this.CalenderObj.prev)
				this.CalenderObj.prev();
		},
		/********************************************
		 * 功能：日历翻页下一页
		 ********************************************/
		next : function(){
			if(this.CalenderObj && this.CalenderObj.next)
				this.CalenderObj.next();
		},
		/*********************************************
		 * 功能：日历回到当前日期页
		 ********************************************/
		today: function(){
			if(this.CalenderObj && this.CalenderObj.today)
				this.CalenderObj.today();
		},
		/*********************************************
		 * 功能：重新获取当前视图数据
		 ********************************************/
		refreshSchedules:function(){
			if(this.CalenderObj && this.CalenderObj.refreshSchedules)
				this.CalenderObj.refreshSchedules();
		},
		/*********************************************
		 * 功能：新增日历数据展示
		 * 参数：schedule	数据信息，数组,对象或函数,
		 *				数据格式参考函数_scheduleGet中数据要求
		 *********************************************/
		addSchedule:function(schedule){
			if(this.CalenderObj && this.CalenderObj.addSchedule)
				this.CalenderObj.addSchedule(schedule);
		},
		/*********************************************
		 * 功能：删除视图数据
		 * 参数：id		数据id信息，为空则全部删除
		 ********************************************/
		removeSchedule:function(id){
			if(this.CalenderObj && this.CalenderObj.removeSchedule)
				this.CalenderObj.removeSchedule(id);
		},
		/*********************************************
		 * 功能：修改视图数据
		 * 参数：
		 *		schedule 数据信息，数据格式参考函数_scheduleGet中数据要求,
		 *           修改前后数据的id必须一致
		 ********************************************/
		updateSchedule:function(schedule){
			if(this.CalenderObj && this.CalenderObj.updateSchedule)
				this.CalenderObj.updateSchedule(schedule);
		},
		/********************************************
		 * 功能：替换数据源
		 * 参数：
		 * 		sourceCfg	数据源参数配置
		 *******************************************/
		replaceDataSource:function(sourceCfg){
			if(sourceCfg!=null){
				this.source = new source[sourceCfg.type](sourceCfg);
				this.refreshSchedules();
			}
		}
	});
	
	exports.solarDay = solarDay;
	exports.Calendar = Calendar;
	exports.AbstractCalenderMode = AbstractCalenderMode;
});