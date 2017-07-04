define(function(require, exports, module) {
	//require("km/imeeting/km_imeeting_calendar/calendar.css");
	//var $ = require("lui/jquery");
	var $=require("resource/js/jquery-ui/jquery.ui");
	require("lui/calender/fullcalendar")($);
	var Calendar = require("lui/calendar");
	var topic = require("lui/topic");
	var Fixed=require("lui/fixed").Fixed;
	var lang=require('lang!km-imeeting');
	
	//日历中空白日期选择事件
	var LUI_CALENDAR_SELECT = "calendar.select";
	//日历中日历数据的点击事件
	var LUI_CALENDAR_THING_CLICK = "calendar.thing.click";
	//日历中日历数据的改变事件
	var LUI_CALENDAR_THING_CHANGE = "calendar.thing.change";
	
	
	/**
	 * 会议日历,暂时只提供周视图
	 */
	var MeetingCalendarMode=Calendar.AbstractCalenderMode.extend({
		//初始化
		initialize:function($super,_config){
			$super(_config);
			this.schedules =[];//
			this.categories={};//会议室分类信息
			this.json={};//返回数据,格式:[id:{name:'402',list:[{meeting1},{meeting2}]},…………]
		},
		//功能：视图绘制
		draw : function(){
			if(!this.drawed){
				var today = new Date();
				this.start = this.clearTime(today);
				this.start.setDate(today.getDate()-(today.getDay()==0?7:today.getDay())+1);//设为星期一
				this.end = $.fullCalendar.cloneDate(this.start);
				this.end.setDate(this.end.getDate()+6);
				this.render();
			}
			this.drawed=true;
			this.calendarDiv.show();
		},
		//功能：渲染
		render:function(){
			var self = this; 
			var evts = self.calSetting.events;
			var startVar = $.fullCalendar.cloneDate(self.start);//开始时间
			var endVar = $.fullCalendar.cloneDate(self.end);
			endVar.setDate(endVar.getDate()+1);//结束时间
			if(evts){
				if ($.isFunction(evts)) {
					evts(startVar, endVar , function(datas){
						self.categories=datas.category;//会议室分类信息
						self.json=datas.main;//会议信息
						self._dataShow(startVar, endVar,datas.main);
						self._afterRender();
					});
				}
			}else{
				self.schedules = [];
				self._dataShow(startVar,endVar,null);
				self._afterRender();
			}
		},
		//功能：渲染结束后执行
		_afterRender:function(){
			var t=this;
			
			$(".meeting_calendar_date_tr[init!='true']").each(function(){
				var Maxtop=0;
				var tops=[1,1,1,1,1,1,1];
				//日程重新定位
				$(this).find(".meeting_calendar_data").each(function(){
					var cellObj=$(this).parents("td").eq(0);//TD
					var cellPerHeight=parseInt($(this).outerHeight());
					var days=parseInt($(this).attr("days"));
					$(this).css("width",days*100-2+"%");//日程长度
					$(this).css("top",tops[cellObj.attr("colIndex")]);
					$(this).css("left",1);//日程位置
					for(var k=0;k<days;k++){
						if(k==0){
							tops[k+parseInt(cellObj.attr("colIndex"))]+=cellPerHeight+1;
						}else{
							tops[k+parseInt(cellObj.attr("colIndex"))]=tops[parseInt(cellObj.attr("colIndex"))];
						}
						if(tops[k+parseInt(cellObj.attr("colIndex"))]>Maxtop)
							Maxtop=tops[k+parseInt(cellObj.attr("colIndex"))];
					}
					
					//可点击
					$(this).click(function(ev){
						if (!$(this).hasClass('ui-draggable-dragging')) {
							//ev.stopPropagation();
							var arg={
								"evt":ev,
								"data":$(this).data("data")
							};
							topic.channel(t.calendar).publish(LUI_CALENDAR_THING_CLICK,arg);
						}
					}).mousedown(function(ev){
						ev.stopPropagation();
					});
					
					//可拖拽
					//var hoverListener=new HoverListener(goordinateGrid);
					var self=this;
					var ____cell,____origcell;
					/*$(this).draggable({
						delay: 50,
						opacity:0.8,
						revertDuration:500,
						start: function(ev, ui) {
							$(self).css('z-index',99);
							hoverListener.start(function(newCell,origCell,rowDelta, colDelta){
								$(self).draggable('option', 'revert', !newCell || !rowDelta && !colDelta);
								//清空已选
								$('.meeting_calendar_date').removeClass('meeting_calendar_state_highlight');
								if(newCell){
									____cell=newCell;
									goordinateGrid.cellToTD(____cell).addClass('meeting_calendar_state_highlight');
								}
								____origcell=origCell;
							},ev,'drag');
						},
						stop:function(ev,ui){
							if($(self).draggable('option', 'revert')==false){
								var TD=goordinateGrid.cellToTD(____cell);
								var origTD=goordinateGrid.cellToTD(____origcell);
								TD.removeClass('meeting_calendar_state_highlight');
								//所有后续节点向上移动一个位置
								for(var n=0;n<$(self).parent().next();n++){
									var ___next=$(self).parent().next().eq(n);
									___next.children().css("top",parseInt(___next.children().css(top)-cellPerHeight));
								}
								origTD.attr("top",origTD.attr("top")-cellPerHeight-1);
								$(self).parent().appendTo(TD);
								$(self).css('left',1);
								$(self).css('top',parseInt(TD.attr('top')));
								TD.attr("top",parseInt(TD.attr("top"))+cellPerHeight+1);
								
								//trigger
								topic.channel(t.calendar).publish(LUI_CALENDAR_THING_CHANGE);
							}
							hoverListener.stop();
							
						}
					});*/
				});
				
				
				//存储当前高度信息,添加区域选择事件
				$(this).find('td').each(function(index){
					if(index){
						$(this).attr('top',tops[index-1]);
					}
					//区域选择事件
					//var hoverListener=new HoverListener(goordinateGrid);
					var ____lastcell,____origcell;
					$(this).mousedown(function(ev){
						if(!$(this).hasClass('meeting_calendar_name')){
							//阻止事件冒泡
							ev.stopPropagation();
							//清空已选
							$('.meeting_calendar_date').removeClass('meeting_calendar_state_highlight');
							$(this).addClass('meeting_calendar_state_highlight');
							hoverListener.start(function(cell, origCell){
								//同一行
								if(cell && goordinateGrid.cellToTD(cell).parent()[0]== goordinateGrid.cellToTD(origCell).parent()[0]){
									____lastcell=cell;
									____origcell=origCell;
									goordinateGrid.cellToTD(cell).addClass('meeting_calendar_state_highlight');
								}
							},ev);
							var td=this;
							$(document).one('mouseup', function(ev) {
								hoverListener.stop();
								//trigger
								if(____origcell.col>____lastcell.col){
									var tmp=____origcell;
									____origcell=____lastcell;
									____lastcell=tmp;
								}
								var arg={
									"evt":ev,
									"start":goordinateGrid.cellToTD(____origcell).attr('date'),
									"end":goordinateGrid.cellToTD(____lastcell).attr('date'),
									"resId":$(td).parent().attr("resId"),
									"resName":$(td).parent().attr("name")
								};
								topic.channel(t.calendar).publish(LUI_CALENDAR_SELECT,arg);
							});
						}
					});
				});
				//取消区域选择事件
				$(document).mousedown(function(ev) {
					$('.meeting_calendar_date').removeClass('meeting_calendar_state_highlight');
				});
				
				//最大设定高度重新
				var trHeight=$(this).height()>Maxtop?$(this).height():Maxtop;
				$(this).height(trHeight+15);
				
				//TODO CoordinateGrid类可以套用到下面的重新定位，后续修改
				var goordinateGrid=new CoordinateGrid();
				var hoverListener=new HoverListener(goordinateGrid);
				
				$(this).attr("init",true);//已初始化.下次加载更多日程时,此行无需初始化了..
			});
		},
		//功能：显示数据
		_dataShow:function(start ,end ,datas){
			
			var headerObj=$('<table class="meeting_calendar_header"></table>');
			var th=this._getTH();
			headerObj.append(th);//绘制标题行
			
			var tableObj;
			tableObj =  $('<table class="meeting_calendar_content"></table>');
			if(datas == null){
				//TODO
			}else{
				for(var id in datas){
					tableObj.append(this._getTR(start, end, id));//绘制日程行
				}
			}
			this.calendarDiv.html('');
			this.calendarDiv.append(headerObj);
			//#7298 构建fixed组件：资源日历头部一直浮现在顶部
			var fixed=new Fixed({elem:'.meeting_calendar_header'});
			fixed.startup();
			fixed.draw();
			//#7298 end
			
			this.calendarDiv.append(tableObj);
		},
		//功能：绘制标题列
		_getTH:function(){
			var tmpTR  = $('<tr/>');
			
			var resTD = $('<td class="meeting_calendar_category_th"/>');
			resTD.append($('<div class="meeting_calendar_category_title"/>').append(lang['kmImeetingRes.fdPlace']));
			
			//分类选择框
			var categoryDialog=$('<div class="category_dialog" />')
			categoryDialog.width(this.calendarDiv.width());
			var categoryCkAll=$('<div class="category_ckAll"><input type="checkbox" checked="check" class="meeting_dialog_ck_all" />全选</div>')
			categoryCkAll.click(function(){
				var checkbox=$(this).find('input[type="checkbox"]');
				if(checkbox.prop("checked")){
					$('.meeting_calendar_date_tr').show();
					$('.meeting_dialog_ck').prop('checked',true);
				}else{
					$('.meeting_calendar_date_tr').hide();
					$('.meeting_dialog_ck').prop('checked',false);
				}
			});
			categoryDialog.append(categoryCkAll);
			
			var categoryUl=$('<ul class="category_ul"/>');
			for(var hierarchyId in this.categories){
				var fdName=this.categories[hierarchyId];
				_li=$('<li><input type="checkbox" class="meeting_dialog_ck" checked=check hierarchyId="'+hierarchyId+'">'+fdName+'</li>');
				_li.click(function(){
					var checkbox=$(this).find('input[type="checkbox"]');
					var operationTR=$('.meeting_calendar_date_tr[hierarchyId^="'+checkbox.attr('hierarchyId')+'"]');
					if(checkbox.prop("checked")){
						operationTR.show();
						if($('.meeting_dialog_ck:checked').length==$('.meeting_dialog_ck').length){
							$('.meeting_dialog_ck_all').prop('checked',true);
						}
					}else{
						operationTR.hide();
						$('.meeting_dialog_ck_all').prop('checked',false);
					}
				});
				categoryUl.append(_li);
			}
			resTD.append(categoryDialog).mouseout(function(){
				$(this).removeClass("on");
				categoryDialog.hide();
			}).mouseover(function(){
				$(this).addClass("on");
				categoryDialog.show();
			});
			categoryDialog.append(categoryUl);
			
			tmpTR.append(resTD);
			
			for(var i=0;i<7;i++){
				var now=new Date();
				var cellStartDate = $.fullCalendar.cloneDate(this.start);
				cellStartDate.setDate(this.start.getDate() + i);
				var dateTd=$('<td class="meeting_calendar_date_th"/>');
				//今天
				if(cellStartDate.getDate()==now.getDate()&&cellStartDate.getMonth()==now.getMonth()&&cellStartDate.getFullYear()&&now.getFullYear()){
					dateTd=$('<td class="meeting_calendar_date_th fc-state-highlight"/>');
				}
				$('<div/>').append(this.calSetting.dayNamesShort[cellStartDate.getDay()]+"("+$.fullCalendar.formatDate(cellStartDate,'yyyy-MM-dd')+")").appendTo(dateTd);
				dateTd.appendTo(tmpTR);//绘制星期列
			}
			
			return tmpTR;
		},
		//功能：绘制内容行
		_getTR:function(start, end, id){
			var data=this.json[id];
			var tmpTR  = $('<tr class="meeting_calendar_date_tr"/>');
			tmpTR.attr("resId",id).attr("name",data.name).attr("hierarchyId",data.hierarchyId);
			
			//第一个单元格,HOVER时显示设备信息、楼层信息、容纳人数
			var nameTd = $('<td class="meeting_calendar_name" style="cursor:pointer" title="'+this._buildResTitle(data)+'"/>');
			var divObj = $('<div/>').append(data.name);
			divObj.appendTo(nameTd);
			nameTd.appendTo(tmpTR);
			//临时解决方案
			nameTd.click(function(){
				Com_OpenWindow(Com_Parameter.ContextPath+"/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=view&fdId="+data.fdId);
			});
			//周一至周日单元格
			for(var i=0;i<7;i++){
				var cellStartDate = $.fullCalendar.cloneDate(start);
				cellStartDate.setDate(start.getDate() + i);
				var cellEndDate = $.fullCalendar.cloneDate(cellStartDate);
				cellEndDate.setDate(cellEndDate.getDate() + 1);
				var dateTD  = $('<td class="meeting_calendar_date" colIndex="'+i+'" date="'+ $.fullCalendar.formatDate(cellStartDate,"yyyy-MM-dd") +'"></td>');
				dateTD.appendTo(tmpTR);//绘制日期列
				var isHasData = false;
				if(data.list.length>0){
					for(var j = 0; j<data.list.length; j++){
						var tmpFlag = this._chkInstect(cellStartDate,cellEndDate,data.list[j],dateTD);
						if(tmpFlag == true && !isHasData){
							isHasData = true;
						}
					}
				}
			}
			return tmpTR;
		},
		//绘制HOVER时资源详细信息
		_buildResTitle:function(data){
			var html="";
			if(data.floor){
				html+="地点楼层："+data.floor+"&#xd;";
			}
			if(data.seats){
				html+="容纳人数："+data.seats+"&#xd;";
			}
			if(data.detail){
				html+="设备详情："+data.detail+"&#xd;";
			}
			return html;
		},
		//功能：较验日程信息是否在时间区域内
		_chkInstect:function(start, end, evt , dataTd){
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
					this.dataRender(evt,dataTd,this.getTDlength(dataStart, dataEnd, allDay));
					return true;
				}
			//日程开始时间不处于日历中,TD=日程结束时间-日历开始时间
			}else if(dataStartInt<this.start.getTime()&&evt.end!=null&&evt.end!=''&&start.getTime()==this.start.getTime()){
				var dataEnd = evt.end;
				if(typeof(dataEnd)=="string")
					dataEnd = $.fullCalendar.parseDate(evt.end,this.calSetting.ignoreTimezone);
				evt.end = dataEnd;
				this.dataRender(evt,dataTd,this.getTDlength(this.start, dataEnd, allDay));
				return true;
			}
			return false;
		},
		//功能：绘制数据
		dataRender:function(data,cellObj,days){
			var formaStr=seajs.data.env.pattern.datetime+"{ ' ~ ' "+seajs.data.env.pattern.datetime+"}";
			var title="",titleAttr="";
			if(data.allDay){
				title='';
			}else{
				titleAttr=$.fullCalendar.formatDate(data['start'],formaStr)+" ~ "+$.fullCalendar.formatDate(data['end'],formaStr);
				title=$.fullCalendar.formatDate(data['start'],"HH:mm{ - HH:mm}");
			}
			title+=" "+data.title;
			titleAttr+="&#xd;"+data.title;
			var divObj = $('<div class="meeting_calendar_data_inner"/>').append($('<p class="textEllipsis" title="'+titleAttr+'">'+title+'</p>'));
			divObj = $('<div class="meeting_calendar_data"/>').append(divObj);
			divObj.attr("days",days);
			divObj.data("data",data);
			
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
			
			if(data.className){
				divObj.addClass(data.className);
			}
			divObj=$('<div style="position:relative;z-index:5"/>').append(divObj);
			divObj.appendTo(cellObj);
		},
		//功能：获取当前view信息
		getView : function(){
			var	formaStr = "MM/dd/yyyy{' - 'MM/dd/yyyy}";
			if(Com_Parameter['Lang']!=null && Com_Parameter['Lang']=='zh-cn'){
				formaStr="yyyy年M月d日{ ' -  'yyyy年M月d日 }";
			}
			return {name:'basicWeek' , title:$.fullCalendar.formatDates(this.start,this.end,formaStr), start:this.start, end:this.end};
		},
		/*****************************************************
		 * 功能：上一页
		 ****************************************************/
		prev: function(){
			this.start.setDate(this.start.getDate()-7);
			this.end.setDate(this.end.getDate()-7);
			this.render(); 
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
			this.render(); 
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
			this.render(); 
			if(this.calSetting.viewDisplay){
				this.calSetting.viewDisplay(this.getView());
			}
		},
		 // 功能：刷新视图数据
		refreshSchedules : function(){
			this.render(); 
			if(this.calSetting.viewDisplay){
				this.calSetting.viewDisplay(this.getView());
			}
		},
		 // 功能：增加日程记录
		addSchedule : function(schedule){
			this.schedules.push(schedule);
			this.refreshSchedules();
		},
		 // 功能：删除日程记录
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
		//功能：更新日程记录
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
		//功能：天数间隔
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
		},
		clearTime : function(d) {
			d.setHours(0);
			d.setMinutes(0);
			d.setSeconds(0); 
			d.setMilliseconds(0);
			return d;
		}
	});
	
	/**
	 * 坐标网格类
	 */
	var CoordinateGrid=function(){
		this.rows=[];
		this.cols=[];
		//构建行、列
		this._build=function(){
			var self=this;
			var headcells=$('.meeting_calendar_date_th'),rowcells=$('.meeting_calendar_date_tr');
			var p,n,element;
			headcells.each(function(i,_element){
				element=$(_element);
				n=element.offset().left;
				if(i>0){
					p[1]=n;
				}
				p=[n];
				self.cols[i]=p;
			});
			p[1]=n+element.outerWidth();
			rowcells.each(function(i,_element){
				element=$(_element);
				n=element.offset().top;
				if(i>0){
					p[1]=n;
				}
				p=[n];
				self.rows[i]=p;
			});
			p[1]=n+element.outerHeight();
		};
		this._build();
		//exports
		//获取单元格
		this.cell=function(x,y){
			var rowCnt = this.rows.length;
			var colCnt = this.cols.length;
			var i, r=-1, c=-1;
			for (i=0; i<rowCnt; i++) {
				if (y >= this.rows[i][0] && y < this.rows[i][1]) {
					r = i;
					break;
				}
			}
			for (i=0; i<colCnt; i++) {
				if (x >= this.cols[i][0] && x < this.cols[i][1]) {
					c = i;
					break;
				}
			}
			return (r>=0 && c>=0) ? { row:r, col:c } : null;
		};
		//将单元格转为TD
		this.cellToTD=function(cell){
			var TR=$('.meeting_calendar_date_tr').eq(cell.row);
			var TD=TR.find('[colindex="'+cell.col+'"]');
			return TD;
		};
	};
	
	/**
	 * 移动监听类
	 */
	var HoverListener=function(coordinateGrid){
		var bindType,firstCell,cell,fn;
		//移动中....
		var mouse=function(ev){
			_fixUIEvent(ev);
			var newCell = coordinateGrid.cell(ev.pageX, ev.pageY);
			if (!newCell != !cell || newCell && (newCell.row != cell.row || newCell.col != cell.col)) {
				if (newCell) {
					if (!firstCell) {
						firstCell = newCell;
					}
					fn(newCell, firstCell, newCell.row-firstCell.row, newCell.col-firstCell.col);
				}else{
					fn(newCell, firstCell);
				}
				cell = newCell;
			}
		};
		//移动开始触发
		this.start=function(_fn, ev, _bindType){
			fn=_fn;
			firstCell = cell = null;
			bindType = _bindType || 'mousemove';
			mouse(ev);
			$(document).bind(bindType, mouse);
		};
		//移动结束触发
		this.stop=function(){
			$(document).unbind(bindType, mouse);
			return cell;
		};
		
		function _fixUIEvent(event) {
			if (event.pageX === undefined) {
				event.pageX = event.originalEvent.pageX;
				event.pageY = event.originalEvent.pageY;
			}
		}
		
	};
	
	/**
	 * 区域选择类
	 */
	var SelectionManager=function(){
		// locals
		var selected = false;
		
		
		
		
	}; 
	
	module.exports=MeetingCalendarMode;
	
});