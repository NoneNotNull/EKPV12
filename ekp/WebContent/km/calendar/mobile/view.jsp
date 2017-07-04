<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.view" >
	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/calendar/mobile/resource/css/view.css" />
	</template:replace>
	
	<template:replace name="title">
		<c:out value="${lfn:message('km-calendar:kmCalendarMain.detailDocContent') }"></c:out>
	</template:replace>
	
	<template:replace name="content">
		<div id="scrollView" class="gray" data-dojo-type="mui/view/DocScrollableView">
			<div class="muiScheduleReadBox">
				<div class="muiScheduleReadHeaer">
					<ul class="dateBar">
						<%-- 几天前？今天？几天后 --%>
						<li>
							<span class="curDate"></span>
						</li>
						<%-- 选中日期 --%>
						<li class="date">
							<c:out value="${param.currentDate }"></c:out>
						</li>
						<%-- 星期几 --%>
						<li class="week"></li>
					</ul>
				</div>
				<p class="txtContent">
					<c:out value="${ kmCalendarMainForm.docSubject}"></c:out>
				</p>
			</div>	
			
			<div class="muiScheduleDateBox">
				<ul class="inner">
					<%-- 开始时间 --%>
					<li class="colBar">
						<div class="dateBrand left">
		                    <div class="head blueBg">
		                    	<xform:datetime property="docStartTime" dateTimeType="date"></xform:datetime>
		                    </div>
		                    <div class="content">
		                    	<c:if test="${ kmCalendarMainForm.fdIsAlldayevent != 'true' }">
		                    		<c:out value="${kmCalendarMainForm.startHour}:${kmCalendarMainForm.startMinute }"></c:out>
		                    	</c:if>
		                    	<c:if test="${ kmCalendarMainForm.fdIsAlldayevent == 'true' }">
		                    		00:00
		                    	</c:if>
		                    </div>
		                    <a class="btn" href="#">开始时间</a>
		                </div>
					</li>
					<%-- 结束时间 --%>
					<li class="colBar">
						<div class="dateBrand right">
		                    <div class="head redBg">
		                    	<xform:datetime property="docFinishTime" dateTimeType="date"></xform:datetime>
		                    </div>
		                    <div class="content">
		                    	<c:if test="${ kmCalendarMainForm.fdIsAlldayevent != 'true' }">
		                    		<c:out value="${kmCalendarMainForm.endHour}:${kmCalendarMainForm.endMinute }"></c:out>
		                    	</c:if>
		                    	<c:if test="${ kmCalendarMainForm.fdIsAlldayevent == 'true' }">
		                    		23:59
		                    	</c:if>
		                    </div>
		                    <a class="btn" href="#">结束时间</a>
		                </div>
					</li>
				</ul>
				<%-- 开始、结束时间差 --%>
				<div class="countdownBar">
					<i class="mui mui-alarm"></i>
					<div class="duration"></div>
				</div>
			</div>
			
			<div class="muiFormContent kmCalendarFormContent">
				<table class="muiSimple" cellpadding="0" cellspacing="0">
					<%--地点--%>
					<tr>
						<td class="muiTitle">
							<bean:message bundle="km-calendar" key="kmCalendarMain.fdLocation" />
						</td>
						<td>
							<xform:text property="fdLocation" mobile="true"/>
						</td>
					</tr>
					<%--标签--%>
					<tr>
						<td class="muiTitle" style="vertical-align:middle;">
							<bean:message bundle="km-calendar" key="kmCalendarMain.docLabel" />
						</td>
						<td>
							<c:if test="${not empty kmCalendarMainForm.labelId }">
								<div class="docLabelContainer" style="background-color: ${kmCalendarMainForm.labelColor}">
									<c:out value="${kmCalendarMainForm.labelName }"></c:out>
								</div>
							</c:if>
							<c:if test="${empty kmCalendarMainForm.labelId }">
								<div class="docLabelContainer muiCalendarDefaultLabel">
									<bean:message bundle="km-calendar" key="kmCalendar.nav.title"/>
								</div>
							</c:if>
						</td>
					</tr>
					<%--提醒--%>
					<tr>
						<td class="muiTitle">
							<bean:message bundle="km-calendar" key="kmCalendarMain.fdNotifySet" />
						</td>
						<td>
						</td>
					</tr>
					<%--重复--%>
					<tr>
						<td class="muiTitle">
							<bean:message bundle="km-calendar" key="recurrence.end.freq" />
						</td>
						<td>
							<xform:select property="RECURRENCE_FREQ" mobile="true">
								<xform:enumsDataSource enumsType="km_calendar_recurrence_freq"></xform:enumsDataSource>
							</xform:select>
						</td>
					</tr>
					
				</table>
			</div>
			
			<div class="muiCalendarOptBar">
				<div class="muiCalendarDeleteOpt" onclick="window.deleteCalendar();">
					<i class="mui mui-cancel"></i>删除
				</div>
				<div class="muiCalendarEditOpt" onclick="window.editCalendar();">
					<i class="mui mui-calendarEdit"></i>编辑
				</div>
			</div>
			
		</div>
		
		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" data-dojo-props='fill:"grid"'>
		  	<li data-dojo-type="mui/back/BackButton"></li>
	    	<li data-dojo-type="mui/tabbar/TabBarButtonGroup" style="float: right;" data-dojo-props="icon1:'mui mui-more'">
	    		<div data-dojo-type="mui/back/HomeButton"></div>
	    	</li>
		</ul>
	
	</template:replace>
	

