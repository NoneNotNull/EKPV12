<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="form"  value="kmCalendarMainForm"></c:set>
<template:include ref="default.simple">
	<%--样式--%>
	<template:replace name="head">
		<template:super/>
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/calendar/resource/css/calendar_main.css" />
	</template:replace>
	<%--日历主体--%>
	<template:replace name="body">
		<script type="text/javascript">	
			seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($,dialog , topic ,toolbar) {
				//初始化默认标签的颜色,针对单个日程
				window.setColor=function(schedule){
					var eventColor="#c19c53";
					var noteColor="#5fb7c1";
					if(schedule.type=="note"){
						schedule.color=noteColor;
					}else if(schedule.color==null||schedule.color==""){
						schedule.color=eventColor;
					}
				};
				//初始化默认标签的颜色,针对集合
				window.setColors=function(data){
					for(var i=0;i<data.length;i++){
						setColor(data[i]);
					}
					return data;
				};
			});
		</script>
		<ui:calendar id="calendar" showStatus="drag" mode="default" >
			<ui:dataformat>
				<ui:source type="AjaxJson">
					{url:'/km/calendar/km_calendar_main/kmCalendarMain.do?method=data&exceptLabelIds=${param.exceptLabelIds}'}
				</ui:source>
				<ui:transform type="ScriptTransform">
					return setColors(data);
				</ui:transform>
			</ui:dataformat>
			<ui:render type="Template">
				{$<p title="{%data['title']%}">$}
				var str="";
				var start=$.fullCalendar.parseDate(data['start']);
				if(data['allDay']=='1'){
					str+="全天 ";
				}else{
					var hours=start.getHours()<10?"0"+start.getHours():start.getHours();
					var minutes=start.getMinutes()<10?"0"+start.getMinutes():start.getMinutes();
					str+=hours+":"+minutes+" "
				}
				if(data['title']){
					str+=env.fn.formatText(data['title'].replace(/(\n)+|(\r\n)+/g, " "));
				}
				{$<span class="textEllipsis">{%str%}</span></p>$}
			</ui:render>
		</ui:calendar>
	</template:replace>
</template:include>