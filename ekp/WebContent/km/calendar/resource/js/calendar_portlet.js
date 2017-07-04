define( function(require, exports, module) {
	var base = require("lui/base");
	var env = require('lui/util/env');
	var $ = require("lui/jquery");
	var dialog=require("lui/dialog");
	var topic=require("lui/topic");
	var dateutil=require("km/calendar/resource/js/dateUtil");
	var lang=require('lang!km-calendar');
 
	var lunarInfo = [0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2, 0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977, 0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970, 0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950, 0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557, 0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0, 0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0, 0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6, 0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570, 0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0, 0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5, 0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930, 0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530, 0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45, 0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0];
	var solarMonth = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	var Gan = new Array("甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸");
	var Zhi = new Array("子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌","亥");
	var Animals = new Array("鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡","狗", "猪");
	var solarTerm = new Array("小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨","立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露","霜降", "立冬", "小雪", "大雪", "冬至");
	var sTermInfo = new Array(0, 21208, 42467, 63836, 85337, 107014, 128867,150921, 173149, 195551, 218072, 240693, 263343, 285989, 308563,331033, 353350, 375494, 397447, 419210, 440795, 462224, 483532,504758);
	var nStr1 = new Array('日', '一', '二', '三', '四', '五', '六', '七', '八', '九', '十');
	var nStr2 = new Array('初', '十', '廿', '卅', '　');
	var monthName = new Array("1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月","9月", "10月", "11月", "12月");
	
	// 国历节日 *表示放假日
	var sFtv = new Array();
	// 农历节日 *表示放假日
	var lFtv = new Array();
	// 某月的第几个星期几
	var wFtv = new Array();

	// 传回农历 y年的总天数
	var lYearDays = function(y) {
		var i, sum = 348;
		for (i = 0x8000; i > 0x8; i >>= 1)
			sum += (lunarInfo[y - 1900] & i) ? 1 : 0;
		return (sum + leapDays(y));
	};

	// ====================================== 传回农历 y年闰月的天数
	var leapDays = function(y) {
		if (leapMonth(y))
			return ((lunarInfo[y - 1900] & 0x10000) ? 30 : 29);
		else
			return (0);
	};

	// ====================================== 传回农历 y年闰哪个月 1-12 , 没闰传回 0
	var leapMonth = function(y) {
		return (lunarInfo[y - 1900] & 0xf);
	};

	// ====================================== 传回农历 y年m月的总天数
	var monthDays = function(y, m) {
		return ((lunarInfo[y - 1900] & (0x10000 >> m)) ? 30 : 29);
	};

	// ====================================== 算出农历, 传入日期物件, 传回农历日期物件
	// 该物件属性有 .year .month .day .isLeap .yearCyl .dayCyl .monCyl
	var Lunar = function(objDate) {

		var i, leap = 0, temp = 0;
		var baseDate = new Date(1900, 0, 31);
		var offset = (objDate - baseDate) / 86400000;

		this.dayCyl = offset + 40;
		this.monCyl = 14;

		for (i = 1900; i < 2050 && offset > 0; i++) {
			temp = lYearDays(i);
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
		leap = leapMonth(i); // 闰哪个月
		this.isLeap = false;
		for (i = 1; i < 13 && offset > 0; i++) {
			//闰月
			if (leap > 0 && i == (leap + 1) && this.isLeap == false) {
				--i;
				this.isLeap = true;
				temp = leapDays(this.year);
			} else {
				temp = monthDays(this.year, i);
			}
			//解除闰月
			if (this.isLeap == true && i == (leap + 1))
				this.isLeap = false;
			offset -= temp;
			if (this.isLeap == false)
				this.monCyl++;
		}

		if (offset == 0 && leap > 0 && i == leap + 1)
			if (this.isLeap) {
				this.isLeap = false;
			} else {
				this.isLeap = true;
				--i;
				--this.monCyl;
			}

		if (offset < 0) {
			offset += temp;
			--i;
			--this.monCyl;
		}

		this.month = i;
		this.day = offset + 1;
	};

	// ==============================传回国历 y年某m+1月的天数
	var solarDays = function(y, m) {
		if (m == 1)
			return (((y % 4 == 0) && (y % 100 != 0) || (y % 400 == 0)) ? 29
					: 28);
		else
			return (solarMonth[m]);
	};
	// ============================== 传入 offset 传回干支, 0=甲子
	var cyclical = function(num) {
		return (Gan[num % 10] + Zhi[num % 12]);
	};

	// ============================== 月历属性
	var calElement = function(sYear, sMonth, sDay, week, lYear, lMonth, lDay,isLeap, cYear, cMonth, cDay) {

		this.isToday = false;
		// 国历
		this.sYear = sYear;
		this.sMonth = sMonth;
		this.sDay = sDay;
		this.week = week;
		// 农历
		this.lYear = lYear;
		this.lMonth = lMonth;
		this.lDay = lDay;
		this.isLeap = isLeap;
		// 干支
		this.cYear = cYear;
		this.cMonth = cMonth;
		this.cDay = cDay;

		this.color = '';

		this.lunarFestival = ''; // 农历节日
		this.solarFestival = ''; // 国历节日
		this.solarTerms = ''; // 节气
	};

	// ===== 某年的第n个节气为几日(从0小寒起算)
	var sTerm = function(y, n) {
		var offDate = new Date(
				(31556925974.7 * (y - 1900) + sTermInfo[n] * 60000)
						+ Date.UTC(1900, 0, 6, 2, 5));
		return (offDate.getUTCDate());
	};

	// ============================== 传回月历物件 (y年,m+1月)
	var calendar = function(y, m) {

		var sDObj, lDObj, lY, lM, lD = 1, lL, lX = 0, tmp1, tmp2;
		var lDPOS = new Array(3);
		var n = 0;
		var firstLM = 0;

		sDObj = new Date(y, m, 1); // 当月一日日期

		this.length = solarDays(y, m);// 国历当月天数
		this.firstWeek = sDObj.getDay()==0?6:sDObj.getDay()-1;// 国历当月1日星期几,星期一:0,星期二:1…………,星期天:6

		for ( var i = 0; i < this.length; i++) {
			if (lD > lX) {
				sDObj = new Date(y, m, i + 1); // 当月一日日期
				lDObj = new Lunar(sDObj); // 农历
				lY = lDObj.year; // 农历年
				lM = lDObj.month; // 农历月
				lD = lDObj.day; // 农历日
				lL = lDObj.isLeap; // 农历是否闰月
				lX = lL ? leapDays(lY) : monthDays(lY, lM); // 农历当月最後一天
				if (n == 0)
					firstLM = lM;
				lDPOS[n++] = i - lD + 1;
			}
			//sYear,sMonth,sDay,week,
			//lYear,lMonth,lDay,isLeap,
			//cYear,cMonth,cDay
			this[i] = new calElement(y, m + 1, i + 1,
					nStr1[(i + this.firstWeek) % 7], lY, lM, lD++, lL,
					cyclical(lDObj.yearCyl), cyclical(lDObj.monCyl),
					cyclical(lDObj.dayCyl++));
		}
		//节气
		tmp1 = sTerm(y, m * 2) - 1;
		tmp2 = sTerm(y, m * 2 + 1) - 1;
		this[tmp1].solarTerms = solarTerm[m * 2];
		this[tmp2].solarTerms = solarTerm[m * 2 + 1];
		for (i in sFtv)
			if (sFtv[i].match(/^(\d{2})(\d{2})([\s\*])(.+)$/))
				if (Number(RegExp.$1) == (m + 1)) {
					this[Number(RegExp.$2) - 1].solarFestival += RegExp.$4 + ' ';
					if (RegExp.$3 == '*')
						this[Number(RegExp.$2) - 1].color = 'black';
				}
		//月周节日
		for (i in wFtv)
			if (wFtv[i].match(/^(\d{2})(\d)(\d)([\s\*])(.+)$/))
				if (Number(RegExp.$1) == (m + 1)) {
					var _firstWeek=new Date(y,m,1).getDay();
					tmp1 = Number(RegExp.$2);
					tmp2 = Number(RegExp.$3);
					this[((_firstWeek > tmp2) ? 7 : 0) + 7 * (tmp1 - 1)
							+ tmp2 - _firstWeek ].solarFestival += RegExp.$5 + ' ';
				}
		//农历节日
		if(this[i] && !this[i].isLeap){
			for (i in lFtv)
				if (lFtv[i].match(/^(\d{2})(.{2})([\s\*])(.+)$/)) {
					tmp1 = Number(RegExp.$1) - firstLM;
					if (tmp1 == -11)
						tmp1 = 1;
					if (tmp1 >= 0 && tmp1 < n) {
						tmp2 = lDPOS[tmp1] + Number(RegExp.$2) - 1;
						if (tmp2 >= 0 && tmp2 < this.length) {
							this[tmp2].lunarFestival += RegExp.$4 + ' ';
							// if(RegExp.$3=='*') this[tmp2].color = 'black'
						}
					}
				}
		}
		//今日
		if (y == new Date().getFullYear() && m == new Date().getMonth())
			this[new Date().getDate() - 1].isToday = true;
	};

	// ====================== 中文日期
	var cDay = function(d) {
		var s;
		switch (d) {
		case 10:
			s = '初十';
			break;
		case 20:
			s = '二十';
			break;
		case 30:
			s = '三十';
			break;
		default:
			s = nStr2[Math.floor(d / 10)];
			s += nStr1[d % 10];
		}
		return (s);
	};
	
	var selectDay=new Date();//当前选中的日期,	Date格式
	var CalendarPortlet = base.Base.extend( {
		//初始化
		initProps : function($super, cfg) {
			$super(cfg);
			this.prefix = cfg.prefix;// 前缀,避免配置多个portlet时冲突
			
			var todayYear = new Date().getFullYear();
			var todayMonth = new Date().getMonth();
			
			this.selectYear=todayYear;//当前选中年
			this.selectMonth=todayMonth;//当前选中月
			
			this.startTime=new Date();//开始时间
			this.endTime=new Date();//结束时间
			
			this.setRangeTime(this.selectYear, this.selectMonth);//初始化开始时间、结束时间
			this.buildCld(todayYear, todayMonth);// 构建数据
			
		},
		//绘制calendar
		drawCld : function(SY, SM, eventsOfEverDay) {
			var self=this;
			//日历JQ对象
			var calendarDIV =$("#"+this.prefix+"calendar");
			// 翻到上一页事件
			calendarDIV.find(".prev").unbind("click").bind("click", function() {
				self.pushBtm('prev');
			});
			//翻到下一页事件
			calendarDIV.find(".next").unbind("click").bind("click", function() {
				self.pushBtm('next');
			});
			//回到今天事件
			calendarDIV.find(".today").unbind("click").bind("click", function() {
				self.pushBtm('');
			});
			//刷新事件
			calendarDIV.find(".refresh").unbind("click").bind("click", function() {
				self.buildCld(self.selectYear, self.selectMonth);
			});
			
			//题头年月，格式:XXXX年X月
			var ymbg =$("#"+this.prefix+"YMBG");
			var ymbgHTML=Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn'?SY+"年"+monthName[SM]:(SM+1)+"/"+SY;
			ymbg.html(" "+ymbgHTML);
			
			var i=0;
			for (i = 0; i < 42; i++) {
				var tt = 0;
				var gObj=$("#"+this.prefix+"GD"+i);
				var sObj = $("#"+this.prefix+"SD"+i);
				var lObj = $("#"+this.prefix+"LD"+i);
				
				// 绑定点击事件
				gObj.bind("click",function(){
					selectDay=$(this).data("date");
					self.showDayEvents(selectDay);
				});
				
				//双击新建窗口
				gObj.bind("dblclick",function(evt) {
					selectDay=$(this).data("date");
					self.openEventSimple(evt,selectDay);
				});
				
				var currentDate=new Date();
				currentDate.setTime(this.startTime.getTime());
				currentDate.setDate(this.startTime.getDate()+i);
				var cldElement=new calendar(currentDate.getFullYear(),currentDate.getMonth())[currentDate.getDate()-1];
				sObj.html(currentDate.getDate());//显示日期
				
				// 中文环境下显示农历
				if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn'){
					this.renderLunarHTML(cldElement, lObj);
				}
				
				sObj.removeClass();
				lObj.removeClass();
				//选中日高亮
				if (this.formatDate(currentDate)==this.formatDate(selectDay)) {
					self.showDayEvents(currentDate);
					sObj.addClass("todyaColor").addClass("selectColor"); // 今日颜色
					lObj.addClass("todyaColor").addClass("selectColor"); // 今日颜色
				}
				//不属于本月，不高亮显示
				if(currentDate.getMonth()!=this.selectMonth){
					sObj.css("color","#a7a6a4");// 不突出显示
					sObj.addClass("not_month");
				}
				//添加有日程的样式
				if (eventsOfEverDay[i]) {
					lObj.addClass("events");
				} else {
					lObj.removeClass("event");
				}
				gObj.attr("date",this.formatDate(currentDate));//记录日期字符串
				gObj.data("date",currentDate);//记录日期
			}
			//如果最后一行全部不属于本月,这一行不显示
			$("#"+this.prefix+"TR5").show();
			if($("#"+this.prefix+"SD35").hasClass("not_month")){
				$("#"+this.prefix+"TR5").hide();
			}
		},
		//渲染农历
		renderLunarHTML : function(cldObj, lObj) {
			var size, s;
			if (cldObj.lDay == 111111){
				// 显示农历月
				lObj.html( '<div style="padding-top:4px; height:18px" style="background-color:#07a5ec"><font color=#000000>'
						+ (cldObj.isLeap ? '闰' : '')
						+ cldObj.lMonth+ '月'
						+ (monthDays(cldObj.lYear, cldObj.lMonth) == 29 ? '小': '大') + '</font></div>');
			} 
			else{
				// 显示农历日
				lObj.html(cDay(cldObj.lDay));
			}
			s = cldObj.lunarFestival;
			if (s.length > 0) { //农历节日
				if (s.length > 6)
					s = s.substr(0, 4) + '…';
				s = s.fontsize('1');
			} else { //国历节日
				s = cldObj.solarFestival;
				if (s.length > 0) {
					size = (s.charCodeAt(0) > 0 && s.charCodeAt(0) < 128) ?8:4;
					if (s.length > size + 2)
						s = s.substr(0, size) + '…';
					s = s.fontsize('1');
				} else { //廿四节气
					s = cldObj.solarTerms;
					if (s.length > 0) {
						s = s.fontsize('1');
					}
				}
			}
			if (s.length > 0) {
				lObj.html(s);
			}
		},
		//根据年、月设置开始时间和结束时间
		setRangeTime : function(SY,SM){
			var cld = new calendar(SY, SM);
			var sD = 0- cld.firstWeek;
			//开始时间
			if(sD<=-1){
				var lastSM=SM-1;
				var lastSY=SY;
				if (lastSM < 0) {
					lastSM = 11;
					lastSY -= 1;
				}
				this.startTime=new Date(lastSY,lastSM,this.getLastDay(lastSY, lastSM) + sD+ 1);
			}else{
				this.startTime=new Date(SY,SM,1);
			}
			sD=41-cld.firstWeek;
			//结束时间
			if(sD >= cld.length){
				var nextSM=SM+1;
				var nextSY=SY;
				if(nextSM>11){
					nextSM=0;
					nextSY+=1;
				}
				this.endTime=new Date(nextSY,nextSM,sD - cld.length + 1);
			}else{
				this.endTime=new Date(SY,SM,this.getLastDay(SY,SM));
			}
		},
		//获取本月最后一天
		getLastDay : function(year,month){
			var nextMonth=month+1;
			var nextYear=year;
			if(nextMonth>11){
				nextMonth=0;
				nextYear+=1;
			}
			var next_date = new Date(nextYear,nextMonth, 1); // 下个月的第一天
			return (new Date(next_date.getTime() - 1000 * 60 * 60 * 24)).getDate();// 本月最后一天
		},
		//翻页
		pushBtm : function(K) {
			switch (K) {
			case 'prev':
				if(this.selectMonth>0){
					this.selectMonth--;
				}else{
					this.selectMonth=11;
					this.selectYear--;
				}
				break;
			case 'next':
				if(this.selectMonth<11){
					this.selectMonth++;
				}else{
					this.selectMonth=0;
					this.selectYear++;
				}
				break;
			default:
				this.selectYear=new Date().getFullYear();
				this.selectMonth=new Date().getMonth();
				selectDay=new Date();   
			}
			this.setRangeTime(this.selectYear, this.selectMonth);
			this.buildCld(this.selectYear, this.selectMonth);
		},
		//构建数据
		buildCld : function(SY, SM) {
			var self = this;
			var month = SM + 1;
			var startTimeStr=this.formatDate(this.startTime);
			
			var end=new Date();
			end.setTime(this.endTime.getTime());
			end.setDate(end.getDate()+1);
			
			var endTimeStr=this.formatDate(end);
			var url=env.fn.formatUrl("/km/calendar/km_calendar_main/kmCalendarMain.do?method=getEventsByRange&startTime="+startTimeStr+"&endTime="+endTimeStr);
			// 获取SY年SM月有日程的日期
			$.ajax( {
				url : url,
				dataType : 'json',
				success : function(datas) {
					var eventsOfEverDay = [];
					for ( var i = 0; i < datas.length; i++) {
						eventsOfEverDay[i] = datas[i];
					}
					self.drawCld(SY, SM, eventsOfEverDay);
				}
			});
		},
		//显示当天日程
		showDayEvents : function(date) {
			var self = this;
			var currentD;
			$("#" + this.prefix + "calendarDIV .selectColor").removeClass("selectColor");
			currentD=this.formatDate(date);//格式化日期
			var sObj=$("td[date='"+currentD+"']");
			$("td[date='"+currentD+"'] [id*=SD]").addClass("selectColor");//设为选中颜色
			$("td[date='"+currentD+"'] [id*=LD]").addClass("selectColor");//设为选中颜色
			var url=env.fn.formatUrl("/km/calendar/km_calendar_main/kmCalendarMain.do?method=getDayEvents&date="+currentD);
			$.ajax( {
				url : url,
				dataType : 'json',
				success : function(datas) {
					sObj.css("cursor","pointer");
					var liHtml = "";
					var moretip="";
					var length = datas.length;
					if (length > 4) {
						length = 3;
						moretip="<b>&nbsp;还有"+(datas.length-3)+"个日程.....</b>";
					}
					for ( var i = 0; i < length; i++) {
						var url=env.fn.formatUrl(datas[i].url);
						var startTime=dateutil.parseDate(datas[i].startTime);//开始时间,Date类型
						var endTime=dateutil.parseDate(datas[i].endTime);
						
						//标题格式:hh:mm~hh:mm {{docSubject}}
						var docSubject="";
						if(datas[i].isAllday){
							docSubject+=lang['kmCalendarMain.allDay'];
						}else{
							//日程开始时间小于点击日期，则显示"上班",否则显示日程的时间
							var today=date;
							dateutil.clearTime(today);
							if(startTime.getTime()<today.getTime()){
								docSubject+=lang['kmCalendarMain.onWork']+"~";
							}else{
								docSubject+=dateutil.formatDate(startTime,"hh:mm")+"~";
							}
							//日程结束时间大于等于点击日期的下一天，则显示"下班"，否则显示日程的时间
							var tomorrow=new Date(date.getTime()+1000*60*60*24);
							dateutil.clearTime(tomorrow);
							if(endTime.getTime()>=tomorrow.getTime()){
								docSubject+=lang['kmCalendarMain.offWork'];
							}else{
								docSubject+=dateutil.formatDate(endTime,"hh:mm");
							}
						}
						docSubject+="&nbsp;"+datas[i].docSubject;
						
						//title格式:MM-dd hh:mm~MM-dd hh:mm  {{docSubject}}
						var title=datas[i].startTime.substring(5);
						if(datas[i].endTime && datas[i].startTime!=datas[i].endTime){
							title+="~"+datas[i].endTime.substring(5);
						}
						title+="&nbsp;"+datas[i].docSubject;
						if(datas[i].hasRelation==true){
							liHtml+="<li><a title='"
								+ title
								+ "' class='textEllipsis' href='"+url
								+ "' target='_blank'>"
								+ docSubject
								+ "</a></li>";
						}else{
							liHtml+="<li><a href='javascript:void(0);' title='"
							+ title
							+ "' class='textEllipsis' onclick='openEvent(\""+datas[i].url+"\");'"
							+ ">"
							+ docSubject
							+ "</a></li>";
						}
					}
					liHtml+=moretip;
					document.getElementById(self.prefix+ "calendarList").innerHTML = liHtml;
				}
			});
		},
		//格式化日期
		formatDate: function(date){
			var dateStr="";
			var year=date.getFullYear();
			var month=date.getMonth()+1;
			var day=date.getDate();
			if(month<10){
				month="0"+month;
			}
			if(day<10){
				day="0"+day;
			}
			if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn'){
				dateStr=year+"-"+month+"-"+day;
			}else{
				dateStr=month+"/"+day+"/"+year;
			}
			return dateStr;
		},
		//打开日程对话框(简单页面)
		openEventSimple:function(evt,date){
			topic.publish("kmCalendar_openSimpleDialog",{evt:evt,date:date});
		},
		//打开日程对话框(详情页面)
		openEvent:function(url,method){
			var header=" ";
			if(method=='add'){
				header='<span class="event_lable_select" style="cursor:pointer;" id="event_base_label">新建日程&nbsp;</span>'
					+'|<span class="event_lable_unselect" style="cursor:pointer;" id="event_auth_label">&nbsp;共享</span>';
				if(selectDay!=null){
					var selectDayStr=this.formatDate(selectDay);
					url+="&startTime="+selectDayStr+"&endTime="+selectDayStr;
				}
			}else{
				header='<span class="event_lable_select" style="cursor:pointer;" id="event_base_label" >编辑日程&nbsp;</span>'
					+'|<span class="event_lable_unselect" style="cursor:pointer;" id="event_auth_label">&nbsp;共享</span>';
			}
			dialog.iframe(url,header,null,{width:700,height:500});
		}
	});
	exports.CalendarPortlet = CalendarPortlet;
});