</template:include>
<script>
require(['dojo/ready','dojo/query','dojo/date','mui/calendar/CalendarUtil',"mui/dialog/Dialog","dojo/dom-construct","dojo/_base/lang","dojo/request"],
		function(ready,query,date,cutil,Dialog,domConstruct,lang,request){
	ready(function(){
		//开始、结束时间差
		var start=cutil.parseDate('${kmCalendarMainForm.docStartTime}'),
			end=cutil.parseDate('${kmCalendarMainForm.docFinishTime}'),
			duration=date.difference(start,end,'day')+1,//时间间隔
			allDay='${kmCalendarMainForm.fdIsAlldayevent}';//是否全天
		if(duration==1 && allDay=='false'){
			var startHour=parseInt('${kmCalendarMainForm.startHour}'),
				endHour=parseInt('${kmCalendarMainForm.endHour}'),
				startMinute=parseInt('${kmCalendarMainForm.startMinute}'),
				endMinute=parseInt('${kmCalendarMainForm.endMinute}'),
				_hour=endHour-startHour,
				_minute=endMinute-startMinute;
			query('.duration')[0].innerHTML='';
			if(_hour != 0){
				query('.duration')[0].innerHTML+=_hour+'小时';
			}
			if(_minute != 0){
				query('.duration')[0].innerHTML+=_minute+'分钟';
			}
		}else{
			query('.duration')[0].innerHTML=duration+'天';
		}
		
		//选中日初始化
		var currentDate='${param.currentDate}';
		if(currentDate){
			currentDate=cutil.parseDate(currentDate);
		}else{
			currentDate=new Date();
		}
		var weekArray='${lfn:message("calendar.week.names")}'.split(','),
			now=new Date();
		now.setHours(0,0,0,0);
		var duration=date.difference(currentDate,now,"day");
		query('.week')[0].innerHTML=weekArray[currentDate.getDay()];//设置星期
		if(duration < 0){
			duration=0-duration;
			curDateStr='<em>'+duration+'</em>天后';
		}else if(duration == 0){
			curDateStr='<em class="Today">今天</em>';
		}else{
			curDateStr='<em>'+duration+'</em>天前'
		}
		query('.curDate')[0].innerHTML=curDateStr;
	});
	
	//删除日程
	window.deleteCalendar=function(){
		var contentNode = domConstruct.create('div', {
			className : 'muiBackDialogElement',
			innerHTML : '<div>确定要删除此日程？<div>'
		});
		Dialog.element({
			'title' : '提示',
			'showClass' : 'muiBackDialogShow',
			'element' : contentNode,
			'scrollable' : false,
			'parseable': false,
			'buttons' : [ {
				title : '取消',
				fn : function(dialog) {
					dialog.hide();
				}
			} ,{
				title : '确定',
				fn : lang.hitch(this,function(dialog) {
					//ajax删除日程
					var url='${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method=delete&fdId=${param.fdId}'
					request
					.get(url, {handleAs : 'json',headers: {"accept": "application/json"}})
					.response
					.then(function(datas) {
						if(datas.status=='200'){
							dialog.hide();
							location.href='${LUI_ContextPath}/km/calendar/mobile/index.jsp';
						}
					});
				})
			} ]
		});
	};
	
	//编辑日程
	window.editCalendar=function(){
		location.href='${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method=edit&fdId=${param.fdId}';
	};
	
});

</script>



