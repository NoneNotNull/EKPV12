define(function(require, exports, module) {
	require("sys/ui/extend/theme/default/style/fullcalendar.css");
	require("theme!calendar");
	//var $ = require("lui/jquery");
	var $=require("resource/js/jquery-ui/jquery.ui");
	require("lui/calender/fullcalendar")($);
	var Calendar = require("lui/calendar");
	var commonlang=require('lang!');
	var lang=require('lang!km-calendar');

	//群组日历模式
	var GroupCalendarMode=Calendar.AbstractCalenderMode.extend({
		
		initialize:function($super,_config){
			$super(_config);
			this.schedules =[];
			this.personJson=[];//当前加载人员数据,格式:{id:name,id:name}
			this.totalPersonJson=[];//总人员
			this.Groupmap={};//当前加载日程数据,格式:{id1:[{schedule1},{schedule2}],id2:[{schedule1},{schedule2}]}
		},
		/******************************************************
		 * 功能：群组视图绘制
		 *****************************************************/
		draw : function(){
			var self=this;
			if(!this.drawed){
				var today = new Date();
				this.start = this.clearTime(today);
				this.start.setDate(today.getDate()-(today.getDay()==0?7:today.getDay())+1);//设为星期一
				this.end = $.fullCalendar.cloneDate(this.start);
				this.end.setDate(this.end.getDate()+6);
				this.renderGroup();
			}
			this.drawed = true;
			//加载更多事件
			$(document).scroll(function(){
				if($(document).height()-$(window).height()<=$(document).scrollTop()){
					$(".lui_calendar_content_nodata").hide();
					//下一页需要取得的人员
					var personIds="";
					var last=$(".lui_calendar_group_person_tr:visible").last();//当前视图显示的最后一个人员
					if(last!=null){
						var lastPerson=last.attr("person");
						var ckLi=$(".lui_person_dialog_ck[person="+lastPerson+"]").parent();
						var nextLi=ckLi.nextAll();
						var index=0,count=0,hasNext=true;
						//取出15个日程人员
						while(count<15&&hasNext){
							if(index>=nextLi.size()){
								hasNext=false;
								break;
							}
							var tmpCk=nextLi.eq(index).children(".lui_person_dialog_ck");
							//选中，需要取出
							if(tmpCk.prop("checked")==true){
								personIds+=tmpCk.attr("person")+';';
								count++;
							}
							index++;
						}
					}
					if(personIds!=""){
						//加载
						self.loadGroup(personIds);
					}else{
						//没有更多数据可以加载....
						$(".lui_calendar_content_nodata").show();
					}
				}
			});
			this.calendarDiv.show();
		},
		/******************************************************
		 * 功能：群组视图展示
		 *****************************************************/
		 renderGroup:function(){
			var self = this; 
			self._beforeRender("render");//开始渲染前
			
			var evts = self.calSetting.events;
			var startVar = $.fullCalendar.cloneDate(self.start);
			var endVar = $.fullCalendar.cloneDate(self.end);
			endVar.setDate(endVar.getDate()+1);
			
			if(evts){
				if ($.isFunction(evts)) {
					evts(startVar, endVar , function(data){
						self.personJson=data["persons"];//人员数据
						self.totalPersonJson=data['totalPerson'];//全部人员数据
						self.Groupmap = data["calendars"];//日程数据
						for(var person in self.Groupmap){
							for(var i in self.Groupmap[person]){
								schedule=self.Groupmap[person][i];
								schedule["person"]=person;
								self.schedules.push(schedule);
							}
						}
						self._dataShow(startVar, endVar,self.Groupmap);
						self._afterRender();//渲染结束后
					});
				}
			}else{
				self.schedules = [];
				self._dataShow(startVar,endVar,null);
				
				self._afterRender();//渲染结束后
			}
		},
		/******************************************************
		 * 功能：群组视图展示(筛选形式)
		 *****************************************************/
		 loadGroup:function(personsId){
			var self = this; 
			self._beforeRender("load");//开始渲染前
			
			var evts = self.calSetting.events;
			var startVar = $.fullCalendar.cloneDate(self.start);
			var endVar = $.fullCalendar.cloneDate(self.end);
			endVar.setDate(endVar.getDate()+1);
			if(evts){
				if ($.isFunction(evts)) {
					evts(startVar, endVar , function(data){
						self.personJson=data["persons"];//人员数据
						self.Groupmap = data["calendars"];//日程数据
						for(var i in self.personJson){
							var person=self.personJson[i];
							var personId=person.fdId;
							for(var index in self.Groupmap[personId]){
								schedule=self.Groupmap[personId][index];
								schedule["person"]=personId;
								self.schedules.push(schedule);
							}
							if($(".lui_calendar_group_person_tr[person="+personId+"]").length>0){
								$(".lui_calendar_group_person_tr[person="+personId+"]").remove();
							}
							var tableObj=$(".lui_calendar_content_group");
							var trObj=self._getTr(startVar, endVar, person, self.Groupmap[personId]);
							self._insertTr(tableObj,trObj,false);
						}
						self._afterRender();
					},{"personsId":personsId});
				}
			}else{
				self.schedules = [];
				self._dataShow(startVar,endVar,null);
				self._afterRender();
			}
		},
		/******************************************************
		 * 功能：根据时间区间展示数据
		 * 参数：
		 * 		start	开始时间
		 * 		end		结束时间
		 * 		Groupmap	事务数据	
		 ******************************************************/
		_dataShow : function(start ,end ,Groupmap){
			var tableObj;
			//首次加载,绘制标题行、姓名列
			tableObj =  $('<table class="lui_calendar_content_group"></table>');
			
			this.calendarDiv.html('');
			this.calendarDiv.append($('<div class="lui_calendar_group_data" style="display:none;">'));
			this.calendarDiv.append(tableObj);
			
			//绘制标题行、姓名列
			tableObj.append(this._getTh());
			
			//绘制日程列
			if(Groupmap == null){
				$(".lui_calendar_content_nodata").show();
			}else{
				for(var i in this.personJson){
					var person=this.personJson[i];
					var personId=person.fdId;
					if($(".lui_calendar_group_person_tr[person="+personId+"]").length>0){
						$(".lui_calendar_group_person_tr[person="+personId+"]").remove();
					}
					var trObj=this._getTr(start, end, person, Groupmap[personId]);
					this._insertTr(tableObj, trObj,true);
					$(".lui_person_dialog_ck[person="+personId+"]").prop("checked",true);//
				}
			}
			
			//绘制其他：loading、提示语
			var loadingDiv=$("<div class='lui_calendar_content_loading'>正在加载.....</div>");
			var nodataDiv=$("<div class='lui_calendar_content_nodata'>没有更多的数据可加载了.....</div>");
			this.calendarDiv.append(loadingDiv);
			this.calendarDiv.append(nodataDiv);
			
		},
		/******************************************************
		 * 功能：群组视图渲染开始前触发
		 ******************************************************/
		_beforeRender:function(method){
			if(method=="load"){
				$(".lui_calendar_content_loading").show();
			}
			if(method=="render"){
				if(this.calSetting.loading){
					this.calSetting.loading(true);
				}
			}
		},
		/******************************************************
		 * 功能：群组视图渲染完成后触发
		 ******************************************************/
		_afterRender : function(method){
			var self=this;
			
			//人名弹出框定位
			$(".person_dialog").eq(0).css("top",$(".person_dialog").eq(0).parent().height());
			$(".person_dialog").eq(0).css("width",this.calendarDiv.width());
			
			//点击姓名
			$(".person_dialog .lui_person_dialog_ck").unbind("click").bind("click",function(event){
				event.stopPropagation();
				var person=$(this).attr("person");//日程人员ID
				var check=$(this).prop("checked");
				if(check){
					if($(".lui_calendar_group_person_tr[person="+person+"]").length>0){
						//该人员的数据已加载过,直接show
						$(".lui_calendar_group_person_tr[person="+person+"]").show();
					}else{
						//该人员的数据未加载过,从后台取并渲染
						$(".lui_calendar_content_loading").show();
						self.loadGroup(person);
						$(".lui_calendar_content_loading").hide();
					}
				}else{
					$(".lui_calendar_group_person_tr[person="+person+"]").hide();
					$(".lui_person_dialog_ck_ok").hide();
				}
			});
			
			//全选事件
			$(".person_dialog .lui_person_dialog_ck_all").unbind("click").bind("click",function(event){
				var check=$(this).prop("checked");
				if(check){
					$(".lui_person_dialog_ck").prop("checked",true);
					$(".lui_calendar_group_person_tr").show();
					//self.renderGroup();
				}else{
					$(".lui_person_dialog_ck").prop("checked",false);
					$(".lui_calendar_group_person_tr").hide();
				}
			});
			
			if(this.calSetting.loading){
				this.calSetting.loading(false);
			}
			$(".lui_calendar_content_loading").hide();
			
		},
		/*************************************************************************
		 * 功能：获取标题行
		 *********************************************************************/
		_getTh:function(){
			var self = this;
			var tmpTR  = $('<tr/>');
			var personTd = $('<td class="lui_calendar_group_person_th"/>');
			$('<div/>').append(lang['sysCalendarShareGroup.persons.name']).appendTo(personTd);
			//人名选择框
			var personDialog=$('<ul class="person_dialog" style="position:absolute;"/>');
			personDialog.append("<li><input type='checkbox' checked='check' class='lui_person_dialog_ck_all' />" + "全选" + "</li>");
			var index=0;
			for(var i in self.totalPersonJson){
				var person=self.totalPersonJson[i];
				var check="checked=check";
				personDialog.append("<li><input type='checkbox' index='"+index+"' "+check+" person='" 
						+ person.fdId + "'  class='lui_person_dialog_ck' />" + person.fdName + "</li>");
				index++;
			}
			personDialog.append("<li><div class='lui_person_dialog_ck_ok' >确定</div></li>");
			personDialog.appendTo(personTd);
			personTd.appendTo(tmpTR);//绘制姓名列
			personDialog.hide();
			//移动到姓名列
			personTd.mouseout(function(){
				$(this).removeClass("on");
				personDialog.hide();
			}).mouseover(function(){
				$(this).addClass("on");
				personDialog.show();
			});
			for(var i=0;i<7;i++){
				var now=new Date();
				var cellStartDate = $.fullCalendar.cloneDate(self.start);
				cellStartDate.setDate(self.start.getDate() + i);
				var dateTd=$('<td class="lui_calendar_group_date_th"/>');
				//今天
				if(cellStartDate.getDate()==now.getDate()&&cellStartDate.getMonth()==now.getMonth()&&cellStartDate.getFullYear()&&now.getFullYear()){
					dateTd=$('<td class="lui_calendar_group_date_th fc-state-highlight"/>');
				}
				var thDateFormat=commonlang['date.format.date'];
				$('<div/>').append(self.calSetting.dayNamesShort[cellStartDate.getDay()]+"("+$.fullCalendar.formatDate(cellStartDate,thDateFormat)+")").appendTo(dateTd);
				dateTd.appendTo(tmpTR);//绘制星期列
			}
			return tmpTR;
		},
		/*************************************************************************
		 * 功能：获取日程行
		 *********************************************************************/
		_getTr:function(start,end,person,calendars){
			var personId=person.fdId;
			var tmpTR  = $('<tr class="lui_calendar_group_person_tr" person="'+ personId +'"/>');
			
			//置为初始值
			this.Maxtop=0;
			this.tops=[1,1,1,1,1,1,1];
			
			//绘制人员列
			var personTd = $('<td class="lui_calendar_group_person"/>');
			this.personRender(person,personTd);
			personTd.appendTo(tmpTR);
			
			//绘制日程列
			for(var i=0;i<7;i++){
				var cellStartDate = $.fullCalendar.cloneDate(start);
				cellStartDate.setDate(start.getDate() + i);
				var cellEndDate = $.fullCalendar.cloneDate(cellStartDate);
				cellEndDate.setDate(cellEndDate.getDate() + 1);
				var dateTD  = $('<td class="lui_calendar_group_date" colIndex="'+i+'" date="'+ $.fullCalendar.formatDate(cellStartDate,"yyyy-MM-dd") +'"></td>');
				dateTD.appendTo(tmpTR);//绘制日期列
				var isHasData = false;
				if(calendars.length>0){
					for(var j = 0; j<calendars.length; j++){
						var tmpFlag = this._chkInstect(cellStartDate,cellEndDate,calendars[j],dateTD);
						if(tmpFlag == true && !isHasData){
							isHasData = true;
						}
					}
				}
			}
			
			var trHeight=tmpTR.height()>this.Maxtop?tmpTR.height():this.Maxtop;
			tmpTR.height(trHeight);
			tmpTR.attr("init",true);//已初始化.下次加载更多日程时,此行无需初始化了..
			
			
			return tmpTR;
		},
		/*************************************************************************
		 * 功能：插入日程行
		 *********************************************************************/
		_insertTr:function(tableObj,trObj,inEnd){
			var personId=$(trObj).attr("person");
			var prev="";
			var hasInsert=false;
			if(!inEnd){
				for(var i in this.totalPersonJson){
					var person=this.totalPersonJson[i];
					if($(".lui_calendar_group_person_tr[person="+person.fdId+"]").length>0){
						prev=person.fdId;
					}	
					if(person.fdId==personId&&prev!=""){
						$(".lui_calendar_group_person_tr[person="+prev+"]").after(trObj);
						hasInsert=true;
						break;
					}
				}
			}
			if(hasInsert==false || inEnd ){
				trObj.appendTo(tableObj);
			}
		},
		/**********************************************************************
		 * 功能：较验日程信息是否在时间区域内
		 *******************************************************************/
		_chkInstect : function(start, end, evt , dataTd){
			var allDay = evt.allDay;
			var dataStart=evt.start;
			if(typeof(dataStart)=="string")
				dataStart = $.fullCalendar.parseDate(evt.start,this.calSetting.ignoreTimezone);
			evt.start = dataStart;
			var dataStartInt = dataStart.getTime();
			//日程开始时间位于这一天
			if(dataStartInt>=start.getTime() && dataStartInt< end.getTime()){
				//没有结束时间,TD=1
				if(evt.end==null || evt.end==''){
					this.dataRender(evt,dataTd,1);
					return true;
				}else{
					//有结束时间,TD=日程结束时间-日程开始时间
					var dataEnd = evt.end;
					if(typeof(dataEnd)=="string")
						dataEnd = $.fullCalendar.parseDate(evt.end,this.calSetting.ignoreTimezone);
					evt.end = dataEnd;
					//var dataEndInt = dataEnd.getTime();
					//var selectStart=dataStartInt>this.start.getTime()?dataStart:this.start;
					//var selectEnd=dataEndInt<this.end.getTime()?dataEnd:this.end;
					this.dataRender(evt,dataTd,this.getTDlength(dataStart, dataEnd, allDay));
					return true;
				}
			//日程开始时间不处于日历中,TD=日程结束时间-日历开始时间
			}else if(dataStartInt<this.start.getTime()&&evt.end!=null&&evt.end!=''&&start.getTime()==this.start.getTime()){
				var dataEnd = evt.end;
				if(typeof(dataEnd)=="string")
					dataEnd = $.fullCalendar.parseDate(evt.end,this.calSetting.ignoreTimezone);
				evt.end = dataEnd;
				//var dataEndInt = dataEnd.getTime();
				//var selectEnd=dataEndInt<this.end.getTime()?dataEnd:this.end;
				this.dataRender(evt,dataTd,this.getTDlength(this.start, dataEnd, allDay));
				return true;
			}
			return false;
		},
		/********************************************************************
		 * 功能：绘制群组人员列内容
		 ********************************************************************/
		personRender : function(person,cellObj){
			var divObj = $('<div/>').append(person.fdName);
			divObj.appendTo(cellObj);
		},
		/**********************************************************
		 * 功能:绘制数据
		 * 参数：
		 * 			id			标示	 		
		 * 			title		标题（必填）
		 * 			start		开始时间（必填）
		 * 			end			结束时间
		 *			allDay		是否整天（true/false）
		 * 			className	日历事务显示样式
		 *			backgroundColor背景样色
		 *			borderColor	边框颜色
		 *			textColor	文本颜色	
		 ***********************************************************/
		dataRender:function(data,cellObj,days){
			var self = this;
			var title="";
			if(data.allDay){
				title=lang['kmCalendarMain.allDay'];
			}else{
				title=$.fullCalendar.formatDate(data['start'],"HH:mm{ - HH:mm}");
			}
			title+=" "+data.title;
			var divObj = $('<div class="lui_calendar_group_data_inner"/>').append($('<p class="textEllipsis" title="'+data.title+'">'+title+'</p>'));
			divObj = $('<div class="lui_calendar_group_data"/>').append(divObj);
			divObj.attr("days",days);
			if(data.className){
				divObj.addClass(data.className);
			}
			
			//定位（开始）
			var cellPerHeight=20;
			divObj.css("width",days*100-2+"%");//日程长度
			divObj.css("top",this.tops[cellObj.attr("colIndex")]);
			divObj.css("left",1);//日程位置
			for(var k=0;k<days;k++){
				if(k==0){
					this.tops[k+parseInt(cellObj.attr("colIndex"))]+=cellPerHeight+1;
				}else{
					this.tops[k+parseInt(cellObj.attr("colIndex"))]=this.tops[parseInt(cellObj.attr("colIndex"))];
				}
				if(this.tops[k+parseInt(cellObj.attr("colIndex"))]>this.Maxtop)
					this.Maxtop=this.tops[k+parseInt(cellObj.attr("colIndex"))];
			}
			//定位（结束）
			
			divObj=$('<div style="position:relative;"/>').append(divObj);
			divObj.appendTo(cellObj);
			
			if(this.calSetting.eventRender){
				this.calSetting.eventRender(data,cellObj);
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
			dom.find(".lui_calendar_group_data_inner").html(html);
		},
		/*****************************************************
		 * 功能：获取当前view信息
		 ****************************************************/
		getView : function(){
			var formaStr = this.calSetting.titleFormat.day;
			if(formaStr==null)
				formaStr = "MM/dd/yyyy";
			return {name:'basicWeek' , title:$.fullCalendar.formatDate(this.start,formaStr)+'-'+$.fullCalendar.formatDate(this.end,formaStr), start:this.start, end:this.end};
		},
		/*****************************************************
		 * 功能：上一页
		 ****************************************************/
		prev: function(){
			this.start.setDate(this.start.getDate()-7);
			this.end.setDate(this.end.getDate()-7);
			this.renderGroup(); 
			if(this.calSetting.viewDisplay){
				this.calSetting.viewDisplay(this.getView());
			}
		},
		/*****************************************************
		 * 功能：下一页
		 ****************************************************/
		next : function(){
			this.start.setDate(this.start.getDate()+7);
			this.end.setDate(this.end.getDate()+7);
			this.renderGroup(); 
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
			this.start.setDate(today.getDate()-(today.getDay()==0?7:today.getDay())+1);//设为星期一
			//this.start.setDate(today.getDate()-3);
			this.end = $.fullCalendar.cloneDate(this.start);
			this.end.setDate(this.end.getDate()+6);
			this.renderGroup(); 
			if(this.calSetting.viewDisplay){
				this.calSetting.viewDisplay(this.getView());
			}
		},
		/*****************************************************
		 * 功能：刷新视图数据
		 ****************************************************/
		refreshSchedules : function(){
			this.renderGroup(); 
			if(this.calSetting.viewDisplay){
				this.calSetting.viewDisplay(this.getView());
			}
		},
		/*****************************************************
		 * 功能：增加日程记录
		 ****************************************************/
		addSchedule : function(schedule){
			this.schedules.push(schedule);
			this.refreshSchedules();
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
			this.refreshSchedules();
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
				this.refreshSchedules();
			}
		},
		clearTime : function(d) {
			d.setHours(0);
			d.setMinutes(0);
			d.setSeconds(0); 
			d.setMilliseconds(0);
			return d;
		},
		/*****************************************************
		 * 功能：天数间隔
		 ****************************************************/
		getTDlength:function(startDate,endDate,isAllDay){
			var tstart=$.fullCalendar.cloneDate(this.start);//日历当前显示的第一天
			var tend=$.fullCalendar.cloneDate(this.end);//日历当前显示的最后的一天
			//tend.setDate(tend.getDate());//日历当前显示的最后的一天
			var tmpStartDate=$.fullCalendar.cloneDate(startDate,true);
			var tmpEndDate=$.fullCalendar.cloneDate(endDate,true);
			//不允许结束时间小于开始时间(强制将结束时间设为开始时间)
			if(tmpStartDate.getTime()>=tmpEndDate.getTime()){
				tmpEndDate=tmpStartDate;
			}
			//(日历开始时间和日程开始时间取较大者)
			if(tstart.getTime()>tmpStartDate.getTime()){
				tmpStartDate=tstart;
			}
			//(日历结束时间和日程结束时间取较小者)
			if(tend.getTime()<tmpEndDate.getTime()){
				tmpEndDate=tend;
			}
			var days=parseInt(Math.abs((tmpStartDate.getTime() - tmpEndDate.getTime()))/(1000*60*60*24));
			if(isAllDay){
				days+=1;  
			}else{
				if(endDate.getTime()-tmpEndDate.getTime()>0){
					days+=1;
				}
			}
			if(days<1){
				days=1;
			}
			return days;
		}
	});
	
	exports.GroupCalendarMode = GroupCalendarMode;
	
});