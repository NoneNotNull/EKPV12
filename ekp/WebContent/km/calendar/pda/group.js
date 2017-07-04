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
		return (offDate.getDate());
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
	
	
	var selectDay=new Date();//当前选中的日期
	function calendarPda(){
		var today=new Date();
		this.startTime=new Date();
		this.startTime.setDate(today.getDate()-(today.getDay()==0?7:today.getDay())+1);//设为星期一
		this.endTime=new Date();
		this.endTime.setDate(this.startTime.getDate()+6);//结束时间
		
		this.groupId="defaultGroup";//群组ID,默认全部共享
		this.personsId="";//群组人员ID
		
		this.hasInit=false;
		//初始化
		this.init=function(){
			//隐藏日历页面，加载数据完成后再显示
			if(this.hasInit==false){
				$('#calendarDIV').hide();//隐藏日历视图
				$('#div_loaing').show();//正在加载中...
			}
			
			this.buildGroup();//构建群组下拉框
			this.buildCld();// 构建数据
			
			//隐藏日历页面，加载数据完成后再显示
			if(this.hasInit==false){
				$('#div_loaing').hide();//正在加载中...
				$('#calendarDIV').show();//隐藏日历视图
			}
			this.hasInit=true;
		};
		//获取群组下拉框
		this.buildGroup=function(){
			var self=this;
			var url=Com_Parameter.ContextPath+"km/calendar/km_calendar_share_group/kmCalendarShareGroup.do?method=listUserGroupJson";
			$.ajax( {
				url : url,
				dataType : 'json',
				success : function(datas) {
					for(var i=0;i<datas.length;i++){
						var option=$("<option value='"+datas[i].id+"'>"+datas[i].name+"</option>").appendTo($("#lui_shareGroup"));
					}
				}
			});
			$("#lui_shareGroup").change(function(){
				self.groupId=$(this).children('option:selected').val();
				self.showDayEvents(selectDay);
			});
		};
		//绘制calendar
		this.buildCld=function(){
			
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
			
			//题头，格式:XXXX年第X周
			calendarDIV.find(".ymbg").html(this.startTime.getFullYear()+"年第"+this.getNthWeek(this.startTime)+"周");
			
			var i=0;
			for (i = 0; i < 7; i++) {
				var tt = 0;
				var gObj=$("#GD"+i);
				var sObj = $("#SD"+i);
				var lObj = $("#LD"+i);
				
				// 绑定点击事件
				gObj.unbind("click").bind("click", function() {
					selectDay=$(this).data("date");
					self.showDayEvents(selectDay);
				});
				
				var currentDate=new Date();
				currentDate.setTime(this.startTime.getTime());
				currentDate.setDate(this.startTime.getDate()+i);
				var cldElement=new calendar(currentDate.getFullYear(),currentDate.getMonth())[currentDate.getDate()-1];
				sObj.html(currentDate.getDate());//显示日期
				
				this.renderLunarHTML(cldElement, lObj);// 显示农历
					
				
				sObj.removeClass();
				lObj.removeClass();
				//选中日子高亮
				if (this.formatDate(currentDate)==this.formatDate(selectDay)) {
					this.showDayEvents(currentDate);
					sObj.addClass("todyaColor").addClass("selectColor"); // 今日颜色
					lObj.addClass("todyaColor").addClass("selectColor"); // 今日颜色
				}
				//添加有日程的样式
				//if (eventsOfEverDay[i]) {
				//	lObj.addClass("events");
				//} else {
				//	lObj.removeClass("events");
				//}
				gObj.attr("date",this.formatDate(currentDate));//记录日期字符串
				gObj.data("date",currentDate);//记录日期
			}
			
		};
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
		};
		//翻页
		this.pushBtm=function(K){
			switch (K) {
			case 'prev':
				this.startTime.setDate(this.startTime.getDate()-7);
				this.endTime.setDate(this.endTime.getDate()-7);
				break;
			case 'next':
				this.startTime.setDate(this.startTime.getDate()+7);
				this.endTime.setDate(this.endTime.getDate()+7);
				break;
			default:
				var today=new Date();
				this.startTime=new Date();
				this.startTime.setDate(today.getDate()-(today.getDay()==0?7:today.getDay())+1);//设为星期一
				this.endTime=new Date();
				this.endTime.setDate(this.startTime.getDate()+6);//结束时间
				selectDay=new Date();   
				
			}
			this.buildCld();
			this.renderEvent();//获取每天是否有日程
		};
		//显示指定日期、指定群组的日程
		this.showDayEvents=function(date){
			//隐藏列表页面，加载数据完成后再显示
			$('#calendarList').hide();//隐藏日历视图
			$('#list_loaing').show();//正在加载中...
			
			var self = this;
			var currentD;
			$("#calendarDIV .selectColor").removeClass("selectColor");
			currentD=this.formatDate(date);//格式化日期
			var sObj=$("td[date="+currentD+"]");
			$("td[date="+currentD+"] [id*=SD]").addClass("selectColor");//设为选中颜色
			$("td[date="+currentD+"] [id*=LD]").addClass("selectColor");//设为选中颜色
			fdStart=this.formatDate(date);
			
			var endDate=new Date();
			endDate.setTime(date.getTime());
			endDate.setDate(endDate.getDate()+1);
			fdEnd=this.formatDate(endDate);
			
			var url=Com_Parameter.ContextPath+"km/calendar/km_calendar_main/kmCalendarMain.do?method=listGroupCalendar&fdStart="+fdStart+"&fdEnd="+fdEnd+"&groupId="+this.groupId;
			$.ajax( {
						url : url,
						dataType : 'json',
						success : function(datas) {
							var liHtml = "";
							var calendars=self.calendars = datas.calendars;
							self.totalPerson=datas.totalPerson;
							var i=0;
							self.personsId="";
							for(var person in calendars){
								self.personsId+=person+";";
								for(var index in calendars[person]){
									var calendar=calendars[person][index];
									var link=Com_Parameter.ContextPath+"km/calendar/km_calendar_main/kmCalendarMain.do?method=view&fdId="+calendar.id;
									var cssClass=i%2==0?"list_odd":"list_even";
									var time=calendar.allDay==true?"全天":calendar.start.substring(11);
									liHtml+="<a href='"+link+"' target='_self'>" +"<div class='"+cssClass+"'>" +
														"<div class='list_left'>"+time+"</div>"+
														"<div class='list_person'>"+self.getPersonById(person).fdName+"</div>"+
														"<div class='list_center'>"+calendar.title+"</div> "+
													"</div></a>";
									i++;
								}
							}
							self.renderEvent();
							document.getElementById("calendarList").innerHTML = liHtml;//显示选中日子的日程
							$('#list_loaing').hide();//取消正在加载中...
							$('#calendarList').show();//显示列表视图
						}
					});
		};
		this.renderEvent=function(){
			var startTimeStr=this.formatDate(this.startTime);//查询开始时间字符串
			var end=new Date();
			end.setTime(this.endTime.getTime());
			end.setDate(end.getDate()+1);
			var endTimeStr=this.formatDate(end);//查询结束时间字符串
			
			var url=Com_Parameter.ContextPath+"km/calendar/km_calendar_main/kmCalendarMain.do?method=getEventsByRange&startTime="+startTimeStr+"&endTime="+endTimeStr+"&personsId="+this.personsId;
			
			// 获取指定范围内有日程的日期
			$.ajax( {
				url : url,
				dataType : 'json',
				success : function(datas) {
					for (var i = 0; i < 7; i++) {
						var lObj = $("#LD"+i);
						if (datas[i]) {
							lObj.addClass("events");
						} else {
							lObj.removeClass("events");
						}
					}
				}
			});
		};		
		//格式化日期
		this.formatDate=function(date){
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
			dateStr=year+"-"+month+"-"+day;
			return dateStr;
		};
		//本年第几周
		this.getNthWeek=function(date){
			var totalDays=0;
			var days=[31,28,31,30,31,30,31,31,30,31,30,31];
			if (Math.round(date.getYear() / 4) == date.getYear() / 4) {
				days[1]=29;
			}
			if (date.getMonth() == 0) {
				totalDays = totalDays + date.getDate();
			} else {
			    var curMonth = date.getMonth();
			    for (var count = 1; count <= curMonth; count++) {
			    	totalDays = totalDays + days[count - 1];
			    }
			    totalDays = totalDays + date.getDate();
			}
			return Math.round(totalDays / 7);
		};
		//获取指定ID的人员
		this.getPersonById=function(fdId){
			for(var i in this.totalPerson){
				if(this.totalPerson[i].fdId == fdId){
					return this.totalPerson[i];
				}
			}
			return {};
		};
	}