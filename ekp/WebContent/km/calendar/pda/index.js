	Com_IncludeFile("jquery.js",null,"js");
	
	var lunarInfo = new Array(0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260,0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2, 0x04ae0, 0x0a5b6,0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0,0x14977, 0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54,0x02b60, 0x09570, 0x052f2, 0x04970, 0x06566, 0x0d4a0, 0x0ea50,0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0,0x0d2b2, 0x0a950, 0x0b557, 0x06ca0, 0x0b550, 0x15355, 0x04da0,0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0, 0x0aea6,0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950,0x05b57, 0x056a0, 0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4,0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6, 0x095b0, 0x049b0,0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60,0x09570, 0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58,0x055c0, 0x0ab60, 0x096d5, 0x092e0, 0x0c960, 0x0d954, 0x0d4a0,0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0,0x15176, 0x052b0, 0x0a930, 0x07954, 0x06aa0, 0x0ad50, 0x05b52,0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530, 0x05aa0,0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250,0x0d520, 0x0dd45, 0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577,0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0);
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
	var calElement = function(sYear, sMonth, sDay, week, lYear, lMonth, lDay,
			isLeap, cYear, cMonth, cDay) {

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
					tmp1 = Number(RegExp.$2);
					tmp2 = Number(RegExp.$3);
					this[((this.firstWeek > tmp2) ? 7 : 0) + 7 * (tmp1 - 1)
							+ tmp2 - this.firstWeek].solarFestival += RegExp.$5 + ' ';
				}
		//农历节日
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
	
	
	function calendarPda(){
		
		this.todayYear = new Date().getFullYear();
		this.todayMonth = new Date().getMonth();
		
		this.selectYear=this.todayYear;//当前选中年
		this.selectMonth=this.todayMonth;//当前选中月
		this.selectDay;//当前选中的日期，格式YYYY-MM-DD
		this.currentNumber;//当前选中日子的索引
		
		this.startTime=new Date();//开始时间
		this.endTime=new Date();//结束时间
		this.hasInit=false;
		
		//初始化
		this.init=function(){
			this.setRangeTime(this.selectYear, this.selectMonth);//初始化开始时间、结束时间
			this.buildCld(this.todayYear, this.todayMonth);// 构建数据
			this.hasInit=true;
		},
		//绘制calendar
		this.drawCld=function(SY, SM, eventsOfEverDay){
			var self=this;
			//日历JQ对象
			var calendarDIV =$("#calendar");
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
				if(self.currentNumber!=null){
					self.showDayEvents(self.currentNumber,new Date(self.selectDay.replace("-","/")));
				}
			});
			
			//题头年月，格式:XXXX年X月
			$("#YMBG").html( "&nbsp;" + SY + "年" + "&nbsp;"+ monthName[SM]);
			
			var i=0;
			for (i = 0; i < 42; i++) {
				var tt = 0;
				var gObj=$("#GD"+i);
				var sObj = $("#SD"+i);
				var lObj = $("#LD"+i);
				
				// 绑定点击事件
				gObj.unbind("click").bind("click", function() {
					self.selectDay=$(this).attr("date");
					self.showDayEvents($(this).attr("index"),new Date(self.selectDay.replace(/-/g,"/")));
					var arr=self.selectDay.split("-");
					$("#selectDay .yearAndMonth").html(arr[0]+"."+arr[1]);
					$("#selectDay .day").html(arr[2]);
				});
				
				var currentDate=new Date();
				currentDate.setTime(this.startTime.getTime());
				currentDate.setDate(this.startTime.getDate()+i);
				var cldElement=new calendar(currentDate.getFullYear(),currentDate.getMonth())[currentDate.getDate()-1];
				sObj.html(currentDate.getDate());//显示日期
				
				this.renderLunarHTML(cldElement, lObj);// 显示农历
					
				
				sObj.removeClass();
				lObj.removeClass();
				//今天高亮
				if (cldElement.isToday) {
					sObj.addClass("todyaColor").addClass("selectColor"); // 今日颜色
					lObj.addClass("todyaColor").addClass("selectColor"); // 今日颜色
					this.showDayEvents(i,currentDate);
					
					this.selectDay=this.formatDate(currentDate.getFullYear(), currentDate.getMonth()+1, currentDate.getDate());
					var arr=this.selectDay.split("-");
					$("#selectDay .yearAndMonth").html(arr[0]+"."+arr[1]);
					$("#selectDay .day").html(arr[2]);
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
				gObj.attr("date",this.formatDate(cldElement.sYear,cldElement.sMonth,cldElement.sDay));//记录日期
			}
			//如果最后一行全部不属于本月,这一行不显示
			$("#TR5").show();
			if($("#SD35").hasClass("not_month")){
				$("#TR5").hide();
			}
		},
		//渲染成农历
		this.renderLunarHTML=function(cldObj, lObj){
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
		//设置开始时间、结束时间
		this.setRangeTime= function(SY,SM){
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
		this.getLastDay= function(year,month){
			var nextMonth=month+1;
			var nextYear=year;
			if(nextMonth>11){
				nextMonth=0;
				nextYear+=1;
			}
			var next_date = new Date(nextYear,nextMonth, 1); // 下个月的第一天
			return (new Date(next_date.getTime() - 1000 * 60 * 60 * 24)).getDate();// 本月最后一天
		},
		this.pushBtm=function(K){
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
			}
			this.setRangeTime(this.selectYear, this.selectMonth);
			this.buildCld(this.selectYear, this.selectMonth);
		},
		this.showDayEvents=function(num,date){
			
			//隐藏列表页面，加载数据完成后再显示
			$('#calendarList').hide();//隐藏日历视图
			$('#list_loaing').show();//正在加载中...
			
			this.currentNumber=num;
			var self = this;
			var currentD;
			var sObj = eval('SD' + num);
			$("#calendarDIV .selectColor").removeClass("selectColor");
			$("#SD" + num).addClass("selectColor");
			$("#LD" + num).addClass("selectColor");
			currentD=this.formatDate(date.getFullYear(), date.getMonth()+1, date.getDate());
			var url=Com_Parameter.ContextPath+"km/calendar/km_calendar_main/kmCalendarMain.do?method=getDayEvents&date="+currentD;
			$.ajax( {
						url : url,
						dataType : 'json',
						success : function(datas) {
							sObj.style.cursor = 'pointer';
							var liHtml = "";
							var length = datas.length;
							for ( var i = 0; i < length; i++) { 
								var link=Com_Parameter.ContextPath+datas[i].pdaUrl.substring(1);
								var cssClass=i%2==0?"list_odd":"list_even";
								var time=datas[i].isAllday==true?"全天":datas[i].startTime.substring(11);
								liHtml+="<a href='"+link+"' target='_self'>" +
													"<div class='"+cssClass+"'>" +
															"<div class='list_left'>"+time+"</div>"+
															"<div class='list_right'></div>"+
															"<div class='list_center'>"+datas[i].docSubject+"</div> "+
														"</div>"+
													"</a>";
							}
							document.getElementById("calendarList").innerHTML = liHtml;
							$('#list_loaing').hide();//取消正在加载中...
							$('#calendarList').show();//显示列表视图
						}
					});
		},
		this.buildCld=function(SY,SM){
			//隐藏日历页面，加载数据完成后再显示
			if(this.hasInit==false){
				$('#calendarDIV').hide();//隐藏日历视图
				$('#div_loaing').show();//正在加载中...
			}
			
			var self = this;
			var month = SM + 1;
			var startTimeStr=this.formatDate(this.startTime.getFullYear(), this.startTime.getMonth()+1, this.startTime.getDate());
			
			var end=new Date();
			end.setTime(this.endTime.getTime());
			end.setDate(end.getDate()+1);
			var endTimeStr=this.formatDate(end.getFullYear(), end.getMonth()+1, end.getDate());
			
			var url=Com_Parameter.ContextPath+"km/calendar/km_calendar_main/kmCalendarMain.do?method=getEventsByRange&startTime="+startTimeStr+"&endTime="+endTimeStr;
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
					$('#div_loaing').hide();//取消正在加载中...
					$('#calendarDIV').show();//显示日历视图
				}
			});
		},
		//格式化日期
		this.formatDate=function(year,month,day){
			var date=year+"-";
			if(month<10){
				date+="0";
			}
			date+=month+"-";
			if(day<10){
				date+="0";
			}
			date+=day;
			return date;
		}
	}